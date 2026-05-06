library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    Port (
        clk             : in  STD_LOGIC;
        reset_n         : in  STD_LOGIC;
        enter_pulse     : in  STD_LOGIC;
        
        -- Status Signals (Από το Datapath)
        pin_correct     : in  STD_LOGIC;
        out_of_attempts : in  STD_LOGIC;
        
        -- Control Signals (Προς το Datapath)
        load_d1         : out STD_LOGIC;
        load_d2         : out STD_LOGIC;
        load_d3         : out STD_LOGIC;
        load_d4         : out STD_LOGIC;
        dec_attempts    : out STD_LOGIC;
        
        -- Εξωτερικές έξοδοι
        unlock_led      : out STD_LOGIC;
        alarm_led       : out STD_LOGIC
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
    type state_type is (INIT, READ_D1, READ_D2, READ_D3, READ_D4, CHECK_PIN, UNLOCKED, ALARM);
    signal state, next_state : state_type;
begin

    -- Διαδικασία Μνήμης FSM (Sequential)
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            state <= INIT;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Διαδικασία Επόμενης Κατάστασης & Εξόδων (Combinational)
    process(state, enter_pulse, out_of_attempts, pin_correct)
    begin
        -- Default αρχικοποιήσεις (για αποφυγή δημιουργίας latches)
        next_state   <= state;
        load_d1      <= '0';
        load_d2      <= '0';
        load_d3      <= '0';
        load_d4      <= '0';
        dec_attempts <= '0';
        unlock_led   <= '0';
        alarm_led    <= '0';

        case state is
            when INIT =>
                if out_of_attempts = '1' then
                    next_state <= ALARM;
                else
                    next_state <= READ_D1;
                end if;

            when READ_D1 =>
                if enter_pulse = '1' then
                    load_d1 <= '1';
                    next_state <= READ_D2;
                end if;

            when READ_D2 =>
                if enter_pulse = '1' then
                    load_d2 <= '1';
                    next_state <= READ_D3;
                end if;

            when READ_D3 =>
                if enter_pulse = '1' then
                    load_d3 <= '1';
                    next_state <= READ_D4;
                end if;

            when READ_D4 =>
                if enter_pulse = '1' then
                    load_d4 <= '1';
                    next_state <= CHECK_PIN;
                end if;

            when CHECK_PIN =>
                if pin_correct = '1' then
                    next_state <= UNLOCKED;
                else
                    dec_attempts <= '1';
                    next_state <= INIT;
                end if;

            when UNLOCKED =>
                unlock_led <= '1';

            when ALARM =>
                alarm_led <= '1';
        end case;
    end process;
end Behavioral;