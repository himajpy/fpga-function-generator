library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_tb is
end main_tb;

architecture tb of main_tb is
    constant clk_period : time := 20 ns;
    signal clk          : std_logic := '0';
    signal rst_n        : std_logic := '0';
    signal enable_signal: std_logic := '1';
    signal sw           : std_logic_vector(10 downto 0) := (others => '0');
    signal keys         : std_logic_vector(2 downto 0) := "000";
    signal data_out     : unsigned(14 downto 0);
    signal mod_data_out1: std_logic;
    signal LEDR         : std_logic_vector(2 downto 0);
    signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 downto 0);

    -- Instantiate the Unit Under Test (UUT)
    component main is
        generic (
            addr_bits : integer range 1 to 14 := 7;
            data_bits : integer range 1 to 15 := 15
        );
        port (
            clk             : in std_logic;
            rst_n           : in std_logic;
            enable_signal   : in std_logic;
            sw              : in std_logic_vector(10 downto 0);
            data_out        : out unsigned(data_bits - 1 downto 0);
            keys            : in std_logic_vector(2 downto 0);
            mod_data_out1   : out std_logic;
            LEDR            : out std_logic_vector(2 downto 0);
            HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(6 downto 0)
        );
    end component;

begin
    -- Instantiate UUT
    uut : main
        port map (
            clk             => clk,
            rst_n           => rst_n,
            enable_signal   => enable_signal,
            sw              => sw,
            data_out        => data_out,
            keys            => keys,
            mod_data_out1   => mod_data_out1,
            LEDR            => LEDR,
            HEX0            => HEX0,
            HEX1            => HEX1,
            HEX2            => HEX2,
            HEX3            => HEX3,
            HEX4            => HEX4,
            HEX5            => HEX5
        );

    -- Clock Generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Reset Process
    stim_proc : process
    begin
        rst_n <= '0';
        enable_signal<='1';
        wait for 1000 ns;
        rst_n <= '1';
        keys <= "110"; wait for 100 ns; -- Test square wave
        wait for 100 ns;
        --sine sawtooth have a period of 128*20ns in no frequency divider mode 
        sw <= "00110000001"; wait for 20us; ---frequency_divider of 2 now sine sawttoth sqaure have period of 128*20ns*2  
        -- Test various select_wave states
       
        keys <= "101"; wait for 30us; -- Test sawtooth wave
       keys <= "011"; wait for 60us; -- Test sawtooth wave

        ---cahnge frequecny 128*20ns*3
    keys <= "110"; --- sqaure
     sw <= "00110000010"; wait for 50us; 
     keys <= "101";wait for 50us;  --- sawtooth
     keys <= "011";wait for 50us;  --- sine
     

        -- Hold simulation to observe waveforms
        wait;
    end process;

end tb;
