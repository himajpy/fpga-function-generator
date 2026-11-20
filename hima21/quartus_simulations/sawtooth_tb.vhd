library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sawtooth_rom_tb is
end sawtooth_rom_tb;

architecture behavior of sawtooth_rom_tb is

  -- Constants matching the DUT (Device Under Test) specifications
  constant addr_bits : integer := 7;
  constant data_bits : integer := 15;
  
  -- Signals to connect to the DUT
  signal clk  : std_logic := '0';
  signal addr : unsigned(addr_bits - 1 downto 0) := (others => '0');
  signal data : unsigned(data_bits - 1 downto 0);

  -- Clock period definition for 50 MHz (20 ns period)
  constant clk_period : time := 20 ns;

begin

  -- Instantiate the DUT (Device Under Test)
  uut: entity work.sawtooth_rom
    generic map (
      addr_bits => addr_bits,
      data_bits => data_bits
    )
    port map (
      clk => clk,
      addr => addr,
      data => data
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

  -- Stimulus process to test different addresses
  stimulus_process : process
  begin
    -- Loop through each address to observe the sawtooth pattern in data output
    for i in 0 to (2**addr_bits - 1) loop
      addr <= to_unsigned(i, addr_bits);  -- Assign the current address
      wait for clk_period;                -- Wait one clock period
    end loop;
    
    -- End simulation after all addresses are tested
    wait;
  end process;

end behavior;
