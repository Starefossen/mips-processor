----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:48 09/07/2012 
-- Design Name: 
-- Module Name:    processor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- "WORK" is the current library
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
	port (
        clk 					 : in  STD_LOGIC;
        reset			 	 	 : in  STD_LOGIC;
        processor_enable    : in  STD_LOGIC;
        imem_address        : out STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0) := (others => '0');
        imem_data_in        : in  STD_LOGIC_VECTOR (IDATA_BUS-1 downto 0);
        dmem_data_in        : in  STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);
        dmem_address        : out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0');
        dmem_address_wr     : out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0');
        dmem_data_out       : out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0');
        dmem_write_enable   : out STD_LOGIC := '0'
    );
end processor;

architecture Behavioral of processor is

	-- Processor Control
	component PROCESSOR_CONTROL is
		Port ( 
			OPCode 				: in  STD_LOGIC_VECTOR (5 downto 0);
			State 				: in  state_type;
			RegDst 				: out STD_LOGIC;
			Jump 					: out STD_LOGIC;
			Branch 				: out STD_LOGIC;
			MemRead 				: out STD_LOGIC;
			MemtoReg 			: out STD_LOGIC;
			ALUOp 				: out STD_LOGIC_VECTOR (1 downto 0);
			MemWrite 			: out STD_LOGIC;
			ALUSrc 				: out STD_LOGIC;
			RegWrite 			: out STD_LOGIC;
			--PCWrite	 			: out STD_LOGIC
			NextState			: out state_type
		);
	end component;
	
	-- ALU Control
	component ALU_CONTROL is
		Port ( 
			ALUOp 			: in  STD_LOGIC_VECTOR (1 downto 0);
			ALUFunct 		: in  STD_LOGIC_VECTOR (5 downto 0);
			ALUCtrl		 	: out ALU_INPUT
		);
	end component;
	
	component SIGN_EXTEND is 
		Port (
			bus_in 	: in  STD_LOGIC_VECTOR (15 downto 0);
			bus_out 	: out  STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;

	component MUX is
		generic (N :NATURAL :=32); 
		Port ( selector : in  STD_LOGIC;
			bus_in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_out : out  STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;
	
	component REGISTER_FILE is
		port(
			CLK 			:	in	STD_LOGIC;				
			RESET			:	in	STD_LOGIC;				
			RW				:	in	STD_LOGIC;				
			RS_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0); 
			RT_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0); 
			RD_ADDR 		:	in	STD_LOGIC_VECTOR (RADDR_BUS-1 downto 0);
			WRITE_DATA	:	in	STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0); 
			RS				:	out STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);
			RT				:	out STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0)
		);
	end component;
	
	component ALU is
		generic (N :NATURAL :=32); 
		port(
			X			: in STD_LOGIC_VECTOR(N-1 downto 0);
			Y			: in STD_LOGIC_VECTOR(N-1 downto 0);
			ALU_IN	: in ALU_INPUT;
			R			: out STD_LOGIC_VECTOR(N-1 downto 0);
			FLAGS		: out ALU_FLAGS
		);
	end component;
	
	component PROGRAM_COUNTER is
		generic (N :NATURAL :=32);
		Port (
			clk 				: in STD_LOGIC;
			reset 			: in STD_LOGIC;
			signext_output	: in STD_LOGIC_VECTOR (31 downto 0);
			imem_data_25_0	: in STD_LOGIC_VECTOR (25 downto 0);
			Jump				: in STD_LOGIC;
			Branch			: in STD_LOGIC;
			Zero				: in STD_LOGIC;
			--PCWrite 			: in STD_LOGIC;
			State 			: in state_type;
			PCIn 				: in STD_LOGIC_VECTOR;
			PCOut 			: out STD_LOGIC_VECTOR (N-1 downto 0) := "00000000000000000000000000000001"
		);
	end component;	

	-- Processor control signals
	signal RegDst 						: STD_LOGIC := '0';
	signal Jump 						: STD_LOGIC := '0';
	signal Branch 						: STD_LOGIC := '0';
	signal MemRead 					: STD_LOGIC := '0';
	signal MemtoReg 					: STD_LOGIC := '0';
	signal ALUOp 						: STD_LOGIC_VECTOR (1 downto 0) := "10";
	signal ALUSrc 						: STD_LOGIC := '0';
	signal RegWrite 					: STD_LOGIC := '0';
	--signal PCWrite 					: STD_LOGIC := '1';
	signal state						: state_type := FETCH;
	signal NextState					: state_type := FETCH;
	signal NewState					: state_type := FETCH;

	-- ALU signals
	signal ALUCtrl 					: ALU_INPUT := (OP0 => '0', OP1 => '0', OP2 => '0', OP3 => '0');
	signal alu_output 				: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal alu_flags 					: ALU_FLAGS := (Carry => '0', Overflow => '0', Zero => '0', Negative => '0');

	-- Component output
	signal signext_output			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal mux_alusrc_output		: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal mux_regdst_output		: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal mux_memtoreg_output		: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal registers_readdata1		: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal registers_readdata2		: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal program_cnt				: STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";

begin
	
	-- Processor control component
	processor_ctrl : PROCESSOR_CONTROL  port map ( 
		OPCode 		=> imem_data_in(31 downto 26),
		State 		=> State,
		RegDst 		=> RegDst,
		Jump 			=> Jump,
		Branch 		=> Branch,
		MemRead 		=> MemRead,
		MemtoReg 	=> MemtoReg,
		ALUOp 		=> ALUOp,
		MemWrite 	=> dmem_write_enable,
		ALUSrc 		=> ALUSrc,
		RegWrite 	=> RegWrite,
		--PCWrite 		=> PCWrite
		NextState 	=> NextState
	);

	-- ALU control component
	alu_ctrl : ALU_CONTROL  port map ( 
		ALUOp 		=> ALUOp,
		ALUFunct 	=> imem_data_in(5 downto 0),
		ALUCtrl 		=> ALUCtrl
	);

	signext : SIGN_EXTEND port map(
		bus_in 		=> imem_data_in(15 downto 0),
		bus_out 		=> signext_output
	);

	mux_alusrc	: MUX port map(
		selector 	=> ALUSrc,
	   bus_in1 		=> registers_readdata2,
	   bus_in2 		=> signext_output,
	   bus_out 		=> mux_alusrc_output
	);
	
	mux_regdst : MUX generic map (N=>5) port map(
		selector 	=> RegDst,
	   bus_in1 		=> imem_data_in(20 downto 16),
	   bus_in2 		=> imem_data_in(15 downto 11),
	   bus_out 		=> mux_regdst_output
	);
	
	mux_memtoreg : MUX port map(
		selector 	=> MemtoReg,
	   bus_in1 		=> alu_output,
	   bus_in2 		=> dmem_data_in,
	   bus_out 		=> mux_memtoreg_output
	);
	
	-- Main ALU
	main_alu : ALU port map(
		X				=> registers_readdata1,
		Y				=> mux_alusrc_output,
		ALU_IN		=> ALUCtrl,
		R				=> alu_output,
		FLAGS			=> alu_flags
	);
	
	-- General Registers
	registers : register_file port map(
		CLK 			=> clk,		
		RESET			=> reset,		
		RW				=> RegWrite,		
		RS_ADDR 		=> imem_data_in(25 downto 21),
		RT_ADDR 		=> imem_data_in(20 downto 16),
		RD_ADDR 		=> mux_regdst_output,
		WRITE_DATA	=> mux_memtoreg_output,
		RS				=>	registers_readdata1,
		RT				=> registers_readdata2
	);
	
	-- Program Counter
	pc : PROGRAM_COUNTER port map(
		clk 				=> clk,
		reset 			=> reset,
		signext_output	=> signext_output,
		imem_data_25_0	=> imem_data_in(25 downto 0),
		Jump				=> Jump,
		Branch			=> Branch,
		Zero				=> alu_flags.Zero,
		--PCWrite			=> PCWrite,
		State				=> State,
		PCIn				=> program_cnt,
		PCOut				=> program_cnt
	);
	
	CHANGE_STATE : process(clk)
	begin
		if (rising_edge(clk)) then
			state <= NewState;
		end if;
	end process;
	
	PROCESSOR : process(clk, reset, processor_enable)
	begin
		-- Set external signals
		imem_address 				<= program_cnt;
		dmem_address 				<= alu_output;
		dmem_address_wr 			<= alu_output; 	
		dmem_data_out 				<= registers_readdata2;
		
		-- Reset
		if reset = '1' then
			imem_address 			<= (others => '0');
			dmem_address 			<= (others => '0');
			dmem_address_wr 		<= (others => '0');
			dmem_data_out 			<= (others => '0');
					
			NewState					<= FETCH;			
		
		-- Processor Enabled and State is Stall
		elsif processor_enable='1' then
			case state is
				when STALL => NewState <= FETCH;						
				when FETCH => NewState <= EXEC;						
				when EXEC => NewState <= NextState;						
			end case;
		
		-- Else (Processor Disabled)
		else
			NewState <= FETCH ;
		end if;
		
	end process;

end Behavioral;