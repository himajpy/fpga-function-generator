library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decimal_controller is
    Port (
        binary_in : in  STD_LOGIC_VECTOR(3 downto 0); -- 4-bit input
        tens      : out STD_LOGIC_VECTOR(3 downto 0); -- Tens digit for first module
        ones      : out STD_LOGIC_VECTOR(3 downto 0)  -- Units digit for second module
    );
end decimal_controller;

architecture Behavioral of decimal_controller is
    signal decimal_val : INTEGER range 0 to 15;
    signal tens_digit  : STD_LOGIC_VECTOR(3 downto 0);
    signal units_digit : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(binary_in)
    begin
        case binary_in is
            when "0000" => tens_digit <= "0000"; units_digit <= "0000"; -- 0
            when "0001" => tens_digit <= "0000"; units_digit <= "0001"; -- 1
            when "0010" => tens_digit <= "0000"; units_digit <= "0010"; -- 2
            when "0011" => tens_digit <= "0000"; units_digit <= "0011"; -- 3
            when "0100" => tens_digit <= "0000"; units_digit <= "0100"; -- 4
            when "0101" => tens_digit <= "0000"; units_digit <= "0101"; -- 5
            when "0110" => tens_digit <= "0000"; units_digit <= "0110"; -- 6
            when "0111" => tens_digit <= "0000"; units_digit <= "0111"; -- 7
            when "1000" => tens_digit <= "0000"; units_digit <= "1000"; -- 8
            when "1001" => tens_digit <= "0000"; units_digit <= "1001"; -- 9
            when "1010" => tens_digit <= "0001"; units_digit <= "0000"; -- 10
            when "1011" => tens_digit <= "0001"; units_digit <= "0001"; -- 11
            when "1100" => tens_digit <= "0001"; units_digit <= "0010"; -- 12
            when "1101" => tens_digit <= "0001"; units_digit <= "0011"; -- 13
            when "1110" => tens_digit <= "0001"; units_digit <= "0100"; -- 14
            when "1111" => tens_digit <= "0001"; units_digit <= "0101"; -- 15
            when others => tens_digit <= "0000"; units_digit <= "0000";
        end case;
    end process;

    -- Assign the signals to the output ports
    tens <= tens_digit;
    ones <= units_digit;
end Behavioral;

