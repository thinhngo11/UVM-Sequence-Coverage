// checking not and yes as well
// many repeat starts
//clock independent - time abstration only order
class seq_covergroup extends uvm_subscriber#(seq_item);
  `uvm_component_utils(seq_covergroup)
 
  seq_coverpoint cpseq8RRWW; //coverpoint 
  seq_covercross ccseq; //covercross
  
  uvm_analysis_imp #(seq_item,seq_covergroup) scport;
  function new(string name="seq_covergroup", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void create_cpseq8RRWW();
    seq_item s = seq_item::type_id::create("s");
    s.rd_wr = 1'b1;
    s.slv_addr = 8;
    cpseq8RRWW.make(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = 1'b1;
    s.slv_addr = 8;    
    cpseq8RRWW.make(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = 1'b0;
    s.slv_addr = 8;    
    cpseq8RRWW.make(s);
/*    s = seq_item::type_id::create("s");
    s.rd_wr = 1'b0;
    s.slv_addr = 8;    
    cpseq8RRWW.make(s); */
    
    cpseq8RRWW.display();
  endfunction

  function void create_ccseq();
    seq_item s = seq_item::type_id::create("s");
    s.rd_wr = 1'b1;
    s.slv_addr = 8;
    ccseq.make1(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = 1'b1;
    s.slv_addr = 8;    
    ccseq.make1(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = 1'b0;
    s.slv_addr = 8;    
    ccseq.make1(s);
    
    s = seq_item::type_id::create("s");
    s.rd_wr = 1'b0;
    s.slv_addr = 4;    
    ccseq.make2(s);
    s = seq_item::type_id::create("s");
    s.rd_wr = 1'b0;
    s.slv_addr = 4;    
    ccseq.make2(s); 
    
    ccseq.display();
  endfunction

  function void build_phase(uvm_phase phase);
    scport=new("Seq coverage port",this);
    cpseq8RRWW = seq_coverpoint::type_id::create("cpseq8RRWW");
    ccseq = seq_covercross::type_id::create("ccseq");    
    //create_cpseq8RRWW();
    create_ccseq();
  endfunction
  
  // update coverage on every sampled transaction
  function void write(seq_item t);
    seq_item t1 = seq_item::type_id::create("t1");
    seq_item t2 = seq_item::type_id::create("t2");
    t1.copy(t);
    t2.copy(t);
    //cpseq8RRWW.update(t1);
    ccseq.update(t2);
  endfunction
  
  //cover cross of sequences: like and of SVA 
  //a and b → a and b must hold in the same period
  // start the same time end the same time

  //throughout a true throughout b
  // two arguments first
  // same transaction type -> no parallel sequences
  // within a true within b seq1 within seq2 → seq1 must occur inside seq2
  function void report_phase(uvm_phase phase);
    //cpseq8RRWW.report();
    ccseq.report();
  endfunction
endclass
