--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:05:29 09/27/2012
-- Design Name:   
-- Module Name:   C:/Users/hanskrfl/Desktop/assignment1SimpleProc_new/testbenches/tb_register_file.vhd
-- Project Name:  assignment1SimpleProc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
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
 
ENTITY tb_register_file IS
END tb_register_file;
 
ARCHITECTURE behavior OF tb_register_file IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         CLK : IN  std_logic;
         RESET : IN  std_logic;
         RW : IN  std_logic;
         RS_ADDR : IN  std_logic_vector(4 downto 0);
         RT_ADDR : IN  std_logic_vector(4 downto 0);
         RD_ADDR : IN  std_logic_vector(4 downto 0);
         WRITE_DATA : IN  std_logic_vector(31 downto 0);
         RS : OUT  std_logic_vector(31 downto 0);
         RT : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal RW : std_logic := '0';
   signal RS_ADDR : std_logic_vector(4 downto 0) := (others => '0');
   signal RT_ADDR : std_logic_vector(4 downto 0) := (others => '0');
   signal RD_ADDR : std_logic_vector(4 downto 0) := (others => '0');
   signal WRITE_DATA : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal RS : std_logic_vector(31 downto 0);
   signal RT : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          CLK => CLK,
          RESET => RESET,
          RW => RW,
          RS_ADDR => RS_ADDR,
          RT_ADDR => RT_ADDR,
          RD_ADDR => RD_ADDR,
          WRITE_DATA => WRITE_DATA,
          RS => RS,
          RT => RT
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here
		
		-- INSERT DATA TO REGISTER 1
		RW 			<= '1';
		RS_ADDR 		<= (others => '0');
		RT_ADDR		<= (others => '0');
		RD_ADDR		<= "00001";
		WRITE_DATA 	<= (others => '1');
		
		wait for CLK_period*10;
		
		-- READ DATA FROM REGISTER 1
		RW 			<= '0';
		RS_ADDR 		<= "00001";
		RT_ADDR		<= "00001";
		RD_ADDR		<= (others => '0');
		WRITE_DATA 	<= (others => '0');
		
      wait;
   end process;

END;
