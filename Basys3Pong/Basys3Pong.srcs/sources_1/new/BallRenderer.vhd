----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 01:48:47 PM
-- Design Name: 
-- Module Name: BallRenderer - Behavioral
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

entity BallRenderer is
    Generic (BallSize : unsigned(9 downto 0) := TO_UNSIGNED(5, 10));
    Port ( bx : in STD_LOGIC_VECTOR (9 downto 0);
           by : in STD_LOGIC_VECTOR (9 downto 0);
           x : in STD_LOGIC_VECTOR (9 downto 0);
           y : in STD_LOGIC_VECTOR (9 downto 0);
           r : out STD_LOGIC_VECTOR (3 downto 0);
           g : out STD_LOGIC_VECTOR (3 downto 0);
           b : out STD_LOGIC_VECTOR (3 downto 0);
           rPassthrough : in STD_LOGIC_VECTOR (3 downto 0);
           gPassthrough : in STD_LOGIC_VECTOR (3 downto 0);
           bPassthrough : in STD_LOGIC_VECTOR (3 downto 0));
end BallRenderer;

architecture Behavioral of BallRenderer is

begin
    process begin
        if(unsigned(x) >= unsigned(bx) - BallSize and unsigned(x) < unsigned(bx) + BallSize and unsigned(y) >= unsigned(by) - BallSize and unsigned(y) < unsigned(by) + BallSize) then
            r <= x"f";
            g <= x"f";
            b <= x"f";
        else
            r <= rPassthrough;
            g <= rPassthrough;
            b <= rPassthrough;
        end if;
    end process;
end Behavioral;
