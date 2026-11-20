library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulated_square_wave_tb is
end modulated_square_wave_tb;

architecture behavior of modulated_square_wave_tb is

  -- Signals for the DUT
  signal clk              : std_logic := '0';
  signal input_vector     : std_logic_vector(10 downto 0);
  signal modulated_output : std_logic;

  -- Clock period definition
  constant clk_period : time := 20 ns;  -- Clock period of 10ns (100 MHz)

begin

  -- Instantiate the DUT (Device Under Test)
  uut: entity work.modulated_square_wave
    port map (
      clk             => clk,
      input_vector    => input_vector,
      modulated_output => modulated_output
    );

  -- Clock generation process
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  -- Stimulus process to apply different input vectors
  stimulus_process : process
  begin
    -- Test Case 1: Set frequency scaler and amplitude multiplier to a low value
    input_vector <= "00010000001";  -- Amplitude multiplier: 1, Frequency scaler: 1
    wait for 1 us;  -- Wait to observe output behavior

    -- Test Case 2: Medium frequency, medium amplitude
    input_vector <= "01010011010";  -- Amplitude multiplier: 5, Frequency scaler: 26
    wait for 1 us;

    -- Test Case 3: Higher frequency, lower amplitude
    input_vector <= "00100001010";  -- Amplitude multiplier: 2, Frequency scaler: 10
    wait for 1 us;

    -- Test Case 4: Maximum frequency and amplitude
    input_vector <= "11111111111";  -- Amplitude multiplier: 15, Frequency scaler: 127
    wait for 1 us;

    -- Test Case 5: Zero amplitude (output should remain zero)
    input_vector <= "00000011010";  -- Amplitude multiplier: 0, Frequency scaler: 26
    wait for 1 us;

    -- End simulation
    wait;
  end process;

end behavior;
