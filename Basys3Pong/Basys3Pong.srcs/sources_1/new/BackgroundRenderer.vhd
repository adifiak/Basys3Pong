----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 01:45:35 PM
-- Design Name: 
-- Module Name: BackgroundRenderer - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BackgroundRenderer is
    Generic (MapWidth : unsigned(9 downto 0) := TO_UNSIGNED(640, 10);
             MapHeight : unsigned(9 downto 0) := TO_UNSIGNED(480, 10));
    Port ( x : in STD_LOGIC_VECTOR (9 downto 0);
           y : in STD_LOGIC_VECTOR (9 downto 0);
           r : out STD_LOGIC_VECTOR (3 downto 0);
           g : out STD_LOGIC_VECTOR (3 downto 0);
           b : out STD_LOGIC_VECTOR (3 downto 0);
           rPassthrough : in STD_LOGIC_VECTOR (3 downto 0);
           gPassthrough : in STD_LOGIC_VECTOR (3 downto 0);
           bPassthrough : in STD_LOGIC_VECTOR (3 downto 0));
end BackgroundRenderer;

architecture Behavioral of BackgroundRenderer is

begin
    process begin
        if(unsigned(y) <2 or unsigned(y) >(MapHeight-2)) then
            r <= x"f";
            g <= x"f";
            b <= x"f";
        elsif(unsigned(x) = (MapWidth/2)) then
            if(y(2) = '1') then
                r <= x"f";
                g <= x"f";
                b <= x"f";
            else
                r <= "0000";
                g <= "0000";
                b <= "0000";
            end if;
        else
            r <= "0000";
            g <= "0000";
            b <= "0000";
        end if;
    end process;
end Behavioral;
