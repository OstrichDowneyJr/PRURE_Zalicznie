library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Port ( 
        clk : in STD_LOGIC;
        btnC: in STD_LOGIC :='0'; --power
        btnU: in STD_LOGIC :='0'; --speed
        btnL: in STD_LOGIC :='0'; --scheme
        led : out STD_LOGIC_VECTOR (7 downto 0)
    );
end TOP;

architecture Behavioral of TOP is
    signal clock_debouncer: std_logic;
    signal onoff_1: std_logic := '0';
    signal speed_1: std_logic := '0';    
    signal scheme_1: std_logic := '0';
    signal ledy: std_logic_vector (7 downto 0);
begin

    zegar_debouncera:    
    --prescaler debouncera
    entity work.Prescaler 
    GENERIC MAP(ilosc => 50000000)
	PORT MAP (
          CLK_IN => clk,
          CLK_OUT => clock_debouncer,
          divider => '0'
        );  
        
    przycisk_moc:
    entity work.debouncer
	PORT MAP (
          Clk => clk,
          wejscie => btnC,
          wyjscie => onoff_1
        );
            
    przycisk_predkosc:
    entity work.debouncer
	PORT MAP (
          Clk => clk,
          wejscie => btnU,
          wyjscie => speed_1
        );
    
    przycisk_schemat:
    entity work.debouncer
	PORT MAP (
          Clk => clk,
          wejscie => btnL,
          wyjscie => scheme_1
        );    
          
    wzor1:
    entity work.wzor1
    PORT MAP( 
        Clk=>clk,
        set_pat => scheme_1,
        sonic => speed_1,
        power => onoff_1,
        wyjscie => led
            );       
        
    
end Behavioral;