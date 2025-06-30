// one primary key for now (transaction type)
// potential secondary keys (address, 
class seq_coverpoint extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_coverpoint)

  seq_item cseq[$];
  //logic cseq_covered[]; // set covered
  int hit; // number of hits of seq coverage 
  int index; // point to the current index needs to be covered in the seq
  string st;
  
  function new(string name="seq_coverpoint");
    super.new(name);
  	hit = 0;
    index = 0;
    //st = define it during new with specific comments like seq pattern
    st = "seq_coverpoint"; 
  endfunction
  
  // add items to queue to define coverage sequence pattern
  function void make(seq_item s);
    cseq.push_back(s);
  endfunction

    // add items to queue to define coverage sequence pattern
  function void display();
    for (int i=0; i<cseq.size(); i++)
      `uvm_info("cov_sequence",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq[i].rd_wr, cseq[i].slv_addr),UVM_LOW)
  endfunction

  // update coverage using sample transacction 
  // cover point
  // cover group
  // cover cross (and)
  // or, within, throughout, etc.
  function void update(seq_item s);
    if (match(s))
      index = index + 1;
    else
      index = 0; // reset if mismatch in between
    
    // increase coverage hit count when the whole sequence covered
    if (cseq.size() ==  index) begin
      hit = hit + 1;
      index = 0;
      `uvm_info("cov_sequence",$sformatf("%s sequence coverage hit =%0d",st,hit),UVM_LOW)       
    end
  endfunction
  
  function void report();
    `uvm_info("cov_sequence",$sformatf("%s sequence coverage hit =%0d",st,hit),UVM_LOW)
  endfunction
  
  // define how match is - using what transaction variable as key
  // can be extended to define match/mismatch is
  function logic match(seq_item s);
    if ((s.rd_wr == cseq[index].rd_wr) && (s.slv_addr == cseq[index].slv_addr))
    `uvm_info("cov_sequence",$sformatf("%s transaction coverage match s.rd_wr==%0d s.slv_addr=%0d cseq.rd_wr==%0d cseq.slv_addr=%0d",st,s.rd_wr, s.slv_addr, cseq[index].rd_wr, cseq[index].slv_addr),UVM_LOW)    
    return (s.rd_wr == cseq[index].rd_wr) && (s.slv_addr == cseq[index].slv_addr);
  endfunction
  
endclass
