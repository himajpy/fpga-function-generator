library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sawtooth_rom is
  generic (
    addr_bits : integer range 1 to 14 := 7;
    data_bits : integer range 1 to 15 := 15
  );
  port (
    clk : in std_logic;
    addr : in unsigned(addr_bits - 1 downto 0);
    data : out unsigned(data_bits - 1 downto 0)
  );
end sawtooth_rom;

architecture rtl of sawtooth_rom is

  subtype addr_range is integer range 0 to 2**addr_bits - 1;
  type rom_type is array (addr_range) of unsigned(data_bits - 1 downto 0);

  --Initializes the ROM with sawtooth values
  function init_rom return rom_type is
    variable rom_v : rom_type;
    variable step : real;

  begin
    --Step size is size of databits / n of address bits
    step := real(2**data_bits - 1) / real(2**addr_bits - 1);
    
    for i in addr_range loop

      --Value increases for each address that gets looped trough
      rom_v(i) := to_unsigned(integer(step * real(i)), data_bits);
      --rom_v(i) := to_unsigned(integer(round(step * real(i))), data_bits);
      --rom_v(i) := (OTHERS => '0');
      
    end loop;
    
    return rom_v;
  end init_rom;

  -- Constant ROM with increasinng values for the sawtooth shape
  constant rom : rom_type := init_rom;

begin

  ROM_PROC : process(clk)
  begin
    if rising_edge(clk) then
      data <= rom(to_integer(addr));
    end if;
  end process;

end architecture;
