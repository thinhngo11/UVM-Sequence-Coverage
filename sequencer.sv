class sequencer extends uvm_sequencer #(seq_item);
  `uvm_component_utils(sequencer)
  
  function new(string name="Sequencer", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
endclass
