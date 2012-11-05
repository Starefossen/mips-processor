--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:	15:41:15 09/21/2012
-- Design Name:	
-- Module Name:	C:/Users/andrmo/Desktop/assignment1SimpleProc/tb_processor.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:	
-- 
-- VHDL Test Bench Created by ISE for module: processor
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
 
ENTITY tb_processor IS
END tb_processor;
 
ARCHITECTURE behavior OF tb_processor IS 
 
	-- Component Declaration for the Unit Under Test (UUT)
 
	COMPONENT processor
	PORT(
			clk : IN  std_logic;
			reset : IN  std_logic;
			processor_enable : IN  std_logic;
			imem_address : OUT  std_logic_vector(31 downto 0);
			imem_data_in : IN  std_logic_vector(31 downto 0);
			dmem_data_in : IN  std_logic_vector(31 downto 0);
			dmem_address : OUT  std_logic_vector(31 downto 0);
			dmem_address_wr : OUT  std_logic_vector(31 downto 0);
			dmem_data_out : OUT  std_logic_vector(31 downto 0);
			dmem_write_enable : OUT  std_logic
		 );
	END COMPONENT;
	

	--Inputs
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal processor_enable : std_logic := '0';
	signal imem_data_in : std_logic_vector(31 downto 0) := (others => '0');
	signal dmem_data_in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
	signal imem_address : std_logic_vector(31 downto 0);
	signal dmem_address : std_logic_vector(31 downto 0);
	signal dmem_address_wr : std_logic_vector(31 downto 0);
	signal dmem_data_out : std_logic_vector(31 downto 0);
	signal dmem_write_enable : std_logic;

	-- Clock period definitions
	constant clk_period : time := 40 ns;
	constant nop : std_logic_vector(31 downto 0) := "11111100000000000000000000000000";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	uut: processor PORT MAP (
		clk 						=> clk,
		reset 					=> reset,
		processor_enable 		=> processor_enable,
		imem_address 			=> imem_address,
		imem_data_in 			=> imem_data_in,
		dmem_data_in 			=> dmem_data_in,
		dmem_address 			=> dmem_address,
		dmem_address_wr 		=> dmem_address_wr,
		dmem_data_out 			=> dmem_data_out,
		dmem_write_enable 	=> dmem_write_enable
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
		imem_data_in	 <= nop;
		-- hold reset state for 100 ns.
		--reset <= '1';
		--wait for 100 ns;	
		reset <= '0';
		wait for 20 ns;
		wait for clk_period*10;

		-- insert stimulus here 
		processor_enable <= '1';

		--TEST LDI
		wait for clk_period;
		--imem_data <= '000010 11111111111111111111111111' -- J-format M[R16 + 8] <= R18
		--imem_data_in	 <= "00001011111111111111111111111111";
		
		--wait for clk_period*2;
		-- Load immidiate R[16] = 1
		--imem_data <= '001111 00000 10000 0000000000000001';
		imem_data_in	 <= "00111100000100000000000000000001";
		
		wait for clk_period;
		-- Load immidiate R[17] = 2
		--imem_data <= '001111 00000 10001 0000000000000010';
		imem_data_in	 <= "00111100000100010000000000000010";
		
		wait for clk_period;
		-- Load immidiate R[18] = 3
		--imem_data <= '001111 00000 10010 0000000000000011';
		imem_data_in	 <= "00111100000100100000000000000011";

		wait for clk_period;
		-- Load immidiate R[19] = 4
		--imem_data <= '001111 00000 10011 0000000000000100';
		imem_data_in	 <= "00111100000100110000000000000100";		
		
		--TEST ADD  (1+2)
		wait for clk_period;
		--imem_data <= '000000 10000 10001 10100 00000 100000';
		imem_data_in	 <= "00000010000100011010000000100000";
		
		--TEST sub  (4-3)  (num 3 from add. FORWARD TEST)
		wait for clk_period;
		--imem_data <= '000000 10011 10100 10101 00000 100010';
		imem_data_in	 <= "00000010011101001010100000100010";	
		
		--TEST OR  (1 | 2)
		wait for clk_period;
		--imem_data <= '000000 10000 10001 10110 00000 100101';
		imem_data_in	 <= "00000010000100011011000000100101";	

		--TEST AND  (2 & 3)
		wait for clk_period;
		--imem_data <= '000000 10010 10001 10111 00000 100100';
		imem_data_in	 <= "00000010010100011011100000100100";	
		
		--TEST SLT  (2 og 3)
		wait for clk_period;
		--imem_data <= '000000 10001 10010 11000 00000 101010';
		imem_data_in	 <= "00000010001100101100000000101010";	
		
		--TEST SLT  (2 og 2)
		wait for clk_period;
		--imem_data <= '000000 10001 10001 11001 00000 101010';
		imem_data_in	 <= "00000010001100011100100000101010";	
		
		--TEST SLT  (3 og 2)
		wait for clk_period;
		--imem_data <= '000000 10010 10001 11010 00000 101010';
		imem_data_in	 <= "00000010010100011101000000101010";	
		
		--Branch
		wait for clk_period;
		--imem_data <= '000100 10010 10010 0111000000001110';
		imem_data_in	 <= "00010010110100100111000000001110";	
		
		wait for clk_period;
		wait for clk_period;
		wait for clk_period;
		wait for clk_period;
				
		--STORE     M[ R[rs] + imm] <= R[rt]
		wait for clk_period;
		--imem_data <= '101011 10000 10011 0000000000000010';
		imem_data_in	 <= "10101110000100110000000000000010";
		
		--LOAD		R[rt] <= M[ R[rs] + imm] 
		wait for clk_period; --Last used mem
		--imem_data <= '100011 10001 11011 0000000000000001';
		imem_data_in	 <= "10001110001110110000000000000001";	
		dmem_data_in 	<= dmem_data_out; --signal ought to be delayed
		
		--TEST ADD  (4+1)    HAZARD TEST
		wait for clk_period;
		dmem_data_in 	<= dmem_data_out; --signal ought to be delayed
		--imem_data <= '000000 10000 11011 11100 00000 100000';
		imem_data_in	 <= "00000010000110111110000000100000";
		wait for clk_period;  --HAZARD STALL
		dmem_data_in 	<= dmem_data_out; --signal ought to be delayed
				
		--JUMP
		wait for clk_period; --Last used mem
		--imem_data <= '000010 00000 00000 0000000000000000';
		imem_data_in	 <= "00001000000000000000000000000000";
		
		wait for clk_period;
			
		--JUMP
		wait for clk_period; --Last used mem
		--imem_data <= '000010 00000 00000 1111000000001111';
		imem_data_in	 <= "00001000000000001111000000001111";	
		
		wait for clk_period;
		
		wait;
	end process;

END;
