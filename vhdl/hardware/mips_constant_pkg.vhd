-- Package File Template
--
-- Purpose: This package defines supplemental types, subtypes, 
-- constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package MIPS_CONSTANT_PKG is

    -- BUS CONSTANTS
    constant IADDR_BUS          : integer := 32;
    constant IDATA_BUS          : integer := 32;
    constant DADDR_BUS          : integer := 32;
    constant DDATA_BUS          : integer := 32;
    constant RADDR_BUS          : integer := 5;

    constant MEM_ADDR_COUNT     : integer := 8;

    constant ZERO1b             : STD_LOGIC                             := '0';
    constant ONE1b              : STD_LOGIC                             := '1';
    constant ZERO32b            : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
    constant ZERO16b            : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    constant ONE32b             : STD_LOGIC_VECTOR(31 downto 0) := "11111111111111111111111111111111"; 
    constant ONE16b             : STD_LOGIC_VECTOR(15 downto 0) := "1111111111111111"; 
    
    -- Instructon OP Codes
    constant OP_R               : STD_LOGIC_VECTOR(5 downto 0) := "000000";
    constant OP_J               : STD_LOGIC_VECTOR(5 downto 0) := "000010";

    constant OP_I_LOAD          : STD_LOGIC_VECTOR(5 downto 0) := "100011"; -- 23 (LOAD WORD) / 35
    constant OP_I_STORE         : STD_LOGIC_VECTOR(5 downto 0) := "101011"; -- 2B (STORE WORD) / 43
    constant OP_I_LI            : STD_LOGIC_VECTOR(5 downto 0) := "001111"; -- (UNKNOWN) F / 15
    constant OP_I_BEQ           : STD_LOGIC_VECTOR(5 downto 0) := "000100"; -- I-branch
    constant OP_I_NOP           : STD_LOGIC_VECTOR(5 downto 0) := "111111"; -- No Operation
    
    -- ALU OP Codes
    constant ALU_OP_LS          : STD_LOGIC_VECTOR(1 downto 0) := "00"; -- Load & Store
    constant ALU_OP_BEQ         : STD_LOGIC_VECTOR(1 downto 0) := "01"; -- Branch on equal
    constant ALU_OP_R           : STD_LOGIC_VECTOR(1 downto 0) := "10"; -- R funct
    
    -- ALU Functions
    constant ALU_FN_ADD         : STD_LOGIC_VECTOR(5 downto 0) := "100000";
    constant ALU_FN_SUB         : STD_LOGIC_VECTOR(5 downto 0) := "100010";
    constant ALU_FN_AND         : STD_LOGIC_VECTOR(5 downto 0) := "100100";
    constant ALU_FN_OR          : STD_LOGIC_VECTOR(5 downto 0) := "100101";
    constant ALU_FN_SLT         : STD_LOGIC_VECTOR(5 downto 0) := "101010";
    
    -- RECORDS
    type ALU_OP_INPUT is
    record
        Op0         : STD_LOGIC;
        Op1         : STD_LOGIC;
        Op2         : STD_LOGIC;
    end record;

    type ALU_INPUT is
    record
        Op0         : STD_LOGIC;
        Op1         : STD_LOGIC;
        Op2     : STD_LOGIC;
        Op3         : STD_LOGIC;
    end record;

    type ALU_FLAGS is
    record
        Carry   : STD_LOGIC;
        Overflow : STD_LOGIC;
        Zero        : STD_LOGIC;
        Negative : STD_LOGIC;
    end record;
     
    -- PROCESSOR STATE
    type state_type is (FETCH, EXEC, STALL);
     
end MIPS_CONSTANT_PKG;
