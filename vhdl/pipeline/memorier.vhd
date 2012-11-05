----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:07:00 10/11/2012 
-- Design Name: 
-- Module Name:    memorier - Behavioral 
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

entity memorier is
	Port ( 
		reset 					: in  STD_LOGIC;
		clk 						: in  STD_LOGIC;
				
		-- input from executer step
		mem_wb_ctrl_regWrite : in  STD_LOGIC := '0';	
		mem_wb_ctrl_memtoReg : in  STD_LOGIC := '0';

		mem_ctrl_branch 		: in  STD_LOGIC := '0';
		mem_ctrl_memRead 		: in  STD_LOGIC := '0';
		mem_ctrl_memWrite 	: in  STD_LOGIC := '0';
		
		mem_aluZero				: in STD_LOGIC := '0';
		mem_branchAddr			: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		mem_aluRes				: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		mem_writeData 			: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		mem_regWriteAddr		: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	
		-- output signals to write back step
		wb_ctrl_regWrite 		: out STD_LOGIC := '0';	
		wb_ctrl_memtoReg 		: out STD_LOGIC := '0';
		
		if_branchAddr			: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		wb_aluRes				: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		wb_regWriteAddr		: out STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		
		if_ctrl_pcSrc			: out STD_LOGIC := '0'; -- branch control / selector
		
		mem_alu_res				: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		mem_reg_dest 			: out STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		mem_reg_write 			: out	STD_LOGIC := '0';
		
		-- external processor signals		
		dmem_address			: out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
		dmem_address_wr     	: out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
		dmem_data_out       	: out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
		dmem_write_enable   	: out STD_LOGIC := '0' -- remove default value?
	);	
end memorier;

architecture Behavioral of memorier is

	component ANDER is
		Port ( 
			X 			: in  STD_LOGIC;
			Y 			: in  STD_LOGIC;
			R 			: out  STD_LOGIC
		);
	end component;

	signal mux_branch_selector : STD_LOGIC := '0';

begin	
	branch_ander : ANDER port map(
		X 				=> mem_ctrl_branch,
	   Y 				=> mem_aluZero,
	   R 				=> mux_branch_selector
	);

	STEP_MEMORIER : process(clk, reset, mem_aluRes, mem_writeData, mem_ctrl_memWrite)
	begin
		mem_reg_dest 			<= mem_regWriteAddr;
		mem_reg_write 			<= mem_wb_ctrl_regWrite;
		mem_alu_res				<= mem_aluRes;
		if reset = '1' then
			wb_ctrl_regWrite 		<= '0';
			wb_ctrl_memtoReg 		<= '0';
			
			wb_aluRes				<= (others => '0');
			wb_regWriteAddr		<= (others => '0');
			
			if_ctrl_pcSrc			<= '0'; -- branch control / selector
			if_branchAddr			<= (others => '0');
			
			-- external processor signals
			dmem_address			<= (others => '0');
			dmem_address_wr     	<= (others => '0');
			dmem_data_out       	<= (others => '0');
			dmem_write_enable   	<= '0';
		else
			dmem_address			<= mem_aluRes;
			dmem_address_wr     	<= mem_aluRes;
			dmem_data_out       	<= mem_writeData;
			dmem_write_enable   	<= mem_ctrl_memWrite;
			-- external processor signals
			if falling_edge(clk) then
				-- pipeline forwarding control signals
				wb_ctrl_regWrite 		<= mem_wb_ctrl_regWrite;
				wb_ctrl_memtoReg 		<= mem_wb_ctrl_memtoReg;
				
				wb_aluRes				<= mem_aluRes;
				wb_regWriteAddr		<= mem_regWriteAddr;
				
				if_ctrl_pcSrc			<= mux_branch_selector; -- branch control / selector
				if_branchAddr			<= mem_branchAddr;
				
			end if;
		end if;
	end process;

end Behavioral;

