library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entity for reading buttons on the Altera DE1-SOC Development Board (Cyclone V FPGA)
entity buttons is
  port (
    clk : in std_logic;                   
    keys : in std_logic_vector(2 downto 0); -- Inputs for buttons KEY0 to KEY3
    button_states : out std_logic_vector(2 downto 0);
    select_wave : out std_logic_vector(1 downto 0) 
  );
end buttons;

architecture rtl of buttons is

  signal prev_keys : std_logic_vector(2 downto 0) := "111";  -- To store previous button states for edge detection
  signal wave_state : std_logic_vector(1 downto 0) := "00";  -- State retention for select_wave

begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- Invert buttons because buttons are active low (pressed = '1')
      button_states <= not keys;

      -- Detect the falling edge of the button press (from 1 to 0)
      if prev_keys /= keys then  -- Button state has changed
        case not keys is
          when "001" => wave_state <= "01";  -- If KEY0 pressed
          when "010" => wave_state <= "10";  -- If KEY1 pressed
          when "100" => wave_state <= "11";  -- If KEY2 pressed
          when others => null;  -- Ignore all other cases
        end case;
      end if;

      -- If the current state is "00", transition to "01" by default
      if wave_state = "00" then
        wave_state <= "01";
      end if;

      -- Assign the state to the output
      select_wave <= wave_state;

      -- Store current keys as previous for edge detection
      prev_keys <= keys;
    end if;
  end process;

end rtl;
