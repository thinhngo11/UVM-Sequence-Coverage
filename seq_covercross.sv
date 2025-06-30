class seq_covercross extends uvm_sequence #(seq_item);
  `uvm_object_utils(seq_covercross)

  seq_item cseq1[$];
  seq_item cseq2[$];
  seq_item q[$]; //to store sampled transactions
  //logic cseq_covered[]; // set covered
  int hit; // number of hits of seq coverage 
  int index1; // the current index needs to be covered in the seq
  int index2; // the current index needs to be covered in the seq
  logic lstart, sstart, lend, send;
  string st;
  
  function new(string name="seq_covercross");
    super.new(name);
  	hit = 0;
    //st = define it during new with specific comments like seq pattern
    st = name; 
  endfunction
  
  // add items to queue to define coverage sequence pattern
  function void make1(seq_item s);
    cseq1.push_back(s);
  endfunction
  function void make2(seq_item s);
    cseq2.push_back(s);
  endfunction

    // add items to queue to define coverage sequence pattern
  function void display();
    for (int i=0; i<cseq1.size(); i++)
      `uvm_info("cseq1",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq1[i].rd_wr, cseq1[i].slv_addr),UVM_LOW)
      for (int i=0; i<cseq2.size(); i++)
        `uvm_info("cseq2",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq2[i].rd_wr, cseq2[i].slv_addr),UVM_LOW)
  endfunction

  // update coverage using sample transaction 
  function void update(seq_item s);
    q.push_back(s);
    if (q.size() == cseq1.size() + cseq2.size()) begin
      if (check()) begin
        hit = hit + 1;
        `uvm_info("cov_sequence",$sformatf("%s sequence coverage cross hit =%0d",st,hit),UVM_LOW)       
      end
      q.pop_front();
    end
  endfunction
  
  //checks if coverage is deteccted cseq2 within cseq1
  //cseq2 can be non-consecutive within
  function logic check();
    int index1, index2; 
    
    index1 = 1; index2 = 0;
    //start and end match cseq1 start and end (within)
    if (!((match(cseq1, 0, q[0]) && match(cseq1, cseq1.size()-1, q[$])))) return 0; 
    //inside matches either
    for (int i=1; i<q.size()-1; i++) 
      if (match(cseq1, index1, q[i])) begin
        index1 = index1 + 1;
        if (index1 > cseq1.size()-1) return 0;
      end
      else if (match(cseq2, index2, q[i])) begin
        index2 = index2 + 1;
        if (index2 > cseq2.size()) return 0;
      end
      else return 0;
    for (int i = 0; i<q.size(); i++)
      `uvm_info("seq_covercross",$sformatf("sequence coverage cross hit q[i].rd_wr=%0d q[i].slv_addr=%0d",q[i].rd_wr, q[i].slv_addr),UVM_LOW)
    return 1;
  endfunction
            
  function void report();
    `uvm_info("seq_covercross",$sformatf("%s sequence coverage crosshit =%0d",st,hit),UVM_LOW)
  endfunction
  
  //either cseq1 or cseq2 match otherwise reset seq coverage
  function logic match(seq_item seq[$], int index, seq_item s);
    if (index == seq.size()) return 0;
    if ((s.rd_wr == seq[index].rd_wr) && (s.slv_addr == seq[index].slv_addr)) begin
      `uvm_info("seq_covercross cseq1",$sformatf("%s transaction coverage match s.rd_wr==%0d s.slv_addr=%0d seq.rd_wr==%0d seq.slv_addr=%0d",st,s.rd_wr, s.slv_addr, seq[index].rd_wr, seq[index].slv_addr),UVM_LOW)    
      return 1;
    end
    return 0;
  endfunction
    
endclass
