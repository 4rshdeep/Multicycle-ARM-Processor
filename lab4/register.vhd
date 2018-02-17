library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;

entity reg is
  port (
	write_data : in std_logic_vector(31 downto 0);
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
	signal rd_add1 : integer;
	signal rd_add2 : integer;
	signal wr_add : integer;

begin
	rd_add1 <= to_integer(unsigned(read_add1));
	rd_add2 <= to_integer(unsigned(read_add2));
	wr_add <= to_integer(unsigned(write_add));
	data_out1 <= register_files(rd_add1);
	data_out2 <= register_files(rd_add2);

	reset_pc : process( reset )
	begin
		if reset = '1' then
			pc <= (others => '0');
		else
			pc <= register_files(15);
		end if ;
	end process ; -- reset_pc

	clocked_process : process( clk, write_data, write_add, reset, write_enable )
	begin
		if clk='1' and clk'event then
			if write_enable = '1' then
				register_files(wr_add) <= write_data;
			end if ;
		end if ;
	end process ; -- clocked_process

end architecture ; -- behaviour_register