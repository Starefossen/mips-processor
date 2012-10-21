----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:45:14 10/11/2012 
-- Design Name: 
-- Module Name:    decoder - Behavioral 
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
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity decoder is
	Port ( 
		clk 						: in  STD_LOGIC;
		reset 					: in  STD_LOGIC;
		
		-- processor instruction
		imem_data_in			: in 	STD_LOGIC_VECTOR (31 downto 0) := "11111100000000000000000000000000";
		
		-- forwarded signals for writing regtister
		id_ctrl_regWrite		: in 	STD_LOGIC := '0';								-- from wb step
		id_regWriteAddr		: in 	STD_LOGIC_VECTOR (4 downto 0) := (others => '0');	-- from wb step
		id_regWriteData		: in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');	-- from wb step
		id_if_pc					: in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');	-- from if step

		-- output signals
		if_ctrl_jump 			: out  STD_LOGIC := '0'; -- from processor control
		if_jump_addr 			: out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

		wb_ctrl_regWrite 		: out  STD_LOGIC := '0';
		wb_ctrl_memtoReg 		: out  STD_LOGIC := '0';

		mem_ctrl_branch 		: out  STD_LOGIC := '0';
		mem_ctrl_memRead 		: out  STD_LOGIC := '0';
		mem_ctrl_memWrite 	: out  STD_LOGIC := '0';

		ex_ctrl_regDst 		: out  STD_LOGIC := '0';
		ex_ctrl_aluOp 			: out  STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		ex_ctrl_aluSrc 		: out  STD_LOGIC := '0';
		ex_pc						: out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_register_read_1 	: out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_register_read_2 	: out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_signext 				: out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_inst_20_16 			: out  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		ex_inst_15_11 			: out  STD_LOGIC_VECTOR (4 downto 0) := (others => '0')
	);
end decoder;

architecture Behavioral of decoder is

	component PROCESSOR_CONTROL is
		Port ( 
			OPCode 				: in  STD_LOGIC_VECTOR (5 downto 0);
			RegDst 				: out STD_LOGIC;
			Jump 					: out STD_LOGIC;
			Branch 				: out STD_LOGIC;
			MemRead 				: out STD_LOGIC;
			MemtoReg 			: out STD_LOGIC;
			ALUOp 				: out STD_LOGIC_VECTOR (1 downto 0);
			MemWrite 			: out STD_LOGIC;
			ALUSrc 				: out STD_LOGIC;
			RegWrite 			: out STD_LOGIC
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

	component SIGN_EXTEND is 
		Port (
			bus_in 	: in  STD_LOGIC_VECTOR (15 downto 0);
			bus_out 	: out  STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	signal RegDst 				: STD_LOGIC := '0';
	signal Jump 				: STD_LOGIC := '0';
	signal Branch 				: STD_LOGIC := '0';
	signal MemRead 			: STD_LOGIC := '0';
	signal MemtoReg 			: STD_LOGIC := '0';
	signal ALUOp 				: STD_LOGIC_VECTOR (1 downto 0) := "10";
	signal MemWrite 			: STD_LOGIC := '0';
	signal ALUSrc 				: STD_LOGIC := '0';
	signal RegWrite 			: STD_LOGIC := '0';
	
	signal registers_readdata1 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal registers_readdata2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
<<<<<<< HEAD
	signal tmp_registers_readdata1 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal tmp_registers_readdata2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
=======
>>>>>>> 6d407c7ed3da5b40cc13aed2ec6edabbea7caf01
	signal signext_output 	: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	
begin

	-- Processor control component
	-- todo remove state from source
	processor_ctrl : PROCESSOR_CONTROL  port map ( 
		OPCode 					=> imem_data_in(31 downto 26),
		RegDst 					=> RegDst,
		Jump 						=> Jump,
		Branch 					=> Branch,
		MemRead 					=> MemRead,
		MemtoReg 				=> MemtoReg,
		ALUOp 					=> ALUOp,
		MemWrite 				=> MemWrite,
		ALUSrc 					=> ALUSrc,
		RegWrite 				=> RegWrite
	);

	-- General Registers
	registers : register_file port map(
		CLK 						=> clk,		
		RESET						=> reset,		
		RW							=> id_ctrl_regWrite,		
		RS_ADDR 					=> imem_data_in(25 downto 21),
		RT_ADDR 					=> imem_data_in(20 downto 16),
		RD_ADDR 					=> id_regWriteAddr,
		WRITE_DATA				=> id_regWriteData,
		RS							=>	registers_readdata1,
		RT							=> registers_readdata2
	);
	
	-- Sign extender (branch)
	signext : SIGN_EXTEND port map(
		bus_in 					=> imem_data_in(15 downto 0),
		bus_out 					=> signext_output
	);

	STEP_DECODER : process(clk, reset)
	begin	
		
		if reset = '1' then
			
			if_jump_addr 			<= (others => '0');
			if_ctrl_jump 			<= '0';

			wb_ctrl_regWrite 		<= '0';
			wb_ctrl_memtoReg 		<= '0';

			mem_ctrl_branch 		<= '0';
			mem_ctrl_memRead 		<= '0';
			mem_ctrl_memWrite 	<= '0';

			ex_ctrl_regDst 		<= '0';
			ex_ctrl_aluOp 			<= "10";
			ex_ctrl_aluSrc 		<= '0';
			
			ex_pc						<= (others => '0');
			ex_signext 				<= (others => '0'); 
			ex_inst_20_16 			<= (others => '0'); 
			ex_inst_15_11 			<= (others => '0'); 
			
			ex_register_read_1 	<= (others => '0'); 
			ex_register_read_2 	<= (others => '0'); 
			
<<<<<<< HEAD
		else
				
			if rising_edge(clk) then
			
				--jump signals
				if_jump_addr(31 downto 28) <= id_if_pc(31 downto 28);
				if_jump_addr(27 downto 2)  <= imem_data_in(25 downto 0);
				if_jump_addr(1 downto 0)	<= "00";
				if_ctrl_jump 					<= Jump;

				--propagating control signals
				wb_ctrl_regWrite 		<= RegWrite;
				wb_ctrl_memtoReg 		<= MemtoReg;

				mem_ctrl_branch 		<= Branch;
				mem_ctrl_memRead 		<= MemRead;
				mem_ctrl_memWrite 	<= MemWrite;

				ex_ctrl_regDst 		<= RegDst;
				ex_ctrl_aluOp 			<= ALUOp;
				ex_ctrl_aluSrc 		<= ALUSrc;
				
				ex_pc						<= id_if_pc;
				ex_signext 				<= signext_output;
				ex_inst_20_16 			<= imem_data_in(20 downto 16);
				ex_inst_15_11 			<= imem_data_in(15 downto 11); 
				
				ex_register_read_1 	<= registers_readdata1;
				ex_register_read_2 	<= registers_readdata2;
				
			elsif falling_edge(clk) then
				tmp_registers_readdata1 	<= registers_readdata1;
				tmp_registers_readdata2 	<= registers_readdata2;
			end if;
=======
		elsif rising_edge(clk) then
			
			--jump signals
			if_jump_addr(31 downto 28) <= id_if_pc(31 downto 28);
			if_jump_addr(27 downto 2)  <= imem_data_in(25 downto 0);
			if_jump_addr(1 downto 0)	<= "00";
			if_ctrl_jump 					<= Jump;

			--propagating control signals
			wb_ctrl_regWrite 		<= RegWrite;
			wb_ctrl_memtoReg 		<= MemtoReg;

			mem_ctrl_branch 		<= Branch;
			mem_ctrl_memRead 		<= MemRead;
			mem_ctrl_memWrite 	<= MemWrite;

			ex_ctrl_regDst 		<= RegDst;
			ex_ctrl_aluOp 			<= ALUOp;
			ex_ctrl_aluSrc 		<= ALUSrc;
			
			ex_pc						<= id_if_pc;
			ex_signext 				<= signext_output;
			ex_inst_20_16 			<= imem_data_in(20 downto 16);
			ex_inst_15_11 			<= imem_data_in(15 downto 11); 
			
			ex_register_read_1 	<= registers_readdata1;
			ex_register_read_2 	<= registers_readdata2;
>>>>>>> 6d407c7ed3da5b40cc13aed2ec6edabbea7caf01
		end if;
	end process;

end Behavioral;

