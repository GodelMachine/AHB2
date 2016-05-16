/**********************************************************
 Start Date: 11 Sept 2015
 Finish Date: 22 Sept 2015
 Author: Mayur Kubavat
 
 Module: AHB Test Library
 Filename: ahb_test.svh
**********************************************************/

class base_test extends uvm_test;

        `uvm_component_utils(base_test)

        ahb_env env_h;

        virtual ahb_intf vif;

        uvm_active_passive_enum m_is_active;
        uvm_active_passive_enum s_is_active;

        env_config env_cfg;


        ahb_reset_vseq reset_vseq_h;
        ahb_set_vseq set_vseq_h;

        ahb_idle_vseq idle_vseq_h;
        ahb_incrx_vseq incrx_vseq_h;
        ahb_wrapx_vseq wrapx_vseq_h;
        ahb_crt_vseq crt_vseq_h;
        ahb_incrbusy_vseq incrbusy_vseq_h;

        ahb_ready_vseq ready_vseq_h;
        ahb_err_vseq err_vseq_h;

        //--------------------------------------------------
        // Methods
        //--------------------------------------------------

        extern function new(string name = "base_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);

endclass: base_test

        //Constructor
        function base_test::new(string name = "base_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        function void base_test::build_phase(uvm_phase phase);
                env_cfg = env_config::type_id::create("env_cfg");

                if(!uvm_config_db#(virtual ahb_intf)::get(this, "", "ahb_intf", vif))
                begin
                        `uvm_fatal(get_full_name(), "Cannot get VIF from configuration database!")
                end

                env_cfg.vif = vif;

                m_is_active = UVM_ACTIVE;
                s_is_active = UVM_ACTIVE;

                env_cfg.m_is_active = m_is_active;
                env_cfg.s_is_active = s_is_active;

                uvm_config_db#(env_config)::set(this, "*", "env_config", env_cfg);

                super.build_phase(phase);

                env_h = ahb_env::type_id::create("env_h", this);
        endfunction

        function void base_test::end_of_elaboration_phase(uvm_phase phase);
                print();
        endfunction


//-------------------------------------------------------------------
// Test
//-------------------------------------------------------------------

class reset_test extends base_test;

        `uvm_component_utils(reset_test)

        //----------------------------------------------------
        // Methods
        //----------------------------------------------------

        extern function new(string name = "reset_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass: reset_test

        //Constructor
        function reset_test::new(string name = "reset_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        //Build
        function void reset_test::build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        //Run
        task reset_test::run_phase(uvm_phase phase);
                reset_vseq_h = ahb_reset_vseq::type_id::create("reset_vseq_h", this);
                phase.raise_objection(this);
                        reset_vseq_h.start(env_h.vseqr_h);
                phase.drop_objection(this);
        endtask



//-------------------------------------------------------------------
// INCRx Test
//-------------------------------------------------------------------

class incrx_test extends base_test;

        `uvm_component_utils(incrx_test)

        //----------------------------------------------------
        // Methods
        //----------------------------------------------------

        extern function new(string name = "incrx_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass: incrx_test

        //Constructor
        function incrx_test::new(string name = "incrx_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        //Build
        function void incrx_test::build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        //Run
        task incrx_test::run_phase(uvm_phase phase);
                reset_vseq_h = ahb_reset_vseq::type_id::create("reset_vseq_h", this);
                set_vseq_h = ahb_set_vseq::type_id::create("set_vseq_h", this);
                incrx_vseq_h = ahb_incrx_vseq::type_id::create("incrx_vseq_h", this);
                ready_vseq_h = ahb_ready_vseq::type_id::create("ready_vseq_h", this);
                idle_vseq_h = ahb_idle_vseq::type_id::create("idle_vseq_h", this);
                phase.raise_objection(this);

                        fork
                        //      repeat(5)
                                        reset_vseq_h.start(env_h.vseqr_h);
                                set_vseq_h.start(env_h.vseqr_h);
                        join_none

                        repeat(10)
                        begin
                                fork
                                        ready_vseq_h.start(env_h.vseqr_h);
                                join_none

                                incrx_vseq_h.start(env_h.vseqr_h);
                        end

                        idle_vseq_h.start(env_h.vseqr_h);
                        #100;
                phase.drop_objection(this);
        endtask


//-------------------------------------------------------------------
// WRAPx Test
//-------------------------------------------------------------------

class wrapx_test extends base_test;

        `uvm_component_utils(wrapx_test)

        //----------------------------------------------------
        // Methods
        //----------------------------------------------------

        extern function new(string name = "wrapx_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass: wrapx_test

        //Constructor
        function wrapx_test::new(string name = "wrapx_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        //Build
        function void wrapx_test::build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        //Run
        task wrapx_test::run_phase(uvm_phase phase);
                reset_vseq_h = ahb_reset_vseq::type_id::create("reset_vseq_h", this);
                set_vseq_h = ahb_set_vseq::type_id::create("set_vseq_h", this);
                wrapx_vseq_h = ahb_wrapx_vseq::type_id::create("wrapx_vseq_h", this);
                ready_vseq_h = ahb_ready_vseq::type_id::create("ready_vseq_h", this);
                idle_vseq_h = ahb_idle_vseq::type_id::create("idle_vseq_h", this);
                phase.raise_objection(this);

                        fork
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                set_vseq_h.start(env_h.vseqr_h);
                        join_none

                        repeat(10)
                        begin
                                fork
                                        ready_vseq_h.start(env_h.vseqr_h);
                                join_none
                                wrapx_vseq_h.start(env_h.vseqr_h);
                        end

                        idle_vseq_h.start(env_h.vseqr_h);

                        #100;
                phase.drop_objection(this);
        endtask



//-------------------------------------------------------------------
// CRT Test
//-------------------------------------------------------------------

class crt_test extends base_test;

        `uvm_component_utils(crt_test)

        //----------------------------------------------------
        // Methods
        //----------------------------------------------------

        extern function new(string name = "crt_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass: crt_test

        //Constructor
        function crt_test::new(string name = "crt_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        //Build
        function void crt_test::build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        //Run
        task crt_test::run_phase(uvm_phase phase);
                reset_vseq_h = ahb_reset_vseq::type_id::create("reset_vseq_h", this);
                set_vseq_h = ahb_set_vseq::type_id::create("set_vseq_h", this);
                crt_vseq_h = ahb_crt_vseq::type_id::create("crt_vseq_h", this);
                ready_vseq_h = ahb_ready_vseq::type_id::create("ready_vseq_h", this);
                idle_vseq_h = ahb_idle_vseq::type_id::create("idle_vseq_h", this);
                phase.raise_objection(this);

                        fork
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                set_vseq_h.start(env_h.vseqr_h);
                        join_none

                        repeat(10)
                        begin
                                fork
                                        ready_vseq_h.start(env_h.vseqr_h);
                                join_none

                                crt_vseq_h.start(env_h.vseqr_h);
                        end
                        idle_vseq_h.start(env_h.vseqr_h);

                        #100;
                phase.drop_objection(this);
        endtask



//-------------------------------------------------------------------
// INCR + BUSY + IDLE Test
//-------------------------------------------------------------------

class incrbusy_test extends base_test;

        `uvm_component_utils(incrbusy_test)

        //----------------------------------------------------
        // Methods
        //----------------------------------------------------

        extern function new(string name = "incrbusy_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass: incrbusy_test

        //Constructor
        function incrbusy_test::new(string name = "incrbusy_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        //Build
        function void incrbusy_test::build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        //Run
        task incrbusy_test::run_phase(uvm_phase phase);
                reset_vseq_h = ahb_reset_vseq::type_id::create("reset_vseq_h", this);
                set_vseq_h = ahb_set_vseq::type_id::create("set_vseq_h", this);
                incrbusy_vseq_h = ahb_incrbusy_vseq::type_id::create("incrbusy_vseq_h", this);
                ready_vseq_h = ahb_ready_vseq::type_id::create("ready_vseq_h", this);
                idle_vseq_h = ahb_idle_vseq::type_id::create("idle_vseq_h", this);

                phase.raise_objection(this);

                        fork
                                reset_vseq_h.start(env_h.vseqr_h);
                                set_vseq_h.start(env_h.vseqr_h);
                        join_none

                        fork
                                ready_vseq_h.start(env_h.vseqr_h);
                        join_none

                        incrbusy_vseq_h.start(env_h.vseqr_h);

                        idle_vseq_h.start(env_h.vseqr_h);

                        #100;
                phase.drop_objection(this);
        endtask


//-------------------------------------------------------------------
// ERR
//-------------------------------------------------------------------

class err_test extends base_test;

        `uvm_component_utils(err_test)

        //----------------------------------------------------
        // Methods
        //----------------------------------------------------

        extern function new(string name = "err_test", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass: err_test

        //Constructor
        function err_test::new(string name = "err_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        //Build
        function void err_test::build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        //Run
        task err_test::run_phase(uvm_phase phase);
                reset_vseq_h = ahb_reset_vseq::type_id::create("reset_vseq_h", this);
                set_vseq_h = ahb_set_vseq::type_id::create("set_vseq_h", this);
                err_vseq_h = ahb_err_vseq::type_id::create("err_vseq_h", this);
                incrbusy_vseq_h = ahb_incrbusy_vseq::type_id::create("incrbusy_vseq_h", this);
                ready_vseq_h = ahb_ready_vseq::type_id::create("ready_vseq_h", this);
                idle_vseq_h = ahb_idle_vseq::type_id::create("idle_vseq_h", this);
                phase.raise_objection(this);

                        fork
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                reset_vseq_h.start(env_h.vseqr_h);
                                set_vseq_h.start(env_h.vseqr_h);
                        join_none

                        fork
                                ready_vseq_h.start(env_h.vseqr_h);
                        join_none
                        incrbusy_vseq_h.start(env_h.vseqr_h);
                        incrbusy_vseq_h.start(env_h.vseqr_h);
                        incrbusy_vseq_h.start(env_h.vseqr_h);

                        err_vseq_h.start(env_h.vseqr_h);

                        fork
                                ready_vseq_h.start(env_h.vseqr_h);
                        join_none
                        incrbusy_vseq_h.start(env_h.vseqr_h);

                        fork
                                ready_vseq_h.start(env_h.vseqr_h);
                        join_none
                        incrbusy_vseq_h.start(env_h.vseqr_h);

                        err_vseq_h.start(env_h.vseqr_h);

                        repeat(5)
                        begin
                                fork
                                        ready_vseq_h.start(env_h.vseqr_h);
                                join_none

                                incrbusy_vseq_h.start(env_h.vseqr_h);
                        end

                        idle_vseq_h.start(env_h.vseqr_h);
                        #100;
                phase.drop_objection(this);

	endtask
