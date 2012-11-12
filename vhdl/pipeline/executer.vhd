----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:49:09 10/11/2012 
-- Design Name: 
-- Module Name:    Executer - Behavioral 
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

entity Executer is
	Port ( 
		reset 					: in  STD_LOGIC;
		clk 						: in  STD_LOGIC;

		-- input signals
		ex_wb_ctrl_regWrite 	: in  STD_LOGIC := '0';
		ex_wb_ctrl_memtoReg 	: in  STD_LOGIC := '0';
		
		ex_mem_ctrl_branch 	: in  STD_LOGIC := '0';
		ex_mem_ctrl_memRead 	: in  STD_LOGIC := '0';
		ex_mem_ctrl_memWrite : in  STD_LOGIC := '0';
		
		ex_ctrl_regDst 		: in STD_LOGIC := '0';
		ex_ctrl_aluOp 			: in STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
		ex_ctrl_aluSrc 		: in STD_LOGIC := '0';
		
		ex_pc						: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_signext 				: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_inst_25_21 			: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		ex_inst_20_16 			: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		ex_inst_15_11 			: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		
		ex_register_read_1 	: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		ex_register_read_2 	: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		
		wb_write_data			: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		mem_alu_res				: in STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		
		mem_reg_dest 			: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		mem_reg_write 			: in STD_LOGIC := '0';
		
		wb_reg_write 			: in STD_LOGIC := '0';
		wb_reg_dest 			: in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		
		-- out signals
		mem_wb_ctrl_regWrite : out  STD_LOGIC := '0';
		mem_wb_ctrl_memtoReg : out  STD_LOGIC := '0';
		
		mem_ctrl_branch 		: out  STD_LOGIC := '0';
		mem_ctrl_memRead 		: out  STD_LOGIC := '0';
		mem_ctrl_memWrite 	: out  STD_LOGIC := '0';
		
		mem_aluZero				: out STD_LOGIC := '0';
		mem_branchAddr			: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		mem_aluRes				: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
		mem_writeData 			: out STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); -- copy of ex_register_read_2
		mem_writeRegisterAddr: out STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		
		-- send back to instruction decode step
		id_rt						: out STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
		id_mem_read				: out STD_LOGIC := '0'
	);	
end Executer;

architecture Behavioral of Executer is

	component FORWARDING_UNIT is
		Port (
			rs : in  STD_LOGIC_VECTOR (4 downto 0);
			rt : in  STD_LOGIC_VECTOR (4 downto 0);
			mem_reg_dest : in  STD_LOGIC_VECTOR (4 downto 0);
			mem_reg_write : in  STD_LOGIC;
			wb_reg_write : in  STD_LOGIC;
			wb_reg_dest : in  STD_LOGIC_VECTOR (4 downto 0);
			fwrd_ctrl_alusrc1 : out  STD_LOGIC_VECTOR (1 downto 0);
			fwrd_ctrl_alusrc2 : out  STD_LOGIC_VECTOR (1 downto 0)
		);
	end component;

	component ALU is
		generic (N :NATURAL :=32); 
		Port(
			X			: in STD_LOGIC_VECTOR(N-1 downto 0);
			Y			: in STD_LOGIC_VECTOR(N-1 downto 0);
			ALU_IN	: in ALU_INPUT;
			R			: out STD_LOGIC_VECTOR(N-1 downto 0);
			FLAGS		: out ALU_FLAGS
		);
	end component;

	-- ALU Control
	component ALU_CONTROL is
		Port ( 
			ALUOp 			: in  STD_LOGIC_VECTOR (1 downto 0);
			ALUFunct 		: in  STD_LOGIC_VECTOR (5 downto 0);
			ALUCtrl		 	: out ALU_INPUT
		);
	end component;

	component MUX is
		generic (N :NATURAL :=32); 
		Port ( selector : in  STD_LOGIC;
			bus_in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_out : out  STD_LOGIC_VECTOR (N-1 downto 0)
		);
	end component;
	
	component MUX3 is
		generic (N :NATURAL :=32); 
		Port ( selector : in STD_LOGIC_VECTOR (1 downto 0);
			bus_in0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_in1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_in2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
			bus_out : out  STD_LOGIC_VECTOR (N-1 downto 0)
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
	
	signal alu_in_x			: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal alu_in_y			: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
	signal alu_ctrl 			: ALU_INPUT := (OP0 => '0', OP1 => '0', OP2 => '0', OP3 => '0');
	signal alu_flags 			: ALU_FLAGS := (Carry => '0', Overflow => '0', Zero => '0', Negative => '0');
	signal alu_result			: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

	signal mux_regdest_out	: STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
	signal mux_alusrc2 		: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	signal adder_out			: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	
	-- forwarding unit control signals here
	signal fwrd_ctrl_alu1	: STD_LOGIC_VECTOR (1 downto 0) := "00";
	signal fwrd_ctrl_alu2	: STD_LOGIC_VECTOR (1 downto 0) := "00";
	
begin

	fwrd_unit : FORWARDING_UNIT port map(
		rs							=> ex_inst_25_21,
		rt							=> ex_inst_20_16,
		mem_reg_dest			=> mem_reg_dest,
		mem_reg_write			=> mem_reg_write,
		wb_reg_write			=> wb_reg_write,
		wb_reg_dest				=> wb_reg_dest,
		fwrd_ctrl_alusrc1		=> fwrd_ctrl_alu1,
		fwrd_ctrl_alusrc2		=> fwrd_ctrl_alu2
	);


	-- Main ALU
	main_alu : ALU port map(
		X				=> alu_in_x,
		Y				=> alu_in_y,
		ALU_IN		=> alu_ctrl,
		R				=> alu_result,
		FLAGS			=> alu_flags
	);
	
	-- ALU control component
	alu_ctrl_comp : ALU_CONTROL  port map ( 
		ALUOp 		=> ex_ctrl_aluOp,
		ALUFunct 	=> ex_signext(5 downto 0),
		ALUCtrl 		=> alu_ctrl
	);

	mux_const : MUX port map(
		selector 	=> ex_ctrl_aluSrc,
	   bus_in1 		=> mux_alusrc2,
	   bus_in2 		=> ex_signext,
	   bus_out 		=> alu_in_y
	);
	
	mux_alusrc0	: MUX3 port map(
		selector 	=> fwrd_ctrl_alu1,
	   bus_in0 		=> ex_register_read_1,
	   bus_in1 		=> wb_write_data,
	   bus_in2 		=> mem_alu_res,
	   bus_out 		=> alu_in_x
	);
	
	mux_alusrc1 : MUX3 port map(
		selector 	=> fwrd_ctrl_alu2,
	   bus_in0 		=> ex_register_read_2,
	   bus_in1 		=> wb_write_data,
	   bus_in2 		=> mem_alu_res,
	   bus_out 		=> mux_alusrc2
	);
	
	mux_regdst : MUX generic map (N=>5) port map(
		selector 	=> ex_ctrl_regDst,
	   bus_in1 		=> ex_inst_20_16,
	   bus_in2 		=> ex_inst_15_11,
	   bus_out 		=> mux_regdest_out
	);
		
	adder_comp : ADDER port map(
		X				=>	ex_pc,
		Y				=> ex_signext,
		CIN			=> '0',
		R				=> adder_out
	);
	
	STEP_EXECUTER : process(clk, reset)
	begin		
		id_rt						<= ex_inst_20_16;
		id_mem_read				<= ex_mem_ctrl_memRead;

		if reset = '1' then
			mem_ctrl_branch 		<= '0';
			mem_ctrl_memRead 		<= '0';
			mem_ctrl_memWrite 	<= '0';

			mem_wb_ctrl_regWrite <= '0';
			mem_wb_ctrl_memtoReg <= '0';
			
			mem_branchAddr			<= (others => '0');
			mem_aluRes				<= (others => '0');		-- intermediate alu res singal
			mem_aluZero				<= '0';
			mem_writeData 			<= (others => '0');
			mem_writeRegisterAddr<= (others => '0');

		elsif falling_edge(clk) then
			-- pipeline forwarding control signals
			mem_wb_ctrl_regWrite <= ex_wb_ctrl_regWrite;
			mem_wb_ctrl_memtoReg <= ex_wb_ctrl_memtoReg;
			
			mem_ctrl_branch 		<= ex_mem_ctrl_branch;
			mem_ctrl_memRead 		<= ex_mem_ctrl_memRead;
			mem_ctrl_memWrite 	<= ex_mem_ctrl_memWrite;
			mem_writeData 			<= mux_alusrc2;
			
			-- set computed results to output signals
			mem_aluZero				<= alu_flags.Zero;
			mem_branchAddr			<= adder_out;				
			mem_aluRes				<= alu_result;		-- intermediate alu res singal
			mem_writeRegisterAddr<= mux_regdest_out;
			
		end if;
	end process;

end Behavioral;

