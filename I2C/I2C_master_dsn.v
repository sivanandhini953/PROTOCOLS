module i2c_master (
  input rst,
  input sys_clk,
  input [7:0] din,
  input [6:0] addr,
  input rw,
  output scl,
  inout sda,
  output reg i2c_clk = 0,
  input en
);

  parameter IDLE = 3'b000;
  parameter START = 3'b001;
  parameter ADDR = 3'b010;
  parameter RW = 3'b011;
  parameter ACK1 = 3'b100;
  parameter DATA = 3'b101;
  parameter ACK2 = 3'b110;
  parameter STOP = 3'b111;

  reg [2:0] state, next;
  reg scl_en, sda_en, sda_reg;
  reg [3:0] count;
  reg [7:0] addr_reg, data_reg;
  reg [2:0] clk_divider = 0;

  assign scl = scl_en ? i2c_clk : 1'b1;
  assign sda = sda_en ? sda_reg : 1'bz;

  // Generate I2C clock with a proper division
  always @(posedge sys_clk) begin
    if (clk_divider == 4) begin
      i2c_clk <= ~i2c_clk;
      clk_divider <= 0;
    end else begin
      clk_divider <= clk_divider + 1;
    end
  end

  // FSM State Transition
  always @(posedge i2c_clk or negedge rst) begin
    if (!rst)
      state <= IDLE;
    else
      state <= next;
  end

  always @(*) begin
    case (state)
      IDLE: next = en ? START : IDLE;
      START: next = ADDR;
      ADDR: next = (count == 8) ? ACK1 : ADDR;
      RW: next = ACK1;
      ACK1: next = DATA;
      DATA: next = (count == 8) ? ACK2 : DATA;
      ACK2: next = STOP;
      STOP: next = IDLE;
      default: next = IDLE;
    endcase
  end

  // Output control for SCL & SDA
  always @(*) begin
    case (state)
      IDLE: begin scl_en = 0; sda_en = 1; sda_reg = 1; end
      START: begin scl_en = 0; sda_en = 1; sda_reg = 0; end
      ADDR, RW, DATA: begin scl_en = 1; sda_en = 1; end
      ACK1, ACK2: begin scl_en = 1; sda_en = 0; end  // SDA floats for ACK reception
      STOP: begin scl_en = 1; sda_en = 1; sda_reg = 1; end
    endcase
  end

  // Data Transmission
  always @(posedge i2c_clk) begin
    case (state)
      START: begin
        addr_reg <= {addr, rw};
        count <= 7;
      end
      ADDR: begin
        if (count == 0)
          count <= 8;
        else begin
          sda_reg <= addr_reg[count];
          count <= count - 1;
        end
      end
      ACK1: count <= 7;
      DATA: begin
        if (count == 0)
          count <= 8;
        else begin
          sda_reg <= din[count];
          count <= count - 1;
        end
      end
    endcase
  end

endmodule








/*module i2c_master(
  input rst,
  input sys_clk,
  input [7:0]din,
  input [6:0]addr,
  input rw,
  output scl,
  inout sda,
  output reg i2c_clk=0,
 	input en
  
);
  
  parameter IDLE=3'b000;
  parameter START=3'b001;
  parameter ADDR=3'b010;
  parameter RW=3'b011;
  
  parameter ACK1=3'b100;
  parameter DATA=3'b101;
  parameter ACK2=3'b110;
  parameter STOP=3'b111;
  
  
  reg [3:0]next,state;
  reg scl_en;
  reg sda_en;
  reg sda_reg;
  reg [3:0]count,cclk=0;
  reg [7:0]addr_reg;
  reg [7:0]data_reg;
  
  
  assign	scl	= scl_en ? i2c_clk : 1;
  assign 	sda	= sda_en ? sda_reg  : 1'bz;
  
  
  always @(posedge sys_clk) begin    // I2C clk from system clk
    //$monitor( "sys = %b , i2c = %b , cclk = %d " ,sys_clk,i2c_clk,cclk  );
	
    if(cclk==3)
      begin
      i2c_clk <= ~i2c_clk;
    cclk <= 0;
      end
    else 
      cclk <= cclk+1;
    
  end
    
    
    
    
  
  always @(posedge i2c_clk) begin
    
    if(!rst)
     	state <= IDLE;
		
  else
  
    state <= next;
	
  
  end
  
  
  
  
  always @(*)begin
    case(state)
      IDLE:  begin $display("idle"); next = en?START:IDLE;end
      START:begin  $display("start"); next = ADDR;end
      
      ADDR:next=(count>9)?ACK1:ADDR;
      RW: next = ACK1;
      
      ACK1: next = DATA;
      DATA:next=(count>8)?ACK2:DATA;
      ACK2: next=STOP;
       STOP: next=IDLE;
    endcase
  
  end
  
  always @(*)begin
    case(state)
      IDLE:begin scl_en=0; sda_en=1; sda_reg=1; end 
      START: begin scl_en=0; sda_en=1; sda_reg=0; end
      ADDR: begin scl_en=1; sda_en=1; end
      RW: begin scl_en=1; sda_en=1; end
      ACK1:begin scl_en=1; sda_en=1; sda_reg=1; end
      DATA:begin scl_en=1; sda_en=1; end
      ACK2:begin scl_en=1; sda_en=1; sda_reg=1; end
      STOP:begin scl_en=0; sda_en=1; sda_reg=1; end
      
      
    endcase
  end
     
  
  
  always @(posedge i2c_clk)begin
    
    case(state)
      START:begin 
        addr_reg <= {addr,rw};
        count <= 7;
      end
      ADDR: begin
        
        if(count>8)
          count <= 0;
        else begin
          sda_reg <= addr_reg[count];
          count <= count-1;
        end
        
      end
      
      ACK1: count <= 7;
      
      DATA: begin
        if(count> 8)
          count <= 0;
        else begin
          sda_reg <= din[count];
        count <= count-1;
        end
      end
    endcase
  end
          
          
      
    
      
endmodule*/
          
        
    
    
