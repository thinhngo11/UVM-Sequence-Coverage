//single interface
class seq_covercross1 extends uvm_scoreboard;
  `uvm_object_utils(seq_covercross1)

  seq_item1 cseq1[$]; //to store coverage sequence1
  seq_item1 cseq2[$]; //to store coverage sequence2
  seq_item1 q[$]; //to store sampled transactions
  int hit; //number of hits of sequence cross coverage 
  string st;
  
  function new(string name="seq_covercross1", uvm_component parent=null);
    super.new(name,parent);
  	hit = 0;
    st = name; 
  endfunction
  
  //add items to queue to define coverage sequences
  function void make1(seq_item1 s);
    cseq1.push_back(s);
  endfunction
  function void make2(seq_item1 s);
    cseq2.push_back(s);
  endfunction

  function void display();
    for (int i=0; i<cseq1.size(); i++)
      `uvm_info("cseq1",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq1[i].rd_wr, cseq1[i].slv_addr),UVM_LOW)
    for (int i=0; i<cseq2.size(); i++)
      `uvm_info("cseq2",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq2[i].rd_wr, cseq2[i].slv_addr),UVM_LOW)
  endfunction

  // update coverage using sample transaction 
  function void update(seq_item1 s);
    q.push_back(s);
    if (q.size() == cseq1.size() + cseq2.size()) begin
      if (docoverage()) begin
        hit = hit + 1;
        //`uvm_info("cov_sequence",$sformatf("%s sequence coverage cross hit =%0d",st,hit),UVM_LOW)       
      end
      q.pop_front();
    end
  endfunction
  
  //checks if coverage is hit
  //sampled transactions can be non-consecutive within cseq
  // 4 modes: either-sided within, one-sided within, overlapped, non-overlapped
  function logic docoverage(int mode = 2);
    int j, start1, end1, start2, end2;
    
    //check if cseq1 & cseq2 are hit inside q
    j=0; start1 = 0; end1 = 0;
    for (int i=0; i<q.size() && j<cseq1.size(); i++)
      if (match(q, i, cseq1[j])) begin
        if (j==0) start1 = i;
        if (j==cseq1.size()-1) end1 = i;
        j=j+1;
      end
    if (j != cseq1.size()) return 0;
    //`uvm_info("cov_sequence",$sformatf("single-interface time1 start1=%t start2=%t end1=%t end2=%t",start1, start2, end1, end2),UVM_LOW);
    
    j=0; start2 = 0; end2 = 0;
    for (int i=0; i<q.size() && j<cseq2.size(); i++)
      if (match(q, i, cseq2[j])) begin
        if (j==0) start2 = i;
        if (j==(cseq2.size()-1)) end2 = i;
        j=j+1;
      end
    if (j != cseq2.size()) return 0;
    //`uvm_info("cov_sequence",$sformatf("single-interface time2 start1=%t start2=%t end1=%t end2=%t",start1, start2, end1, end2),UVM_LOW);
            
    	//seq2 within seq1 only (one-sided)
    if (((mode==1) && ((start1 < start2) && (end1 > end2))) || 
        //both seq2 within seq1 and
        ((mode == 0) && (((start1 < start2) && (end1 > end2)) || 
                         //seq1 within seq2 (two-sided)
                         ((start2 < start1) && (end2 > end1)))) || 
        //overlapped seq1 first 
        ((mode == 2) && (((start1 < start2) && (end1 > start2) && (end2 > end1)) || 
                         //overlapped seq2 first 
                         ((start2 < start1) && (end2 > start1) &&(end1 > end2)) || 
                         //overlapped seq2 within seq1
                         ((start1 < start2) && (end1 > end2)) || 
                         //overlapped seq1 within seq2
                         ((start2 < start1) && (end2 > end1)))) || 
        //non-overlapped seq1 first 
        ((mode == 3) && ((end1 < start2) || 
                         //non-overlapped seq2 first  
                         (end2 < start1)))) 
      	begin
      		//for (int i = 0; i<q.size(); i++)
        	//`uvm_info("seq_covercross",$sformatf("single-interface sequence coverage cross HIT q[i].rd_wr=%0d q[i].slv_addr=%0d",q[i].rd_wr, q[i].slv_addr),UVM_LOW)
      		return 1;
    	end
    //`uvm_info("cov_sequence",$sformatf("missed single-interface time start1=%t start2=%t end1=%t end2=%t",start1, start2, end1, end2),UVM_LOW);
    return 0;
  endfunction
            
  function void cseq_report();
    `uvm_info("seq_covercross",$sformatf("%s sequence coverage cross hit =%0d",st,hit),UVM_LOW)
  endfunction
  
  function logic match(seq_item1 seq[$], int index, seq_item1 s);
    if (index == seq.size()) return 0;
    if ((s.rd_wr == seq[index].rd_wr) && (s.slv_addr == seq[index].slv_addr)) begin
      //`uvm_info("seq_covercross cseq1",$sformatf("%s transaction coverage match s.rd_wr==%0d s.slv_addr=%0d seq.rd_wr==%0d seq.slv_addr=%0d",st,s.rd_wr, s.slv_addr, seq[index].rd_wr, seq[index].slv_addr),UVM_LOW)    
      return 1;
    end
    return 0;
  endfunction
    
endclass
