----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 12:07:24 PM
-- Design Name: 
-- Module Name: PongInputProcessor - Behavioral
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

entity PongInputProcessor is
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
end PongInputProcessor;

architecture Behavioral of PongInputProcessor is
    component Debouncer is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               btnIn : in STD_LOGIC;
               btnOut : out STD_LOGIC);
    end component;
    
    component MovementInputTransformer is
    Port ( Up : in STD_LOGIC;
           Down : in STD_LOGIC;
           Move : out STD_LOGIC;
           UpNDown : out STD_LOGIC);
end component;

signal p1UpProcessed, p2UpProcessed, p1DownProcessed, p2DownProcessed : STD_LOGIC;
begin
    p1u : Debouncer port map(
          clk => clk,
          rst => rst,
          btnIn => p1Up,
          btnOut => p1UpProcessed);
          
    p1d : Debouncer port map(
          clk => clk,
          rst => rst,
          btnIn => p1Down,
          btnOut => p1DownProcessed);
          
    p2u : Debouncer port map(
          clk => clk,
          rst => rst,
          btnIn => p2Up,
          btnOut => p2UpProcessed);
          
    p2d : Debouncer port map(
          clk => clk,
          rst => rst,
          btnIn => p2Down,
          btnOut => p2DownProcessed);
          
    p1mt : MovementInputTransformer port map(
          Up => p1UpProcessed,
          Down => p1DownProcessed,
          Move => p1Move,
          UpNDown => p1UpNDown);
          
    p2mt : MovementInputTransformer port map(
          Up => p2UpProcessed,
          Down => p2DownProcessed,
          Move => p2Move,
          UpNDown => p2UpNDown);
          
end Behavioral;
