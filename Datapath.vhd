library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
    Port (
        clk             : in  STD_LOGIC;
        reset_n         : in  STD_LOGIC;
        switches_in     : in  STD_LOGIC_VECTOR(3 downto 0);
        
        -- Control Signals (Από το Control Unit)
        load_d1         : in  STD_LOGIC;
        load_d2         : in  STD_LOGIC;
        load_d3         : in  STD_LOGIC;
        load_d4         : in  STD_LOGIC;
        dec_attempts    : in  STD_LOGIC;
        
        -- Status Signals (Προς το Control Unit)
        pin_correct     : out STD_LOGIC;
        out_of_attempts : out STD_LOGIC;
        
        -- Εξωτερικές έξοδοι
        attempts_out    : out integer range 0 to 7 := 7
    );
end Datapath;

architecture Behavioral of Datapath is
    signal d1, d2, d3, d4 : STD_LOGIC_VECTOR(3 downto 0);
    signal attempts       : integer range 0 to 7;
begin
    -- Συνεχείς αναθέσεις (Combinational logic)
    attempts_out <= attempts;
    
    -- Flag για το αν τελείωσαν οι προσπάθειες
    out_of_attempts <= '1' when (attempts = 0) else '0';
    
    -- Συγκριτής PIN (Σταθερό: 0230)
    pin_correct <= '1' when (d1="0000" and d2="0010" and d3="0011" and d4="0000") else '0';

    -- Σύγχρονη λογική Καταχωρητών
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            attempts <= 7;
            d1 <= (others => '0');
            d2 <= (others => '0');
            d3 <= (others => '0');
            d4 <= (others => '0');
        elsif rising_edge(clk) then
            -- Φόρτωση των ψηφίων του PIN
            if load_d1 = '1' then d1 <= switches_in; end if;
            if load_d2 = '1' then d2 <= switches_in; end if;
            if load_d3 = '1' then d3 <= switches_in; end if;
            if load_d4 = '1' then d4 <= switches_in; end if;

            -- Μείωση προσπαθειών
            if dec_attempts = '1' then
                if attempts > 0 then
                    attempts <= attempts - 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;