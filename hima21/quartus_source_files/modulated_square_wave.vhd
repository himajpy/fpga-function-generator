library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulated_square_wave is
  port (
    clk         : in std_logic;                        -- Input clock signal
    input_vector : in std_logic_vector(10 downto 0);   -- Input vector for amplitude and frequency modulation
    modulated_output : out std_logic                   -- Output modulated square wave
  );
end modulated_square_wave;

architecture rtl of modulated_square_wave is

  signal amplitude_multiplier : unsigned(3 downto 0);  -- Amplitude control (from bits 10 downto 7)
  signal frequency_scaler     : unsigned(6 downto 0);  -- Frequency scaling factor (from bits 6 downto 0)
  signal counter              : unsigned(6 downto 0) := (others => '0'); -- Counter for frequency division
  signal temp_square_wave     : std_logic := '0';      -- Temporary square wave signal
  signal amplitude_counter    : unsigned(3 downto 0) := (others => '0'); -- Counter for amplitude modulation
  signal amplitude_steps      : unsigned(3 downto 0);  -- Used to control amplitude in 0.5 steps

begin

  -- Extract the amplitude and frequency scaler from the input vector
  amplitude_multiplier <= unsigned(input_vector(10 downto 7));  -- 4-bit amplitude control
  frequency_scaler <= unsigned(input_vector(6 downto 0));       -- 7-bit frequency scaler

  -- Frequency modulation process: create a divided clock based on the frequency scaler
  process(clk)
  begin
    if rising_edge(clk) then
      if counter = frequency_scaler then
        counter <= (others => '0');  -- Reset counter
        temp_square_wave <= not temp_square_wave;  -- Toggle square wave signal
      else
        counter <= counter + 1;  -- Increment counter
      end if;
    end if;
  end process;

  -- Amplitude modulation process: generate the amplitude-modulated square wave
  -- The amplitude will be adjusted according to the binary value, scaled in steps of 0.5
  process(clk)
  begin
    if rising_edge(clk) then
      -- Calculate the number of steps based on the amplitude (amplitude_multiplier * 0.5)
      amplitude_steps <= amplitude_multiplier;

      if amplitude_steps /= 0 then  -- Avoid zero-amplitude case
        if amplitude_counter < amplitude_steps then
          modulated_output <= temp_square_wave;  -- Allow the square wave to pass
          amplitude_counter <= amplitude_counter + 1;
        else
          modulated_output <= '0';  -- Set output to 0 when amplitude limit is reached
          amplitude_counter <= (others => '0');  -- Reset amplitude counter
        end if;
      else
        modulated_output <= '0';  -- Zero amplitude output
      end if;
    end if;
  end process;

end rtl;
