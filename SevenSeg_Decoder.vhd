library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenSeg_Decoder is
    Port (
        number   : in  integer range 0 to 7;
        segments : out STD_LOGIC_VECTOR(6 downto 0)
    );
end SevenSeg_Decoder;

architecture Behavioral of SevenSeg_Decoder is
begin
    with number select
        segments <= "1111000" when 7, "0000010" when 6,
                    "0010010" when 5, "0011001" when 4,
                    "0110000" when 3, "0100100" when 2,
                    "1111001" when 1, "1000000" when 0,
                    "1111111" when others;
end Behavioral;