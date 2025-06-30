class seq_stuck0 extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_stuck0)
  
  function new(string name="Stuck at 0");
    super.new(name);
  endfunction
  
  byte i=0;
  
  task body();
    repeat(17) begin
      `uvm_info("Stuck 0","Stuck at 0 Sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==0; int_addr==i; rpt==0; wdata==8'b11111111;})
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==0; int_addr==i; rpt==0; wdata==8'b11111111;})
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==1; int_addr==i; rpt==0;})
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==1; int_addr==i; rpt==0;})
      i++;
    end
  endtask
  
endclass

class seq_stuck1 extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_stuck1)
  
  function new(string name="Stuck at 1");
    super.new(name);
  endfunction
  
  byte i=0;
  
  task body();
    repeat(17) begin
      `uvm_info("Stuck 1","Stuck at 1 Sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==0; int_addr==i; rpt==0; wdata==0;})
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==0; int_addr==i; rpt==0; wdata==0;})
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==1; int_addr==i; rpt==0;})
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==1; int_addr==i; rpt==0;})
      i++;
    end
  endtask
  
endclass
