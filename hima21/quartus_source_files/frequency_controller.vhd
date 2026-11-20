library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity frequency_controller is
    Port (
        binary_in : in  STD_LOGIC_VECTOR(6 downto 0); -- 7-bit input
        thousands : out STD_LOGIC_VECTOR(3 downto 0); -- Thousands place
        hundreds  : out STD_LOGIC_VECTOR(3 downto 0); -- Hundreds place
        tens      : out STD_LOGIC_VECTOR(3 downto 0); -- Tens place
        ones      : out STD_LOGIC_VECTOR(3 downto 0)  -- Ones place
    );
end frequency_controller;

architecture Behavioral of frequency_controller is
    signal decimal_val : INTEGER range 0 to 127;
begin
    -- Convert 7-bit binary input to an integer
    decimal_val <= CONV_INTEGER(binary_in);

    process(decimal_val)
        variable temp_val : INTEGER := 0;
        variable thousands_digit, hundreds_digit, tens_digit, ones_digit : INTEGER range 0 to 9;
    begin
        temp_val := decimal_val;

        -- Calculate thousands place (not necessary for values up to 127, will stay zero)
        thousands_digit := 0;

        -- Calculate hundreds place
        if temp_val >= 100 then
            hundreds_digit := 1;
            temp_val := temp_val - 100;
        else
            hundreds_digit := 0;
        end if;

        -- Calculate tens place (manual subtraction without loops)
        if temp_val >= 90 then
            tens_digit := 9;
            temp_val := temp_val - 90;
        elsif temp_val >= 80 then
            tens_digit := 8;
            temp_val := temp_val - 80;
        elsif temp_val >= 70 then
            tens_digit := 7;
            temp_val := temp_val - 70;
        elsif temp_val >= 60 then
            tens_digit := 6;
            temp_val := temp_val - 60;
        elsif temp_val >= 50 then
            tens_digit := 5;
            temp_val := temp_val - 50;
        elsif temp_val >= 40 then
            tens_digit := 4;
            temp_val := temp_val - 40;
        elsif temp_val >= 30 then
            tens_digit := 3;
            temp_val := temp_val - 30;
        elsif temp_val >= 20 then
            tens_digit := 2;
            temp_val := temp_val - 20;
        elsif temp_val >= 10 then
            tens_digit := 1;
            temp_val := temp_val - 10;
        else
            tens_digit := 0;
        end if;

        -- Remaining value is the ones place
        ones_digit := temp_val;

        -- Convert each place to 4-bit binary
        thousands <= CONV_STD_LOGIC_VECTOR(thousands_digit, 4);
        hundreds  <= CONV_STD_LOGIC_VECTOR(hundreds_digit, 4);
        tens      <= CONV_STD_LOGIC_VECTOR(tens_digit, 4);
        ones      <= CONV_STD_LOGIC_VECTOR(ones_digit, 4);
    end process;

end Behavioral;
