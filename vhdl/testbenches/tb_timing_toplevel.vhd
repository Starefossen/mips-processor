--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:43:41 10/22/2012
-- Design Name:   
-- Module Name:   C:/Users/sondree/Desktop/Exercse2/Exercise2/tb_timing_toplevel.vhd
-- Project Name:  Exercise2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: toplevel
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_timing_toplevel IS
END tb_timing_toplevel;
 
ARCHITECTURE behavior OF tb_timing_toplevel IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT toplevel
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         command : IN  std_logic_vector(0 to 31);
         bus_address_in : IN  std_logic_vector(0 to 31);
         bus_data_in : IN  std_logic_vector(0 to 31);
         status : OUT  std_logic_vector(0 to 31);
         bus_data_out : OUT  std_logic_vector(0 to 31)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal command : std_logic_vector(0 to 31) := (others => '0');
   signal bus_address_in : std_logic_vector(0 to 31) := (others => '0');
   signal bus_data_in : std_logic_vector(0 to 31) := (others => '0');

 	--Outputs
   signal status : std_logic_vector(0 to 31);
   signal bus_data_out : std_logic_vector(0 to 31);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant zero : std_logic_vector(0 to 31) := "00000000000000000000000000000000";
	
	constant addr1 : std_logic_vector(0 to 31) := "00000000000000000000000000000001";
	constant addr2 : std_logic_vector(0 to 31) := "00000000000000000000000000000010";
	constant addr3 : std_logic_vector(0 to 31) := "00000000000000000000000000000011";
	constant addr4 : std_logic_vector(0 to 31) := "00000000000000000000000000000100";
	constant addr5 : std_logic_vector(0 to 31) := "00000000000000000000000000000101";
	constant addr6 : std_logic_vector(0 to 31) := "00000000000000000000000000000110";
	constant addr7 : std_logic_vector(0 to 31) := "00000000000000000000000000000111";
	constant addr8 : std_logic_vector(0 to 31) := "00000000000000000000000000001000";
	constant addr9 : std_logic_vector(0 to 31) := "00000000000000000000000000001001";
	constant addr10 : std_logic_vector(0 to 31):= "00000000000000000000000000001010";
   
	constant data1 : std_logic_vector(0 to 31):= "00000000000000000000000000001010";
	constant data2 : std_logic_vector(0 to 31):= "00000000000000000000000000000010";
	
	constant IDLE : std_logic_vector(0 to 31)		:= "00000000000000000000000000100010";		--	Do Nothing		00 00 00 22
	constant LOAD_1 : std_logic_vector(0 to 31)	:= "10001100000000010000000000000001";		-- LW 	$1 $0(1)		8C $4 $0(1)
	constant LOAD_2 : std_logic_vector(0 to 31)	:= "10001100000000100000000000000010";		-- LW 	$2 $0(2)		8C $4 $0(1)
	constant LDI_1 : std_logic_vector(0 to 31)	:= "00111100000000010000000000000110";		-- LDI 	$1 06		3C 01 00 06
   constant LDI_2 : std_logic_vector(0 to 31)	:= "00111100000000100000000000001000";		-- LDI 	$2 08		3C 02 00 08	
	constant ADD : std_logic_vector(0 to 31)		:= "00000000001000100001100000100000";		-- ADD 	$3 $2 $1 	00 22 18 20
	constant SW : std_logic_vector(0 to 31)		:= "10101100000000110000000000000101";		-- SW 	$3 $0(5)		AC 03 00 01
	constant BEQ : std_logic_vector(0 to 31)		:= "00010000000000000000000000000011";		-- BEQ 	goto 3
	constant nop : std_logic_vector(0 to 31) 		:= "11111100000000000000000000000000";
   
   constant CMD_IDLE	: std_logic_vector(0 to 31) := "00000000000000000000000000000000";
	constant CMD_WI	: std_logic_vector(0 to 31) := "00000000000000000000000000000001";
	constant CMD_RD	: std_logic_vector(0 to 31) := "00000000000000000000000000000010";
	constant CMD_WD	: std_logic_vector(0 to 31) := "00000000000000000000000000000011";
	constant CMD_RUN	: std_logic_vector(0 to 31) := "00000000000000000000000000000100";
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: toplevel PORT MAP (
          clk => clk,
          reset => reset,
          command => command,
          bus_address_in => bus_address_in,
          bus_data_in => bus_data_in,
          status => status,
          bus_data_out => bus_data_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
-- INSTR: WRITE DATA TO DMEM
		
		--Loads M[1] = 10
		command <= CMD_WD;					
      bus_address_in <= addr1;
      bus_data_in <= data1;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		--Loads M[2] = 2
		command <= CMD_WD;					
      bus_address_in <= addr2;
      bus_data_in <= data2;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		
		-- INSTR-1: LOAD DATA TO REGISTER
		-- Load R[1] = M[R[0]+1]
		command <= CMD_WI;					
      bus_address_in <= addr1;
      bus_data_in <= LOAD_1;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		
		-- INSTR-2: LOAD DATA TO REGISTER
		-- Load R[2] = M[R[0]+2]
		command <= CMD_WI;					
      bus_address_in <= addr2;
      bus_data_in <= LOAD_2;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		--nop for pipeline
		command <= CMD_WI;					
      bus_address_in <= addr3;
      bus_data_in <= nop;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		--nop for pipeline
		command <= CMD_WI;					
      bus_address_in <= addr4;
      bus_data_in <= nop;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		-- INSTR-3: ADD (R3 = R1 + R2)
		-- Should be 12
		command <= CMD_WI;					
      bus_address_in <= addr5;
      bus_data_in <= ADD;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		command <= CMD_WI;					
      bus_address_in <= addr6;
      bus_data_in <= nop;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		command <= CMD_WI;					
      bus_address_in <= addr7;
      bus_data_in <= nop;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		-- INSTR-4: STORE TO DMEM
		command <= CMD_WI;					
      bus_address_in <= addr8;
      bus_data_in <= SW;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;

		-- NOTHING		
		command <= CMD_WI;					
      bus_address_in <= addr9;
      bus_data_in <= BEQ;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		command <= CMD_WI;					
      bus_address_in <= addr10;
      bus_data_in <= nop;
      wait for clk_period*3;
      
      command <= CMD_IDLE;					
      bus_address_in <= zero;
      bus_data_in <= zero;
      wait for clk_period*3;
		
		command <= CMD_RUN;					
      bus_address_in <= zero;
      bus_data_in <= zero;
		wait for clk_period*100;

      wait;
   end process;

END;
