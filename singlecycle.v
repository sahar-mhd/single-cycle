/// computerAssignment_4
// group members: sara Ghavampour 98 127 62 781 - sahar Mohammadi 9812762305



module FUM_MIPS ();

reg clk;
wire [31:0] Instruction; // 32 bit instrucions in mips
wire [4:0] WriteRegister;   /// adress of register that we're gonna write in.
wire [31:0] ReadData1, ReadData2;
wire [31:0] Instruction_15_0_SignExtended;
wire [31:0] ALUSrc2, ALUResult;  // ALUSrc2 is the second input for ALU
wire [31:0] DataMemory_ReadData;

wire [31:0] BranchOrPC;    //// pc=pc+4 or pc = BranchAddress
wire [31:0] BranchAddress;


reg  [31:0] ProgramCounter;   //  pc    
wire [31:0] RegisterFile_WriteData;   /// data that we want to write in regFile

wire [31:0] JumpAddress;
wire [31:0] FinalPC, ProgramCounterPlus2;   //  final pc is final value for pc after checking branchs ans jump

//  ????

wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Jump, Beq, Bne;
wire [3:0] ALU_ControlOut;     // output of cintrol unit                                                               

wire Zero, gt,lt;

wire Branch;  // control signal for branch and bne

reg  [31:0] temp;    


  initial begin
    temp <= 32'd0;
    ProgramCounter <= 32'd0;
    clk <= 0;
  end
  
  always #10 clk = ~clk;
  
  always @(posedge clk)    
  begin
   ProgramCounter = temp;
   #1
   temp = FinalPC[31:0];

  end


assign Branch = (Beq & Zero) | (Bne & !(Zero));
assign JumpAddress = {ProgramCounter[31:25] , Instruction[25:0]}; // calculate JumpAddress 



MUX_5bit_2to1  RegDst_Multiplexer(Instruction[20:16], Instruction[15:11], WriteRegister, RegDst); //if RegDst == 1 (R-type) : out = p1 else out = p0

MUX_32bit_2to1 ALUSrc_Multiplexer(Instruction_15_0_SignExtended, ReadData2, ALUSrc2, ALUSrc); //if ALUSrc == 1 (ADDI, SUBI ...) : out = p1 else out = p2

MUX_32bit_2to1 MemtoReg_Multiplexer(DataMemory_ReadData, ALUResult, RegisterFile_WriteData, MemtoReg); //if MemtoReg == 1 : out = p1 else out = p2

MUX_32bit_2to1 Branch_Multiplexer(BranchAddress, ProgramCounterPlus2, BranchOrPC, Branch);

MUX_32bit_2to1 Jump_Multiplexer(JumpAddress, BranchOrPC, FinalPC, Jump);


IMemBank InstructionMemory(1'b1, ProgramCounter, Instruction);  // fetch instruction   //  ProgramCounter   ??????

RegFile RegisterFile(clk, Instruction[25:21], Instruction[20:16], WriteRegister, RegisterFile_WriteData, RegWrite, ReadData1, ReadData2);

ALU Alu(ReadData1, ALUSrc2, ALU_ControlOut, ALUResult, Zero, lt, gt);

DMemBank DataMemory(MemRead, MemWrite, ALUResult[7:0], ReadData2, DataMemory_ReadData);

ControlUnit Control(Instruction[31:26], Instruction[5:0],
                    RegDst, ALUSrc, MemtoReg, RegWrite,
                    MemRead, MemWrite, Jump, Beq, Bne,ALU_ControlOut);
                    
/////   ????
Add_32 addadd(ProgramCounterPlus2[31:0], Instruction_15_0_SignExtended[31:0], BranchAddress[31:0]);   // calculate BranchAddress

SignExtend_32_bit Instruction_15_0_SignExtend(Instruction[15:0], Instruction_15_0_SignExtended, clk);

Add_PC ProgramCounter_Adder(temp, ProgramCounterPlus2[31:0], clk);  ///  pc = pc+1


endmodule



////    ????????
module Add_32(input [31:0] src1, src2, output reg [31:0] out);
always @(*)
    begin
        out = src1 + src2;
    end

endmodule

module SignExtend_32_bit(input[15:0] src,output reg [31:0] out,input clk);
always @(*) begin
    if(src[15])
      out = {16'b1111_1111_1111_1111 , src};
    else
      out = {16'd0 , src};
end
endmodule



////// ???????
module Add_PC(input [31:0] src, output reg  [31:0] out, input clk);
always @(*)
    begin
        out = src + 32'd1;
    end
endmodule

//2 to 1 MUX (32-bit inputs)
module MUX_32bit_2to1(p1, p2, out , sel);
input [31:0] p1;
input [31:0] p2;
input sel;
output reg [31:0] out;

always@(sel,p1,p2) begin
  if (sel==1'b1) begin
   out = p1;
  end 
  else begin 
   out = p2;
  end
end
endmodule

//2 to 1 MUX (5-bit inputs)
module MUX_5bit_2to1(p0, p1, out , sel);
input [4:0] p0;
input [4:0] p1;
input sel;
output reg [4:0] out;

always@(sel,p0,p1) begin
  if (sel==1'b1) begin
   out = p1;
  end 
  else begin
   out = p0;
  end
end
endmodule


