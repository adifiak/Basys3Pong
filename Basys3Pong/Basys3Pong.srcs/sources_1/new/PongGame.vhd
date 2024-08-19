----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 11:17:13 AM
-- Design Name: 
-- Module Name: PongGame - Behavioral
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

entity PongGame is
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
end PongGame;

architecture Behavioral of PongGame is
    component PongInputProcessor is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               p1Up : in STD_LOGIC;
               p1Down : in STD_LOGIC;
               p2Up : in STD_LOGIC;
               p2Down : in STD_LOGIC;
               p1Move : out STD_LOGIC;
               p1UpNDown : out STD_LOGIC;
               p2Move : out STD_LOGIC;
               p2UpNDown : out STD_LOGIC);
    end component;

    component PongControler is
        Generic (BallSize : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
        
                 PaddleWidth : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
                 PaddleHeight : unsigned(9 downto 0) := TO_UNSIGNED(60, 10);
                 
                 MapWidth : unsigned(9 downto 0) := TO_UNSIGNED(640, 10);
                 MapHeight : unsigned(9 downto 0) := TO_UNSIGNED(480, 10));
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               p1Move : in STD_LOGIC;
               p1UpNDown : in STD_LOGIC;
               p2Move : in STD_LOGIC;
               p2UpNDown : in STD_LOGIC;
               bX : out STD_LOGIC_VECTOR (9 downto 0);
               bY : out STD_LOGIC_VECTOR (9 downto 0);
               p1En : out STD_LOGIC;
               p1Y : out STD_LOGIC_VECTOR (9 downto 0);
               p1Score : out STD_LOGIC_VECTOR (3 downto 0);
               p2En : out STD_LOGIC;
               p2Y : out STD_LOGIC_VECTOR (9 downto 0);
               p2Score : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    component PongRenderer is
        Generic (BallSize : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
        
                 PaddleWidth : unsigned(9 downto 0) := TO_UNSIGNED(5, 10);
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
    end component;
    
    signal p1Move, p2Move, p1En, p2En, p1UpNDown, p2UpNDown : STD_LOGIC;
    signal p1Score, p2Score : STD_LOGIC_VECTOR (3 downto 0);
    signal bX, bY, p1Y, p2Y : STD_LOGIC_VECTOR (9 downto 0);
begin
    ip : PongInputProcessor port map(clk => clk, rst => rst, p1Up => P1UP, p1Down => P1DOWN, p2Up => P2UP, p2Down => P2DOWN, p1Move => p1Move, p1UpNDown => p1UpNDown, p2Move => p2Move, p2UpNDown => p2UpNDown);
    
    pc : PongControler port map(clk => clk, rst => rst, p1Move => p1Move, p1UpNDown => p1UpNDown, p2Move => p2Move, p2UpNDown => p2UpNDown, bX => bX, bY => bY, p1En => p1En, p1Y => p1Y, p1Score => p1Score, p2En => p2En, p2Y => p2Y, p2Score => p2Score);
    
    pr : PongRenderer port map(bX => bX, bY => bY, p1En => p1En, p1Y => p1Y, p1Score => p1Score, p2En => p2En, p2Y => p2Y, p2Score => p2Score, imageX => X, imageY => Y, r => R, g => G, b => B);


end Behavioral;
