#!/urs/bin/perl

use warnings;


main();



#----------------------------- Main ------------------------------#
sub main(){

                clean();
                variables();    #Initialize all variables
                library();      #Create and Map library
                compile();      #Compile

                read_test();

                print "\nEnter Test No. (Press 0 for regress) = ";
                $i = <STDIN>;
                chomp($i);
                print "\n";



                if($i == 0){
                        run_regress();
                        report();
                        view_browser();
                }else{
                        print "Start test in CMD/GUI: (e.g. cmd / gui) = ";
                        $mode = <STDIN>;
                        chop($mode);
                        print "\n";
                        if($mode eq "gui"){
                                 run_gui();
                        }elsif($mode eq "cmd"){
                                run_cmd();
                        }
                }

}



#-------------------- Variable Initialization --------------------#
sub variables(){

        $IF = "../rtl/*.sv";
        $TOP = "../ahb_env/top.sv";
        $PKG = "../ahb_test/ahb_test_pkg.sv";
        $WORK = "work";
        $INC = "+incdir+../rtl +incdir+../ahb_env +incdir+../ahb_test +incdir+../reset_agent +incdir+../ahb_master_agent +incdir+../ahb_slave_agent";

}



#-------------------- SIM Variable Initialization -----------------#
sub simulation(){

        $VSIMOPT = "-novopt -assertdebug -sva -sv_seed 16422201 -l $LOG work.top";
        $VSIMBATCH = "-c -do \"coverage save -onexit -assert -directive -cvg -codeAll $COV; run -all; exit\"";

}



#---------------------- Library & Mapping--------------------------#
sub library(){
        system "vlib $WORK";
        system "vmap work $WORK";
}



#-------------------------- Compile -------------------------------#
sub compile(){
        system "vlog -work $WORK $INC $IF $PKG $TOP";
}



#-----------------------------------------------------------------#
sub run_cmd(){
        $LOG = "test".$i."_sim.log";
        $COV = "cov".$i;
        simulation();
        system "vsim $VSIMBATCH $VSIMOPT +UVM_TESTNAME=$tests[$i-1]";
        system "vcover report -html $COV";
}


#-----------------------------------------------------------------#
sub run_regress(){

        $t = 1;

        foreach(@tests){
                $LOG = "test".$t."_sim.log";
                $COV = "cov".$t;
                simulation();
                system "vsim $VSIMBATCH $VSIMOPT +UVM_TESTNAME=$tests[$t-1]";
                system "vcover report -html $COV";

                $t++;
        }
}


#-----------------------------------------------------------------#
sub report(){
        system "vcover merge cov_final cov?";
        system "vcover report -html cov_final";
}


#-----------------------------------------------------------------#
sub view_browser(){
        system "firefox covhtmlreport/pages/__frametop.htm";

}


#-----------------------------------------------------------------#
sub run_gui(){
        $LOG = "test".$i."_sim.log";
        $COV = "cov".$i;
        simulation();
        system "vsim $VSIMOPT +UVM_TESTNAME=$tests[$i-1]";
        system "vcover report -html $COV";
}



#-----------------------------------------------------------------#
sub clean(){
        system "rm -rf modelsim* transcript* *log* work vsim.wlf wlf* fcover* covhtml* cov*";
        system "clear";
}

#-----------------------------------------------------------------#
sub read_test(){

        print "\n\n------------------------------------------------\n";
        print "Tests Available";
        print "\n------------------------------------------------\n";

        $i = 1;

        $FH;
        open(FH, "<testcases.txt");
        @tests = <FH>;
        foreach (@tests){
                chomp($_);
                print "$i. $_\n";
                $i++;
        }
        close(FH);
        print "------------------------------------------------\n";


}




