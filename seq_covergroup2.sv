// checking not and yes as well
// many repeat starts
//clock independent - time abstration only order
//class seq_covergroup1 extends uvm_subscriber#(seq_item1);
`uvm_analysis_imp_decl(_seq1)  // Declares 'write_packet()'
`uvm_analysis_imp_decl(_seq2) // Declares 'write_address()'

class seq_covergroup2 extends uvm_scoreboard;
  `uvm_component_utils(seq_covergroup2)

  localparam logic READ = 1'b1;
  localparam logic WRITE = 1'b0;
  localparam int TENBI2C = 8;
  localparam int FOURBI2C = 4;
  
  seq_coverpoint G;
  seq_coverpoint1 H;
  seq_covercross2 J; 
  
  uvm_analysis_imp_seq1#(seq_item, seq_covergroup2) scport1;  
  uvm_analysis_imp_seq2#(seq_item1, seq_covergroup2) scport2; 
  
  function new(string name="seq_covergroup2", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void create_G();
    seq_item s = seq_item::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;
    G.make(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    G.make(s);
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    G.make(s); 
    
    G.display();
  endfunction

  function void create_H();
    seq_item1 s = seq_item1::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = FOURBI2C;
    H.make(s); 
    s = seq_item1::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = FOURBI2C;    
    H.make(s); 
    s = seq_item1::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;    
    H.make(s);
    
    H.display();
  endfunction

  function void create_J();
    seq_item s = seq_item::type_id::create("s");
    seq_item1 s1 = seq_item1::type_id::create("s1");
    
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;
    J.make1(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;    
    J.make1(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    J.make1(s);
    
    s1 = seq_item1::type_id::create("s1");
    s1.rd_wr = WRITE;
    s1.slv_addr = FOURBI2C;    
    J.make2(s1);
    s1 = seq_item1::type_id::create("s1");
    s1.rd_wr = WRITE;
    s1.slv_addr = FOURBI2C;    
    J.make2(s1); 
    
    J.display();
  endfunction

  function void build_phase(uvm_phase phase);
    scport1=new("Seq coverage port1",this);
    scport2=new("Seq coverage port2",this);
    G = seq_coverpoint::type_id::create("G");
    H = seq_coverpoint1::type_id::create("H");
    J = seq_covercross2::type_id::create("J");    
    create_G();
    create_H();
    create_J();
  endfunction
  
  // update coverage on every sampled transaction
  function void write_seq1(seq_item t);
    G.update(t);
    //H.update(t);
    J.update1(t);    
  endfunction
  
  // update coverage on every sampled transaction
  function void write_seq2(seq_item1 t);
    //G.update(t);
    H.update(t);
    J.update2(t);    
  endfunction
  
  function void report_phase(uvm_phase phase);
    G.cseq_report();
    H.cseq_report();
    J.cseq_report();
  endfunction
endclass
