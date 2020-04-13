----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.04.2020 16:25:32
-- Design Name: 
-- Module Name: wallclock_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wallclock_tb is
--  Port ( );
end wallclock_tb;

architecture Behavioral of wallclock_tb is
    component WallClock
        port ( CLK100MHZ : in STD_LOGIC;
               RESET_BTN : in STD_LOGIC;
               INC_MIN : in STD_LOGIC;
               INC_HOUR : in STD_LOGIC;
               pwm_in : in STD_LOGIC_VECTOR (7 downto 0);
               
               LED : out STD_LOGIC_VECTOR (5 downto 0);
               SevenSegment : out STD_LOGIC_VECTOR (7 downto 0);
               SegmentDrivers : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
begin


end Behavioral;
