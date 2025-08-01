import uvm_pkg::*;
`include "uvm_macros.svh"

`include "Slave_7b.sv"
`include "Slave_10b.sv"
`include "interface.sv"
`include "interface1.sv"
`include "tb_pkg.sv"

module top;
  
  intface intf0();
  intface1 intf1();
  
  Slave_7b#(4) sl1(intf0.sda, intf0.scl);
  Slave_10b#(8) sl2(intf0.sda, intf0.scl);
  assign intf0.sda=1;
  assign intf0.scl=1;
  initial begin
    uvm_config_db#(virtual intface)::set(uvm_root::get(),"*","driver0",intf0);
    uvm_config_db#(virtual intface)::set(uvm_root::get(),"*","monitor0",intf0);
  end
  
  Slave_7b#(4) sl3(intf1.sda, intf1.scl);
  Slave_10b#(8) sl4(intf1.sda, intf1.scl);
  assign intf1.sda=1;
  assign intf1.scl=1;
  initial begin
    uvm_config_db#(virtual intface1)::set(uvm_root::get(),"*","driver1",intf1);
    uvm_config_db#(virtual intface1)::set(uvm_root::get(),"*","monitor1",intf1);
  end
  
  initial run_test("test");
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
//     #500 $finish;
  end
  
  // To check clock streching
  initial begin
    #62 @(negedge intf0.scl);
    force intf0.scl=0;
    #11 release intf0.scl;
    #185 @(negedge intf0.scl);
    force intf0.scl=0;
    #16 release intf0.scl;
  end
  
endmodule
