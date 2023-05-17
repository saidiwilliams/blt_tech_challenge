----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2023 02:34:03 PM
-- Design Name: 
-- Module Name: ADC_interface - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADC_interface is
    Port ( clk_125_n : in STD_LOGIC;
           clk_125_p: in STD_LOGIC;
           reset: in std_logic;
           din: in std_logic;
           dco: out std_logic
          );
            
end ADC_interface;

architecture Behavioral of ADC_interface is

signal data_out: std_logic_vector(16 downto 0):=(others => '0'); --data sent to ADC on clk plus
signal data_count: unsigned(4 downto 0); --counter to keep track of data bits based on clk plus
signal rx_data: std_logic_vector(16 downto 0):=(others => '0');  -- received data from controller from MSB to LSB
signal read_done: std_logic:='0'; --trigger signal for clk plus

signal data_out_n: std_logic_vector(16 downto 0):=(others => '0'); --data sent to ADC on clk minus
signal data_count_n: unsigned(4 downto 0); --counter to keep track of data bits based on clk minus
signal rx_data_n: std_logic_vector(16 downto 0):=(others => '0');  -- received data from controller from LSB to MSB
signal read_done_n: std_logic:='0'; --trigger signal for clk minus

begin

process(clk_125_p, reset)
begin
    if(reset = '1') then
	   rx_data <= (others => '0');
	   data_count <= (others => '0');
	   data_out <= (others => '0');
	   read_done <= '0';
	else
	   if(rising_edge(clk_125_p)) then 
	       read_done <= '0';
	       data_count <= data_count + 1;
	       data_out <= rx_data(15 downto 0) & din;
	   elsif(data_count = to_unsigned(17,5)) then
	   	   data_count <= "00000";
	       read_done <= '1';
	   end if;
    end if;
end process;

process(clk_125_n, reset)
begin
    if(reset = '1') then
	   rx_data_n <= (others => '0');
	   data_count_n <= (others => '0');
       data_out_n <= (others => '0');
	   read_done_n <= '0';
	else
        if(falling_edge(clk_125_p)) then
            read_done_n <= '0';
            data_count_n <= data_count_n + 1;
            data_out_n <= rx_data_n(0 to 15) & din;
        elsif(data_count_n = to_unsigned(17,5)) then
            data_count_n <= "00000";
            read_done_n <= '1';
        end if;
    end if;
end process;			
end Behavioral;
