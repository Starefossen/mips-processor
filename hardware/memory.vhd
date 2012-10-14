----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:37:09 05/03/2012 
-- Design Name: 
-- Module Name:    memory - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory is
	generic (N :NATURAL; M :NATURAL);
	port(
		CLK			: in STD_LOGIC;
		--RESET			:	in  STD_LOGIC;	
		W_ADDR		:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Address to write data
		WRITE_DATA	:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Data to be written
		MemWrite		:	in  STD_LOGIC;									-- Write Signal
		ADDR			:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Address to access data
		READ_DATA	:	out STD_LOGIC_VECTOR (N-1 downto 0)		-- Data read from memory
	);
end memory;

architecture Behavioral of memory is

	constant MEM_SIZE : integer := 2 ** M;
	type MEM_T is array (MEM_SIZE-1 downto 0) of STD_LOGIC_VECTOR (N-1 downto 0);
	
	signal MEM : MEM_T := (others => (others => '0'));
	signal address_reg :	STD_LOGIC_VECTOR (N-1 downto 0);	-- Address to access data
	
begin

	MEM_PROC: process(CLK, MemWrite, WRITE_DATA, ADDR, W_ADDR, MEM, address_reg)
	begin	
		if rising_edge (CLK) then
			--if (RESET = '1') then 
			--	for i in 0 to M-1 loop
			--		MEM(i) <= (others => '0');
			--	end loop;
			--els
			if MemWrite='1' then
				MEM(to_integer(unsigned( W_ADDR((M-1) downto 0) ))) <= WRITE_DATA;
			end if;
			address_reg <= ADDR;
		end if;
		READ_DATA <= MEM(to_integer(unsigned( address_reg ((M-1) downto 0) )));
	end process MEM_PROC;

end Behavioral;

