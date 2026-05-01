library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Safe_Control is
    Port (
        clk           : in  STD_LOGIC;
        reset_n       : in  STD_LOGIC;
        enter_pulse   : in  STD_LOGIC;
        switches_in   : in  STD_LOGIC_VECTOR(3 downto 0);
        unlock_led    : out STD_LOGIC;
        alarm_led     : out STD_LOGIC;
        attempts_out  : out integer range 0 to 7
    );
end Safe_Control;

architecture Behavioral of Safe_Control is
    type state_type is (INIT, READ_D1, READ_D2, READ_D3, READ_D4, CHECK_PIN, UNLOCKED, ALARM);
	 
    signal state : state_type;
    signal d1, d2, d3, d4 : STD_LOGIC_VECTOR(3 downto 0);
    signal attempts : integer range 0 to 7 := 7; -- d5 = 7
begin
    attempts_out <= attempts;

    process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= INIT; attempts <= 7; unlock_led <= '0'; alarm_led <= '0';
        elsif rising_edge(clk) then
            case state is
                when INIT =>
                    unlock_led <= '0';
                    if attempts > 0 then state <= READ_D1; else state <= ALARM; end if;
                when READ_D1 => if enter_pulse = '1' then d1 <= switches_in; state <= READ_D2; end if;
                when READ_D2 => if enter_pulse = '1' then d2 <= switches_in; state <= READ_D3; end if;
                when READ_D3 => if enter_pulse = '1' then d3 <= switches_in; state <= READ_D4; end if;
                when READ_D4 => if enter_pulse = '1' then d4 <= switches_in; state <= CHECK_PIN; end if;
                when CHECK_PIN =>
                    -- PIN: 0230 βάσει ΑΜ 2023078
                    if (d1="0000" and d2="0010" and d3="0011" and d4="0000") then
                        state <= UNLOCKED;
                    else
                        attempts <= attempts - 1; state <= INIT;
                    end if;
                when UNLOCKED => unlock_led <= '1';
                when ALARM    => alarm_led <= '1';
            end case;
        end if;
    end process;
end Behavioral;