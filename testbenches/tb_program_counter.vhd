--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:00:04 10/01/2012
-- Design Name:   
-- Module Name:   //webedit.ntnu.no/groups/tdt4255lab2012/HK_REWRITE/assignment1SimpleProc/tb_program_counter.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PROGRAM_COUNTER
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
-- "WORK" is the current library
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL; 
 
ENTITY tb_program_counter IS
END tb_program_counter;
 
ARCHITECTURE behavior OF tb_program_counter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PROGRAM_COUNTER
    PORT(
		   clk 					: IN  std_logic;
		   reset 				: IN  std_logic;
		   signext_output 	: IN  std_logic_vector(31 downto 0);
		   imem_data_25_0 	: IN  std_logic_vector(25 downto 0);
		   Jump 					: IN  std_logic;
		   Branch 				: IN  std_logic;
		   Zero 					: IN  std_logic;
		   --PCWrite 				: IN  std_logic;
		   State 				: IN  state_type;
		   PCIn 					: IN  std_logic_vector(31 downto 0);
		   PCOut 				: OUT  std_logic_vector(31 downto 0)
		  );
    END COMPONENT;
    

   --Inputs
   signal clk 					: std_logic := '0';
   signal reset 				: std_logic := '0';
   signal signext_output 	: std_logic_vector(31 downto 0) := (others => '0');
   signal imem_data_25_0 	: std_logic_vector(25 downto 0) := (others => '0');
   signal Jump 				: std_logic := '0';
   signal Branch 				: std_logic := '0';
   signal Zero 				: std_logic := '0';
   --signal PCWrite 			: std_logic := '0';
   signal State	 			: state_type := EXEC;
   signal PCIn 				: std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal PCOut : std_logic_vector(31 downto 0) := (others => '0');

   -- Clock period definitions
   constant clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROGRAM_COUNTER PORT MAP (
		    clk 					=> clk,
		    reset 				=> reset,
		    signext_output 	=> signext_output,
		    imem_data_25_0 	=> imem_data_25_0,
		    Jump 				=> Jump,
		    Branch 				=> Branch,
		    Zero 				=> Zero,
		    --PCWrite 			=> PCWrite,
		    State	 			=> State,
		    PCIn					=> PCIn,
		    PCOut 				=> PCOut
		  );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		-- hold reset for 100 ns
		reset <= '1';
		wait for 100 ns;	
		reset <= '0';
		
		wait for clk_period*10;

		signext_output 		<= (others => '0'); 
		imem_data_25_0 		<= (others => '0'); 
		Jump 						<= '0'; 
		Branch 					<= '0'; 
		Zero 						<= '0'; 
		--PCWrite 				<= '1';
		State						<= EXEC;
		PCIn(28)					<= '1'; 

		wait for clk_period;
		
		PCIn 						<= PCOut;
		wait for clk_period;

		PCIn 						<= PCOut;
		wait for clk_period;

		PCIn 						<= PCOut;
		wait for clk_period;
		
		--PCWrite				<= '0';
		State						<= STALL;
		PCIn 						<= PCOut;
		wait for clk_period*2;
	
		--PCWrite				<= '1';
		PCIn 						<= PCOut;
		State						<= EXEC;
		wait for clk_period;
		
		-- BRANCH
		PCIn 						<= PCOut;
		Branch					<= '1';
		signext_output(31 downto 16)		<= (others => '0');
		signext_output(5 downto 0)			<= "101010";
		wait for clk_period;
	
		-- NORMAL
		PCIn 										<= PCOut;
		Branch									<= '0';
		signext_output							<= (others => '0');
		wait for clk_period;
		
		-- JUMP
		PCIn 										<= PCOut;
		Jump										<= '1';
		imem_data_25_0(25)					<= '1';
		imem_data_25_0(24 downto 0)		<= (others => '0');
		wait for clk_period;

		-- NORMAL
		PCIn 										<= PCOut;
		Jump										<= '0';
		signext_output							<= (others => '0');
		wait for clk_period;
		
		wait;
   end process;

END;