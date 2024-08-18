----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/15/2024 08:07:37 AM
-- Design Name: 
-- Module Name: ClockDivider - Behavioral
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

entity ClockDivider is
    Generic(scale : integer := 4);
            
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end ClockDivider;

architecture Behavioral of ClockDivider is
signal cnt: integer:=1;
signal outState : std_logic := '0'; 
begin
    process(clk,rst) begin
        if(rst='1') then
            cnt<=1;
            outState<='0';
        elsif(rising_edge(clk)) then
            if (cnt = scale / 2) then
                outState <= not outState;
                cnt <= 1;
            else
                cnt <=cnt+1;
            end if;
        end if;
    end process;
    clk_out <= outState;
end Behavioral;
