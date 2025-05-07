`timescale 1ns / 1ps

module tb_i2c_master();

  reg rst, sys_clk, en, rw;
  reg [7:0] din;
  reg [6:0] addr;
  wire scl;
  wire sda;
  wire i2c_clk;

  // Instantiate the I2C Master module
  i2c_master uut (
    .rst(rst),
    .sys_clk(sys_clk),
    .din(din),
    .addr(addr),
    .rw(rw),
    .scl(scl),
    .sda(sda),
    .i2c_clk(i2c_clk),
    .en(en)
  );

  // Generate System Clock
  always #5 sys_clk = ~sys_clk;  // 10ns clock cycle

  initial begin
    $dumpfile("i2c_master.vcd");
    $dumpvars(0, tb_i2c_master);

    // Initialize signals
    sys_clk = 0;
    rst = 0;
    en = 0;
    rw = 0;       // Write operation
    addr = 7'b1010101;
    din = 8'h3C;
    
    #10 rst = 1;  // Release reset
    #10 en = 1;   // Enable I2C Master Transaction

    #200 en = 0;  // Stop transaction after a few cycles
    #50 $finish;
  end

  // Monitor signals for debugging
  always @(posedge sys_clk) begin
    $display("Time: %0t | state: %b | scl: %b | sda: %b | i2c_clk: %b", $time, uut.state, scl, sda, i2c_clk);
  end

endmodule



/*module tb();
reg 	sys_clk;
reg 	rst;
  reg 	[7:0] din;
  reg 	[6:0] addr;
reg 	rw;
reg 	en;

wire 	scl;
wire	sda;
wire	i2c_clk;
  

i2c_master uut(
	.sys_clk  (sys_clk),
	.rst     (rst),
  	.din    (din),
	.addr     (addr),
  	.rw   (rw),
  	.en  (en),      	         .scl(scl),
  	.sda	(sda),
  	.i2c_clk	(i2c_clk)
);
  
always #5 sys_clk = ~sys_clk;


initial begin
	sys_clk = 0;
	rst = 1;en=0;
	
	
	#50;
  rst = 0;
 #10 rst=1;
  en =1; rw=1;
  addr = 7'h42;
	din = 8'h85;
end
initial begin
  $monitor("rst: %d ,scl_out  = %d sda_out = %0d", rst,scl, sda);
		$dumpfile("dump.vcd");
		$dumpvars;
		#10000;
		$finish;
end

endmodule*/
