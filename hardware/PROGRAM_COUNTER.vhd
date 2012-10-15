----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:16:07 09/25/2012 
-- Design Name: 
-- Module Name:    register_single - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- "WORK" is the current library
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity PROGRAM_COUNTER is
	generic (N : NATURAL := 32);
	Port (
		clk 				: in STD_LOGIC;
		reset 			: in STD_LOGIC;
		signext_output	: in STD_LOGIC_VECTOR (N-1 downto 0);
		imem_data_25_0	: in STD_LOGIC_VECTOR (25 downto 0);
		Jump				: in STD_LOGIC; -- control signal
		Branch			: in STD_LOGIC; -- control signal
		Zero				: in STD_LOGIC; -- ALU zero signal
		--PCWrite 			: in STD_LOGIC; -- control signal
		State 			: in state_type; -- control signal
		PCIn 				: in STD_LOGIC_VECTOR (N-1 downto 0) := "00000000000000000000000000000001";
		PCOut 			: out STD_LOGIC_VECTOR (N-1 downto 0) := "00000000000000000000000000000001"
	);
end program_counter;

architecture Behavioral of PROGRAM_COUNTER is 



	


	signal mux_branch_selector	: STD_LOGIC := '0';
	signal JumpAdr					: STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
	signal adder1_output			: STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
	signal adder2_output			: STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
	signal mux_branch_output	: STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
	signal mux_pcsrc_output		: STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
begin




	

	PROGRAM_COUNTER : process(clk, reset, PCIn, imem_data_25_0) begin	
		JumpAdr(31 downto 26)	<= PCIn(31 downto 26);
		JumpAdr(25 downto 0)		<= imem_data_25_0;
		
		-- processor_enable?
		if (reset = '1') then
				PCOut 				<= (others => '0');
		elsif (rising_edge(clk)) then
			if (State = EXEC) then
				PCOut 				<= mux_pcsrc_output;
			end if;
		end if;
	end process;
end Behavioral;