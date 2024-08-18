----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2024 03:57:25 PM
-- Design Name: 
-- Module Name: VGAControllerTestBench - Behavioral
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

entity VGAControllerTestBench is
--  Port ( );
end VGAControllerTestBench;

architecture Behavioral of VGAControllerTestBench is
    component VGAController is
        Generic(ImageWidth : unsigned(9 downto 0) := to_unsigned(640, 10);
                ImageHeight : unsigned(9 downto 0) := to_unsigned(480, 10);
            
                HorizontalFrontPorch : unsigned(9 downto 0) := to_unsigned(16, 10);
                HorizontalBackPorch : unsigned(9 downto 0) := to_unsigned(48, 10);
                HorizontalSync : unsigned(9 downto 0) := to_unsigned(96, 10);
            
                VerticalFrontPorch : unsigned(9 downto 0) := to_unsigned(10, 10);
                VerticalBackPorch : unsigned(9 downto 0) := to_unsigned(33, 10);
                VerticalSync : unsigned(9 downto 0) := to_unsigned(2, 10));
                    
        Port (clk, rst : in std_logic;
              x,y : out std_logic_vector(9 downto 0);
              red, blue, green : in std_logic_vector(3 downto 0);
              vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
              Hsync, Vsync : out std_logic);
    end component;
    
    --Inputs
    signal clk, rst : std_logic;
    signal red, blue, green : std_logic_vector(3 downto 0) := x"f";
    --Outputs
    signal x,y : std_logic_vector(9 downto 0);
    signal vgaRed, vgaBlue, vgaGreen : std_logic_vector(3 downto 0);
    signal Hsync, Vsync : std_logic;
    --Constants
	constant t_clk : time := 20 ns;
begin
    vgac : VGAController
        port map(
            clk => clk,
            rst => rst,
            x => x,
            y => y,
            red => red,
            blue => blue,
            green => green,
            vgaRed => vgaRed,
            vgaBlue => vgaBlue,
            vgaGreen => vgaGreen,
            Hsync => Hsync,
            Vsync => Vsync);

    -- Clock definition.
	process begin
		clk <= '0';
		wait for t_clk / 2;
		clk <= '1';
		wait for t_clk / 2;
	end process;

	-- Processing.
	process begin
		rst <= '1'; -- Initial conditions.
		wait for 100 ns;
		rst <= '0'; -- Down to work!
        wait;
	end process;
end Behavioral;
