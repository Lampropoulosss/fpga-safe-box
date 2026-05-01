library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Safe_Box is
    Port (
        CLK           : in  STD_LOGIC;
        KEY           : in  STD_LOGIC_VECTOR(1 downto 0); -- KEY0=Reset, KEY1=Enter
        SW            : in  STD_LOGIC_VECTOR(3 downto 0);
        LEDR          : out STD_LOGIC_VECTOR(1 downto 0); -- LEDR0=Unlock, LEDR1=Alarm
        HEX0          : out STD_LOGIC_VECTOR(6 downto 0)
    );
end Safe_Box;

architecture Structural of Safe_Box is
    -- Εσωτερικά "καλώδια"
    signal s_enter_pulse : STD_LOGIC;
    signal s_attempts    : integer range 0 to 7;

begin
    -- Σύνδεση 1: Edge Detector
    U1: entity work.Edge_Detector
        port map(
            clk       => CLK,
            reset_n   => KEY(0),
            button_in => KEY(1),
            pulse_out => s_enter_pulse
        );

    -- Σύνδεση 2: Safe Control (FSM)
    U2: entity work.Safe_Control
        port map(
            clk          => CLK,
            reset_n      => KEY(0),
            enter_pulse  => s_enter_pulse,
            switches_in  => SW,
            unlock_led   => LEDR(0),
            alarm_led    => LEDR(1),
            attempts_out => s_attempts
        );

    -- Σύνδεση 3: 7-Segment Decoder
    U3: entity work.SevenSeg_Decoder
        port map(
            number   => s_attempts,
            segments => HEX0
        );

end Structural;