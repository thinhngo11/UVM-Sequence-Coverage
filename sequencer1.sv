class sequencer1 extends uvm_sequencer #(seq_item1);
  `uvm_component_utils(sequencer1)
  
  function new(string name="Sequencer1", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
endclass
