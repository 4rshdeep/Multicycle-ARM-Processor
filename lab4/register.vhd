library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;

entity reg is
  port (
	data_in : in std_logic_vector(31 downto 0);
	read_add1 : in std_logic_vector(3 downto 0);
	read_add2 : in std_logic_vector(3 downto 0);
	write_add : in std_logic_vector(3 downto 0);
	clk : in std_logic;
	reset : in std_logic;
	write_enable : in std_logic;
	data_out1 : out std_logic_vector(31 downto 0);
	data_out2 : out std_logic_vector(31 downto 0);
	pc : out std_logic_vector(31 downto 0)
  ) ;
end reg ;

architecture behaviour_reg of reg is
type register_arr is array (15 downto 0) of std_logic_vector(31 downto 0);
signal register_files : register_arr;
signal radd1 : integer;
signal radd2 : integer;
signal wadd : integer;

begin
radd1 <= to_integer(unsigned(read_add1));
radd2 <= to_integer(unsigned(read_add2));
wadd <= to_integer(unsigned(read_add2));
data_out1 <= register_files(radd1);
data_out2 <= register_files(radd2);

-- clocked_process : process( clk, data_in, write_add, resey, w )
-- begin

-- end process ; -- clocked_process





end architecture ; -- behaviour_register