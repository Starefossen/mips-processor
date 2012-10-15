--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:53:35 10/15/2012
-- Design Name:   
-- Module Name:   C:/Users/sondree/Desktop/assignment1SimpleProc/tb_decoder.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: decoder
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
 
ENTITY tb_decoder IS
END tb_decoder;
 
ARCHITECTURE behavior OF tb_decoder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT decoder
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         imem_data_in : IN  std_logic_vector(31 downto 0);
         id_ctrl_regWrite : IN  std_logic;
         id_regWriteAddr : IN  std_logic_vector(4 downto 0);
         id_regWriteData : IN  std_logic_vector(31 downto 0);
         id_if_pc : IN  std_logic_vector(31 downto 0);
         if_ctrl_jump : OUT  std_logic;
         if_jump_addr : OUT  std_logic_vector(31 downto 0);
         wb_ctrl_regWrite : OUT  std_logic;
         wb_ctrl_memtoReg : OUT  std_logic;
         mem_ctrl_branch : OUT  std_logic;
         mem_ctrl_memRead : OUT  std_logic;
         mem_ctrl_memWrite : OUT  std_logic;
         ex_ctrl_regDst : OUT  std_logic;
         ex_ctrl_aluOp : OUT  std_logic_vector(1 downto 0);
         ex_ctrl_aluSrc : OUT  std_logic;
         ex_pc : OUT  std_logic_vector(31 downto 0);
         ex_register_read_1 : OUT  std_logic_vector(31 downto 0);
         ex_register_read_2 : OUT  std_logic_vector(31 downto 0);
         ex_signext : OUT  std_logic_vector(31 downto 0);
         ex_inst_20_16 : OUT  std_logic_vector(4 downto 0);
         ex_inst_15_11 : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal imem_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal id_ctrl_regWrite : std_logic := '0';
   signal id_regWriteAddr : std_logic_vector(4 downto 0) := (others => '0');
   signal id_regWriteData : std_logic_vector(31 downto 0) := (others => '0');
   signal id_if_pc : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal if_ctrl_jump : std_logic;
   signal if_jump_addr : std_logic_vector(31 downto 0);
   signal wb_ctrl_regWrite : std_logic;
   signal wb_ctrl_memtoReg : std_logic;
   signal mem_ctrl_branch : std_logic;
   signal mem_ctrl_memRead : std_logic;
   signal mem_ctrl_memWrite : std_logic;
   signal ex_ctrl_regDst : std_logic;
   signal ex_ctrl_aluOp : std_logic_vector(1 downto 0);
   signal ex_ctrl_aluSrc : std_logic;
   signal ex_pc : std_logic_vector(31 downto 0);
   signal ex_register_read_1 : std_logic_vector(31 downto 0);
   signal ex_register_read_2 : std_logic_vector(31 downto 0);
   signal ex_signext : std_logic_vector(31 downto 0);
   signal ex_inst_20_16 : std_logic_vector(4 downto 0);
   signal ex_inst_15_11 : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: decoder PORT MAP (
          clk => clk,
          reset => reset,
          imem_data_in => imem_data_in,
          id_ctrl_regWrite => id_ctrl_regWrite,
          id_regWriteAddr => id_regWriteAddr,
          id_regWriteData => id_regWriteData,
          id_if_pc => id_if_pc,
          if_ctrl_jump => if_ctrl_jump,
          if_jump_addr => if_jump_addr,
          wb_ctrl_regWrite => wb_ctrl_regWrite,
          wb_ctrl_memtoReg => wb_ctrl_memtoReg,
          mem_ctrl_branch => mem_ctrl_branch,
          mem_ctrl_memRead => mem_ctrl_memRead,
          mem_ctrl_memWrite => mem_ctrl_memWrite,
          ex_ctrl_regDst => ex_ctrl_regDst,
          ex_ctrl_aluOp => ex_ctrl_aluOp,
          ex_ctrl_aluSrc => ex_ctrl_aluSrc,
          ex_pc => ex_pc,
          ex_register_read_1 => ex_register_read_1,
          ex_register_read_2 => ex_register_read_2,
          ex_signext => ex_signext,
          ex_inst_20_16 => ex_inst_20_16,
          ex_inst_15_11 => ex_inst_15_11
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
		
      --imem_data_in : IN  std_logic_vector(31 downto 0);
      --id_ctrl_regWrite : IN  std_logic;
      --id_regWriteAddr : IN  std_logic_vector(4 downto 0);
      --id_regWriteData : IN  std_logic_vector(31 downto 0);
      --id_if_pc : IN  std_logic_vector(31 downto 0);
		
		-- Load immidiate R[16] = 1
		imem_data_in <= "00111100000100000000000000000001";
      id_ctrl_regWrite <= '0';
      id_regWriteAddr <= "00000";
      id_regWriteData <= "00000000000000000000000000000000";
      id_if_pc <= "00000000000000000000000000000000";
		
		wait for clk_period;
		
		--TEST ADD  (1+2)
		imem_data_in <= "00000010000100011010000000100000";
		

      -- insert stimulus here 

      wait;
   end process;

END;
