library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_segment_display_controller is
  port (
    input_vector : in std_logic_vector(10 downto 0);  -- 11-bit input vector
    seg0 ,seg1, seg2, seg3, seg4, seg5: out std_logic_vector(6 downto 0)  -- 7-segment outputs
  );
end seven_segment_display_controller;

architecture rtl of seven_segment_display_controller is

  signal amplitude: std_logic_vector(3 downto 0);  -- For the amplitude (4-bit for hexadecimal)
  signal frequency: std_logic_vector(6 downto 0);  -- For the frequency (7-bit input)

  signal seg : std_logic_vector(6 downto 0);
  signal digit : std_logic_vector(3 downto 0); -- 4-bit input for each digit

  signal display_amplitude_1: std_logic_vector(3 downto 0);  -- Upper 4 bits for amplitude
  signal display_amplitude_2: std_logic_vector(3 downto 0);  -- Lower 4 bits for amplitude
  signal frequency_value: std_logic_vector(15 downto 0);  -- Hexadecimal value for frequency

  begin
  -- Split the input vector into amplitude and frequency components
  amplitude <= input_vector(10 downto 7);  -- 4 bits for amplitude (hexadecimal)
  frequency <= input_vector(6 downto 0);   -- 7 bits for frequency

  --amplitude portion
  --instantiation of amplitude ccontroller
 
    decimal_controller_inst : entity work.decimal_controller
        Port map (
            binary_in => amplitude,  -- Connect the 4-bit input
            tens      => display_amplitude_2,   -- Connect tens output to internal signal
            ones      => display_amplitude_1    -- Connect ones output to internal signal
        );
  
  
  
  u1: entity work.seven_segment_display port map(
    digit => display_amplitude_1 ,  
    seg => seg0
  );
  u2: entity work.seven_segment_display port map(
    digit => display_amplitude_2 ,  
    seg => seg1
  );
  
  --frequency portion
  -- insantitiaion of frequency controller and assign the output to hex3_7 dsiplay
  
    frequency_controller_inst : entity work.frequency_controller
        Port map (
            binary_in => frequency,          
            thousands =>frequency_value(15 downto 12),      
            hundreds  => frequency_value(11 downto 8),      
            tens      => frequency_value(7 downto 4),           
            ones      => frequency_value(3 downto 0)            
        );  

  
  
  u3: entity work.seven_segment_display port map(
    digit => frequency_value(3 downto 0) ,  
    seg => seg2
  );
  u4: entity work.seven_segment_display port map(
    digit => frequency_value(7 downto 4) ,  
    seg => seg3
  );  
  u5: entity work.seven_segment_display port map(
    digit => frequency_value(11 downto 8) ,  
    seg => seg4
  );
  u6: entity work.seven_segment_display port map(
    digit => frequency_value(15 downto 12) ,  
    seg => seg5
  );
  

end rtl;
