				--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:06:58 11/08/2012
-- Design Name:   
-- Module Name:   C:/Users/sondree/Desktop/assignment3/tb_HAZARD_DETECTOR.vhd
-- Project Name:  mips
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: HAZARD_DETECTOR
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
 
ENTITY tb_HAZARD_DETECTOR IS
END tb_HAZARD_DETECTOR;
 
ARCHITECTURE behavior OF tb_HAZARD_DETECTOR IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT HAZARD_DETECTOR
    PORT(
         imem_data_in : IN  std_logic_vector(31 downto 0);
         ex_rt : IN  std_logic_vector(4 downto 0);
         ex_mem_read : IN  std_logic;
         stall : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
	signal clk : std_logic := '0';
   signal imem_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal ex_rt : std_logic_vector(4 downto 0) := (others => '0');
   signal ex_mem_read : std_logic := '0';

 	--Outputs
   signal stall : std_logic;
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
	constant a : std_logic_vector(4 downto 0) := "10101";
	constant b : std_logic_vector(4 downto 0) := "01010";
	constant x_single : std_logic := '0';
	constant x_vector : std_logic_vector(4 downto 0) := "11111";
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: HAZARD_DETECTOR PORT MAP (
          imem_data_in => imem_data_in,
          ex_rt => ex_rt,
          ex_mem_read => ex_mem_read,
          stall => stall
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		imem_data_in <= (others =>'0');
		--Case 1
		imem_data_in(20 downto 16) <= a;
		imem_data_in(15 downto 11) <= b;
		ex_rt <= x_vector;
		ex_mem_read <= '0';
      wait for clk_period*1;
		
		--Case 2
		ex_rt <= a;
		ex_mem_read <= '1';
      wait for clk_period*1;
		
		--Case 3
		ex_rt <= b;
		ex_mem_read <= '1';
      wait for clk_period*1;
		
		--Case 4
		ex_rt <= x_vector;
		ex_mem_read <= '1';
      wait for clk_period*1;

      wait;
   end process;

END;
