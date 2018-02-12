library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting

entity ALU is
port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		results : out std_logic_vector(31 downto 0);
		nzvf : out std_logic_vector(3 downto 0)
	);
end entity;

arc