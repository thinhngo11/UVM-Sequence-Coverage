class seq_data_override extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_data_override)
  
  function new(string name="full register read and write");
    super.new(name);
  endfunction
  
  byte i=0;
  
  task body();
    `uvm_do_with(req,{slv_addr==7'b0000000; rd_wr==0;})
    repeat(17) begin
      `uvm_info("Override","Data override Sequence",UVM_LOW);
      
      `uvm_do_with(req,{slv_addr=='b0000100; rd_wr==0; bit_10==0; rpt==0;})
      i=req.int_addr;
      `uvm_do_with(req,{slv_addr=='b0000100; rd_wr==0; bit_10==0; rpt==0; req.int_addr==i;})
      `uvm_do_with(req,{slv_addr=='b0000100; rd_wr==1; bit_10==0; rpt==0; req.int_addr==i;})
      
      `uvm_do_with(req,{slv_addr=='b0000001000; rd_wr==0; bit_10==1; rpt==0;})
      i=req.int_addr;
      `uvm_do_with(req,{slv_addr=='b0000001000; rd_wr==0; bit_10==1; rpt==0; req.int_addr==i;})      
      `uvm_do_with(req,{slv_addr=='b0000001000; rd_wr==1; bit_10==1; rpt==0; req.int_addr==i;})      
      i++;
    end
  endtask
  
endclass
