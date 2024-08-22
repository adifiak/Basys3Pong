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
    
             PaddleWidth : unsigned(9 downto 0) := TO_UNSIGNED(10, 10);
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
    
    type pongState is (Init, WaitForStart, ResetBall, Play, EndGame);

    signal state, nextstate : pongState := Init;

    signal bYVelUp, bXVelRight : std_logic := '1';
    signal wallCollision, paddleTopCollision, paddleCenterCollision, paddleBottomCollision, goalL, goalR : std_logic;
    signal p1YPos, p2YPos, bXPos, bYPos : unsigned(9 downto 0) := TO_UNSIGNED(240, 10);
    signal bXVel, bYVel : unsigned(9 downto 0) := TO_UNSIGNED(0, 10);
    signal ballReset, p1Moved, p2Moved : std_logic := '0';


    signal moveClk : std_logic;
begin
    clkDivider : Counter generic map(N => 20) port map(clk => clk, rst => rst, en => '1', max => std_logic_vector(to_unsigned(1000000, 20)), q => open, tc => moveClk); --1000000

    process(clk, rst) begin
        if(rst = '1') then
            state <= Init;
        elsif(rising_edge(clk)) then
            UpdateState : state <= nextState;
            
            if(state = Init) then
                p1Moved <= '0';
                p2Moved <= '0';
                p1YPos <= MapHeight/2;
                p2YPos <= MapHeight/2;
                bXPos <= MapWidth/2;
                bYPos <= MapHeight/2;
                bYVelUp <= '0';
                bXVel <= to_unsigned(0, 10);
                bYVel <= to_unsigned(0, 10);
            else
                MoveObjects : if(moveClk = '1') then
                    MovePaddle1 : if(p1Move = '1') then
                        p1Moved <= '1';
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
                        p2Moved <= '1';
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
                    
                    MoveBall : if(state = Play) then
                        ballReset <= '0';
                        
                        if(wallCollision = '1') then
                            bYVelUp <= not bYVelUp;
                            
                            if(bYPos < (MapHeight / 2)) then
                                bYPos <= 3 + BallSize;
                            else
                                bYPos <= MapHeight - BallSize - 3;
                            end if;
                            
                            if(paddleTopCollision = '1' or paddleBottomCollision = '1') then
                                if(bXPos < (MapWidth / 2)) then
                                    bXVelRight <= '1';
                                    bXPos <= to_unsigned(40,10);--(PaddleWidth + PaddleWidth) + BallSize + 1;--Temp fix for double sized ports from multiplication (More of this later on...)
                                else
                                    bXVelRight <= '0';
                                    bXPos <= to_unsigned(600,10);--MapWidth - (PaddleWidth + PaddleWidth) - BallSize - 1;
                                end if;                   
                            end if;  
                        else
                            if((paddleTopCollision = '1') or (paddleCenterCollision = '1') or (paddleBottomCollision = '1')) then
                                if(bXPos <= MapWidth / 2) then
                                    bXVelRight <= '1';
                                    bXPos <= (PaddleWidth + PaddleWidth) + BallSize + 1;
                                else
                                    bXVelRight <= '0';
                                    bXPos <= MapWidth - (PaddleWidth + PaddleWidth) - BallSize - 1;
                                end if;
                                
                                if(paddleTopCollision = '1') then
                                    bXVel <= to_unsigned(3, 10);
                                    bYVel <= to_unsigned(2, 10);
                                    bYVelUp <= '1';
                                elsif(paddleCenterCollision = '1') then
                                    bXVel <= to_unsigned(5, 10);
                                    bYVel <= to_unsigned(0, 10);
                                elsif(paddleBottomCollision = '1') then
                                    bXVel <= to_unsigned(3, 10);
                                    bYVel <= to_unsigned(2, 10);
                                    bYVelUp <= '0';
                                end if;
                            else
                                if(bXVelRight = '1') then
                                    bXPos <= bXPos + bXVel;
                                else
                                    bXPos <= bXPos - bXVel;
                                end if;
                                
                                if(bYVelUp = '1') then
                                    bYPos <= bYPos - bYVel;
                                else
                                    bYPos <= bYPos + bYVel;
                                end if;
                            end if;
                        end if;                   
                    elsif(state = ResetBall) then
                        ballReset <= '1';
                        bXVelRight <= not bXVelRight;
                        bXPos <= MapWidth/2;
                        bYPos <= MapHeight/2;
                        bYVelUp <= '0';
                        bXVel <= to_unsigned(5, 10);
                        bYVel <= to_unsigned(0, 10);
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    process(goalL, goalR, state, ballReset, p1Moved, p2Moved) begin
        case state is
            when Init => 
                nextState <= WaitForStart;
                
            when WaitForStart =>
                if(p1Moved = '1' and p1Moved = '1')then
                    nextState <= ResetBall;
                else
                    nextState <= WaitForStart;
                end if;              
            when ResetBall =>
                if(ballReset = '1') then
                    nextState <= Play;
                else
                    nextState <= ResetBall;
                end if;
            when Play =>
                if(goalL = '1') then
                    nextState <= ResetBall;
                elsif(goalR = '1') then
                    nextState <= ResetBall;
                else
                    nextState <= Play;
                end if;
            when EndGame =>
                nextState <= Init;
                
        end case;
    end process;
    
    process(p1YPos, p2YPos, bXPos, bYPos) begin
        if(bXPos <= 2 * PaddleWidth + BallSize) then --Left
            if(bYPos <= p1YPos) then
                if(p1YPos - bYPos <= (PaddleHeight / 6)) then
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '1';
                    paddleBottomCollision <= '0';
                elsif(p1YPos - bYPos <= (PaddleHeight / 2) + BallSize) then
                    paddleTopCollision <= '1';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '0';
                else
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '0';
                end if;
            else
                if(bYPos - p1YPos <= (PaddleHeight / 6)) then
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '1';
                    paddleBottomCollision <= '0';
                elsif(bYPos - p1YPos <= (PaddleHeight / 2) + BallSize) then
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '1';
                else
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '0';
                end if;
            end if;
        elsif(bXPos >= (MapWidth - (PaddleWidth * 2) - BallSize)) then --Right
            if(bYPos <= p2YPos) then
                if(p2YPos - bYPos <= (PaddleHeight / 6)) then
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '1';
                    paddleBottomCollision <= '0';
                elsif(p2YPos - bYPos <= (PaddleHeight / 2) + BallSize) then
                    paddleTopCollision <= '1';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '0';
                else
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '0';
                end if;
            else
                if(bYPos - p2YPos <= (PaddleHeight / 6)) then
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '1';
                    paddleBottomCollision <= '0';
                elsif(bYPos - p2YPos <= (PaddleHeight / 2) + BallSize) then
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '1';
                else
                    paddleTopCollision <= '0';
                    paddleCenterCollision <= '0';
                    paddleBottomCollision <= '0';
                end if;
            end if;
        else
            paddleTopCollision <= '0';
            paddleCenterCollision <= '0';
            paddleBottomCollision <= '0';
        end if;
    end process;
    
    wallCollision <= '1' when((bYVelUp = '1' and (bYPos <= (BallSize + 2))) or (bYVelUp = '0' and (bYPos >= (MapHeight - BallSize - 2)))) else '0';
    goalL <= '1' when(bXPos <= BallSize + 1) else '0';
    goalR <= '1' when(bXPos >= (MapWidth - BallSize - 1)) else '0';

    
    bX      <= std_logic_vector(bXPos);
    bY      <= std_logic_vector(bYPos);
    p1En    <= p1Moved;
    p1Y     <= std_logic_vector(p1YPos);
    p1Score <= x"0";
    p2En    <= p2Moved;
    p2Y     <= std_logic_vector(p2YPos);
    p2Score <= x"0";

end Behavioral;
