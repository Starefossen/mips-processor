----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:08:24 05/03/2012 
-- Design Name: 
-- Module Name:    toplevel - Behavioral 
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

library WORK;
use WORK.MIPS_CONSTANT_PKG.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity toplevel is

	generic  (
		MEM_ADDR_BUS	: integer	:= 32;
		MEM_DATA_BUS	: integer	:= 32 );

	Port (
		clk            : in STD_LOGIC;
		reset          : in STD_LOGIC;
		command        : in  STD_LOGIC_VECTOR (0 to 31);
		bus_address_in : in  STD_LOGIC_VECTOR (0 to 31);
		bus_data_in    : in  STD_LOGIC_VECTOR (0 to 31);
		status         : out  STD_LOGIC_VECTOR (0 to 31);
		bus_data_out   : out  STD_LOGIC_VECTOR (0 to 31)
	); 
end toplevel;

--
architecture Behavioral of toplevel is

	component com
	port ( 
		clk				: in  STD_LOGIC;
		reset				: in  STD_LOGIC;
		command			: in  STD_LOGIC_VECTOR (0 to 31);
		bus_address_in	: in  STD_LOGIC_VECTOR (0 to 31);
		bus_data_in		: in  STD_LOGIC_VECTOR (0 to 31);
		status			: out  STD_LOGIC_VECTOR (0 to 31);
		bus_data_out 	: out  STD_LOGIC_VECTOR (0 to 31);
		read_addr		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS - 1 downto 0);
		read_data		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS - 1 downto 0);
		write_addr		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS - 1 downto 0);
		write_data		: out  STD_LOGIC_VECTOR (MEM_DATA_BUS - 1 downto 0);       
		write_enable	: out  STD_LOGIC;    
		write_imem 		: out STD_LOGIC;
		processor_enable : out  STD_LOGIC
	);
	end component;
	
	component processor is  
	Port ( 
		clk : in STD_LOGIC;
		reset					: in STD_LOGIC;
		processor_enable	: in  STD_LOGIC;
		imem_address 		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS-1 downto 0);
		imem_data_in 		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
		dmem_data_in 		: in  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
		dmem_address 		: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS-1 downto 0);
		dmem_address_wr	: out  STD_LOGIC_VECTOR (MEM_ADDR_BUS-1 downto 0);
		dmem_data_out		: out  STD_LOGIC_VECTOR (MEM_DATA_BUS-1 downto 0);
		dmem_write_enable	: out  STD_LOGIC
	);
	end component;
	
	component MEMORY is
		generic (M :NATURAL :=MEM_ADDR_COUNT; N :NATURAL :=DDATA_BUS); 
		port(
			CLK			: in STD_LOGIC;
			--RESET			:	in  STD_LOGIC;	
			W_ADDR		:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Address to write data
			WRITE_DATA	:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Data to be written
			MemWrite		:	in  STD_LOGIC;									-- Write Signal
			ADDR			:	in  STD_LOGIC_VECTOR (N-1 downto 0);	-- Address to access data
			READ_DATA	:	out STD_LOGIC_VECTOR (N-1 downto 0)		-- Data read from memory
		);
	end component MEMORY;
	
	signal proc_enable				: std_logic;
	signal com_write_en				: std_logic;
	signal dmem_write_enable_com	: std_logic;
	signal imem_write_enable_com	: std_logic;
	signal instr_data					: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal instr_addr					: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_address_wr			: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_write_data			: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_address				: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_address_wr_proc	: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_data_in				: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_write_enable 		: std_logic;
	signal dmem_write_data_proc	: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_address_proc		: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_write_enable_proc	: std_logic;
	signal dmem_address_wr_com		: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal dmem_write_data_com		: std_logic_vector(MEM_DATA_BUS-1 downto 0);
	signal dmem_address_com			: std_logic_vector(MEM_ADDR_BUS-1 downto 0); 
	signal com_write_imem			: std_logic;
	
begin

	TDT4255_COM : com port map(
		clk				=> clk,
		reset				=> reset,
		command			=> command,
		bus_address_in	=> bus_address_in,
		bus_data_in		=> bus_data_in,
		status			=> status,
		bus_data_out	=> bus_data_out,
		processor_enable	=> proc_enable,
		read_data		=> dmem_data_in,
		read_addr		=> dmem_address_com,
		write_addr		=> dmem_address_wr_com,
		write_data		=> dmem_write_data_com,
		write_enable	=> com_write_en,
		write_imem		=> com_write_imem
	);
	
	DMEM_MUX : process(clk, reset, dmem_address_proc, dmem_address_wr_proc, dmem_write_data_proc, dmem_write_enable_proc,
					dmem_address_com, dmem_address_wr_com, dmem_write_data_com, dmem_write_enable_com, proc_enable)
	begin
		if proc_enable = '1' then          
			dmem_address		<= dmem_address_proc;
			dmem_address_wr	<= dmem_address_wr_proc;
			dmem_write_data	<= dmem_write_data_proc;
			dmem_write_enable	<= dmem_write_enable_proc;
		else
			dmem_address		<= dmem_address_com;
			dmem_address_wr	<= dmem_address_wr_com;
			dmem_write_data	<= dmem_write_data_com;
			dmem_write_enable <= dmem_write_enable_com;
		end if;
	end process;
	
	IMEM_WRITE_ENABLE_MUX : process(com_write_imem, com_write_en)
	begin
		if com_write_imem = '1' then
			imem_write_enable_com <= com_write_en;
			dmem_write_enable_com <= ZERO1b;
		else
			imem_write_enable_com <= ZERO1b;
			dmem_write_enable_com <= com_write_en;
		end if;
	end process;
	
	DATA_MEM: MEMORY generic map (M=>MEM_ADDR_COUNT, N=>DDATA_BUS) 
	port map(
		CLK			=> clk,
		--RESET			=> reset,
		W_ADDR		=> dmem_address_wr,		-- ADDRESS TO BE WRITTEN
		WRITE_DATA	=> dmem_write_data,		-- DATA TO BE WRITTEN
		ADDR			=> dmem_address,			-- ADDRESS TO BE READ
		READ_DATA	=> dmem_data_in,			-- DATA READ OUT
		MemWrite		=> dmem_write_enable
	);

	INST_MEM: MEMORY generic map (M=>MEM_ADDR_COUNT, N=>IDATA_BUS) 
	port map(
		CLK			=> clk,
		--RESET		=> reset,
		W_ADDR		=> dmem_address_wr_com,		-- ADDRESS TO BE WRITTEN
		WRITE_DATA	=> dmem_write_data_com,		-- DATA TO BE WRITTEN
		ADDR		=> instr_addr,					-- ADDRESS TO BE READ
		READ_DATA	=> instr_data,					-- DATA READ OUT
		MemWrite	=> imem_write_enable_com
	);
	
	MIPS_SC_PROCESSOR: processor 
	port map(
		clk 				=> clk,
		reset				=> reset,
		processor_enable	=> proc_enable,
		imem_data_in		=> instr_data,
		imem_address		=> instr_addr,
		dmem_data_in		=> dmem_data_in,				-- DATA READ FROM THE MEMORY
		dmem_address		=> dmem_address_proc,			-- ADDRESS TO BE READ
		dmem_address_wr		=> dmem_address_wr_proc,		-- ADDRESS OF DATA TO BE WRITTEN
		dmem_data_out		=> dmem_write_data_proc,		-- DATA TO BE WRITTEN
		dmem_write_enable	=> dmem_write_enable_proc
	);
	
end Behavioral;

