----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2024 05:22:07 PM
-- Design Name: 
-- Module Name: MovementInputTransformer - Behavioral
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

entity MovementInputTransformer is
    Port ( Up : in STD_LOGIC;
           Down : in STD_LOGIC;
           Move : out STD_LOGIC;
           UpNDown : out STD_LOGIC);
end MovementInputTransformer;

architecture Behavioral of MovementInputTransformer is

begin
    
    Move <= Up xor Down;
    UpNDown <= Up;

end Behavioral;
