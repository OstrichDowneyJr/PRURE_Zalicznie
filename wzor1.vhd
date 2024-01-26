library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity wzor1 is
    Port ( 
        clk :   in STD_LOGIC; -- zegar zewnetrzny
        set_pat: in STD_LOGIC :='0'; -- wybór wzoru
        sonic: in STD_LOGIC :='0'; -- zmiana predkosci
        power:  in STD_LOGIC :='0'; -- wlczenie/wylczenie       
        wyjscie :  out STD_LOGIC_VECTOR (7 downto 0) -- wektor wyjsciowy do w??czania/wy??czania ledów
    );
end wzor1;

architecture Behavioral of wzor1 is
    signal aktualny_wzor: std_logic_vector(7 downto 0); -- przechowuje aktualny wzór
    signal zasilanie: std_logic_vector (7 downto 0); -- 
    signal lewy: std_logic_vector (3 downto 0) := (3 => '1', others => '0');
    signal prawy: std_logic_vector (3 downto 0) := (0 => '1', others => '0');
    signal kombinacja: std_logic_vector (7 downto 0) ;
    signal tick: std_logic; -- sygnal z prescalera
    signal flaga_wzor: bit; -- flaga do wyboru wzoru
    signal flaga_predkosc: std_logic := '0'; -- flaga do zmiany pr?dko?ci
    signal flaga_zasilanie: std_logic := '1';

begin
    zegar: entity work.Prescaler 
        GENERIC MAP(ilosc => 100000000)
        PORT MAP (
            CLK_IN => clk,
            CLK_OUT => tick,
            divider => flaga_predkosc
        );

    generacja_wzoru: process(clk)
    begin
        if rising_edge(Clk) then
                if (set_pat = '1' and flaga_wzor = '0') then
                    flaga_wzor <= '1';
                elsif (set_pat = '1' and flaga_wzor = '1') then
                    aktualny_wzor <= "00000001";
                    flaga_wzor <= '0';
                end if; 
                
                if sonic = '1' then
                   flaga_predkosc <= not flaga_predkosc;
                end if;
                
                if power = '1' then
                    flaga_zasilanie <= not flaga_zasilanie;
                end if;
                
                zasilanie <= (others => flaga_zasilanie);
            if tick = '1' then 
            if flaga_wzor='0' then
                aktualny_wzor(7 downto 1) <= aktualny_wzor(6 downto 0);
                aktualny_wzor(0) <= aktualny_wzor(7);           
                wyjscie <=aktualny_wzor and zasilanie;
                
            elsif flaga_wzor = '1' then
                lewy(2 downto 0) <= lewy (3 downto 1);
                lewy(3) <= lewy(0);
                
                prawy(3 downto 1) <= prawy (2 downto 0);
                prawy(0) <= prawy(3);
                
                kombinacja (7 downto 4) <= lewy;
                kombinacja (3 downto 0) <= prawy;
                wyjscie <= kombinacja and zasilanie;
            end if;
                
            end if;
        end if;
    end process;

end Behavioral;
