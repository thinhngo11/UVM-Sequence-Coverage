class driver1 extends uvm_driver #(seq_item1);
  `uvm_component_utils(driver1)
  
  function new(string name="Driver1", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual intface1 vif;
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual intface1)::get(this,"","driver1",vif))
      `uvm_fatal("No_Vif","Virtual interface not found");
  endfunction
  
  task reset_phase(uvm_phase phase);
    vif.sda=1; 
    vif.scl=1;
  endtask
  
  byte byte_1;
  virtual task run_phase(uvm_phase phase);
    forever begin
      `uvm_info(get_full_name,"Driver started",UVM_MEDIUM)
/*   Start   */ vif.d.scl=1; #2 vif.d.sda=0;
      fork
        begin
          forever begin
            seq_item_port.get_next_item(req);
            
            if(req.bit_10)
              byte_1={5'b11110,req.slv_addr[9:8],req.rd_wr};
            else
              byte_1={req.slv_addr[6:0],req.rd_wr};
            
/*    addr   */ drive_byte(byte_1);
/* addr ack  */ get_ack(req.a_ack);
                if(!req.a_ack==0) break;
            
            if(req.bit_10) begin
                drive_byte({req.slv_addr[7:0]});
                get_ack(req.a_ack);
                if(!req.a_ack==0) break;
            end
            
/*  int_addr */ drive_byte({req.int_addr});
/*  int_ack  */ get_ack(req.i_ack);
                if(!req.i_ack==0) break;
            
                if(req.rd_wr) begin
/*   rdata   */ drive_byte(8'bz);
/* rdata ack */ put_ack(); end
            
                else begin
/*   wdata   */ drive_byte(req.wdata);
/* wdata ack */ get_ack(req.s_ack); end
            
            break;
          end
          if(!req.rpt) begin
/*   stop    */ @(negedge vif.d.scl); vif.d.sda=0;
               @(posedge vif.d.scl); #1 vif.d.sda=1;
          end
          else begin
            @(negedge vif.d.scl); vif.d.sda=1;
          end
        end
        
    forever begin
          #2 vif.d.scl<=0;
          #2 vif.d.scl<=1;
          wait(vif.d.scl);
        end
      join_any
      disable fork;
      #2 seq_item_port.item_done();
    end
  endtask
  
  task drive_byte(logic [7:0]dr);
    repeat(8) begin
      @(negedge vif.d.scl); vif.d.sda=dr[7];
      dr=dr<<1;
    end
  endtask
  
  task get_ack(output logic ack);
    @(negedge vif.d.scl); vif.d.sda=1'bz;
    @(posedge vif.d.scl); ack=vif.d.sda;
  endtask
  
  task put_ack();
    @(negedge vif.d.scl); vif.d.sda=1'b0;
    @(posedge vif.d.scl); req.m_ack=vif.d.sda;
  endtask
  
endclass
