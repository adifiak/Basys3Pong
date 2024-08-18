----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/16/2024 07:24:19 PM
-- Design Name: 
-- Module Name: ClockDividerTestBench - Behavioral
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

entity ClockDividerTestBench is
--  Port ( );
end ClockDividerTestBench;

architecture Behavioral of ClockDividerTestBench is
    component ClockDivider is
        Generic(scale : integer := 4);
                
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_out : out STD_LOGIC);
    end component;
    
    -- Inputs
	signal clk  : std_logic := '0';
	signal rst   : std_logic := '0';
	-- Outputs
	signal clk_out : std_logic;
	--Constants
	constant t_clk : time := 20 ns;
begin

    cd: ClockDivider port map(
        clk => clk,
        rst => rst,
        clk_out => clk_out
    );

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
