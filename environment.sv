class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  agent ag;
  scoreboard sb;
  coverage cv;
  seq_covergroup cseq;
  
  function new(string name="Environment", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ag=agent::type_id::create("Agent",this);
    sb=scoreboard::type_id::create("Scoreboard",this);
    cv=coverage::type_id::create("Coverage",this);
    cseq=seq_covergroup::type_id::create("Seq covergroup", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    ag.mon.mnport.connect(sb.sbport);
    ag.mon.mnport.connect(cv.cvport);
    ag.mon.mnport.connect(cseq.scport);
  endfunction
  
endclass
