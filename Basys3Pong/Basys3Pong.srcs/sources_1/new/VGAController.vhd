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
    Generic(ImageWidth : unsigned(9 downto 0) := to_unsigned(640, 10);
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

    type VGAState is (TopPadding, LeftPadding, Image, RightPadding, BottomPadding);
    
    signal state, nextState : VGAState := TopPadding;
    signal paddingXtc, paddingYtc, imageXtc, imageYtc : STD_LOGIC;
    signal paddingXen, paddingYen, imageXen, imageYen : STD_LOGIC;
    signal paddingXq, paddingYq, paddingXmax, paddingYmax, imageXmax, imageYmax : STD_LOGIC_VECTOR(9 downto 0);
begin
    paddingX : Counter
        generic map(
            N => 10)
        port map(
            clk => clk,
            rst => rst,
            en  => paddingXen,
            max => paddingXmax,
            q   => paddingXq,
            tc  => paddingXtc);
            
    paddingY : Counter
        generic map(
            N => 10)
        port map(
            clk => clk,
            rst => rst,
            en  => paddingYen,
            max => paddingYmax,
            q   => paddingYq,
            tc  => paddingYtc);
            
    imageX : Counter
        generic map(
            N => 10)
        port map(
            clk => clk,
            rst => rst,
            en  => imageXen,
            max => imageXmax,
            q   => x,
            tc  => imageXtc);
            
    imageY : Counter
        generic map(
            N => 10)
        port map(
            clk => clk,
            rst => rst,
            en  => imageYen,
            max => imageYmax,
            q   => y,
            tc  => imageYtc);

    StateLogic : process(clk, rst) begin
        --State Logic
        if(rst='1') then
            state <= TopPadding;
        elsif(rising_edge(clk)) then
            state <= nextState;
        end if;        
    end process;
    
    TerminalCountLogic : process(state) begin
        case state is
            when TopPadding     =>
                paddingXmax <= std_logic_vector(HorizontalSync + HorizontalBackPorch + ImageWidth + HorizontalFrontPorch);
                paddingYmax <= std_logic_vector(VerticalSync + VerticalBackPorch);
            when LeftPadding    =>
                paddingXmax <= std_logic_vector(HorizontalSync + HorizontalBackPorch);
                paddingYmax <= std_logic_vector(ImageHeight);
            when Image          =>
                paddingXmax <= std_logic_vector(ImageWidth);
                paddingYmax <= std_logic_vector(ImageHeight);
            when RightPadding   =>
                paddingXmax <= std_logic_vector(HorizontalFrontPorch);
                paddingYmax <= std_logic_vector(ImageHeight);
            when BottomPadding  =>
                paddingXmax <= std_logic_vector(HorizontalSync + HorizontalBackPorch + ImageWidth + HorizontalFrontPorch);
                paddingYmax <= std_logic_vector(VerticalFrontPorch);
        end case;
    end process;
    imageXmax <= std_logic_vector(ImageWidth);
    imageYmax <= std_logic_vector(ImageHeight);
    
    NextStateLogic : process(state, paddingXtc, paddingYtc,  imageXtc, imageYtc) begin
        case state is
            when TopPadding     =>
                if(paddingYtc = '1') then
                    nextState <= LeftPadding;
                else
                    nextState <= TopPadding;
                end if;
            when LeftPadding    =>
                if(paddingXtc = '1') then
                    nextState <= Image;
                else
                    nextState <= LeftPadding;
                end if;
            when Image          =>
                if(imageXtc = '1') then
                    nextState <= RightPadding;
                else
                    nextState <= Image;
                end if;
            when RightPadding   =>
                if(paddingXtc = '1') then
                    if(imageYtc = '1') then
                        nextState <= BottomPadding;
                    else
                        nextState <= LeftPadding;
                    end if;
                else
                    nextState <= RightPadding;
                end if;
            when BottomPadding  =>
                if(paddingYtc = '1') then
                    nextState <= TopPadding;
                else
                    nextState <= BottomPadding;
                end if;
        end case;
    end process;
    
    paddingYen <= '1' when((paddingXtc = '1') and ((state = TopPadding) or (state = BottomPadding))) else '0';
    paddingXen <= '1' when((state = TopPadding) or (state = BottomPadding) or (state = RightPadding) or (state = LeftPadding)) else '0';
    imageXen   <= '1' when(state = Image) else '0';
    imageYen   <= '1' when((paddingXtc = '1') and (state = RightPadding)) else '0';
    
    Hsync <= '1' when((unsigned(paddingXq) <= HorizontalSync) and ((state = TopPadding) or (state = BottomPadding) or (state = LeftPadding))) else '0';
    Vsync <= '1' when((unsigned(paddingYq) <=   VerticalSync) and (state = TopPadding)) else '0';

    vgaRed   <= red   when (state=Image) else "0000";
    vgaBlue  <= blue  when (state=Image) else "0000";
    vgaGreen <= green when (state=Image) else "0000";

end Behavioral;
