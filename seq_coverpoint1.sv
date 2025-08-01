class seq_coverpoint1 extends uvm_scoreboard;
  `uvm_object_utils(seq_coverpoint1)

  seq_item1 cseq[$]; //to store coverage sequence
  seq_item1 q[$]; //to store sampled transactions
  
  int hit; //number of hits of seq coverage 
  int index; //points to the current index needs to be covered in the seq
  string st;
  
  function new(string name="seq_coverpoint1", uvm_component parent=null);
    super.new(name,parent);
  	hit = 0;
    index = 0;
    st = name; 
  endfunction
  
  //add items to queue to define coverage sequence
  function void make(seq_item1 s);
    cseq.push_back(s);
  endfunction

  function void display();
    for (int i=0; i<cseq.size(); i++)
      `uvm_info("cov_sequence",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq[i].rd_wr, cseq[i].slv_addr),UVM_LOW)
  endfunction

  //update coverage using sample transaction 
  function void update(seq_item1 s);
    q.push_back(s);
    if (q.size() == cseq.size()) begin
      if (docoverage()) begin
        hit = hit + 1;
        //`uvm_info("cov_sequence",$sformatf("%s sequence coverage hit =%0d",st,hit),UVM_LOW)       
      end
      q.pop_front();
    end
  endfunction
  
  //checks if coverage is deteccted 
  function logic docoverage();
    int index;
    
    index = 1; 
    //start and end match cseq1 start and end (within)
    if (!((match(0, q[0]) && match(cseq.size()-1, q[$])))) return 0; 
    //inside matches 
    for (int i=1; i<q.size()-1; i++) 
      if (match(index, q[i])) begin
        index = index + 1;
        if (index > cseq.size()-1) return 0;
      end
      else return 0;
    //for (int i = 0; i<q.size(); i++)
      //`uvm_info("seq_covercross",$sformatf("sequence coverage cross q[i].rd_wr=%0d q[i].slv_addr=%0d",q[i].rd_wr, q[i].slv_addr),UVM_LOW)
    return 1;
  endfunction
  
  function void cseq_report();
    `uvm_info("cov_sequence",$sformatf("%s sequence coverage hit =%0d",st,hit),UVM_LOW)
  endfunction
    
  function logic match(int index, seq_item1 s);
    if (index == cseq.size()) return 0;
    if ((s.rd_wr == cseq[index].rd_wr) && (s.slv_addr == cseq[index].slv_addr)) begin
      //`uvm_info("seq_covercross cseq1",$sformatf("%s transaction coverage match s.rd_wr==%0d s.slv_addr=%0d seq.rd_wr==%0d seq.slv_addr=%0d",st,s.rd_wr, s.slv_addr, cseq[index].rd_wr, cseq[index].slv_addr),UVM_LOW)    
      return 1;
    end
    return 0;
  endfunction
  
endclass
