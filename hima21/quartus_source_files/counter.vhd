library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
 
entity counter is
 generic (
 addr_bits : integer range 1 to 14 := 7
 
);
  port (
    clk           : in std_logic;
    rst           : in std_logic;
    count_enable  : in std_logic;
    counter       : out unsigned(addr_bits - 1 downto 0)
  );
end counter;

architecture rtl of counter is
  signal counter_i : unsigned(counter'range);
begin
  counter <= counter_i;

  COUNTER_PROC : process(clk, rst)
  begin
    if rst = '1' then
      counter_i <= (others => '0'); -- Asynchronous reset
    elsif rising_edge(clk) then
      if count_enable = '1' then
        counter_i <= counter_i + 1; -- Increment counter on clock edge if enabled
      end if;
    end if;
  end process;

end architecture;
