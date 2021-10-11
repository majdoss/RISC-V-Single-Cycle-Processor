library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RV32I_pkg.all;

entity datapath is 
 port ( clk : in std_logic ;
	rst_n : in std_logic );
end datapath;

architecture rtl of datapath is

component instr_mem
 port ( address : in std_logic_vector (ADDRLEN-1 downto 0);
	dataout : out std_logic_vector (XLEN-1 downto 0));
end component;

component add4
 port ( datain : in std_logic_vector (XLEN-1 downto 0);
	result : out std_logic_vector (XLEN-1 downto 0));
end component;

component pc
 port ( clk : in std_logic ;
	rst_n : in std_logic ;
	datain : in std_logic_vector (XLEN-1 downto 0);
	dataout : out std_logic_vector (XLEN-1 downto 0));
end component ;

component alu
    port ( inputA : in std_logic_vector (XLEN-1 downto 0);
       	   inputB : in std_logic_vector (XLEN-1 downto 0);
           ALUop : in std_logic_vector (3 downto 0);
           result : out std_logic_vector (XLEN-1 downto 0));
end component;

component branch_cmp
    port (
        inputA : in std_logic_vector(XLEN-1 downto 0);
        inputB : in std_logic_vector(XLEN-1 downto 0);
        cond : in std_logic_vector(2 downto 0);
        result : out std_logic );
end component;

component data_mem
    port ( clk : in std_logic;
           reset_n : in std_logic;
           address : in std_logic_vector (ADDRLEN-1 downto 0);
           datain : in std_logic_vector (XLEN-1 downto 0);
           ByteMask : in std_logic_vector (1 downto 0); -- "00" = byte; "01" = half-word; "10" = word
           SignExt_n : in std_logic; -- '0' = sign-extend; '1' = zero-extend
           MemWrite : in std_logic;
           MemRead : in std_logic;
           dataout : out std_logic_vector (XLEN-1 downto 0));
end component;

component immgen
    port (
        instruction : in std_logic_vector (XLEN-1 downto 0);
        immediate : out std_logic_vector (XLEN-1 downto 0));
end component;

component reg_file
    port ( clk : in std_logic;
           rst_n : in std_logic;
           RegWrite : in std_logic;
           rs1 : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           rs2 : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           rd : in std_logic_vector (LOG2_XRF_SIZE-1 downto 0);
           datain : in std_logic_vector (XLEN-1 downto 0);
           regA : out std_logic_vector (XLEN-1 downto 0);
           regB : out std_logic_vector (XLEN-1 downto 0));
end component;

component control
  port (
    instruction : in std_logic_vector (XLEN-1 downto 0);
    BranchCond : in std_logic; -- BR. COND. SATISFIED = 1; NOT SATISFIED = 0
    Jump : out std_logic;
    Lui : out std_logic;
    PCSrc : out std_logic;
    RegWrite : out std_logic;
    ALUSrc1 : out std_logic;
    ALUSrc2 : out std_logic;
    ALUOp : out std_logic_vector (3 downto 0);
    MemWrite : out std_logic;
    MemRead : out std_logic;
    MemToReg : out std_logic);
end component;

component mux2to1
    port ( sel : in std_logic;
	   input0 : in std_logic_vector (XLEN-1 downto 0);
       	   input1 : in std_logic_vector (XLEN-1 downto 0);
           output : out std_logic_vector (XLEN-1 downto 0));
end component;

signal out_add4: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal in_pc: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal out_pc: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal out_instruction: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal out_imm: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal out_regA: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal out_regB: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal datain_reg: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal in1_alu: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal in2_alu: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal branch_result: std_logic := '0';
signal out_alu: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal out_data_mem: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal out_MemToReg: std_logic_vector (XLEN-1 downto 0):= (others => '0');
signal in_mux: std_logic_vector (XLEN-1 downto 0):= (others => '0');

signal d_zero : std_logic_vector (XLEN-1 downto 0);

signal c_Jump: std_logic := '0';
signal c_Lui: std_logic := '0';
signal c_PCSrc: std_logic := '0';
signal c_RegWrite: std_logic := '0';
signal c_ALUSrc1: std_logic := '0';
signal c_ALUSrc2: std_logic := '0';
signal c_ALUOp: std_logic_vector (3 downto 0):= (others => '0');
signal c_MemWrite: std_logic := '0';
signal c_MemRead: std_logic := '0';
signal c_MemToReg: std_logic := '0';

signal d_byte_mask : std_logic_vector (1 downto 0);
signal d_rs1 : std_logic_vector (4 downto 0);
signal d_rs2 : std_logic_vector (4 downto 0);
signal d_rd : std_logic_vector (4 downto 0);
signal d_funct3 : std_logic_vector (2 downto 0);
signal d_dmem_addr : std_logic_vector (ADDRLEN-1 downto 0);
signal d_sign_ext_n : std_logic;
signal d_imem_addr : std_logic_vector (ADDRLEN-1 downto 0);

begin 

pc_block: pc port map ( clk => clk,
	          	rst_n => rst_n,
		  	datain => in_pc,
		        dataout => out_pc );

add4_block: add4 port map ( datain => out_pc,
	              	    result => out_add4 );

instr_mem_block: instr_mem port map ( address => d_imem_addr,
			      	      dataout => out_instruction);

alu_block: alu port map ( inputA => in1_alu,
       			  inputB => in2_alu,
        		  ALUop => c_ALUOp,
        		  result => out_alu );

branch_cmp_block: branch_cmp port map ( inputA => out_regA,
       					inputB => out_regB,
        				cond => d_funct3,
        				result => branch_result );

data_mem_block: data_mem port map ( clk => clk,
          			    reset_n => rst_n,
           			    address => d_dmem_addr,
           			    datain => out_regB,
           			    ByteMask => d_byte_mask,
				    SignExt_n => d_sign_ext_n,
           			    MemWrite => c_MemWrite,
           			    MemRead => c_MemRead,
           			    dataout => out_data_mem);

immgen_block: immgen port map ( instruction => out_instruction,
                                immediate => out_imm );

reg_file_block: reg_file port map ( clk => clk,
         		            rst_n => rst_n,
        		     	    RegWrite => c_RegWrite,
        		     	    rs1 => d_rs1,
        		     	    rs2 => d_rs2,
        		            rd => d_rd,
        		            datain => datain_reg,
        		            regA => out_regA,
        		            regB => out_regB );

control_block: control port map ( instruction => out_instruction,
   				  BranchCond => branch_result,
    				  Jump => c_Jump,
				  Lui => c_Lui,
    				  PCSrc => c_PCSrc,
    				  RegWrite => c_RegWrite,
    				  ALUSrc1 => c_ALUSrc1,
    				  ALUSrc2 => c_ALUSrc2,
    				  ALUOp => c_ALUOp,
    				  MemWrite => c_MemWrite,
    				  MemRead => c_MemRead,
    				  MemToReg => c_MemToReg );

MUX_IF_stage: mux2to1 port map ( sel => c_PCSrc,
				 input0 => out_add4,
       	 		   	 input1 => out_alu,
          		         output => in_pc );

MUX_RF_datain: mux2to1 port map ( sel => c_Jump,
				  input0 => out_MemToReg,
       	 		 	  input1 => out_add4,
          		  	  output => datain_reg);

MUX_ALU_in_1: mux2to1 port map ( sel => c_ALUSrc1,
				 input0 => out_regA,
       	 		  	 input1 => in_mux,
          		   	 output => in1_alu );

MUX_ALU_in_2: mux2to1 port map ( sel => c_ALUSrc2,
				 input0 => out_regB,
       	 		   	 input1 => out_imm,
          		   	 output => in2_alu );

MUX_in_MUX: mux2to1 port map ( sel => c_Lui,
			       input0 => out_pc,
       	 		       input1 => d_zero,
          		       output => in_mux);

MUX_MemToReg: mux2to1 port map ( sel => c_MemToReg,
				 input0 => out_alu,
       	 		  	 input1 => out_data_mem,
          		   	 output => out_MemToReg );

    d_imem_addr <= out_pc(ADDRLEN-1 downto 0);
    d_dmem_addr <= out_alu(ADDRLEN-1 downto 0);
    d_rs1 <= out_instruction(LOG2_XRF_SIZE+14 downto 15);
    d_rs2 <= out_instruction(LOG2_XRF_SIZE+19 downto 20);
    d_rd <= out_instruction(LOG2_XRF_SIZE+6 downto 7);
    d_funct3 <= out_instruction(14 downto 12);
    d_zero <= (others=>'0');
    d_byte_mask <= d_funct3(1 downto 0);
    d_sign_ext_n <= d_funct3(2);

end architecture;
