--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:20:27 09/27/2012
-- Design Name:   
-- Module Name:   C:/Users/hanskrfl/Desktop/assignment1SimpleProc_new/testbenches/tb_alu.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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

ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal X : std_logic_vector(31 downto 0) := (others => '0');
   signal Y : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_IN : ALU_INPUT;

 	--Outputs
   signal R : std_logic_vector(31 downto 0);
   signal FLAGS : ALU_FLAGS;
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          X => X,
          Y => Y,
          ALU_IN => ALU_IN,
          R => R,
          FLAGS => FLAGS
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;
		
		X <= "00000000000000000000000000000000";
		Y <= "00000000000000000000000000000001";
		ALU_IN <= (OP3 => '0', OP2 => '0', OP1 => '1', OP0 => '0');
		
      -- insert stimulus here 

      wait;
   end process;

END;
