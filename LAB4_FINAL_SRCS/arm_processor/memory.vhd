--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all; -- for addition & counting
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity memory is
  port (
	address : in std_logic_vector(9 downto 0) ;
	data_in : in std_logic_vector(31 downto 0) ;
	rd_enable : in std_logic;
	data_out : out std_logic_vector(31 downto 0) ;
	byte_offset : in std_logic_vector(3 downto 0) ; -- processor memory datapath gives a 4 bit signal which one to activate (memory enable)
	clk : in std_logic
  ) ;
end memory ;

architecture arch of memory is
type mem is array (1023 downto 0) of std_logic_vector(31 downto 0) ;
signal memory : mem;

begin

  process( clk, address, data_in, rd_enable, byte_offset )
	begin
		if clk='1' and clk'event then
			if byte_offset /= "0000" then
				if byte_offset(3) = '1' then
					memory(to_integer(unsigned(address)))(31 downto 24) <= data_in(31 downto 24);
				elsif byte_offset(2) = '1' then
					memory(to_integer(unsigned(address)))(23 downto 16) <= data_in(23 downto 16);
				elsif byte_offset(1) = '1' then
					memory(to_integer(unsigned(address)))(15 downto 8) <= data_in(15 downto 8);
				elsif byte_offset(0) = '1' then
					memory(to_integer(unsigned(address)))(7 downto 0) <= data_in(7 downto 0);
				end if ;
			end if ;
			if rd_enable = '1' then
				data_out <= memory(to_integer(unsigned(address)));
				end if ;
		end if ;
	end process ; --


	end architecture ; -- arch