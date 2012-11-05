----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:18:17 10/11/2012 
-- Design Name: 
-- Module Name:    writebacker - Behavioral 
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
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity writebacker is
	Port ( 
		reset 					: in  STD_LOGIC;
		clk 						: in  STD_LOGIC;
				
		-- input signals from memory step
		wb_ctrl_regWrite 		: in STD_LOGIC := '0';	
		wb_ctrl_memtoReg 		: in STD_LOGIC := '0';
		
		wb_aluRes				: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		wb_regWriteAddr		: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

		-- external processor signal 
		dmem_data_in			: in  STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0) := (others => '0');

		-- output signals to instruction decoder
		id_ctrl_regWrite		: out STD_LOGIC := '0';
		id_writeRegisterAddr : out STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		id_writeData			: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		
		wb_write_data			: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		wb_reg_write 			: out STD_LOGIC := '0';
		wb_reg_dest 			: out STD_LOGIC_VECTOR (4 downto 0) := (others => '0')
	);
end writebacker;

architecture Behavioral of writebacker is

	component MUX is
		generic (N :NATURAL :=32); 
		Port ( selector : in  STD_LOGIC;
			bus_in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_out : out  STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;

	signal mux_memtoreg_output : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal tmp_id_writeData 	: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	
begin

	mux_memtoreg : MUX port map(
		selector 	=> wb_ctrl_memtoReg,
	   bus_in1 		=> wb_aluRes,
	   bus_in2 		=> dmem_data_in,
	   bus_out 		=> mux_memtoreg_output
	);

	STEP_WRITEBACKER : process(clk, reset,wb_ctrl_regWrite,wb_regWriteAddr,mux_memtoreg_output)
	begin		
		wb_reg_write 				<= wb_ctrl_regWrite;
		wb_reg_dest 				<= wb_regWriteAddr;
		wb_write_data				<= mux_memtoreg_output;
		id_writeRegisterAddr 	<= wb_regWriteAddr;
		id_writeData				<= mux_memtoreg_output;
		id_ctrl_regWrite			<= wb_ctrl_regWrite;
		if reset = '1' then
			-- output signals to instruction decoder
			id_ctrl_regWrite			<= '0';	
			id_writeRegisterAddr 	<= (others => '0');
			id_writeData				<= (others => '0');
		end if;
	end process;
	
end Behavioral;

