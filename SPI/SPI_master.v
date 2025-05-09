// Code your design here
module spi_master(
  
  input sys_clk,
  output reg sclk=0,
  input reset,
  input cs,
  input [7:0]data,
  output reg mosi,
  input miso,
  output reg [7:0]out_reg
  
);
  
  reg [7:0]m_reg;
  reg [1:0]count=0;
  reg [7:0]shift;
  reg [7:0]cnt;
  
  parameter IDLE=2'b00;
  parameter TRANSFER=2'b01;
  parameter STOP=2'b10;
  
  reg [1:0]state,next;
  
  
  
  always @(posedge sys_clk)
    if(count==2) begin
      sclk <= ~sclk;
  		count <= 0;
  
    end
  else 
    count <= count+1;
  
  always @(posedge sclk or posedge reset)begin
    if(reset)begin
      state <= IDLE;
      $display("resetting......");
      shift<=0;
     // m_reg<=0;
      cnt<=0;
      mosi<=0;
      
    end
      else 
        state <= next;
    end
    
    always @(*)begin
      case(state)
        
        IDLE:next=TRANSFER;
        TRANSFER: if(shift<8)
          next=TRANSFER;
        else next=STOP;
        STOP:begin next=IDLE;end
        
      endcase
    end
  
  always @(posedge sclk)begin
    if(state==TRANSFER)
      if(shift<8)begin
        mosi <=m_reg[shift];
      shift <=shift+1;
        $display("shift=%d",shift);
       
    end
    else 
      shift <=0;
  end
  assign m_reg=reset?8'h00:data;

   always @(posedge sclk)begin
     if(state==TRANSFER)
       if(cnt<8)begin
         out_reg[7-cnt]<=mosi;
       cnt<=cnt+1;
   end
    else 
      cnt <=0;
   end
endmodule
  
  
  
      
    
    
 
  
  
