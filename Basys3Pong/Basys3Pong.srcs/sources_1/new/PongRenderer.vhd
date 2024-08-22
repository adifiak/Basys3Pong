----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 12:07:24 PM
-- Design Name: 
-- Module Name: PongRenderer - Behavioral
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

entity PongRenderer is
    Generic (BallSize : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
    
             PaddleWidth : unsigned(9 downto 0) := TO_UNSIGNED(10, 10);
             PaddleHeight : unsigned(9 downto 0) := TO_UNSIGNED(60, 10);
             
             MapWidth : unsigned(9 downto 0) := TO_UNSIGNED(640, 10);
             MapHeight : unsigned(9 downto 0) := TO_UNSIGNED(480, 10));
    Port ( bX : in STD_LOGIC_VECTOR (9 downto 0);
           bY : in STD_LOGIC_VECTOR (9 downto 0);
           p1En : in STD_LOGIC;
           p1Y : in STD_LOGIC_VECTOR (9 downto 0);
           p1Score : in STD_LOGIC_VECTOR (3 downto 0);
           p2En : in STD_LOGIC;
           p2Y : in STD_LOGIC_VECTOR (9 downto 0);
           p2Score : in STD_LOGIC_VECTOR (3 downto 0);
           imageX : in STD_LOGIC_VECTOR (9 downto 0);
           imageY : in STD_LOGIC_VECTOR (9 downto 0);
           r : out STD_LOGIC_VECTOR (3 downto 0);
           g : out STD_LOGIC_VECTOR (3 downto 0);
           b : out STD_LOGIC_VECTOR (3 downto 0));
end PongRenderer;

architecture Behavioral of PongRenderer is
    component PaddleRenderer is
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
    end component;
    
    component BallRenderer is
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
    end component;
    
    component BackgroundRenderer is
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
    end component;
    
    signal rBgToBall, gBgToBall, bBgToBall, rBallToPaddle, gBallToPaddle, bBallToPaddle : STD_LOGIC_VECTOR (3 downto 0);
begin
    pr : PaddleRenderer port map(p1y => p1Y, p2y => p2Y, p1en => p1En, p2en => p2En, x => imageX, y => imageY, r => r, g => g, b => b, rPassthrough => rBallToPaddle, gPassthrough => gBallToPaddle, bPassthrough => bBallToPaddle);
    
    br : BallRenderer port map(bx => bX, by => bY, x => imageX, y => imageY, r => rBallToPaddle, g => gBallToPaddle, b => bBallToPaddle, rPassthrough => rBgToBall, gPassthrough => gBgToBall, bPassthrough => bBgToBall);
    
    bgr: BackgroundRenderer port map(x => imageX, y => imageY, r => rBgToBall, g => gBgToBall, b => bBgToBall, rPassthrough => "0000", gPassthrough => "0000", bPassthrough => "0000");

end Behavioral;
