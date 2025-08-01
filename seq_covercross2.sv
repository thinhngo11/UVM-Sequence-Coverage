//multi-interface
class seq_covercross2 extends uvm_scoreboard;
  `uvm_object_utils(seq_covercross2)

  seq_item cseq1[$]; //to store coverage sequence1 
  seq_item1 cseq2[$]; //to store coverage sequence2
  time cseqt1[$], cseqt2[$]; //for time alignment
  seq_item q1[$]; //to store sampled transactions of sequence1
  seq_item1 q2[$]; //to store sampled transactions of sequence2
  int hit; //number of hits of seq cross coverage 
  logic hit1, hit2; // number of hits of seq coverage 
  int index1; //the current index needs to be covered in the seq
  int index2; //the current index needs to be covered in the seq
  string st;
  time start1, start2, end1, end2;

  function new(string name="seq_covercross2", uvm_component parent=null);
    super.new(name,parent);
  	hit = 0;
    st = name; 
    start1=0; start2=0; end1=0; end2=0;    
  endfunction
  
  //add items to queue to define coverage sequence pattern
  function void make1(seq_item s);
    cseq1.push_back(s);
  endfunction
  function void make2(seq_item1 s);
    cseq2.push_back(s);
  endfunction

  function void display();
    for (int i=0; i<cseq1.size(); i++)
      `uvm_info("cseq",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq1[i].rd_wr, cseq1[i].slv_addr),UVM_LOW)
      for (int i=0; i<cseq2.size(); i++)
        `uvm_info("cseq",$sformatf("%s sequence coverage pattern rd_wr==%0d slv_addr=%0d",st,cseq2[i].rd_wr, cseq2[i].slv_addr),UVM_LOW)
  endfunction

  // update coverage using sample transaction 
  function void update1(seq_item s);
    if (q1.size() == cseq1.size()) begin
    	q1.pop_front();
    	cseqt1.pop_front();
    end
    q1.push_back(s);
    cseqt1.push_back($time);    
    hit1 = 0;
    if (q1.size() == cseq1.size()) begin
      if (docoverage1()) begin
        hit1 = 1;
        //`uvm_info("cov_sequence",$sformatf("%s sequence coverage cross hit1 =%0d",st,hit1),UVM_LOW)       
        docrosscoverage(2);
      end
    end    
  endfunction
        
  //checks if coverage is deteccted 
  function logic docoverage1();
    if (q1.size() != cseq1.size()) return 0;
    for (int i=0; i<q1.size(); i++) 
      if (!(match1(i, q1[i]))) return 0;
        
    //for (int i = 0; i<q1.size(); i++)
      //`uvm_info("seq_covercross",$sformatf("sequence coverage cross time1=%t q1[i].rd_wr=%0d q1[i].slv_addr=%0d ",cseqt1[i], q1[i].rd_wr, q1[i].slv_addr),UVM_LOW)

    start1 = cseqt1[0];
    end1 = cseqt1[$];
    //`uvm_info("seq_covercross",$sformatf("sequence coverage hit1"),UVM_LOW)    
          
    return 1;
  endfunction
  
  // update coverage using sample transaction 
  function void update2(seq_item1 s);
    if (q2.size() == cseq2.size()) begin
    	q2.pop_front();
    	cseqt2.pop_front();
    end
    q2.push_back(s);
    cseqt2.push_back($time);    
    hit2 = 0;
    if (q2.size() == cseq2.size()) begin
      if (docoverage2()) begin
        hit2 = 1;
        //`uvm_info("cov_sequence",$sformatf("%s sequence coverage cross hit2 =%0d",st,hit2),UVM_LOW)  
        docrosscoverage(2);        
      end
    end    
  endfunction
        
  //checks if coverage is deteccted 
  function logic docoverage2();
    if (q2.size() != cseq2.size()) return 0;
    for (int i=0; i<q2.size(); i++) 
      if (!(match2(i, q2[i]))) return 0;
    
    start2 = cseqt2[0];
    end2 = cseqt2[$];
    //`uvm_info("seq_covercross",$sformatf("sequence coverage hit2"),UVM_LOW)    
              
    return 1;
  endfunction
/*          
  function void docrosscoverage(int mode = 0);        
    if (hit1 & hit2) begin
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
			hit = hit + 1;
        	`uvm_info("cov_sequence",$sformatf("multi-interface sequence coverage cross HIT"),UVM_LOW)    
          	`uvm_info("cov_sequence",$sformatf("mode=%d start1=%t start2=%t end1=%t end2=%t",mode, start1, start2, end1, end2),UVM_LOW);
        	start1=0; start2=0; end1=0; end2=0;
        	//for (int i = 0; i<cseq1.size(); i++)
          		//`uvm_info("seq_covercross",$sformatf("sequence coverage cross hit time1=%t q1[i].rd_wr=%0d q[i].slv_addr=%0d",cseqt1[i], cseq1[i].rd_wr, cseq1[i].slv_addr),UVM_LOW)
        	//for (int i = 0; i<cseq2.size(); i++)
          		//`uvm_info("seq_covercross",$sformatf("sequence coverage cross hit time2=%t q2[i].rd_wr=%0d q2[i].slv_addr=%0d",cseqt2[i], cseq2[i].rd_wr, cseq2[i].slv_addr),UVM_LOW)        
      	end else
        `uvm_info("cov_sequence",$sformatf("missed time start1=%t start2=%t end1=%t end2=%t",start1, start2, end1, end2),UVM_LOW);
     	end else
        `uvm_info("cov_sequence",$sformatf("missed hit1=%0d hit2=%0d",hit1, hit2),UVM_LOW);          
  endfunction
*/            
  function void docrosscoverage(int mode=0);        
    if (hit1&hit2) begin
    	//seq2 within seq1 only (one-sided)
    if (((mode==1)&& 
         	((start1<start2)&&(end1>end2)))|| 
        //seq2 within seq1 or seq1 within seq2 (two-sided)
        ((mode==0)&& 
            //seq2 within seq1 or
         	(((start1<start2)&&(end1>end2))|| 
            //seq1 within seq2 (two-sided)
            ((start2<start1)&&(end2>end1))))|| 
        //overlapped 
        ((mode==2)&& 
         	//overlapped seq1 first 
         	(((start1<start2)&&(end1>start2)&&(end2>end1))|| 
            //overlapped seq2 first 
            ((start2<start1)&&(end2>start1)&&(end1>end2))|| 
            //overlapped seq2 within seq1
            ((start1<start2)&&(end1>end2))|| 
            //overlapped seq1 within seq2
            ((start2<start1)&&(end2>end1))))|| 
        //non-overlapped 
        ((mode==3)&& 
         	//non-overlapped seq1 first 
         	((end1<start2) || 
            //non-overlapped seq2 first  
            (end2<start1))))
      	begin
			hit=hit+1;
        	start1=0; start2=0; end1=0; end2=0;
        end
    end
  endfunction

  function void cseq_report();
    `uvm_info("seq_covercross",$sformatf("%s multi-interface sequence coverage cross hit =%0d",st,hit),UVM_LOW)
  endfunction
  
  function logic match1(int index, seq_item s);
    if (index == cseq1.size()) return 0;
    if ((s.rd_wr == cseq1[index].rd_wr) && (s.slv_addr == cseq1[index].slv_addr)) begin
      //`uvm_info("seq_covercross cseq1",$sformatf("%s transaction coverage match s.rd_wr==%0d s.slv_addr=%0d seq.rd_wr==%0d seq.slv_addr=%0d",st,s.rd_wr, s.slv_addr, cseq1[index].rd_wr, cseq1[index].slv_addr),UVM_LOW)    
      return 1;
    end
    return 0;
  endfunction
  
  function logic match2(int index, seq_item1 s);
    if (index == cseq2.size()) return 0;
    if ((s.rd_wr == cseq2[index].rd_wr) && (s.slv_addr == cseq2[index].slv_addr)) begin
            //`uvm_info("seq_covercross cseq2",$sformatf("%s transaction coverage match s.rd_wr==%0d s.slv_addr=%0d seq.rd_wr==%0d seq.slv_addr=%0d",st,s.rd_wr, s.slv_addr, cseq2[index].rd_wr, cseq2[index].slv_addr),UVM_LOW)    
      return 1;
    end
    return 0;
  endfunction
    
endclass
