--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:45:33 10/15/2012
-- Design Name:   
-- Module Name:   C:/Users/sondree/Desktop/assignment1SimpleProc/tb_executer.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Executer
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
 
ENTITY tb_executer IS
END tb_executer;
 
ARCHITECTURE behavior OF tb_executer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Executer
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         ex_wb_ctrl_regWrite : IN  std_logic;
         ex_wb_ctrl_memtoReg : IN  std_logic;
         ex_mem_ctrl_branch : IN  std_logic;
         ex_mem_ctrl_memRead : IN  std_logic;
         ex_mem_ctrl_memWrite : IN  std_logic;
         ex_ctrl_regDst : IN  std_logic;
         ex_ctrl_aluOp : IN  std_logic_vector(1 downto 0);
         ex_ctrl_aluSrc : IN  std_logic;
         ex_pc : IN  std_logic_vector(31 downto 0);
         ex_signext : IN  std_logic_vector(31 downto 0);
         ex_inst_20_16 : IN  std_logic_vector(4 downto 0);
         ex_inst_15_11 : IN  std_logic_vector(4 downto 0);
         ex_register_read_1 : IN  std_logic_vector(31 downto 0);
         ex_register_read_2 : IN  std_logic_vector(31 downto 0);
         mem_wb_ctrl_regWrite : OUT  std_logic;
         mem_wb_ctrl_memtoReg : OUT  std_logic;
         mem_ctrl_branch : OUT  std_logic;
         mem_ctrl_memRead : OUT  std_logic;
         mem_ctrl_memWrite : OUT  std_logic;
         mem_aluZero : OUT  std_logic;
         mem_branchAddr : OUT  std_logic_vector(31 downto 0);
         mem_aluRes : OUT  std_logic_vector(31 downto 0);
         mem_writeData : OUT  std_logic_vector(31 downto 0);
         mem_writeRegisterAddr : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal ex_wb_ctrl_regWrite : std_logic := '0';
   signal ex_wb_ctrl_memtoReg : std_logic := '0';
   signal ex_mem_ctrl_branch : std_logic := '0';
   signal ex_mem_ctrl_memRead : std_logic := '0';
   signal ex_mem_ctrl_memWrite : std_logic := '0';
   signal ex_ctrl_regDst : std_logic := '0';
   signal ex_ctrl_aluOp : std_logic_vector(1 downto 0) := (others => '0');
   signal ex_ctrl_aluSrc : std_logic := '0';
   signal ex_pc : std_logic_vector(31 downto 0) := (others => '0');
   signal ex_signext : std_logic_vector(31 downto 0) := (others => '0');
   signal ex_inst_20_16 : std_logic_vector(4 downto 0) := (others => '0');
   signal ex_inst_15_11 : std_logic_vector(4 downto 0) := (others => '0');
   signal ex_register_read_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal ex_register_read_2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal mem_wb_ctrl_regWrite : std_logic;
   signal mem_wb_ctrl_memtoReg : std_logic;
   signal mem_ctrl_branch : std_logic;
   signal mem_ctrl_memRead : std_logic;
   signal mem_ctrl_memWrite : std_logic;
   signal mem_aluZero : std_logic;
   signal mem_branchAddr : std_logic_vector(31 downto 0);
   signal mem_aluRes : std_logic_vector(31 downto 0);
   signal mem_writeData : std_logic_vector(31 downto 0);
   signal mem_writeRegisterAddr : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Executer PORT MAP (
          reset => reset,
          clk => clk,
          ex_wb_ctrl_regWrite => ex_wb_ctrl_regWrite,
          ex_wb_ctrl_memtoReg => ex_wb_ctrl_memtoReg,
          ex_mem_ctrl_branch => ex_mem_ctrl_branch,
          ex_mem_ctrl_memRead => ex_mem_ctrl_memRead,
          ex_mem_ctrl_memWrite => ex_mem_ctrl_memWrite,
          ex_ctrl_regDst => ex_ctrl_regDst,
          ex_ctrl_aluOp => ex_ctrl_aluOp,
          ex_ctrl_aluSrc => ex_ctrl_aluSrc,
          ex_pc => ex_pc,
          ex_signext => ex_signext,
          ex_inst_20_16 => ex_inst_20_16,
          ex_inst_15_11 => ex_inst_15_11,
          ex_register_read_1 => ex_register_read_1,
          ex_register_read_2 => ex_register_read_2,
          mem_wb_ctrl_regWrite => mem_wb_ctrl_regWrite,
          mem_wb_ctrl_memtoReg => mem_wb_ctrl_memtoReg,
          mem_ctrl_branch => mem_ctrl_branch,
          mem_ctrl_memRead => mem_ctrl_memRead,
          mem_ctrl_memWrite => mem_ctrl_memWrite,
          mem_aluZero => mem_aluZero,
          mem_branchAddr => mem_branchAddr,
          mem_aluRes => mem_aluRes,
          mem_writeData => mem_writeData,
          mem_writeRegisterAddr => mem_writeRegisterAddr
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
		reset <= '1';
      wait for 100 ns;	

      wait for clk_period*10;
		reset <= '0';
		
		--ex_wb_ctrl_regWrite : IN  std_logic;
		--ex_wb_ctrl_memtoReg : IN  std_logic;
		--ex_mem_ctrl_branch : IN  std_logic;
		--ex_mem_ctrl_memRead : IN  std_logic;
		--ex_mem_ctrl_memWrite : IN  std_logic;
		--ex_ctrl_regDst : IN  std_logic;
		--ex_ctrl_aluOp : IN  std_logic_vector(1 downto 0);
		--ex_ctrl_aluSrc : IN  std_logic;
		--ex_pc : IN  std_logic_vector(31 downto 0);
		--ex_signext : IN  std_logic_vector(31 downto 0);
		--ex_inst_20_16 : IN  std_logic_vector(4 downto 0);
		--ex_inst_15_11 : IN  std_logic_vector(4 downto 0);
		--ex_register_read_1 : IN  std_logic_vector(31 downto 0);
		--ex_register_read_2 : IN  std_logic_vector(31 downto 0);
		
		--These just go trough
		ex_wb_ctrl_regWrite 	<= '0';
		ex_wb_ctrl_memtoReg 	<= '0';
		ex_mem_ctrl_branch 	<= '0';
		ex_mem_ctrl_memRead  <= '0';
		ex_mem_ctrl_memWrite <= '0';
		
		--"important" signals
		
		--mux reg dst
		ex_ctrl_regDst  		<= '0';
		ex_inst_20_16		 	<= "01000";
		ex_inst_15_11 			<= "00010";
		
		--add to branch addr
		ex_pc 					<= "00000000000000000000000000000001";
		ex_signext  			<= "00000000000000000000000000100000";
		
		--mux between reg2 and signext
		ex_ctrl_aluSrc  		<= '0';
		ex_register_read_2  	<= "00000000000000000000000000000001";
		
		--alu
		ex_ctrl_aluOp 			<= "10";
		ex_register_read_1  	<= "00000000000000000000000000000010";
		
		wait for clk_period;
		--These just go trough
		ex_wb_ctrl_regWrite 	<= '1';
		ex_wb_ctrl_memtoReg 	<= '1';
		ex_mem_ctrl_branch 	<= '1';
		ex_mem_ctrl_memRead  <= '1';
		ex_mem_ctrl_memWrite <= '1';
		
		--"important" signals
		
		--mux reg dst
		ex_ctrl_regDst  		<= '1';
		ex_inst_20_16		 	<= "01000";
		ex_inst_15_11 			<= "00010";
		
		--add to branch addr
		ex_pc 					<= "00000000000000000000000000001001";
		ex_signext  			<= "00000000000000000000000000100010";
		
		--mux between reg2 and signext
		ex_ctrl_aluSrc  		<= '0';
		ex_register_read_2  	<= "00000000000000000000000000000001";
		
		--alu
		ex_ctrl_aluOp 			<= "10";
		ex_register_read_1  	<= "00000000000000000000000000000101";

      -- insert stimulus here 

      wait;
   end process;

END;
