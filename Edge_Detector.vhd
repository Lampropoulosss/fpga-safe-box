library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Edge_Detector is
    Port (
        clk        : in  STD_LOGIC;
        reset_n    : in  STD_LOGIC;
        button_in  : in  STD_LOGIC;
        pulse_out  : out STD_LOGIC
    );
end Edge_Detector;

architecture Behavioral of Edge_Detector is
    signal reg1, reg2 : STD_LOGIC;
begin
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            reg1 <= '1'; reg2 <= '1';
        elsif rising_edge(clk) then
            reg1 <= button_in;
            reg2 <= reg1;
        end if;
    end process;
    pulse_out <= '1' when (reg1 = '0' and reg2 = '1') else '0';
end Behavioral;