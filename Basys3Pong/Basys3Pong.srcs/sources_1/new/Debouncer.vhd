----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 05:22:07 PM
-- Design Name: 
-- Module Name: Debouncer - Behavioral
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

entity Debouncer is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btnIn : in STD_LOGIC;
           btnOut : out STD_LOGIC);
end Debouncer;

architecture Behavioral of Debouncer is
    signal maxCnt : integer := 7;
    signal cnt : integer := 0;
    signal outState : std_logic := '0';
begin
    
    process(clk, rst, btnIn) begin
        if(rst = '1') then
            cnt <= 0;
            outState <= btnIn;
        else
            if(rising_edge(clk)) then
                if(btnIn = outState) then
                    cnt <= 0;
                else
                    if(cnt < maxCnt) then
                        cnt <= cnt + 1;
                    else
                        outState <= btnIn;
                    end if;
                end if;
            end if;
        end if;
    end process;

    btnOut <= outState;
end Behavioral;
