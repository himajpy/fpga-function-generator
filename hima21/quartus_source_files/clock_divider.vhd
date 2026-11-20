library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_divider is
    Port (
        clk_50      : in  STD_LOGIC;           -- Input clock
        reset       : in  STD_LOGIC;           -- Asynchronous reset
        div_factor  : in  STD_LOGIC_VECTOR(6 downto 0); -- 7-bit division factor
        clk_out     : out STD_LOGIC            -- Divided output clock
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal counter : STD_LOGIC_VECTOR(6 downto 0) := (others => '0'); -- Counter
    signal clk_out_internal : STD_LOGIC := '0'; -- Internal clock out
begin

    process(clk_50, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');         -- Reset counter
            clk_out_internal <= '0';            -- Reset output clock
        elsif rising_edge(clk_50) then
            if counter = div_factor - 1 then
                counter <= (others => '0');     -- Reset counter
                clk_out_internal <= not clk_out_internal; -- Toggle output clock
            else
                counter <= counter + 1;         -- Increment counter
            end if;
        end if;
    end process;

    clk_out <= clk_out_internal;

end Behavioral;