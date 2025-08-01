class seq_covergroup extends uvm_scoreboard;
  `uvm_component_utils(seq_covergroup)
 
  localparam logic READ = 1'b1;
  localparam logic WRITE = 1'b0;
  localparam int TENBI2C = 8;
  localparam int FOURBI2C = 4;
  
  seq_coverpoint A;
  seq_coverpoint B;
  seq_covercross C; 
  
  uvm_analysis_imp #(seq_item,seq_covergroup) scport;

  function new(string name="seq_covergroup", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void create_A();
    seq_item s = seq_item::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;
    A.make(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    A.make(s);
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    A.make(s); 
    
    A.display();
  endfunction

  function void create_B();
    seq_item s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = FOURBI2C;
    B.make(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = FOURBI2C;    
    B.make(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;    
    B.make(s);
    
    A.display();
  endfunction

  function void create_C();
    seq_item s = seq_item::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;
    C.make1(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;    
    C.make1(s); 
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    C.make1(s);
    
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = FOURBI2C;    
    C.make2(s);
    s = seq_item::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = FOURBI2C;    
    C.make2(s); 
    
    C.display();
  endfunction

  function void build_phase(uvm_phase phase);
    scport=new("Seq coverage port",this);
    A = seq_coverpoint::type_id::create("A");
    B = seq_coverpoint::type_id::create("B");
    C = seq_covercross::type_id::create("C");    
    create_A();
    create_B();
    create_C();
  endfunction
  
  //update coverage on every sampled transaction
  function void write(seq_item t);
    A.update(t);
    B.update(t);
    C.update(t);
  endfunction
  
  function void report_phase(uvm_phase phase);
    A.cseq_report();
    B.cseq_report();
    C.cseq_report();
  endfunction
endclass
