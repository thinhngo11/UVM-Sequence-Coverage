// checking not and yes as well
// many repeat starts
//clock independent - time abstration only order
class seq_coverage extends uvm_subscriber#(seq_item);
  `uvm_component_utils(seq_coverage)
 
  cov_sequence cseq10RRWW;
  
  uvm_analysis_imp #(seq_item,seq_coverage) scport;
  function new(string name="Scoreboard", uvm_component parent=null);
    super.new(name,parent);
    cseq10RRWW = new;
  endfunction
  
  function void create_cseq();
    seq_item s;

    s = new();
    s.rd_wr = 1'b1;
    s.slv_addr = 8;
    cseq10RRWW.create_cseq(s); 
    s = new();
    s.rd_wr = 1'b1;
    s.slv_addr = 8;    
    cseq10RRWW.create_cseq(s); 
    s = new();
    s.rd_wr = 1'b0;
    s.slv_addr = 8;    
    cseq10RRWW.create_cseq(s);
    s = new();
    s.rd_wr = 1'b1;
    s.slv_addr = 8;    
    cseq10RRWW.create_cseq(s); 
    
    cseq10RRWW.display_cseq();
  endfunction
  
  function void build_phase(uvm_phase phase);
    scport=new("Seq coverage port",this);
    create_cseq();
  endfunction
  
  // update coverage on every sampled transaction
  function void write(seq_item t);
    cseq10RRWW.update_cseq(t);
  endfunction

  
  //cover cross of sequences: like and of SVA 
  //a and b → a and b must hold in the same period
  // start the same time end the same time

  //throughout a true throughout b
  // two arguments first
  // same transaction type -> no parallel sequences
  // within a true within b seq1 within seq2 → seq1 must occur inside seq2
  function cover_cross(input cov_sequence args[int]);
  endfunction
  
  task run_phase(uvm_phase phase);
  endtask
  
  function void report_phase(uvm_phase phase);
    cseq10RRWW.report_cseq();
  endfunction
endclass
