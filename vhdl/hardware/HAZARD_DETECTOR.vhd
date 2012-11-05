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
		imem_data_in : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_rt : in  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		ex_mem_read : in  STD_LOGIC := '0';
		stall : out  STD_LOGIC := '0'
	);
end HAZARD_DETECTOR;

architecture Behavioral of HAZARD_DETECTOR is

begin

	STEP_FETCHER : process(imem_data_in, ex_rt, ex_mem_read)
	begin		
		if (ex_mem_read = '1' and ((ex_rt = imem_data_in(20 downto 16)) or (ex_rt = imem_data_in(15 downto 11)))) then
			stall <= '1';
		else
			stall <= '0';
		end if;
	end process;

end Behavioral;

