----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:27:25 10/29/2012 
-- Design Name: 
-- Module Name:    FORWARDING_UNIT - Behavioral 
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

entity FORWARDING_UNIT is
    Port ( rs : in  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           rt : in  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           mem_reg_dest : in  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           mem_reg_write : in  STD_LOGIC := '0';
           wb_reg_write : in  STD_LOGIC := '0';
           wb_reg_dest : in  STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           fwrd_ctrl_alusrc1 : out  STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
           fwrd_ctrl_alusrc2 : out  STD_LOGIC_VECTOR (1 downto 0) := (others => '0')
	);
end FORWARDING_UNIT;

architecture Behavioral of FORWARDING_UNIT is

begin

	FORWARDING_UNIT : process(rs, rt, mem_reg_dest,mem_reg_write, wb_reg_write, wb_reg_dest)
	begin
		if ((mem_reg_write = '1') and (mem_reg_dest /= "00000") and (mem_reg_dest = rs)) then
			fwrd_ctrl_alusrc1 <= "10";
		elsif ((wb_reg_write = '1') and (wb_reg_dest /= "00000") and (mem_reg_dest /= rs) and (wb_reg_dest = rs)) then
			fwrd_ctrl_alusrc1 <= "01";
		else
			fwrd_ctrl_alusrc1 <= "00";
		end if;
		
		if ((mem_reg_write = '1') and (mem_reg_dest /= "00000") and (mem_reg_dest = rt)) then
			fwrd_ctrl_alusrc2 <= "10";
		elsif ((wb_reg_write = '1') and (wb_reg_dest /= "00000") and (mem_reg_dest /= rt) and (wb_reg_dest = rt)) then
			 fwrd_ctrl_alusrc2 <= "01";
		else
			fwrd_ctrl_alusrc2 <= "00";
		end if;

	end process;

end Behavioral;

