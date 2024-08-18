----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2024 11:30:21 AM
-- Design Name: 
-- Module Name: CounterTestBench - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CounterTestBench is
--  Port ( );
end CounterTestBench;

architecture Behavioral of CounterTestBench is
    component Counter is
        Generic(N : integer := 4);
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               en  : in STD_LOGIC;
               max : in STD_LOGIC_VECTOR (N-1 downto 0);
               q   : out STD_LOGIC_VECTOR (N-1 downto 0);
               tc  : out std_logic);
    end component;
    
    -- Inputs
	signal clk  : std_logic := '0';
	signal rst  : std_logic := '0';
	signal en   : std_logic := '0';
	signal max  : std_logic_vector(3 downto 0) := x"c";
	-- Outputs
	signal q  : std_logic_vector(3 downto 0);
	signal tc : std_logic;
	--Constants
	constant t_clk : time := 20 ns;
begin
    cnt : Counter port map(
        clk => clk,
        rst => rst,
        en  => en,
        max => max,
        q   => q,
        tc  => tc);
        
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
		wait for 100 ns;
		en <= '1';
        wait for 100 ns;
		en <= '1';
		wait for 100 ns;
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
        wait;
	end process;


end Behavioral;
