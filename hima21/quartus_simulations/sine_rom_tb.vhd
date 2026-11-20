----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/04/2024 12:59:27 PM
-- Design Name: 
-- Module Name: sine_rom_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sine_rom_tb is
end sine_rom_tb;

architecture behavior of sine_rom_tb is

  -- Constants for testbench matching the DUT (Design Under Test)
  constant addr_bits : integer := 7;
  constant data_bits : integer := 15;

  -- Signals for connecting to the DUT
  signal clk  : std_logic := '0';
  signal addr : unsigned(addr_bits - 1 downto 0) := (others => '0');
  signal data : unsigned(data_bits - 1 downto 0);

  -- Clock period definition
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the DUT (Device Under Test)
  uut: entity work.sine_rom
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
    -- Loop through each address
    for i in 0 to (2**addr_bits - 1) loop
      addr <= to_unsigned(i, addr_bits);
      wait for clk_period;
    end loop;

    -- Finish simulation
    wait;
  end process;

end behavior;
