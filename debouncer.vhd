--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.Numeric_STD.all;

--entity debouncer is
--    Port ( 
--        Clk :   in STD_LOGIC;
--        tick:   in STD_LOGIC;
--        wejscie: in STD_LOGIC;
--        wyjscie :  out STD_LOGIC
--    );
--end debouncer;

--architecture Behavioral of debouncer is
--    signal inputSig: std_logic_vector(1 downto 0):="00";

--begin
--    debouncing: process(Clk) is
--	begin
--		if(rising_edge(Clk)) then 
--		      inputSig(1)<=inputSig(0);
--		      if(tick='1') then
--		         inputSig(0)<=wejscie;
--		      end if;
--		      wyjscie<=inputSig(0) and inputSig(1);
--		end if;
--	end process;		          
	
--end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debouncer is
    port(   clk : in std_logic;
            wejscie : in std_logic;
            wyjscie : out std_logic
        );
end debouncer;

architecture behav of debouncer is

--the below constants decide the working parameters.
--the higher this is, the more longer time the user has to press the button.
constant COUNT_MAX : integer := 30000000; 
--set it '1' if the button creates a high pulse when its pressed, otherwise '0'.
constant BTN_ACTIVE : std_logic := '1';

signal count : integer := 0;
type state_type is (idle,wait_time); --state machine
signal state : state_type := idle;

begin
  
process(clk)
begin
    --if(Reset = '1') then
        --state <= idle;
--        pulse_out <= '0';
   if(rising_edge(clk)) then
        case (state) is
            when idle =>
                if(wejscie = BTN_ACTIVE) then  
                    state <= wait_time;
                else
                    state <= idle; --wait until button is pressed.
                end if;
                wyjscie <= '0';
            when wait_time =>
                if(count = COUNT_MAX) then
                    count <= 0;
                    if(wejscie = BTN_ACTIVE) then
                        wyjscie <= '1';
                    end if;
                    state <= idle;  
                else
                    count <= count + 1;
                end if; 
        end case;       
    end if;        
end process;                  
                                                                                
end architecture behav;