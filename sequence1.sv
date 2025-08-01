class seq1 extends uvm_sequence #(seq_item1);
  `uvm_object_utils(seq1)
  
  function new(string name="sequence1");
    super.new(name);
  endfunction
  
  byte i;
  bit [9:0]a;
  
  task body();
    `uvm_info("Random","Sequence",UVM_LOW);
    `uvm_do_with(req,{slv_addr==7'b0000000; rd_wr==0;})
    repeat(2000) begin
      //`uvm_info("Random","Sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr inside {4,8}; rpt==0;})
    end
  endtask
  
endclass
