library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_frequency_controller is
-- Testbench does not have any ports
end tb_frequency_controller;

architecture Behavioral of tb_frequency_controller is
    -- Component declaration for the Unit Under Test (UUT)
    component frequency_controller
        Port (
            binary_in : in  STD_LOGIC_VECTOR(6 downto 0); -- 7-bit input
            thousands : out STD_LOGIC_VECTOR(3 downto 0); -- Thousands place
            hundreds  : out STD_LOGIC_VECTOR(3 downto 0); -- Hundreds place
            tens      : out STD_LOGIC_VECTOR(3 downto 0); -- Tens place
            ones      : out STD_LOGIC_VECTOR(3 downto 0)  -- Ones place
        );
    end component;

    -- Signals to connect to the UUT
    signal binary_in : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
    signal thousands : STD_LOGIC_VECTOR(3 downto 0);
    signal hundreds  : STD_LOGIC_VECTOR(3 downto 0);
    signal tens      : STD_LOGIC_VECTOR(3 downto 0);
    signal ones      : STD_LOGIC_VECTOR(3 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: frequency_controller
        Port map (
            binary_in => binary_in,
            thousands => thousands,
            hundreds  => hundreds,
            tens      => tens,
            ones      => ones
        );

    -- Test process
    process
    begin
        -- Test case 1: Input = 0
        binary_in <= "0000000";
        wait for 10 ns;

        -- Test case 2: Input = 25
        binary_in <= "0011001"; -- 25 in binary
        wait for 10 ns;

        -- Test case 3: Input = 123
        binary_in <= "1111011"; -- 123 in binary
        wait for 10 ns;

        -- Test case 4: Input = 99
        binary_in <= "1100011"; -- 99 in binary
        wait for 10 ns;

        -- Test case 5: Input = 127 (max 7-bit value)
        binary_in <= "1111111"; -- 127 in binary
        wait for 10 ns;

        -- Additional test cases as needed
        -- ...

        -- Stop simulation
        wait;
    end process;

end Behavioral;
