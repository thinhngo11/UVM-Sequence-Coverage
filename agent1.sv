class agent1 extends uvm_agent;
  `uvm_component_utils(agent1)
  
  sequencer1 sqnr;
  driver1 dri;
  monitor1 mon;
  
  function new(string name="Agen1", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active==UVM_ACTIVE) begin
      sqnr=sequencer1::type_id::create("Sequencer1",this);
      dri=driver1::type_id::create("Driver1",this);
    end
    mon=monitor1::type_id::create("Monitor1",this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    if(get_is_active==UVM_ACTIVE)
      dri.seq_item_port.connect(sqnr.seq_item_export);
  endfunction
  
endclass
