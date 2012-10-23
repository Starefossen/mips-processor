--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:54:54 10/01/2012
-- Design Name:   
-- Module Name:   C:/Users/hanskrfl/Desktop/assignment1SimpleProc/testbenches/tb_alu_control.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU_CONTROL
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
 
ENTITY tb_alu_control IS
END tb_alu_control;

ARCHITECTURE behavior OF tb_alu_control IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU_CONTROL
    PORT(
         ALUOp : IN  std_logic_vector(1 downto 0);
         ALUFunct : IN  std_logic_vector(5 downto 0);
         ALUCtrl : OUT  ALU_INPUT
        );
    END COMPONENT;
    

   --Inputs
   signal ALUOp : std_logic_vector(1 downto 0) := (others => '0');
   signal ALUFunct : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal ALUCtrl : ALU_INPUT;
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU_CONTROL PORT MAP (
          ALUOp => ALUOp,
          ALUFunct => ALUFunct,
          ALUCtrl => ALUCtrl
        );

   -- Stimulus process
   stim_proc: process
   begin		

		ALUOp 		<= (others => '0');
		ALUFunct 	<= (others => '0');

      wait for clk_period*10;
		
		-- Load / Store
		ALUOp 		<= ALU_OP_LS;

      wait for clk_period*10;
	
		-- Branch on Equal
		ALUOp 		<= ALU_OP_BEQ;
		
      wait for clk_period*10;

		-- R-format
		ALUOp 		<= ALU_OP_R;	
		ALUFunct 	<= ALU_FN_ADD;
		
      wait for clk_period*10;

		ALUFunct 	<= ALU_FN_SUB;
		
      wait for clk_period*10;

		ALUFunct 	<= ALU_FN_AND;		

      wait for clk_period*10;

		ALUFunct 	<= ALU_FN_OR;

      wait for clk_period*10;

		ALUFunct 	<= ALU_FN_SLT;

      wait;
   end process;

END;
