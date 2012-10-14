----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:37:32 07/05/2011 
-- Design Name: 
-- Module Name:    com - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity com is
    
  generic (
    MEM_ADDR_BUS    : integer := 32;
    MEM_DATA_BUS    : integer := 32;
    INPUT_BUS_WIDTH : integer := 32);

    port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           
           -- bus signals
           command        : in  STD_LOGIC_VECTOR (0 to INPUT_BUS_WIDTH-1);
           bus_address_in : in  STD_LOGIC_VECTOR (0 to INPUT_BUS_WIDTH-1);
           bus_data_in    : in  STD_LOGIC_VECTOR (0 to INPUT_BUS_WIDTH-1);
           status         : out  STD_LOGIC_VECTOR (0 to INPUT_BUS_WIDTH-1);
           bus_data_out   : out  STD_LOGIC_VECTOR (0 to INPUT_BUS_WIDTH-1);
           
           -- memory and control signals
           read_addr : out  STD_LOGIC_VECTOR (MEM_ADDR_BUS - 1 downto 0);
           read_data : in  STD_LOGIC_VECTOR (MEM_DATA_BUS - 1 downto 0);
           write_addr : out  STD_LOGIC_VECTOR (MEM_ADDR_BUS - 1 downto 0);
           write_data : out  STD_LOGIC_VECTOR (MEM_DATA_BUS - 1 downto 0);
           write_enable : out  STD_LOGIC;
           processor_enable : out  STD_LOGIC;
           write_imem : out STD_LOGIC);
end com;

architecture Behavioral of com is

  signal state : std_logic_vector(2 downto 0);
  
  signal internal_data_out   : std_logic_vector(MEM_DATA_BUS - 1 downto 0);
  
  constant CMD_NONE    : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000000";
  constant CMD_WI      : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000001";
  constant CMD_RD      : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000010";
  constant CMD_WD      : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000011";
  constant CMD_RUN     : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000100";
  
  constant STATUS_IDLE : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000000";
  constant STATUS_BUSY : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000001";
  constant STATUS_RUN  : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000010";
  constant STATUS_DONE : std_logic_vector(0 to INPUT_BUS_WIDTH-1) := "00000000000000000000000000000011";
  
begin

  STATE_MACHINE : process(clk, reset)
    constant STATE_IDLE  : std_logic_vector(2 downto 0) := "000";
    constant STATE_WI    : std_logic_vector(2 downto 0) := "001";
    constant STATE_WD    : std_logic_vector(2 downto 0) := "010";
    constant STATE_RD1   : std_logic_vector(2 downto 0) := "011";
    constant STATE_RUN   : std_logic_vector(2 downto 0) := "100";
    constant STATE_DONE  : std_logic_vector(2 downto 0) := "101";
    constant STATE_RD2   : std_logic_vector(2 downto 0) := "110";
    constant STATE_RD3   : std_logic_vector(2 downto 0) := "111";
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state            <= (others => '0');
        status           <= STATUS_IDLE;
        bus_data_out     <= (others => '0');        
        read_addr        <= (others => '0');
        write_addr       <= (others => '0');
        write_data       <= (others => '0');
        write_enable     <= '0';
        processor_enable <= '0';
        write_imem       <= '0';
        internal_data_out <= (others => '0');
      else
        case state is
          -- idle
          when STATE_IDLE =>
            status           <= STATUS_IDLE;
            bus_data_out     <= (others => '0');        
            read_addr        <= (others => '0');
            write_addr       <= (others => '0');
            write_data       <= (others => '0');
            write_enable     <= '0';
            processor_enable <= '0';
            write_imem       <= '0';
            internal_data_out <= (others => '0');
            
            -- next state function
            if command = CMD_WI then
              state <= STATE_WI;
            elsif command = CMD_WD then
              state <= STATE_WD;
            elsif command = CMD_RD then
              state <= STATE_RD1;
            elsif command = CMD_RUN then
              state <= STATE_RUN;
            else
              state <= STATE_IDLE;
            end if;
          
          -- write instruction
          when STATE_WI =>
            status           <= STATUS_BUSY;
            bus_data_out     <= (others => '0');        
            read_addr        <= (others => '0');
            write_addr       <= bus_address_in(INPUT_BUS_WIDTH - MEM_ADDR_BUS to INPUT_BUS_WIDTH - 1);
            write_data       <= bus_data_in;
            write_enable     <= '1';
            processor_enable <= '0';
            write_imem       <= '1';
            internal_data_out <= (others => '0');
            
            state <= STATE_DONE;
            
          -- write data
          when STATE_WD =>
            status           <= STATUS_BUSY;
            bus_data_out     <= (others => '0');        
            read_addr        <= (others => '0');
            write_addr       <= bus_address_in(INPUT_BUS_WIDTH - MEM_ADDR_BUS to INPUT_BUS_WIDTH - 1);
            write_data       <= bus_data_in;
            write_enable     <= '1';
            processor_enable <= '0';
            write_imem       <= '0';           
            internal_data_out <= (others => '0');
            
            state <= STATE_DONE;
            
          -- read data
          when STATE_RD1 =>
            status            <= STATUS_BUSY;
            bus_data_out      <= (others => '0');
            internal_data_out <= (others => '0');
            read_addr         <= bus_address_in(INPUT_BUS_WIDTH - MEM_ADDR_BUS to INPUT_BUS_WIDTH - 1);
            write_addr        <= (others => '0');
            write_data        <= (others => '0');
            write_enable      <= '0';
            processor_enable  <= '0';
            write_imem        <= '0';      
            
            state    <= STATE_RD2;
            
          -- read data
          when STATE_RD2 =>
            status            <= STATUS_BUSY;
            bus_data_out      <= (others => '0');
            internal_data_out <= (others => '0');
            read_addr         <= (others => '0');
            write_addr        <= (others => '0');
            write_data        <= (others => '0');
            write_enable      <= '0';
            processor_enable  <= '0';
            write_imem        <= '0';      
            
            state    <= STATE_RD3;
            
          when STATE_RD3 =>
            status            <= STATUS_BUSY;
            bus_data_out      <= (others => '0');
            internal_data_out <= read_data; -- read data into internal register
            read_addr         <= (others => '0');
            write_addr        <= (others => '0');
            write_data        <= (others => '0');
            write_enable      <= '0';
            processor_enable  <= '0';
            write_imem        <= '0';      
            
            state    <= STATE_DONE;
            
          -- processor running
          when STATE_RUN =>
            status           <= STATUS_RUN;
            bus_data_out     <= (others => '0');        
            read_addr        <= (others => '0');
            write_addr       <= (others => '0');
            write_data       <= (others => '0');
            write_enable     <= '0';
            processor_enable <= '1';
            write_imem       <= '0';
            internal_data_out <= (others => '0');           
            
            if command = CMD_RUN then
              state <= STATE_RUN;
            else
              state <= STATE_IDLE;
            end if;
          
          when STATE_DONE => 
            status           <= STATUS_DONE;
            bus_data_out     <= internal_data_out;
            read_addr        <= (others => '0');
            write_addr       <= (others => '0');
            write_data       <= (others => '0');
            write_enable     <= '0';
            processor_enable <= '0';
            write_imem       <= '0';
            
            if command = CMD_NONE then
              state <= STATE_IDLE;
            else
              state <= STATE_DONE;
            end if;
          
          when others =>
            state            <= (others => '0');
            status           <= (others => '0');
            bus_data_out     <= (others => '0');        
            read_addr        <= (others => '0');
            write_addr       <= (others => '0');
            write_data       <= (others => '0');
            write_enable     <= '0';
            processor_enable <= '0';
            write_imem       <= '0';
            internal_data_out <= (others => '0');
            
        end case;
      end if;
    end if;
  end process;
  
  
  --IO_REGISTERS: process (clk, reset) is
  --begin
  --  if rising_edge(clk) then
  --    if reset = '1' then
  --      internal_address_in <= (others => '0');
  --      internal_data_in    <= (others => '0');
  --    else
  --      internal_address_in <= bus_address_in(INPUT_BUS_WIDTH - MEM_ADDR_BUS to INPUT_BUS_WIDTH - 1);
  --      internal_data_in <= bus_data_in;
  --    end if;
  --  end if;
  --end process;

end Behavioral;

