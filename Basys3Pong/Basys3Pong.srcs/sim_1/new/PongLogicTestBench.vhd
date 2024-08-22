----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/20/2024 05:20:42 PM
-- Design Name: 
-- Module Name: PongLogicTestBench - Behavioral
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

entity PongLogicTestBench is
--  Port ( );
end PongLogicTestBench;

architecture Behavioral of PongLogicTestBench is
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
    
    signal clk, rst : std_logic;
    signal bX, bY, p1Y, p2Y : STD_LOGIC_VECTOR (9 downto 0);
	constant t_clk : time := 20 ns;
    
begin

pc : PongControler port map(clk => clk, rst => rst, p1Move => '0', p1UpNDown => '0', p2Move => '0', p2UpNDown => '0', bX => bX, bY => bY, p1En => open, p1Y => p1Y, p1Score => open, p2En => open, p2Y => p2Y, p2Score => open);

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
