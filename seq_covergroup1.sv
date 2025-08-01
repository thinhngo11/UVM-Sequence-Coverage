class seq_covergroup1 extends uvm_scoreboard;
  `uvm_component_utils(seq_covergroup1)
 
  localparam logic READ = 1'b1;
  localparam logic WRITE = 1'b0;
  localparam int TENBI2C = 8;
  localparam int FOURBI2C = 4;
  
  seq_coverpoint1 D;
  seq_coverpoint1 E;
  seq_covercross1 F; 
  
  uvm_analysis_imp #(seq_item1,seq_covergroup1) scport;

  function new(string name="seq_covergroup1", uvm_component parent=null);
    super.new(name,parent);
  endfunction

  function void create_D();
    seq_item1 s = seq_item1::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;
    D.make(s); 
    s = seq_item1::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    D.make(s);
    s = seq_item1::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    D.make(s); 
    
    D.display();
  endfunction

  function void create_E();
    seq_item1 s = seq_item1::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = FOURBI2C;
    E.make(s); 
    s = seq_item1::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = FOURBI2C;    
    E.make(s); 
    s = seq_item1::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;    
    E.make(s);
    
    E.display();
  endfunction

  function void create_F();
    seq_item1 s = seq_item1::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;
    F.make1(s); 
    s = seq_item1::type_id::create("s");
    s.rd_wr = READ;
    s.slv_addr = TENBI2C;    
    F.make1(s); 
    s = seq_item1::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = TENBI2C;    
    F.make1(s);
    
    s = seq_item1::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = FOURBI2C;    
    F.make2(s);
    s = seq_item1::type_id::create("s");
    s.rd_wr = WRITE;
    s.slv_addr = FOURBI2C;    
    F.make2(s); 
    
    F.display();
  endfunction

  function void build_phase(uvm_phase phase);
    scport=new("Seq coverage port",this);
    D = seq_coverpoint1::type_id::create("D");
    E = seq_coverpoint1::type_id::create("E");
    F = seq_covercross1::type_id::create("F");    
    create_D();
    create_E();
    create_F();
  endfunction
  
  //update coverage on every sampled transaction
  function void write(seq_item1 t);
    D.update(t);
    E.update(t);
    F.update(t);
  endfunction
  
  function void report_phase(uvm_phase phase);
    D.cseq_report();
    E.cseq_report();
    F.cseq_report();
  endfunction
endclass
