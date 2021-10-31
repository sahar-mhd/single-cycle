/// computerAssignment_4
// group members: sara Ghavampour 98 127 62 781 - sahar Mohammadi 9812762305

//memory unit
module DMemBank(input memread, input memwrite, input [7:0] address, input [31:0] writedata, output reg [31:0] readdata);
 
  reg [31:0] mem_array [127:0];
  
  integer i;
  initial 
  begin
      mem_array[0]=2;
	mem_array[1]=5;
	mem_array[2]=17;
	mem_array[3]=4;
	mem_array[4]=1;
	mem_array[5]=19;
	mem_array[6]=20;
	mem_array[7]=9;
	mem_array[8]=5;
	mem_array[9]=11;
  end
 
  always@(memread, memwrite, address, mem_array[address], writedata)
  begin
    if(memread)begin
      readdata=mem_array[address];
    end

    if(memwrite)
    begin
      mem_array[address]= writedata;
    end

  end

endmodule

module testbench4;
  reg memread, memwrite;              /* rw=RegWrite */
  reg [7:0] adr;  /* adr=address */
  wire [31:0] rd; /* rd=readdata */
  reg [31:0] wd;
  
  DMemBank u0(memread, memwrite, adr, wd, rd);
  
  initial begin
    memread=1'b0;
    adr=16'd0;
    
    #5
    memread=1'b1;
    adr=16'd0;
  end
  
  initial repeat(127)#4 adr=adr+1;
  
endmodule
