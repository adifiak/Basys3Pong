----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2024 11:11:37 AM
-- Design Name: 
-- Module Name: Counter - Behavioral
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
--use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter is
    Generic(N : integer := 8);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en  : in STD_LOGIC;
           max : in STD_LOGIC_VECTOR (N-1 downto 0);
           q   : out STD_LOGIC_VECTOR (N-1 downto 0);
           tc  : out std_logic);
end Counter;
    
architecture Behavioral of Counter is
    signal cnt : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
    signal terminalCount : std_logic;
begin
    process(rst, clk) begin
        if(rst = '1') then
            cnt <= (others => '0');
        elsif(rising_edge(clk)) then
            if(en = '1') then
                if(terminalCount = '1') then
                    cnt <= (others => '0');
                else
                    cnt <= std_logic_vector(unsigned(cnt) + x"1");
                end if;       
            end if;
        end if;
    end process;
    
    terminalCount <= '1' when ((cnt = max) and (en = '1')) else '0';
    
    tc <= terminalCount;
    q <= cnt;
end Behavioral;
