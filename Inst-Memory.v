/// computerAssignment_4
// group members: sara Ghavampour 98 127 62 781 - sahar Mohammadi 9812762305

//memory unit
module IMemBank(input memread, input [7:0] address, output reg [31:0] readdata);
 
  reg [31:0] mem_array [255:0];
  
  integer i;
  initial begin
      mem_array[0] = 32'b001000_00000_00010_0000000000100000;
        mem_array[1] = 32'b00000000000000000010000000100000;
        mem_array[2] = 32'b00101000100001010000000000001010;
        mem_array[3] = 32'b00010000101000000000000000000110;
        mem_array[4] = 32'b10001100100001100000000000000000;
        mem_array[5] = 32'b000000_00110_00010_0011100000101010;
        mem_array[6] = 32'b00010000111000000000000000000001;
        mem_array[7] = 32'b000000_00000_00110_00010_00000_100000;
        mem_array[8] = 32'b00100000100001000000000000000001;
        mem_array[9] = 32'b000010_00000000000000000000000010;    //find min

	mem_array[10] = 32'b00100000000000110000000000000000;
        mem_array[11] = 32'b00000000000000000010000000100000;
        mem_array[12] = 32'b00101000100001010000000000001010;
        mem_array[13] = 32'b00010000101000000000000000000110;
        mem_array[14] = 32'b10001100100001100000000000000000;
        mem_array[15] = 32'b00000000011001100011100000101010;
        mem_array[16] = 32'b00010000111000000000000000000001;
        mem_array[17] = 32'b00000000000001100001100000100000;
        mem_array[18] = 32'b00100000100001000000000000000001;
        mem_array[19] = 32'b000010_00000000000000000000001100;   //find max

	mem_array[20] = 32'b101011_00000_00010_0000000000001010;
	mem_array[21] = 32'b101011_00000_00011_0000000000001011;
  end
 
  always@(memread, address, mem_array[address])
  begin
    if(memread)begin
      readdata=mem_array[address];
    end
  end

endmodule

module testbench3;
  reg memread;              /* rw=RegWrite */
  reg [7:0] adr;  /* adr=address */
  wire [31:0] rd; /* rd=readdata */
  
  IMemBank u0(memread, adr, rd);
  
  initial begin
    memread=1'b0;
    adr=16'd0;
    
    #5
    memread=1'b1;
    adr=16'd0;
  end
  
  initial repeat(127)#4 adr=adr+1;
  
endmodule
