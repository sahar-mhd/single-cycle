// computerAssignment_4
// group memebers: sara Ghacampour 98 127 62 781 - sahar Mohammadi 9812762305

module ControlUnit(opcode, funct, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Jump, Beq, Bne, ALU_Control);
input [5:0] opcode; 
input [5:0] funct;      
output RegDst;         
output ALUSrc;      
output MemtoReg;       
output RegWrite;     
output MemRead;          
output MemWrite;         
output Jump;            
output Beq;
output Bne;

          
output [3:0] ALU_Control;  

//Functions
`define ADD  6'b100000  //32
`define SUB  6'b100010   //34
`define AND  6'b100100   //36
`define OR   6'b100101    //37

`define SLT  6'b101010   //42


//I-Type Opcodes
`define ADDI 6'b001000  //8
`define ANDI 6'b001100  //12
`define ORI  6'b001101   //13
`define SLTI  6'b001010 //10

`define LW  6'b100011   //35
`define SW  6'b101011  //43

`define BEQ  6'b000100   //4
`define BNE  6'b000101    //5


//J-Type Opcodes
`define JMP  6'b000010   //2 

reg [3:0] alu_ctrl;

assign RegDst    = (opcode==6'b000000);

assign ALUSrc    = (opcode!=6'b000000) && (opcode!=`BEQ) && (opcode!=`BNE) && (opcode!=`JMP) ;

assign MemtoReg  = (opcode==`LW);

assign RegWrite  = (opcode==6'b000000) || (opcode==`ADDI) || (opcode==`ANDI) || (opcode==`ORI) || (opcode==`SLTI) || (opcode==`LW);

assign MemRead   = (opcode==`LW);

assign MemWrite  = (opcode==`SW);

assign Jump      = (opcode==`JMP);

assign Beq       = (opcode==`BEQ);

assign Bne       = (opcode==`BNE);



always@(opcode,funct) begin
  casex({opcode,funct})
    {6'd0 , `ADD},
    {`ADDI, 6'dx},
    {`LW , 6'dx},
    {`SW , 6'dx} : alu_ctrl = 4'b0010;

    {6'd0 , `SUB},    
    {`BEQ , 6'dx},
    {`BNE , 6'dx} : alu_ctrl = 4'b0110;

    {6'd0 , `AND},
    {`ANDI, 6'dx} : alu_ctrl = 4'b0000;

    {6'd0 , `OR} ,
    {`ORI , 6'dx} : alu_ctrl = 4'b0001;

 

   

    {6'd0 , `SLT},
    {`SLTI ,6'dx }: alu_ctrl = 4'b0111;

    default       : alu_ctrl = 4'b0010;    //  add
  endcase
end
 
assign ALU_Control = alu_ctrl;
   
endmodule


module controltestbench2;
  
  reg [31:0] Instruction;
  wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Jump, Beq, Bne;
  wire [3:0] ALU_ControlOut;           
  
  ControlUnit Control(Instruction[31:26], Instruction[5:0],
                    RegDst, ALUSrc, MemtoReg, RegWrite,
                    MemRead, MemWrite, Jump, Beq, Bne,ALU_ControlOut);

  initial begin
   Instruction = 32'b000000_00001_00010_00011_00000_100000; // add $3, $1 ,$2  // R-Type
    
   #5
   Instruction = 32'b100011_00001_00010_00000_00000_100000; // lw $2,32($1)  // I-Type

   #10
   Instruction = 32'b000010_0000000_0000000_100111000100;  // j 10000    // J-Type
  end
  
  
endmodule
