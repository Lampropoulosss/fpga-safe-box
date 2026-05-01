library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Safe_Box_Wrong is
end tb_Safe_Box_Wrong;

architecture behavior of tb_Safe_Box_Wrong is
    signal CLK  : STD_LOGIC := '0';
    signal KEY  : STD_LOGIC_VECTOR(1 downto 0) := "11"; 
    signal SW   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal LEDR : STD_LOGIC_VECTOR(1 downto 0);
    signal HEX0 : STD_LOGIC_VECTOR(6 downto 0);

    constant clk_period : time := 20 ns; 

begin
    -- Instantiation του δικού σου Safe_Box
    uut: entity work.Safe_Box
        port map (
            CLK => CLK,
            KEY => KEY,
            SW => SW,
            LEDR => LEDR,
            HEX0 => HEX0
        );

    -- Παραγωγή Ρολογιού
    clk_process :process
    begin
        CLK <= '0';
        wait for clk_period/2;
        CLK <= '1';
        wait for clk_period/2;
    end process;

    -- Διαδικασία Δοκιμής (Σενάριο Συναγερμού - 7 λάθος προσπάθειες)
    stim_proc: process
    begin
        -- Αρχική κατάσταση: Και τα δύο κουμπιά ελεύθερα ('1')
        KEY(1) <= '1';
        KEY(0) <= '1';
        wait for 10 ns;

        -- 1. Αρχικό Reset (Το KEY0 πατιέται = '0')
        KEY(0) <= '0';
        wait for 40 ns;
        KEY(0) <= '1'; -- Απελευθέρωση Reset
        wait for 40 ns;

        -- 2. Βρόχος για 7 λανθασμένες προσπάθειες
        for i in 1 to 7 loop
            -- Εισαγωγή 1ου ψηφίου (λάθος: '1')
            SW <= "0001";
            wait for 20 ns;
            KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter (Active-Low)
            wait for 40 ns;

            -- Εισαγωγή 2ου ψηφίου (λάθος: '1')
            SW <= "0001";
            wait for 20 ns;
            KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter
            wait for 40 ns;

            -- Εισαγωγή 3ου ψηφίου (λάθος: '1')
            SW <= "0001";
            wait for 20 ns;
            KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter
            wait for 40 ns;

            -- Εισαγωγή 4ου ψηφίου (λάθος: '1')
            SW <= "0001";
            wait for 20 ns;
            KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter
            wait for 80 ns; -- Περιμένουμε λίγο παραπάνω για να φανεί καθαρά η μείωση της προσπάθειας
        end loop;

        -- Η προσομοίωση σταματάει εδώ. Το LEDR(1) πρέπει να είναι '1' (Alarm).
        wait;
    end process;
end behavior;