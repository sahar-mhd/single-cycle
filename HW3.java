//Computer assignment number 3
// group members: Sahar Mohammadi 9812762305 - Sara Ghavampour 9812762781

class ALU {
    int add(int operand1, int operand2) {
        return operand1 + operand2;
    }

    int sub(int operand1, int operand2) {
        return operand1 - operand2;
    }

    int and(int operand1, int operand2) {
        return operand1 & operand2;
    }

    int or(int operand1, int operand2) {
        return operand1 | operand2;
    }
}

class RegisterFile {
    String[] registers = new String[32];

    String read(int readR1) {
        return registers[readR1];
    }

    String[] read(int readR1, int readR2) {
        String[] read = new String[2];
        read[0] = registers[readR1];
        read[1] = registers[readR2];
        return read;
    }

    void write(int writeR, String writeD) {
        registers[writeR] = writeD;
    }
}

class DataMemory {
    String[] data = new String[20];

    String read(int address) {
        return data[address];
    }

    void write(int address, String writeD) {
        data[address] = writeD;
    }
}

class InstructionMemory {
    String[] instructions = new String[40];

    String read(int address) {
        return instructions[address];
    }
}

class FUM_MIPS {
    RegisterFile register_file = new RegisterFile();
    DataMemory data_memory = new DataMemory();
    InstructionMemory instruction_memory = new InstructionMemory();
    int PC = 0;
    ALU alu = new ALU();

    void run(int programEnd) {
        while (PC < programEnd) {
            decode(instruction_memory.instructions[PC]);
        }
    }

    void decode(String ins) {
        if (ins.startsWith("000000")) {
            rType(ins);
        } else if (ins.startsWith("000010")) {
            jType(ins);
        } else {
            iType(ins);
        }
    }

    void rType(String ins) {
        String s1 = ins.substring(6, 11);
        String s2 = ins.substring(11, 16);
        int r1 = Integer.parseInt(s1, 2);
        int r2 = Integer.parseInt(s2, 2);
        String[] s = register_file.read(r1, r2);
        int o1 = Integer.parseInt(s[0], 2);
        int o2 = Integer.parseInt(s[1], 2);
        int w = Integer.parseInt(ins.substring(16, 21), 2);

        if (ins.endsWith("100000")) { //add
            int result = alu.add(o1, o2);
            String s3 = Integer.toBinaryString(result);
            register_file.write(w, s3);

        } else if (ins.endsWith("100010")) { //sub
            int result = alu.sub(o1, o2);
            register_file.write(w, Integer.toBinaryString(result));

        } else if (ins.endsWith("100101")) { //or
            int result = alu.or(o1, o2);
            register_file.write(w, Integer.toBinaryString(result));

        } else if (ins.endsWith("100100")) { //and
            int result = alu.and(o1, o2);
            register_file.write(w, Integer.toBinaryString(result));

        } else if (ins.endsWith("101010")) { //slt
            if (o1 < o2) {
                register_file.write(w, "000001");
            } else {
                register_file.write(w, "000000");
            }
        }

        PC++;
    }

    void jType(String ins) {
        PC = Integer.parseInt(ins.substring(6, 32), 2);
    }

    void iType(String ins) {

        String s1 = ins.substring(6, 11);  // rs
        int destination = Integer.parseInt(ins.substring(11, 16), 2); //rd(dest)
        int r1 = Integer.parseInt(s1, 2);
        int rsVal = Integer.parseInt(register_file.read(r1), 2);
        int immediate = Integer.parseInt(ins.substring(16, 32), 2);
        if (ins.startsWith("101011")) { //sw
            int addr = alu.add(rsVal, immediate);

            data_memory.write(addr, register_file.read(destination));
            PC++;

        } else if (ins.startsWith("100011")) { //lw
            int addr = alu.add(rsVal, immediate);

            register_file.write(destination, data_memory.read(addr));
            PC++;

        } else if (ins.startsWith("001000")) { //addi
            int add = alu.add(rsVal, immediate);

            register_file.write(destination, Integer.toBinaryString(add));
            PC++;

        } else if (ins.startsWith("001010")) { //slti

            if (rsVal < immediate) register_file.write(destination, Integer.toBinaryString(1));
            else register_file.write(destination, Integer.toBinaryString(0));
            PC++;


        } else if (ins.startsWith("001100")) { //andi
            int and = alu.and(rsVal, immediate);
            register_file.write(destination, Integer.toBinaryString(and));
            PC++;


        } else if (ins.startsWith("001101")) { //ori
            int or = alu.or(rsVal, immediate);
            register_file.write(destination, Integer.toBinaryString(or));
            PC++;


        } else if (ins.startsWith("000100")) { //beq
            if (rsVal == destination)
                PC += immediate + 1;
            else PC++;

        } else if (ins.startsWith("000101")) { //bne
            if (rsVal != destination) PC += immediate + 1;
            else PC++;

        }
    }
}

public class HW3 {

    public static void findMin(FUM_MIPS mips) {
        String[] mem_array = new String[10];
        mem_array[0] = "00100000000000101111111111111111";        //addi $2, $0, 65535
        mem_array[1] = "00000000000000000010000000100000";        //add $4, $0, $0
        mem_array[2] = "00101000100001010000000000001010";//loop: slti $5, $4, 10
        mem_array[3] = "00010000101000000000000000000110";       //beq $5, $0, endloop
        mem_array[4] = "10001100100001100000000000000000";       //lw $6, 0($4)
        mem_array[5] = "00000000110000100011100000101010";       //slt $7, $6, $2
        mem_array[6] = "00010000111000000000000000000001";       //beq $7, $0, afterif
        mem_array[7] = "00000000000001100001000000100000";       //add $2, $0, $6
        mem_array[8] = "00100000100001000000000000000001";       //addi $4, $4, 1
        mem_array[9] = "00001000000000000000000000000100";//afterif: j loop
                                                          //endloop:
        int i = 0;
        for (int j = mips.PC; i < mem_array.length; j++) {
            mips.instruction_memory.instructions[j] = mem_array[i];
            i++;
        }
        mips.run(mips.PC + i);
    }

    public static void findMax(FUM_MIPS mips) {
        String[] mem_array = new String[10];
        mem_array[0] = "00100000000000110000000000000000";        //addi $3, $0, 0
        mem_array[1] = "00000000000000000010000000100000";        //add $4, $0, $0
        mem_array[2] = "00101000100001010000000000001010";//loop: slti $5, $4, 10
        mem_array[3] = "00010000101000000000000000000110";        //beq $5, $0, endloop
        mem_array[4] = "10001100100001100000000000000000";        //lw $6, 0($4)
        mem_array[5] = "00000000011001100011100000101010";        //slt $7, $3, $6
        mem_array[6] = "00010000111000000000000000000001";        //beq $7, $0, afterif
        mem_array[7] = "00000000000001100001100000100000";        //add $3, $0, $6
        mem_array[8] = "00100000100001000000000000000001";        //addi $4, $4, 1
        mem_array[9] = "00001000000000000000000000001110";//afterif: j loop
                                                          //endloop
        int i = 0;
        for (int j = mips.PC; i < mem_array.length; j++) {
            mips.instruction_memory.instructions[j] = mem_array[i];
            i++;
        }
        mips.run(mips.PC + i);
    }

    public static void main(String[] args) {
        FUM_MIPS mips = new FUM_MIPS();

        mips.register_file.registers[0] = Integer.toBinaryString(0);
        mips.register_file.registers[1] = Integer.toBinaryString(10);
        mips.register_file.registers[2] = Integer.toBinaryString(12);

        mips.data_memory.data[11] = Integer.toBinaryString(20);

        String[] program = new String[2];
        program[0] = "00000000001000100001100000100000";  //add $3, $1, $2
        program[1] = "10001100001000100000000000000001";  //lw $2, 1($1)

        int i = 0;
        for (int j = mips.PC; i < program.length; j++) {
            mips.instruction_memory.instructions[j] = program[i];
            i++;
        }
        mips.run(mips.PC + i);

        mips.data_memory.data[0] = Integer.toBinaryString(2);
        mips.data_memory.data[1] = Integer.toBinaryString(5);
        mips.data_memory.data[2] = Integer.toBinaryString(17);
        mips.data_memory.data[3] = Integer.toBinaryString(4);
        mips.data_memory.data[4] = Integer.toBinaryString(1);
        mips.data_memory.data[5] = Integer.toBinaryString(19);
        mips.data_memory.data[6] = Integer.toBinaryString(20);
        mips.data_memory.data[7] = Integer.toBinaryString(9);
        mips.data_memory.data[8] = Integer.toBinaryString(5);
        mips.data_memory.data[9] = Integer.toBinaryString(11);

        findMin(mips);
        findMax(mips);

        String[] mem_array = new String[6];
        mem_array[0] = "00000000001000100100000000100010";  //sub $8, $1, $2
        mem_array[1] = "10101101000000100000000000000011";  //sw $2, 3($8)
        mem_array[2] = "00000000001000100100100000100101";  //or $9, $1, $2
        mem_array[3] = "00000000001000100101000000100100";  //and $10, $1, $2
        mem_array[4] = "00110100001010110000000000000010";  //ori $11, $1, 2
        mem_array[5] = "00110000001011000000000000000010";  //andi $12, $1, 2

        i = 0;
        for (int j = mips.PC; i < mem_array.length; j++) {
            mips.instruction_memory.instructions[j] = mem_array[i];
            i++;
        }
        mips.run(mips.PC + i);

        System.out.println("pc: " + mips.PC);
        System.out.println("register_file:");

        for (int j = 0; j < 32; j++) {
            System.out.println("register_file  " + j + " :  " + mips.register_file.registers[j]);
        }
        System.out.println("data_memory:");

        for (int j = 0; j < 20; j++) {
            System.out.println("data_memory  " + j + " :  " + mips.data_memory.data[j]);
        }

    }
}
