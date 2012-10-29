----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:42:51 10/29/2012 
-- Design Name: 
-- Module Name:    HAZARD_DETECTOR - Behavioral 
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

entity HAZARD_DETECTOR is
    Port (
		rs : in  STD_LOGIC_VECTOR (4 downto 0);
		rt : in  STD_LOGIC_VECTOR (4 downto 0);
		ex_rt : in  STD_LOGIC_VECTOR (4 downto 0);
		ex_mem_read : in  STD_LOGIC;
		stall : out  STD_LOGIC
	);
end HAZARD_DETECTOR;

architecture Behavioral of HAZARD_DETECTOR is

begin

	STEP_FETCHER : process(rs, rt, ex_rt, ex_mem_read)
	begin		
		if (ex_mem_read = '1' and ((ex_rt = rs) or (ex_rt = rt))) then
			stall <= '1';
		else
			stall <= '0';
		end if;
	end process;

end Behavioral;

