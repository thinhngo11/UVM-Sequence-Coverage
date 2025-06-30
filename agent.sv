class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  sequencer sqnr;
  driver dri;
  monitor mon;
  
  function new(string name="Monitor", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active==UVM_ACTIVE) begin
      sqnr=sequencer::type_id::create("Sequencer",this);
      dri=driver::type_id::create("Driver",this);
    end
    mon=monitor::type_id::create("Monitor",this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    if(get_is_active==UVM_ACTIVE)
      dri.seq_item_port.connect(sqnr.seq_item_export);
  endfunction
  
endclass
