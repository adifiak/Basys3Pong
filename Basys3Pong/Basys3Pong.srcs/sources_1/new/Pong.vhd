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
           vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
           Hsync, Vsync : out std_logic);
end Pong;

architecture Behavioral of Pong is
    component ClockDivider is
        Generic(scale : integer := 4);                
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_out : out STD_LOGIC);
    end component;

    component VGAController is            
        Port (clk, rst, pixelClk : in std_logic;
              x,y : out std_logic_vector(9 downto 0);
              red, blue, green : in std_logic_vector(3 downto 0);
              vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
              Hsync, Vsync : out std_logic);
    end component;
    
    signal r,g,b : std_logic_vector(3 downto 0);
    signal x,y : std_logic_vector(9 downto 0);
    signal vgaClk : std_logic;
begin
    cd : ClockDivider
        port map(
        clk => clk,
        rst => '0',
        clk_out => vgaClk);

    vgac : VGAController
        port map(
            clk => clk,
            pixelClk => vgaClk,
            rst => '0',
            x => x,
            y => y,
            red => r,
            blue => b,
            green => g,
            vgaRed => vgaRed,
            vgaBlue => vgaBlue,
            vgaGreen => vgaGreen,
            Hsync => Hsync,
            Vsync => Vsync);
            
    r <= x"f" when(unsigned(x) < 320) else x"0";
    g <= x"f" when(unsigned(y) < 240) else x"0";
    b <= x"f" when(unsigned(y) >= 240 and unsigned(x) >= 320) else x"0";

end Behavioral;
