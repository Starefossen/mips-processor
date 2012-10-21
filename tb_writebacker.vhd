--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:28:06 10/15/2012
-- Design Name:   
-- Module Name:   C:/Users/sondree/Desktop/assignment1SimpleProc/tb_writebacker.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: writebacker
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
 
ENTITY tb_writebacker IS
END tb_writebacker;
 
ARCHITECTURE behavior OF tb_writebacker IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT writebacker
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         wb_ctrl_regWrite : IN  std_logic;
         wb_ctrl_memtoReg : IN  std_logic;
         wb_aluRes : IN  std_logic_vector(31 downto 0);
         wb_regWriteAddr : IN  std_logic_vector(4 downto 0);
         dmem_data_in : IN  std_logic_vector(31 downto 0);
         id_ctrl_regWrite : OUT  std_logic;
         id_writeRegisterAddr : OUT  std_logic_vector(4 downto 0);
         id_writeData : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal wb_ctrl_regWrite : std_logic := '0';
   signal wb_ctrl_memtoReg : std_logic := '0';
   signal wb_aluRes : std_logic_vector(31 downto 0) := (others => '0');
   signal wb_regWriteAddr : std_logic_vector(4 downto 0) := (others => '0');
   signal dmem_data_in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal id_ctrl_regWrite : std_logic;
   signal id_writeRegisterAddr : std_logic_vector(4 downto 0);
   signal id_writeData : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: writebacker PORT MAP (
          reset => reset,
          clk => clk,
          wb_ctrl_regWrite => wb_ctrl_regWrite,
          wb_ctrl_memtoReg => wb_ctrl_memtoReg,
          wb_aluRes => wb_aluRes,
          wb_regWriteAddr => wb_regWriteAddr,
          dmem_data_in => dmem_data_in,
          id_ctrl_regWrite => id_ctrl_regWrite,
          id_writeRegisterAddr => id_writeRegisterAddr,
          id_writeData => id_writeData
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
		reset <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		reset <= '0';
		
		--wb_ctrl_regWrite : IN  std_logic;
		--wb_ctrl_memtoReg : IN  std_logic;
		--wb_aluRes : IN  std_logic_vector(31 downto 0);
		--wb_regWriteAddr : IN  std_logic_vector(4 downto 0);
		--dmem_data_in : IN  std_logic_vector(31 downto 0);
		
		--send to decoder
		wb_ctrl_regWrite	<= '0';
		wb_regWriteAddr 	<= "01000";
		
		--mux which data to write
		wb_ctrl_memtoReg 	<= '0';
		wb_aluRes 			<= "00000000000000000000000000000010";
		dmem_data_in 		<= "00000000000000000000000000000001";

		wait for clk_period;
		
		--send to decoder
		wb_ctrl_regWrite	<= '0';
		wb_regWriteAddr 	<= "00010";
		
		--mux which data to write
		wb_ctrl_memtoReg 	<= '1';
		wb_aluRes 			<= "00000000000000000000000000000010";
		dmem_data_in 		<= "00000000000000000000000000000001";
      -- insert stimulus here 

      wait;
   end process;

END;
