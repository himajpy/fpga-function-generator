library ieee;
use ieee.std_logic_1164.all;

-- Altera Seven Segment display Decoder with 4-bit input and 7-bit output
--
--     --0--
--    |     |
--    5     1
--    |     |
--     --6--
--    |     |
--    4     2
--    |     |
--     --3--

entity seven_segment_display is
  port (
    digit : in std_logic_vector(3 downto 0); -- 4-bit input (0-15)
    seg   : out std_logic_vector(6 downto 0)  -- 7-segment output (0-6)
  );
end seven_segment_display;

architecture rtl of seven_segment_display is
begin
  process(digit)
  begin
    case digit is
      when "0000" => seg <= "1000000"; -- Display 0
      when "0001" => seg <= "1111001"; -- Display 1
      when "0010" => seg <= "0100100"; -- Display 2
      when "0011" => seg <= "0110000"; -- Display 3
      when "0100" => seg <= "0011001"; -- Display 4
      when "0101" => seg <= "0010010"; -- Display 5
      when "0110" => seg <= "0000010"; -- Display 6
      when "0111" => seg <= "1111000"; -- Display 7
      when "1000" => seg <= "0000000"; -- Display 8
      when "1001" => seg <= "0010000"; -- Display 9
      when "1010" => seg <= "0001000"; -- Display A
      when "1011" => seg <= "0000011"; -- Display B
      when "1100" => seg <= "1000110"; -- Display C
      when "1101" => seg <= "0100001"; -- Display D
      when "1110" => seg <= "0000110"; -- Display E
      when "1111" => seg <= "0001110"; -- Display F
      when others => seg <= "1111111"; -- Blank display
    end case;
  end process;
end rtl;
