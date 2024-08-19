----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 01:48:47 PM
-- Design Name: 
-- Module Name: PaddleRenderer - Behavioral
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

entity PaddleRenderer is
    Generic (PaddleWidth : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
             PaddleHeight : unsigned(9 downto 0) := TO_UNSIGNED(60, 10);
             
             MapWidth : unsigned(9 downto 0) := TO_UNSIGNED(640, 10);
             MapHeight : unsigned(9 downto 0) := TO_UNSIGNED(480, 10));
    Port ( p1y : in STD_LOGIC_VECTOR (9 downto 0);
           p2y : in STD_LOGIC_VECTOR (9 downto 0);
           p1en : in STD_LOGIC;
           p2en : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (9 downto 0);
           y : in STD_LOGIC_VECTOR (9 downto 0);
           r : out STD_LOGIC_VECTOR (3 downto 0);
           g : out STD_LOGIC_VECTOR (3 downto 0);
           b : out STD_LOGIC_VECTOR (3 downto 0);
           rPassthrough : in STD_LOGIC_VECTOR (3 downto 0);
           gPassthrough : in STD_LOGIC_VECTOR (3 downto 0);
           bPassthrough : in STD_LOGIC_VECTOR (3 downto 0));
end PaddleRenderer;

architecture Behavioral of PaddleRenderer is

begin
    process begin
        if(unsigned(x) >= PaddleWidth and (unsigned(x) < 2*PaddleWidth)) then --Left paddle
            if(unsigned(y) >= (unsigned(p1y) - PaddleHeight/2) and unsigned(y) < (unsigned(p1y) + PaddleHeight/2)) then
                r <= x"f";
                g <= x"f";
                b <= x"f";
            else
                r <= rPassthrough;
                g <= gPassthrough;
                b <= bPassthrough;
            end if;
        elsif(unsigned(x) >= (MapWidth - 2*PaddleWidth) and unsigned(x) < (MapWidth - PaddleWidth)) then -- Right paddle
            if(unsigned(y) >= (unsigned(p2y) - PaddleHeight/2) and unsigned(y) < (unsigned(p2y) + PaddleHeight/2)) then
                r <= x"f";
                g <= x"f";
                b <= x"f";
            else
                r <= rPassthrough;
                g <= gPassthrough;
                b <= bPassthrough;
            end if;
        else
            r <= rPassthrough;
            g <= gPassthrough;
            b <= bPassthrough;
        end if;
    end process;

end Behavioral;
