library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Safe_Control is
    Port (
        clk          : in  STD_LOGIC;
        reset_n      : in  STD_LOGIC;
        enter_pulse  : in  STD_LOGIC;
        switches_in  : in  STD_LOGIC_VECTOR(3 downto 0);
        unlock_led   : out STD_LOGIC;
        alarm_led    : out STD_LOGIC;
        attempts_out : out integer range 0 to 7
    );
end Safe_Control;

architecture Structural of Safe_Control is

    -- Εσωτερικά σήματα διασύνδεσης μεταξύ Datapath και Control Unit
    signal s_load_d1         : STD_LOGIC;
    signal s_load_d2         : STD_LOGIC;
    signal s_load_d3         : STD_LOGIC;
    signal s_load_d4         : STD_LOGIC;
    signal s_dec_attempts    : STD_LOGIC;
    
    signal s_pin_correct     : STD_LOGIC;
    signal s_out_of_attempts : STD_LOGIC;

begin
    -- Ενσωμάτωση του Datapath
    DP_INST: entity work.Datapath
        port map(
            clk             => clk,
            reset_n         => reset_n,
            switches_in     => switches_in,
            load_d1         => s_load_d1,
            load_d2         => s_load_d2,
            load_d3         => s_load_d3,
            load_d4         => s_load_d4,
            dec_attempts    => s_dec_attempts,
            pin_correct     => s_pin_correct,
            out_of_attempts => s_out_of_attempts,
            attempts_out    => attempts_out
        );

    -- Ενσωμάτωση του Control Unit
    CU_INST: entity work.Control_Unit
        port map(
            clk             => clk,
            reset_n         => reset_n,
            enter_pulse     => enter_pulse,
            pin_correct     => s_pin_correct,
            out_of_attempts => s_out_of_attempts,
            load_d1         => s_load_d1,
            load_d2         => s_load_d2,
            load_d3         => s_load_d3,
            load_d4         => s_load_d4,
            dec_attempts    => s_dec_attempts,
            unlock_led      => unlock_led,
            alarm_led       => alarm_led
        );

end Structural;