----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/15/2024 08:18:29 AM
-- Design Name: 
-- Module Name: VGAController - Behavioral
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

entity VGAController is
    Generic (ClkFactor : unsigned(3 downto 0) := to_unsigned(4, 4);
    
            ImageWidth : unsigned(9 downto 0) := to_unsigned(640, 10);
            ImageHeight : unsigned(9 downto 0) := to_unsigned(480, 10);
            
            HorizontalFrontPorch : unsigned(9 downto 0) := to_unsigned(16, 10);
            HorizontalBackPorch : unsigned(9 downto 0) := to_unsigned(48, 10);
            HorizontalSync : unsigned(9 downto 0) := to_unsigned(96, 10);
            
            VerticalFrontPorch : unsigned(9 downto 0) := to_unsigned(10, 10);
            VerticalBackPorch : unsigned(9 downto 0) := to_unsigned(33, 10);
            VerticalSync : unsigned(9 downto 0) := to_unsigned(2, 10));
    Port (clk, rst: in std_logic;
          x,y : out std_logic_vector(9 downto 0);
          red, blue, green : in std_logic_vector(3 downto 0);
          vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
          Hsync, Vsync : out std_logic);
end VGAController;

architecture Behavioral of VGAController is
    component Counter is
        Generic(N : integer := 10);
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               en  : in STD_LOGIC;
               max : in STD_LOGIC_VECTOR (N-1 downto 0);
               q   : out STD_LOGIC_VECTOR (N-1 downto 0);
               tc  : out std_logic);
    end component;
    
    signal onImage, vgaClk, Xtc  : std_logic;
    signal Xq, Yq : STD_LOGIC_VECTOR(9 downto 0);
begin
    clkDivider : Counter generic map(N => 4) port map(clk => clk, rst => rst, en => '1', max => std_logic_vector(ClkFactor - 1), q => open, tc => vgaClk);

    Xpos : Counter generic map(N => 10) port map(clk => clk, rst => rst, en => vgaClk, max => std_logic_vector(ImageWidth + HorizontalFrontPorch + HorizontalBackPorch + HorizontalSync - 1), q => Xq, tc => Xtc);
            
    Ypos : Counter generic map(N => 10) port map(clk => clk, rst => rst, en => Xtc, max => std_logic_vector(ImageHeight + VerticalFrontPorch + VerticalBackPorch + VerticalSync - 1), q => Yq, tc => open);
    
    onImage <= '1' when((unsigned(Xq) < ImageWidth) and (unsigned(Yq) < ImageHeight)) else '0';
    
    x <= Xq when(unsigned(Xq) < ImageWidth)  else std_logic_vector(ImageWidth-1);
    y <= Yq when(unsigned(Yq) < ImageHeight) else std_logic_vector(ImageHeight-1);
    
    Hsync <= '1' when((unsigned(Xq) >= (ImageWidth + HorizontalFrontPorch - 1)) and (unsigned(Xq) <= (ImageWidth + HorizontalFrontPorch + HorizontalSync - 1))) else '0';
    Vsync <= '1' when((unsigned(Yq) >= (ImageHeight + VerticalFrontPorch - 1))  and (unsigned(Yq) <= (ImageHeight + VerticalFrontPorch + VerticalSync - 1)))    else '0';

    vgaRed   <= red   when (onImage = '1') else "0000";
    vgaBlue  <= blue  when (onImage = '1') else "0000";
    vgaGreen <= green when (onImage = '1') else "0000";

end Behavioral;
