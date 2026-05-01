library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Safe_Box is
end tb_Safe_Box;

architecture behavior of tb_Safe_Box is
    signal CLK  : STD_LOGIC := '0';
    signal KEY  : STD_LOGIC_VECTOR(1 downto 0) := "11"; -- Active low/high ανάλογα (το reset_n σου είναι '0' για reset)
    signal SW   : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal LEDR : STD_LOGIC_VECTOR(1 downto 0);
    signal HEX0 : STD_LOGIC_VECTOR(6 downto 0);

    constant clk_period : time := 20 ns; -- Ρολόι 50MHz

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

    -- Διαδικασία Δοκιμής (Stimulus)
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

        -- 2. Εισαγωγή 1ου ψηφίου (0)
        SW <= "0000";
        wait for 20 ns;
        KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter (Active-Low)
        wait for 40 ns;

        -- 3. Εισαγωγή 2ου ψηφίου (2)
        SW <= "0010";
        wait for 20 ns;
        KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter
        wait for 40 ns;

        -- 4. Εισαγωγή 3ου ψηφίου (3)
        SW <= "0011";
        wait for 20 ns;
        KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter
        wait for 40 ns;

        -- 5. Εισαγωγή 4ου ψηφίου (0)
        SW <= "0000";
        wait for 20 ns;
        KEY(1) <= '0'; wait for 20 ns; KEY(1) <= '1'; -- Πάτημα Enter
        wait for 100 ns;

        -- Παρατήρησε αν άναψε το LEDR(0) (Unlock)
        wait;
    end process;
end behavior;