library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_seven_segment_display_controller is
-- No ports in the testbench
end tb_seven_segment_display_controller;

architecture Behavioral of tb_seven_segment_display_controller is
    -- Component declaration for the Unit Under Test (UUT)
    component seven_segment_display_controller
        port (
            input_vector : in  std_logic_vector(10 downto 0);
            seg0, seg1, seg2, seg3, seg4, seg5 : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal input_vector : std_logic_vector(10 downto 0) := (others => '0');
    signal seg0, seg1, seg2, seg3, seg4, seg5 : std_logic_vector(6 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: seven_segment_display_controller
        port map (
            input_vector => input_vector,
            seg0 => seg0,
            seg1 => seg1,
            seg2 => seg2,
            seg3 => seg3,
            seg4 => seg4,
            seg5 => seg5
        );

    -- Stimulus process to apply test vectors
    stimulus: process
    begin
        -- Test case 1: Minimum value, all segments should show zero
        input_vector <= "00000000000";  -- Expected: seg1-seg0 = 00, seg5-seg2 = 0000
        wait for 10 ns;

        -- Test case 2: Small value
        input_vector <= "00000001010";  -- Decimal 10, expected seg1-seg0 = 00, seg5-seg2 = 0010
        wait for 10 ns;

        -- Test case 3: Mid-range value
        input_vector <= "00110011001";  -- , expected seg0-seg1 = 03, seg2-seg5 = 0025
        wait for 10 ns;
        -- Test case 4: Mid-range value
        input_vector <= "11001101100";  -- , expected seg0-seg1 = 12, seg2-seg5 = 0108
        wait for 10 ns;
       
        -- Test case 4: Larger value near maximum 11-bit value
        input_vector <= "11111111111";  -- Decimal 2047, expected seg0-seg1 = 16, seg2-seg5 = 0127
        wait for 10 ns;

        -- Test case 5: Random binary pattern
        input_vector <= "10101010101";  -- Expected output based on design, may vary
        wait for 10 ns;

        -- End of simulation
        wait;
    end process;

end Behavioral;
