----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:21:45 10/11/2012 
-- Design Name: 
-- Module Name:    fetcher - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fetcher is
	Port ( 
		clk 						: in  STD_LOGIC;
		reset 					: in  STD_LOGIC;
		pc_stall 				: in  STD_LOGIC := '0';
		pc_stall_number		: in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		processor_enable		: in	STD_LOGIC := '0';
		
		-- input signals from write back
		if_ctrl_pcSrc			: in STD_LOGIC := '0'; 								-- from memory step
		if_jump_addr 			: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); 	-- from instruction decoder step
		if_ctrl_jump 			: in STD_LOGIC := '0';								-- from instruction decoder step
		if_branchAddr			: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); 	-- from memory step
		
		-- output signals
		id_pc						: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		imem_address			: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0')
	);
end fetcher;

architecture Behavioral of fetcher is

	component MUX is
		generic (N :NATURAL :=32); 
		Port (
			selector : in  STD_LOGIC;
			bus_in1 	: in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_in2 	: in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_out 	: out  STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;
	
	component ADDER is
		generic (N : NATURAL := 32);
		port(
			X			: in	STD_LOGIC_VECTOR(N-1 downto 0);
			Y			: in	STD_LOGIC_VECTOR(N-1 downto 0);
			CIN		: in	STD_LOGIC;
			COUT		: out	STD_LOGIC;
			R			: out	STD_LOGIC_VECTOR(N-1 downto 0)
		);
	end component;

	signal adder1_output 		: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal pc_register			: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal mux_branch_output 	: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal sub_output 			: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal mux_jump_output 		: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal mux_staller_output 	: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	
begin

	mux_branch : MUX port map(
		selector 	=> if_ctrl_pcSrc,
	   bus_in1 		=> adder1_output,
	   bus_in2 		=> if_branchAddr,
		bus_out 		=> mux_branch_output
	);
	
	mux_jump : MUX port map(
		selector 	=> if_ctrl_jump,	
	   bus_in1 		=> mux_branch_output,
	   bus_in2 		=> if_jump_addr,
	   bus_out 		=> mux_jump_output
	);
	
	staller : MUX port map(
		selector 	=> pc_stall,	
	   bus_in1 		=> mux_jump_output,
	   bus_in2 		=> pc_stall_number,
	   bus_out 		=> mux_staller_output
	);

	adder1 : ADDER port map(
		X				=>	pc_register,
		Y				=> "00000000000000000000000000000001",
		CIN			=> '0',
		R				=> adder1_output
	);
		
	STEP_FETCHER : process(clk, reset)
	begin		
		if reset = '1' or processor_enable = '0' then	
			id_pc						<= (others => '0');
			imem_address			<= (others => '0');
			pc_register				<= (others => '0');
			-- output signals	
		elsif falling_edge(clk) then			
			pc_register				<= mux_staller_output;
			id_pc						<= adder1_output;
			imem_address			<= mux_staller_output;--pc_register;
		end if;
	end process;

end Behavioral;

