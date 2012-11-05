----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:50:48 09/07/2012 
-- Design Name: 
-- Module Name:    processor - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- "WORK" is the current library
library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

entity processor is
	port (
        clk 					 : in  STD_LOGIC;
        reset			 	 	 : in  STD_LOGIC;
        processor_enable    : in  STD_LOGIC := '0';
        imem_address        : out STD_LOGIC_VECTOR (IADDR_BUS-1 downto 0) := (others => '0');
        imem_data_in        : in  STD_LOGIC_VECTOR (IDATA_BUS-1 downto 0) := "11111100000000000000000000000000";
        dmem_data_in        : in  STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0) := (others => '0');
        dmem_address        : out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0');
        dmem_address_wr     : out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0');
        dmem_data_out       : out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0');
        dmem_write_enable   : out STD_LOGIC := '0'
    );
end processor;

architecture Behavioral of processor is

	component fetcher is
		Port ( 
			clk 						: in  STD_LOGIC;
			reset 					: in  STD_LOGIC;
			pc_stall 				: in  STD_LOGIC;
			pc_stall_number		: in  STD_LOGIC_VECTOR (31 downto 0);
			processor_enable		: in 	STD_LOGIC;
		
			--input
			if_ctrl_pcSrc			: in STD_LOGIC; 								-- from memory step
			if_ctrl_jump 			: in STD_LOGIC;								-- from instruction decoder step
			if_jump_addr 			: in STD_LOGIC_VECTOR (31 downto 0); 	-- from instruction decoder step
			if_branchAddr			: in STD_LOGIC_VECTOR (31 downto 0); 	-- from memory step
			
			--output
			id_pc						: out STD_LOGIC_VECTOR (31 downto 0);
			imem_address			: out STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	component decoder is
		Port ( 
			clk						: in  STD_LOGIC;
			reset 					: in  STD_LOGIC;	
			
			--input
			imem_data_in 			: in  STD_LOGIC_VECTOR (31 downto 0);
			pc_unincremented		: in  STD_LOGIC_VECTOR (31 downto 0);

			id_ctrl_regWrite		: in 	STD_LOGIC;
			id_regWriteAddr		: in 	STD_LOGIC_VECTOR (4 downto 0);
			id_regWriteData		: in  STD_LOGIC_VECTOR (31 downto 0);	
			id_if_pc					: in  STD_LOGIC_VECTOR (31 downto 0);

			ex_back_rt				: in STD_LOGIC_VECTOR (4 downto 0);
			ex_back_mem_read		: in STD_LOGIC;
			
			--output
			if_ctrl_jump 			: out  STD_LOGIC; -- from processor control
			if_jump_addr 			: out  STD_LOGIC_VECTOR (31 downto 0);

			wb_ctrl_regWrite 		: out  STD_LOGIC;
			wb_ctrl_memtoReg 		: out  STD_LOGIC;

			mem_ctrl_branch 		: out  STD_LOGIC;
			mem_ctrl_memRead 		: out  STD_LOGIC;
			mem_ctrl_memWrite 	: out  STD_LOGIC;

			ex_ctrl_regDst 		: out  STD_LOGIC;
			ex_ctrl_aluOp 			: out  STD_LOGIC_VECTOR (1 downto 0);
			ex_ctrl_aluSrc 		: out  STD_LOGIC;
			ex_pc						: out  STD_LOGIC_VECTOR (31 downto 0);
			ex_register_read_1 	: out  STD_LOGIC_VECTOR (31 downto 0);
			ex_register_read_2 	: out  STD_LOGIC_VECTOR (31 downto 0);
			ex_signext 				: out  STD_LOGIC_VECTOR (31 downto 0);
			ex_inst_25_21 			: out  STD_LOGIC_VECTOR (4 downto 0);
			ex_inst_20_16 			: out  STD_LOGIC_VECTOR (4 downto 0);
			ex_inst_15_11 			: out  STD_LOGIC_VECTOR (4 downto 0);
			
			pc_stall 				: out STD_LOGIC := '0';
			pc_unincremented_back: out  STD_LOGIC_VECTOR (31 downto 0)
		);
	end component;
	
	component Executer is
		Port ( 
			reset 					: in  STD_LOGIC;
			clk 						: in  STD_LOGIC;

			-- input signals
			ex_wb_ctrl_regWrite 	: in  STD_LOGIC;
			ex_wb_ctrl_memtoReg 	: in  STD_LOGIC;
			
			ex_mem_ctrl_branch 	: in  STD_LOGIC;
			ex_mem_ctrl_memRead 	: in  STD_LOGIC;
			ex_mem_ctrl_memWrite : in  STD_LOGIC;
			
			ex_ctrl_regDst 		: in STD_LOGIC;
			ex_ctrl_aluOp 			: in STD_LOGIC_VECTOR (1 downto 0);
			ex_ctrl_aluSrc 		: in STD_LOGIC;
			
			ex_pc						: in STD_LOGIC_VECTOR (31 downto 0);
			ex_signext 				: in STD_LOGIC_VECTOR (31 downto 0);
			ex_inst_25_21 			: in STD_LOGIC_VECTOR (4 downto 0);
			ex_inst_20_16 			: in STD_LOGIC_VECTOR (4 downto 0);
			ex_inst_15_11 			: in STD_LOGIC_VECTOR (4 downto 0);
			
			ex_register_read_1 	: in STD_LOGIC_VECTOR (31 downto 0);
			ex_register_read_2 	: in STD_LOGIC_VECTOR (31 downto 0);
		
			wb_write_data			: in STD_LOGIC_VECTOR (31 downto 0);
			mem_alu_res				: in STD_LOGIC_VECTOR (31 downto 0);
			
			mem_reg_dest 			: in STD_LOGIC_VECTOR (4 downto 0);
			mem_reg_write 			: in STD_LOGIC;
			
			wb_reg_write 			: in STD_LOGIC;
			wb_reg_dest 			: in STD_LOGIC_VECTOR (4 downto 0);
			
			-- out signals
			mem_wb_ctrl_regWrite : out  STD_LOGIC;
			mem_wb_ctrl_memtoReg : out  STD_LOGIC;
			
			mem_ctrl_branch 		: out  STD_LOGIC;
			mem_ctrl_memRead 		: out  STD_LOGIC;
			mem_ctrl_memWrite 	: out  STD_LOGIC;
			
			mem_aluZero				: out STD_LOGIC;
			mem_branchAddr			: out STD_LOGIC_VECTOR (31 downto 0);
			mem_aluRes				: out STD_LOGIC_VECTOR (31 downto 0);
			mem_writeData 			: out STD_LOGIC_VECTOR (31 downto 0); -- copy of ex_register_read_2
			mem_writeRegisterAddr: out STD_LOGIC_VECTOR (4 downto 0);
			
			id_rt						: out STD_LOGIC_VECTOR (4 downto 0);
			id_mem_read				: out STD_LOGIC
		);	
	end component;
	
	component memorier is
		Port ( 
			reset 					: in  STD_LOGIC;
			clk 						: in  STD_LOGIC;
					
			-- input from executer step
			mem_wb_ctrl_regWrite : in  STD_LOGIC;	
			mem_wb_ctrl_memtoReg : in  STD_LOGIC;

			mem_ctrl_branch 		: in  STD_LOGIC;
			mem_ctrl_memRead 		: in  STD_LOGIC;
			mem_ctrl_memWrite 	: in  STD_LOGIC;
			
			mem_aluZero				: in STD_LOGIC;
			mem_branchAddr			: in STD_LOGIC_VECTOR (31 downto 0);
			mem_aluRes				: in STD_LOGIC_VECTOR (31 downto 0);
			mem_writeData 			: in STD_LOGIC_VECTOR (31 downto 0);
			mem_regWriteAddr		: in STD_LOGIC_VECTOR (4 downto 0);
		
			-- output signals to write back step
			wb_ctrl_regWrite 		: out STD_LOGIC;	
			wb_ctrl_memtoReg 		: out STD_LOGIC;
			
			if_branchAddr			: out STD_LOGIC_VECTOR (31 downto 0);
			wb_aluRes				: out STD_LOGIC_VECTOR (31 downto 0);
			wb_regWriteAddr		: out STD_LOGIC_VECTOR (4 downto 0);
			
			if_ctrl_pcSrc			: out STD_LOGIC; -- branch control / selector
			
			mem_alu_res				: out STD_LOGIC_VECTOR (31 downto 0);
			mem_reg_dest 			: out STD_LOGIC_VECTOR (4 downto 0);
			mem_reg_write 			: out	STD_LOGIC;
			
			-- external processor signals		
			dmem_address			: out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
			dmem_address_wr     	: out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
			dmem_data_out       	: out STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
			dmem_write_enable   	: out STD_LOGIC
		);	
	end component;
	
	component writebacker is
		Port ( 
			reset 					: in  STD_LOGIC;
			clk 						: in  STD_LOGIC;
					
			-- input signals from memory step
			wb_ctrl_regWrite 		: in STD_LOGIC;	
			wb_ctrl_memtoReg 		: in STD_LOGIC;
			
			wb_aluRes				: in STD_LOGIC_VECTOR (31 downto 0);
			wb_regWriteAddr		: in STD_LOGIC_VECTOR (4 downto 0);

			-- external processor signal 
			dmem_data_in			: in  STD_LOGIC_VECTOR (DDATA_BUS-1 downto 0);

			-- output signals to instruction decoder
			id_ctrl_regWrite		: out STD_LOGIC;
			id_writeRegisterAddr : out STD_LOGIC_VECTOR (4 downto 0);
			id_writeData			: out STD_LOGIC_VECTOR (31 downto 0);
			
			wb_write_data			: out STD_LOGIC_VECTOR (31 downto 0);
			wb_reg_write 			: out STD_LOGIC;
			wb_reg_dest 			: out STD_LOGIC_VECTOR (4 downto 0)
		);
	end component;
	
	--fetcher out signals
	signal fetcher_id_pc						: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal fetcher_imem_address			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	
	--decoder out signals
	signal decoder_if_ctrl_jump 			: STD_LOGIC := '0'; -- from processor control
	signal decoder_if_jump_addr 			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

	signal decoder_wb_ctrl_regWrite 		: STD_LOGIC := '0';
	signal decoder_wb_ctrl_memtoReg 		: STD_LOGIC := '0';

	signal decoder_mem_ctrl_branch 		: STD_LOGIC := '0';
	signal decoder_mem_ctrl_memRead 		: STD_LOGIC := '0';
	signal decoder_mem_ctrl_memWrite 	: STD_LOGIC := '0';

	signal decoder_ex_ctrl_regDst 		: STD_LOGIC := '0';
	signal decoder_ex_ctrl_aluOp 			: STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
	signal decoder_ex_ctrl_aluSrc 		: STD_LOGIC := '0';
	signal decoder_ex_pc						: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal decoder_ex_register_read_1 	: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal decoder_ex_register_read_2 	: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal decoder_ex_signext 				: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal decoder_ex_inst_25_21 			: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal decoder_ex_inst_20_16 			: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal decoder_ex_inst_15_11 			: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal decoder_pc_stall			 		: STD_LOGIC := '0';
	signal decoder_pc_unincremented_back: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	
	--executer
	signal executer_mem_wb_ctrl_regWrite : STD_LOGIC := '0';
	signal executer_mem_wb_ctrl_memtoReg : STD_LOGIC := '0';
	
	signal executer_mem_ctrl_branch 		: STD_LOGIC := '0';
	signal executer_mem_ctrl_memRead 	: STD_LOGIC := '0';
	signal executer_mem_ctrl_memWrite 	: STD_LOGIC := '0';
	
	signal executer_mem_aluZero				: STD_LOGIC := '0';
	signal executer_mem_branchAddr			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal executer_mem_aluRes					: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal executer_mem_writeData 			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); -- copy of ex_register_read_2
	signal executer_mem_writeRegisterAddr	: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	
	signal executer_id_rt					: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal executer_id_mem_read			: STD_LOGIC := '0';
	
	--memorier
	signal memorier_wb_ctrl_regWrite 	: STD_LOGIC := '0';	
	signal memorier_wb_ctrl_memtoReg 	: STD_LOGIC := '0';
	
	signal memorier_if_branchAddr			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal memorier_wb_aluRes				: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal memorier_wb_regWriteAddr		: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	
	signal memorier_if_ctrl_pcSrc			: STD_LOGIC := '0'; -- branch control / selector
	
	signal memorier_mem_alu_res			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal memorier_mem_reg_dest			: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal memorier_mem_reg_write			: STD_LOGIC := '0';
	
	-- external processor signals from memorier		
	signal memorier_dmem_address			: STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
	signal memorier_dmem_address_wr     : STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
	signal memorier_dmem_data_out       : STD_LOGIC_VECTOR (DADDR_BUS-1 downto 0) := (others => '0'); -- remove default value?
	signal memorier_dmem_write_enable   : STD_LOGIC := '0';
	
	--writebacker
	signal writebacker_id_ctrl_regWrite			: STD_LOGIC := '0';
	signal writebacker_id_writeRegisterAddr 	: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal writebacker_id_writeData				: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	
	signal writebacker_wb_reg_write			: STD_LOGIC := '0';
	signal writebacker_wb_reg_dest 			: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal writebacker_wb_write_data			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
	
	fetcher_comp: fetcher port map(
		clk 					=> clk,
		reset					=> reset,
		pc_stall				=> decoder_pc_stall,
		pc_stall_number   => decoder_pc_unincremented_back,
		processor_enable 	=> processor_enable,
		if_ctrl_pcSrc 		=>	memorier_if_ctrl_pcSrc,
		if_ctrl_jump		=> decoder_if_ctrl_jump,
		if_jump_addr		=> decoder_if_jump_addr,
		if_branchAddr		=> memorier_if_branchAddr,
		id_pc					=> fetcher_id_pc,
		imem_address		=>	fetcher_imem_address
	);
	
	decoder_comp: decoder port map(
		clk 					=> clk,
		reset					=> reset,
		imem_data_in		=> imem_data_in,
		pc_unincremented  => fetcher_imem_address,
		id_ctrl_regWrite	=> writebacker_id_ctrl_regWrite,
		id_regWriteAddr	=> writebacker_id_writeRegisterAddr,
		id_regWriteData	=> writebacker_id_writeData,
		id_if_pc				=> fetcher_id_pc,
		ex_back_rt			=> executer_id_rt,
		ex_back_mem_read	=> executer_id_mem_read,
		if_ctrl_jump		=> decoder_if_ctrl_jump,
		if_jump_addr		=> decoder_if_jump_addr,
		wb_ctrl_regWrite	=> decoder_wb_ctrl_regWrite,
		wb_ctrl_memtoReg	=> decoder_wb_ctrl_memtoReg,
		mem_ctrl_branch	=> decoder_mem_ctrl_branch,
		mem_ctrl_memRead	=> decoder_mem_ctrl_memRead,
		mem_ctrl_memWrite	=> decoder_mem_ctrl_memWrite,
		ex_ctrl_regDst		=> decoder_ex_ctrl_regDst,
		ex_ctrl_aluOp		=> decoder_ex_ctrl_aluOp,
		ex_ctrl_aluSrc		=> decoder_ex_ctrl_aluSrc,
		ex_pc					=> decoder_ex_pc,
		ex_register_read_1=> decoder_ex_register_read_1,
		ex_register_read_2=> decoder_ex_register_read_2,
		ex_signext			=> decoder_ex_signext,
		ex_inst_25_21		=> decoder_ex_inst_25_21,
		ex_inst_20_16		=> decoder_ex_inst_20_16,
		ex_inst_15_11		=> decoder_ex_inst_15_11,
		pc_stall				=>	decoder_pc_stall,
		pc_unincremented_back => decoder_pc_unincremented_back
	);
	
	executer_comp: Executer port map(
		clk 						=> clk,
		reset						=> reset,
		ex_wb_ctrl_regWrite	=> decoder_wb_ctrl_regWrite,
		ex_wb_ctrl_memtoReg	=> decoder_wb_ctrl_memtoReg,
		ex_mem_ctrl_branch	=> decoder_mem_ctrl_branch,
		ex_mem_ctrl_memRead	=> decoder_mem_ctrl_memRead,
		ex_mem_ctrl_memWrite	=> decoder_mem_ctrl_memWrite,
		ex_ctrl_regDst			=> decoder_ex_ctrl_regDst,
		ex_ctrl_aluOp			=> decoder_ex_ctrl_aluOp,
		ex_ctrl_aluSrc			=> decoder_ex_ctrl_aluSrc,
		ex_pc						=> decoder_ex_pc,
		ex_signext				=> decoder_ex_signext,
		ex_inst_25_21			=> decoder_ex_inst_25_21,
		ex_inst_20_16			=> decoder_ex_inst_20_16,
		ex_inst_15_11			=> decoder_ex_inst_15_11,
		ex_register_read_1	=> decoder_ex_register_read_1,
		ex_register_read_2	=> decoder_ex_register_read_2,
		wb_write_data			=> writebacker_wb_write_data,
		mem_alu_res				=> memorier_mem_alu_res,
		mem_reg_dest			=> memorier_mem_reg_dest,
		mem_reg_write			=> memorier_mem_reg_write,
		wb_reg_write			=> writebacker_wb_reg_write,
		wb_reg_dest				=> writebacker_wb_reg_dest,
		mem_wb_ctrl_regWrite	=> executer_mem_wb_ctrl_regWrite,
		mem_wb_ctrl_memtoReg	=> executer_mem_wb_ctrl_memtoReg,
		mem_ctrl_branch		=> executer_mem_ctrl_branch,
		mem_ctrl_memRead		=> executer_mem_ctrl_memRead,
		mem_ctrl_memWrite		=> executer_mem_ctrl_memWrite,
		mem_aluZero				=> executer_mem_aluZero,
		mem_branchAddr			=> executer_mem_branchAddr,
		mem_aluRes				=> executer_mem_aluRes,
		mem_writeData			=> executer_mem_writeData,
		mem_writeRegisterAddr=> executer_mem_writeRegisterAddr,
		id_rt						=> executer_id_rt,
		id_mem_read				=> executer_id_mem_read
	);
	
	memorier_comp: memorier port map(
		clk 						=> clk,
		reset						=> reset,
		mem_wb_ctrl_regWrite	=> executer_mem_wb_ctrl_regWrite,
		mem_wb_ctrl_memtoReg	=> executer_mem_wb_ctrl_memtoReg,
		mem_ctrl_branch		=> executer_mem_ctrl_branch,
		mem_ctrl_memRead		=> executer_mem_ctrl_memRead,
		mem_ctrl_memWrite		=> executer_mem_ctrl_memWrite,
		mem_aluZero				=> executer_mem_aluZero,
		mem_branchAddr			=> executer_mem_branchAddr,
		mem_aluRes				=> executer_mem_aluRes,
		mem_writeData			=> executer_mem_writeData,
		mem_regWriteAddr		=> executer_mem_writeRegisterAddr,
		wb_ctrl_regWrite		=> memorier_wb_ctrl_regWrite,
		wb_ctrl_memtoReg		=> memorier_wb_ctrl_memtoReg,
		if_branchAddr			=> memorier_if_branchAddr,
		wb_aluRes				=> memorier_wb_aluRes,
		wb_regWriteAddr		=> memorier_wb_regWriteAddr,
		if_ctrl_pcSrc			=> memorier_if_ctrl_pcSrc,
		mem_alu_res				=> memorier_mem_alu_res,
		mem_reg_dest			=> memorier_mem_reg_dest,
		mem_reg_write			=> memorier_mem_reg_write,
		dmem_address			=> memorier_dmem_address,
		dmem_address_wr		=> memorier_dmem_address_wr,
		dmem_data_out			=> memorier_dmem_data_out,
		dmem_write_enable		=> memorier_dmem_write_enable
	);
	
	writebacker_comp: writebacker port map(
		clk 						=> clk,
		reset						=> reset,
		wb_ctrl_regWrite		=> memorier_wb_ctrl_regWrite,
		wb_ctrl_memtoReg		=> memorier_wb_ctrl_memtoReg,
		wb_aluRes				=> memorier_wb_aluRes,
		wb_regWriteAddr		=> memorier_wb_regWriteAddr,
		dmem_data_in			=> dmem_data_in,
		id_ctrl_regWrite		=> writebacker_id_ctrl_regWrite,
		id_writeRegisterAddr	=> writebacker_id_writeRegisterAddr,
		id_writeData			=> writebacker_id_writeData,
		wb_write_data			=> writebacker_wb_write_data,
		wb_reg_write			=> writebacker_wb_reg_write,
		wb_reg_dest				=> writebacker_wb_reg_dest
	);
	
		
	PROCESSOR : process(clk, reset, processor_enable)
	begin
		
		-- Reset
		if reset = '1' or processor_enable = '0' then
			imem_address 			<= (others => '0');
			dmem_address 			<= (others => '0');
			dmem_address_wr 		<= (others => '0');
			dmem_data_out 			<= (others => '0');
			dmem_write_enable		<= '0';
		
		-- Processor Enabled and State is Stall
		else
			-- Set external signals
			imem_address 				<= fetcher_imem_address;
			dmem_address 				<= memorier_dmem_address;
			dmem_address_wr 			<= memorier_dmem_address_wr; 	
			dmem_data_out 				<= memorier_dmem_data_out;
			dmem_write_enable			<= memorier_dmem_write_enable;
		end if;
		
	end process;

end Behavioral;