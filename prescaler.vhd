library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Prescaler is
    Generic (
        ilosc : natural
    );
    Port ( 
        CLK_IN : in STD_LOGIC;
        CLK_OUT : out STD_LOGIC;
        divider: in STD_LOGIC
    );
end Prescaler;

architecture Behavioral of Prescaler is
    signal cykle_oryginalne : natural := 0;
    signal ilosc_cykli: natural := 0;
    signal internal_clk : STD_LOGIC := '0';
begin
    CLK_OUT <= internal_clk;
    
    prescaler_proc: process(CLK_IN,divider) is
    begin
        if divider = '0' then
            ilosc_cykli <= ilosc;
        elsif divider = '1' then
            ilosc_cykli <= ilosc / 2;
        end if;
    
        if rising_edge(CLK_IN) then
            if cykle_oryginalne >= ilosc_cykli - 1 then
                cykle_oryginalne <= 0;
                internal_clk <= '1';
            else
                cykle_oryginalne <= cykle_oryginalne + 1;
                internal_clk <= '0';
            end if;
        end if;
    end process;
end Behavioral;
