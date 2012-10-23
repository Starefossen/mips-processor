--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	07:46:10 10/01/2012
-- Design Name:	
-- Module Name:	C:/Users/hanskrfl/Desktop/assignment1SimpleProc/testbenches/tb_processor_control.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: PROCESSOR_CONTROL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- "WORK" is the current library
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

ENTITY tb_processor_control IS
END tb_processor_control;
 
ARCHITECTURE behavior OF tb_processor_control IS 
 
	-- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT PROCESSOR_CONTROL
	PORT(
		 OPCode 				: IN  std_logic_vector(5 downto 0);
		 State 				: IN  state_type;
		 RegDst 				: OUT  std_logic;
		 Jump 				: OUT  std_logic;
		 Branch 				: OUT  std_logic;
		 MemRead 			: OUT  std_logic;
		 MemtoReg 			: OUT  std_logic;
		 ALUOp 				: OUT  std_logic_vector(1 downto 0);
		 MemWrite 			: OUT  std_logic;
		 ALUSrc 				: OUT  std_logic;
		 --PCWrite 			: OUT  std_logic;
		 RegWrite 			: OUT  std_logic;
		 NextState 			: OUT  state_type
	);
	END COMPONENT;
	

	--Inputs
	signal OPCode 			: std_logic_vector(5 downto 0) := (others => '0');
	signal State 			: state_type := EXEC;

 	--Outputs
	signal RegDst 			: std_logic;
	signal Jump				: std_logic;
	signal Branch 			: std_logic;
	signal MemRead 		: std_logic;
	signal MemtoReg 		: std_logic;
	signal ALUOp 			: std_logic_vector(1 downto 0);
	signal MemWrite 		: std_logic;
	signal ALUSrc 			: std_logic;
	--signal PCWrite 		: std_logic;
	signal RegWrite 		: std_logic;
	signal NextState 		: state_type;
 
	constant clk_period : time := 40 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: PROCESSOR_CONTROL PORT MAP (
			OPCode 			=> OPCode,
			State 			=> State,
			RegDst 			=> RegDst,
			Jump 				=> Jump,
			Branch 			=> Branch,
			MemRead 			=> MemRead,
			MemtoReg 		=> MemtoReg,
			ALUOp 			=> ALUOp,
			MemWrite 		=> MemWrite,
			ALUSrc 			=> ALUSrc,
			--PCWrite 			=> PCWrite,
			RegWrite 		=> RegWrite,
			NextState 		=> NextState
		);

	-- Stimulus process
	stim_proc: process
	begin		
	
		State					<= EXEC;
		OPCode 				<= OP_R;
		wait for clk_period;
				
		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_J;
		wait for clk_period;
				
		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_R;
		wait for clk_period;
				
		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_I_LOAD;
		wait for clk_period;
				
		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_R;
		wait for clk_period;

		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_I_STORE;
		wait for clk_period;		

		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_R;
		wait for clk_period;		

		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_I_LI;
		wait for clk_period;
				
		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_R;
		wait for clk_period;

		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_I_BEQ;
		wait for clk_period;		

		if State = STALL then
			State 			<= EXEC;
		else
			State				<= NextState;
		end if;
		OPCode 				<= OP_R;
		
		wait;
	end process;

END;
