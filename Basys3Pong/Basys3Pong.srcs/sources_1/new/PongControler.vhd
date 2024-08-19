----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 12:07:24 PM
-- Design Name: 
-- Module Name: PongControler - Behavioral
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

entity PongControler is
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
end PongControler;

architecture Behavioral of PongControler is
    component Counter is
        Generic(N : integer := 10);
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               en  : in STD_LOGIC;
               max : in STD_LOGIC_VECTOR (N-1 downto 0);
               q   : out STD_LOGIC_VECTOR (N-1 downto 0);
               tc  : out std_logic);
    end component;

    signal p1YPos, p2YPos : unsigned(9 downto 0) := TO_UNSIGNED(240, 10);
    signal moveClk : std_logic;
begin
    clkDivider : Counter generic map(N => 20) port map(clk => clk, rst => rst, en => '1', max => std_logic_vector(to_unsigned(1000000, 20)), q => open, tc => moveClk);

    process(clk, rst) begin
        if(rst = '1') then
            p1YPos <= MapHeight/2;
            p2YPos <= MapHeight/2;
        elsif(rising_edge(clk)) then
            if(moveClk = '1') then
                MovePaddle1 : if(p1Move = '1') then
                    if(p1UpNDown = '1')then
                        if(p1YPos > (5 + (PaddleHeight/2)))then
                            p1YPos <= p1YPos - 5;
                        end if;
                    else
                        if(p1YPos < (MapHeight - 5 - (PaddleHeight/2)))then
                            p1YPos <= p1YPos + 5;
                        end if;
                    end if;
                end if;
                
                MovePaddle2 : if(p2Move = '1') then
                    if(p2UpNDown = '1')then
                        if(p2YPos > (5 + (PaddleHeight/2)))then
                            p2YPos <= p2YPos - 5;
                        end if;
                    else
                        if(p2YPos < (MapHeight - 5 - (PaddleHeight/2)))then
                            p2YPos <= p2YPos + 5;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    bX      <= std_logic_vector(MapWidth/2);
    bY      <= std_logic_vector(MapHeight/2);
    p1En    <= '1';
    p1Y     <= std_logic_vector(p1YPos);
    p1Score <= x"0";
    p2En    <= '1';
    p2Y     <= std_logic_vector(p2YPos);
    p2Score <= x"0";

end Behavioral;
