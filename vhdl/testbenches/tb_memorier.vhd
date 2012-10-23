--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:08:14 10/15/2012
-- Design Name:   
-- Module Name:   C:/Users/sondree/Desktop/assignment1SimpleProc/tb_memorier.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memorier
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
 
ENTITY tb_memorier IS
END tb_memorier;
 
ARCHITECTURE behavior OF tb_memorier IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memorier
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         mem_wb_ctrl_regWrite : IN  std_logic;
         mem_wb_ctrl_memtoReg : IN  std_logic;
         mem_ctrl_branch : IN  std_logic;
         mem_ctrl_memRead : IN  std_logic;
         mem_ctrl_memWrite : IN  std_logic;
         mem_aluZero : IN  std_logic;
         mem_branchAddr : IN  std_logic_vector(31 downto 0);
         mem_aluRes : IN  std_logic_vector(31 downto 0);
         mem_writeData : IN  std_logic_vector(31 downto 0);
         mem_regWriteAddr : IN  std_logic_vector(4 downto 0);
         wb_ctrl_regWrite : OUT  std_logic;
         wb_ctrl_memtoReg : OUT  std_logic;
         if_branchAddr : OUT  std_logic_vector(31 downto 0);
         wb_aluRes : OUT  std_logic_vector(31 downto 0);
         wb_regWriteAddr : OUT  std_logic_vector(4 downto 0);
         if_ctrl_pcSrc : OUT  std_logic;
         dmem_address : OUT  std_logic_vector(31 downto 0);
         dmem_address_wr : OUT  std_logic_vector(31 downto 0);
         dmem_data_out : OUT  std_logic_vector(31 downto 0);
         dmem_write_enable : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal mem_wb_ctrl_regWrite : std_logic := '0';
   signal mem_wb_ctrl_memtoReg : std_logic := '0';
   signal mem_ctrl_branch : std_logic := '0';
   signal mem_ctrl_memRead : std_logic := '0';
   signal mem_ctrl_memWrite : std_logic := '0';
   signal mem_aluZero : std_logic := '0';
   signal mem_branchAddr : std_logic_vector(31 downto 0) := (others => '0');
   signal mem_aluRes : std_logic_vector(31 downto 0) := (others => '0');
   signal mem_writeData : std_logic_vector(31 downto 0) := (others => '0');
   signal mem_regWriteAddr : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
   signal wb_ctrl_regWrite : std_logic;
   signal wb_ctrl_memtoReg : std_logic;
   signal if_branchAddr : std_logic_vector(31 downto 0);
   signal wb_aluRes : std_logic_vector(31 downto 0);
   signal wb_regWriteAddr : std_logic_vector(4 downto 0);
   signal if_ctrl_pcSrc : std_logic;
   signal dmem_address : std_logic_vector(31 downto 0);
   signal dmem_address_wr : std_logic_vector(31 downto 0);
   signal dmem_data_out : std_logic_vector(31 downto 0);
   signal dmem_write_enable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memorier PORT MAP (
          reset => reset,
          clk => clk,
          mem_wb_ctrl_regWrite => mem_wb_ctrl_regWrite,
          mem_wb_ctrl_memtoReg => mem_wb_ctrl_memtoReg,
          mem_ctrl_branch => mem_ctrl_branch,
          mem_ctrl_memRead => mem_ctrl_memRead,
          mem_ctrl_memWrite => mem_ctrl_memWrite,
          mem_aluZero => mem_aluZero,
          mem_branchAddr => mem_branchAddr,
          mem_aluRes => mem_aluRes,
          mem_writeData => mem_writeData,
          mem_regWriteAddr => mem_regWriteAddr,
          wb_ctrl_regWrite => wb_ctrl_regWrite,
          wb_ctrl_memtoReg => wb_ctrl_memtoReg,
          if_branchAddr => if_branchAddr,
          wb_aluRes => wb_aluRes,
          wb_regWriteAddr => wb_regWriteAddr,
          if_ctrl_pcSrc => if_ctrl_pcSrc,
          dmem_address => dmem_address,
          dmem_address_wr => dmem_address_wr,
          dmem_data_out => dmem_data_out,
          dmem_write_enable => dmem_write_enable
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
		
		
		--mem_wb_ctrl_regWrite : IN  std_logic;
		--mem_wb_ctrl_memtoReg : IN  std_logic;
		--mem_ctrl_branch : IN  std_logic;
		--mem_ctrl_memRead : IN  std_logic;
		--mem_ctrl_memWrite : IN  std_logic;
		--mem_aluZero : IN  std_logic;
		--mem_branchAddr : IN  std_logic_vector(31 downto 0);
		--mem_aluRes : IN  std_logic_vector(31 downto 0);
		--mem_writeData : IN  std_logic_vector(31 downto 0);
		--mem_regWriteAddr : IN  std_logic_vector(4 downto 0);
		
		--propagate
		mem_wb_ctrl_regWrite 	<= '0';
		mem_wb_ctrl_memtoReg 	<= '0';
		
		--check branch
		mem_ctrl_branch  			<= '1';
		mem_aluZero  				<= '1';
		
		--no functionallity?!!
		mem_ctrl_memRead  		<= '0';
		
		--external
		mem_ctrl_memWrite  		<= '0';
		mem_branchAddr 			<= "00000000000000000000000000000011";
		mem_writeData 				<= "00000000000000000000000000011111";
		
		--to mem
		mem_aluRes 					<= "00000000000000000000000000000101";
		mem_regWriteAddr  		<= "01000";

      -- insert stimulus here 

      wait;
   end process;

END;
