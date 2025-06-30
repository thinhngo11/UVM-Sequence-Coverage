class seq_rpt_start extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_rpt_start)
  
  function new(string name="Repeated start");
    super.new(name);
  endfunction
  
  byte i=0;
  
  task body();
    repeat(10) begin
      `uvm_info("Repeat Start","Repeated start Sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==0; bit_10==0; rpt==1;})
      i=req.int_addr;
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==1; bit_10==0; int_addr==i; rpt==0;})
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==0; bit_10==1; rpt==1;})
      i=req.int_addr;
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==1; bit_10==1; int_addr==i; rpt==0;})
    end
  endtask
  
endclass
