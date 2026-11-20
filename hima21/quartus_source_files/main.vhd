library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
    generic (
        addr_bits : integer range 1 to 14 := 7;  -- Number of address bits for ROMs
        data_bits : integer range 1 to 15 := 15  -- Data bit resolution
    );
    port (
        clk             : in std_logic;
        rst_n           : in std_logic;
        enable_signal   : in std_logic;
        sw              : in std_logic_vector(10 downto 0);  -- Frequency and amplitude control
        data_out        : out unsigned(data_bits - 1 downto 0);  -- Output data
        keys            : in std_logic_vector(2 downto 0);  -- Control keys
        mod_data_out1   : out std_logic;--for testing of mod_square_wave signal
        	    ---leds connections
        LEDR: out std_logic_vector(2 downto 0);
        ---seven segment connections
        HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out std_logic_vector(6 downto 0)
        
        
        
        
        
        
    );
end main;

architecture rtl of main is
    -- Component declarations
    component reset
        port (
            clk   : in std_logic;
            rst_n : in std_logic;
            rst   : out std_logic
        );
    end component;

    component clock_divider
        port (
            clk_50     : in std_logic;
            reset      : in std_logic;
            div_factor : in std_logic_vector(6 downto 0); -- 7-bit division factor
            clk_out    : out std_logic
        );
    end component;

    component counter
        generic (
            addr_bits : integer
        );
        port (
            clk           : in std_logic;
            rst           : in std_logic;
            count_enable  : in std_logic;
            counter       : out unsigned(addr_bits - 1 downto 0)
        );
    end component;

    component sine_rom
        generic (
            addr_bits : integer;
            data_bits : integer
        );
        port (
            clk  : in std_logic;
            addr : in unsigned(addr_bits - 1 downto 0);
            data : out unsigned(data_bits - 1 downto 0)
        );
    end component;

    component sawtooth_rom
        generic (
            addr_bits : integer;
            data_bits : integer
        );
        port (
            clk  : in std_logic;
            addr : in unsigned(addr_bits - 1 downto 0);
            data : out unsigned(data_bits - 1 downto 0)
        );
    end component;

    component modulated_square_wave
        port (
            clk             : in std_logic;
            input_vector    : in std_logic_vector(10 downto 0);
            modulated_output : out std_logic
        );
    end component;

    component buttons
        port (
            clk            : in std_logic;
            keys           : in std_logic_vector(2 downto 0);
            button_states  : out std_logic_vector(2 downto 0);
            select_wave    : out std_logic_vector(1 downto 0)
        );
    end component;
    --seven segment
    component seven_segment_display_controller
      port (
        input_vector : in std_logic_vector(10 downto 0);   -- 11-bit input vector
        seg0         : out std_logic_vector(6 downto 0);   -- 7-segment output for display 0
        seg1         : out std_logic_vector(6 downto 0);   -- 7-segment output for display 1
        seg2         : out std_logic_vector(6 downto 0);   -- 7-segment output for display 2
        seg3         : out std_logic_vector(6 downto 0);   -- 7-segment output for display 3
        seg4         : out std_logic_vector(6 downto 0);   -- 7-segment output for display 4
        seg5         : out std_logic_vector(6 downto 0)    -- 7-segment output for display 5
      );
    end component;

    
    
    
    
    
    

    -- Signals
    signal clk_501       : std_logic;
    signal rst           : std_logic;
    signal addr          : unsigned(addr_bits - 1 downto 0);
    signal sine_data     : unsigned(data_bits - 1 downto 0);
    signal sawtooth_data : unsigned(data_bits - 1 downto 0);
    signal rect_data     : unsigned(data_bits - 1 downto 0);
    signal select_wave   : std_logic_vector(1 downto 0);
    signal mod_data_out  : std_logic;
    signal leds          : std_logic_vector(2 downto 0);

begin
    -- Reset component instantiation
    reset_inst: reset
        port map (
            clk   => clk,
            rst_n => rst_n,
            rst   => rst
        );

    -- Buttons component instantiation
    buttons_inst : buttons
        port map (
            clk           => clk,
            keys          => keys,
            button_states => open,
            select_wave   => select_wave
        );

    -- Clock divider instantiation
    clock_divider_inst : clock_divider
        port map (
            clk_50     => clk,
            reset      => rst,
            div_factor => sw(6 downto 0),
            clk_out    => clk_501
        );

    -- Counter instantiation
    counter_inst : counter
        generic map (
            addr_bits => addr_bits
        )
        port map (
            clk          => clk_501,
            rst          => rst,
            count_enable => enable_signal,
            counter      => addr
        );

    -- Sine ROM instantiation
    sine_rom_inst : sine_rom
        generic map (
            addr_bits => addr_bits,
            data_bits => data_bits
        )
        port map (
            clk  => clk,
            addr => addr,
            data => sine_data
        );

    -- Sawtooth ROM instantiation
    sawtooth_rom_inst : sawtooth_rom
        generic map (
            addr_bits => addr_bits,
            data_bits => data_bits
        )
        port map (
            clk  => clk,
            addr => addr,
            data => sawtooth_data
        );

    -- Modulated square wave instantiation
    rect_inst : modulated_square_wave
        port map (
            clk             => clk,
            input_vector    => sw,
            modulated_output => mod_data_out
        );

    -- Assign modulated square wave output to output signal
    mod_data_out1 <= mod_data_out;

    -- Control rect_data based on mod_data_out
    rect_data <= (others => '0') when mod_data_out = '0' else (0 => '1', others => '0');
---seven segment insantation
-- Instantiation of the Component
  display_controller_inst : seven_segment_display_controller
    port map (
      input_vector => sw,
      seg0         => HEX0,
      seg1         => HEX1,
      seg2         => HEX2,
      seg3         => HEX3,
      seg4         => HEX4,
      seg5         => HEX5
    );
    -- Main process to select the output waveform
process(clk, rst)
    begin
        if rst = '1' then
            data_out <= (others => '0');  -- Reset output
            leds <= (others => '0');      -- Reset LEDs
        elsif rising_edge(clk) then
            -- Choose output based on select_wave
            case select_wave is
                when "01" =>
                    data_out <= rect_data;
                    leds <= "001";  -- LED 0 on for square wave
                when "10" =>
                    data_out <= sawtooth_data;
                    leds <= "010";  -- LED 1 on for sawtooth wave
                when "11" =>
                    data_out <= sine_data;
                    leds <= "100";  -- LED 2 on for sine wave
                when others =>
                    data_out <= rect_data;
                    leds <= "001";  -- Default to square wave
            end case;
        end if;
    end process;
    LEDR(0) <= leds(0);
    LEDR(1) <= leds(1);
    LEDR(2) <= leds(2);
    

end rtl;



-- TODO in QSF file to assign Pin numbers to keys vector and hex vector

-- set_location_assignment PIN_AA14 -to keys[0]  # KEY0
-- set_location_assignment PIN_AA15 -to keys[1]  # KEY1
-- set_location_assignment PIN_W15 -to keys[2]  # KEY2
-- set_location_assignment PIN_Y16 -to keys[3]  # KEY3

-- # For HEX0 (Display 0)
-- set_location_assignment PIN_AE26 -to seg[0]   # Segment 0
-- set_location_assignment PIN_AE27 -to seg[1]   # Segment 1
-- set_location_assignment PIN_AE28 -to seg[2]   # Segment 2
-- set_location_assignment PIN_AG27 -to seg[3]   # Segment 3
-- set_location_assignment PIN_AF28 -to seg[4]   # Segment 4
-- set_location_assignment PIN_AG28 -to seg[5]   # Segment 5
-- set_location_assignment PIN_AH28 -to seg[6]   # Segment 6

-- # For HEX1 (Display 1)
-- set_location_assignment PIN_AJ29 -to seg[0]   # Segment 0
-- set_location_assignment PIN_AH29 -to seg[1]   # Segment 1
-- set_location_assignment PIN_AH30 -to seg[2]   # Segment 2
-- set_location_assignment PIN_AG30 -to seg[3]   # Segment 3
-- set_location_assignment PIN_AF29 -to seg[4]   # Segment 4
-- set_location_assignment PIN_AF30 -to seg[5]   # Segment 5
-- set_location_assignment PIN_AD27 -to seg[6]   # Segment 6

-- # For HEX2 (Display 2)
-- set_location_assignment PIN_AB23 -to seg[0]   # Segment 0
-- set_location_assignment PIN_AE29 -to seg[1]   # Segment 1
-- set_location_assignment PIN_AD29 -to seg[2]   # Segment 2
-- set_location_assignment PIN_AC28 -to seg[3]   # Segment 3
-- set_location_assignment PIN_AD30 -to seg[4]   # Segment 4
-- set_location_assignment PIN_AC29 -to seg[5]   # Segment 5
-- set_location_assignment PIN_AC30 -to seg[6]   # Segment 6

-- # For HEX3 (Display 3)
-- set_location_assignment PIN_AD26 -to seg[0]   # Segment 0
-- set_location_assignment PIN_AC27 -to seg[1]   # Segment 1
-- set_location_assignment PIN_AD25 -to seg[2]   # Segment 2
-- set_location_assignment PIN_AC25 -to seg[3]   # Segment 3
-- set_location_assignment PIN_AB28 -to seg[4]   # Segment 4
-- set_location_assignment PIN_AB25 -to seg[5]   # Segment 5
-- set_location_assignment PIN_AB22 -to seg[6]   # Segment 6

-- # For HEX4 (Display 4)
-- set_location_assignment PIN_AA24 -to seg[0]   # Segment 0
-- set_location_assignment PIN_Y23  -to seg[1]   # Segment 1
-- set_location_assignment PIN_Y24  -to seg[2]   # Segment 2
-- set_location_assignment PIN_W22  -to seg[3]   # Segment 3
-- set_location_assignment PIN_W24  -to seg[4]   # Segment 4
-- set_location_assignment PIN_V23   -to seg[5]   # Segment 5
-- set_location_assignment PIN_W25   -to seg[6]   # Segment 6

-- # For HEX5 (Display 5)
-- set_location_assignment PIN_V25   -to seg[0]   # Segment 0
-- set_location_assignment PIN_AA28  -to seg[1]   # Segment 1
-- set_location_assignment PIN_Y27   -to seg[2]   # Segment 2
-- set_location_assignment PIN_AB27   -to seg[3]   # Segment 3
-- set_location_assignment PIN_AB26   -to seg[4]   # Segment 4
-- set_location_assignment PIN_AA26   -to seg[5]   # Segment 5
-- set_location_assignment PIN_AA25   -to seg[6]   # Segment 6
