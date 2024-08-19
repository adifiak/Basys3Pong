----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2024 10:15:04 AM
-- Design Name: 
-- Module Name: Pong - Behavioral
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

entity Pong is
    Port ( clk : in std_logic;
           btnC, btnU, btnD, btnL, btnR : in std_logic;
           vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
           Hsync, Vsync : out std_logic);
end Pong;

architecture Behavioral of Pong is
    component PongGame is
        Generic (BallSize : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
        
                 PaddleWidth : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
                 PaddleHeight : unsigned(9 downto 0) := TO_UNSIGNED(60, 10);
                 
                 MapWidth : unsigned(9 downto 0) := TO_UNSIGNED(640, 10);
                 MapHeight : unsigned(9 downto 0) := TO_UNSIGNED(480, 10));
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               P1UP : in STD_LOGIC;
               P1DOWN : in STD_LOGIC;
               P2UP : in STD_LOGIC;
               P2DOWN : in STD_LOGIC;
               X : in STD_LOGIC_VECTOR (9 downto 0);
               Y : in STD_LOGIC_VECTOR (9 downto 0);
               R : out STD_LOGIC_VECTOR (3 downto 0);
               G : out STD_LOGIC_VECTOR (3 downto 0);
               B : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component VGAController is            
        Port (clk, rst : in std_logic;
              x,y : out std_logic_vector(9 downto 0);
              red, blue, green : in std_logic_vector(3 downto 0);
              vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
              Hsync, Vsync : out std_logic);
    end component;
    
    signal r,g,b : std_logic_vector(3 downto 0);
    signal x,y : std_logic_vector(9 downto 0);
begin
    vgac : VGAController
        port map(clk => clk, rst => btnC, x => x, y => y, red => r, blue => b, green => g, vgaRed => vgaRed, vgaBlue => vgaBlue, vgaGreen => vgaGreen, Hsync => Hsync, Vsync => Vsync);
        
    pg : PongGame port map( clk => clk, rst => btnC, P1UP => btnL, P1DOWN => btnD, P2UP => btnU, P2DOWN => btnR, X => x, Y => y, R => r, G => g, B => b);
            
    --r <= x"f" when(unsigned(x) < 320) else x"0";
    --g <= x"f" when(unsigned(y) < 240) else x"0";
    --b <= x"f" when(unsigned(y) >= 240 and unsigned(x) >= 320) else x"0";

end Behavioral;
