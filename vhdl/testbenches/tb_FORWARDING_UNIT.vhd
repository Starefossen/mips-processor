--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:06:14 11/08/2012
-- Design Name:   
-- Module Name:   C:/Users/sondree/Desktop/assignment3/tb_FORWARDING_UNIT.vhd
-- Project Name:  mips
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FORWARDING_UNIT
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
 
ENTITY tb_FORWARDING_UNIT IS
END tb_FORWARDING_UNIT;
 
ARCHITECTURE behavior OF tb_FORWARDING_UNIT IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FORWARDING_UNIT
    PORT(
         rs : IN  std_logic_vector(4 downto 0);
         rt : IN  std_logic_vector(4 downto 0);
         mem_reg_dest : IN  std_logic_vector(4 downto 0);
         mem_reg_write : IN  std_logic;
         wb_reg_write : IN  std_logic;
         wb_reg_dest : IN  std_logic_vector(4 downto 0);
         fwrd_ctrl_alusrc1 : OUT  std_logic_vector(1 downto 0);
         fwrd_ctrl_alusrc2 : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
	
	signal clk : std_logic := '0';
   signal rs : std_logic_vector(4 downto 0) := (others => '0');
   signal rt : std_logic_vector(4 downto 0) := (others => '0');
   signal mem_reg_dest : std_logic_vector(4 downto 0) := (others => '0');
   signal mem_reg_write : std_logic := '0';
   signal wb_reg_write : std_logic := '0';
   signal wb_reg_dest : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal fwrd_ctrl_alusrc1 : std_logic_vector(1 downto 0);
   signal fwrd_ctrl_alusrc2 : std_logic_vector(1 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
	constant a : std_logic_vector(4 downto 0) := "10101";
	constant b : std_logic_vector(4 downto 0) := "01010";
	constant c : std_logic_vector(4 downto 0) := "01110";
	constant x_single : std_logic := '0';
	constant x_vector : std_logic_vector(4 downto 0) := "11111";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FORWARDING_UNIT PORT MAP (
          rs => rs,
          rt => rt,
          mem_reg_dest => mem_reg_dest,
          mem_reg_write => mem_reg_write,
          wb_reg_write => wb_reg_write,
          wb_reg_dest => wb_reg_dest,
          fwrd_ctrl_alusrc1 => fwrd_ctrl_alusrc1,
          fwrd_ctrl_alusrc2 => fwrd_ctrl_alusrc2
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
		
		-- Case 1
		rs <= a;
		rt <= b;
		mem_reg_dest <= x_vector;
		mem_reg_write <= x_single; -- =x
		wb_reg_write <= x_single;
		wb_reg_dest <= x_vector;
		
      wait for clk_period*1;
		
		-- Case 2
		mem_reg_dest <= a;
		mem_reg_write <= x_single; -- =x
		wb_reg_write <= '1';
		wb_reg_dest <= b;
      wait for clk_period*1;
		
		-- Case 3
		mem_reg_dest <= b;
		mem_reg_write <= '1';
		wb_reg_write <= x_single;
		wb_reg_dest <= x_vector;
      wait for clk_period*1;
		
		-- Case 4
		mem_reg_dest <= b;
		mem_reg_write <= x_single; -- =x
		wb_reg_write <= '1';
		wb_reg_dest <= a;
      wait for clk_period*1;
		
		-- Case 5
		rt <= a;
		mem_reg_dest <= c;
		mem_reg_write <= x_single; -- =x
		wb_reg_write <= '1';
		wb_reg_dest <= a;
      wait for clk_period*1;
		
		-- Case 6
		rt <= b;
		mem_reg_dest <= b;
		mem_reg_write <= '1'; -- =x
		wb_reg_write <= '1';
		wb_reg_dest <= a;
      wait for clk_period*1;
		
		-- Case 7
		mem_reg_dest <= a;
		mem_reg_write <= '1'; -- =x
		wb_reg_write <= x_single;
		wb_reg_dest <= x_vector;
      wait for clk_period*1;
		
		-- Case 8
		mem_reg_dest <= a;
		mem_reg_write <= '1'; -- =x
		wb_reg_write <= '1';
		wb_reg_dest <= b;
      wait for clk_period*1;
		
		-- Case 9
		rt <= a;
		mem_reg_dest <= a;
		mem_reg_write <= '1'; -- =x
		wb_reg_write <= x_single;
		wb_reg_dest <= x_vector;
      wait for clk_period*1;
		
      -- insert stimulus here 

      wait;
   end process;

END;
