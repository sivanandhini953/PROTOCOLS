// Code your testbench here
// or browse Examples
module master_tb();
  
  reg sys_clk;
  reg reset;
  reg cs;
  reg [7:0]data;
  reg miso;
  wire mosi;
  wire sclk;
  wire [7:0]out_reg;
  
  
  spi_master uut(
    .sys_clk(sys_clk),
    .reset(reset),
    .cs(cs),
    .data(data),
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .out_reg(out_reg)
  );
  
  
  initial begin 
    
    $dumpfile("dump.vcd");
    $dumpvars;
    
  end
  
  initial sys_clk=0;
  always #5 sys_clk=~sys_clk;
  
initial begin 
  $monitor($time,"sys_scl=%b;sclk=%b mosi=%b  output=%h",sys_clk,sclk,mosi,out_reg);
  
  reset=1;cs=1;
  
  #5 reset=0;
  
 data=8'h55;
  
  
  
  
  #565 $finish;
  
end
endmodule
  
