class seq_full_rw extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_full_rw)
  
  function new(string name="full register read and write");
    super.new(name);
  endfunction
  
  byte i;
  int q[$];
  
  task body();
    `uvm_do_with(req,{slv_addr==7'b0000000; rd_wr==0;})
    repeat(17) begin
      `uvm_info("Full memory","Full read write Sequence",UVM_LOW);
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==0; bit_10==0; !(int_addr inside {q}); rpt==0;})
      q.push_back(i);
      i=req.int_addr;
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==0; bit_10==1; int_addr==i; rpt==0;})
      `uvm_do_with(req,{slv_addr==7'b0000100; rd_wr==1; bit_10==0; int_addr==i; rpt==0;})
      `uvm_do_with(req,{slv_addr==7'b0001000; rd_wr==1; bit_10==1; int_addr==i; rpt==0;})
    end
  endtask
endclass
