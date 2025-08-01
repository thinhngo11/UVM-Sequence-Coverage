class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  agent ag0;
  scoreboard sb0;
  coverage cv0;
  seq_covergroup cseq0;
  
  agent1 ag1;
  scoreboard1 sb1;
  coverage1 cv1;
  seq_covergroup1 cseq1;

  seq_covergroup2 cseq2;
  
  function new(string name="Environment", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag0=agent::type_id::create("Agent0",this);
    sb0=scoreboard::type_id::create("Scoreboard0",this);
    cv0=coverage::type_id::create("Coverage0",this);
    cseq0=seq_covergroup::type_id::create("Seq covergroup0", this);
    ag1=agent1::type_id::create("Agent1",this);
    sb1=scoreboard1::type_id::create("Scoreboard1",this);
    cv1=coverage1::type_id::create("Coverage1",this);
    cseq1=seq_covergroup1::type_id::create("Seq covergroup1", this);
    cseq2=seq_covergroup2::type_id::create("Seq covergroup2", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    ag0.mon.mnport.connect(sb0.sbport);
    ag0.mon.mnport.connect(cv0.cvport);
    ag0.mon.mnport.connect(cseq0.scport);
    ag1.mon.mnport.connect(sb1.sbport);
    ag1.mon.mnport.connect(cv1.cvport);
    ag1.mon.mnport.connect(cseq1.scport);
    ag0.mon.mnport.connect(cseq2.scport1);
    ag1.mon.mnport.connect(cseq2.scport2);
  endfunction
  
endclass
