library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity multiplier is
  port (
	op1 : in std_logic_vector(31 downto 0);
	op2 : in std_logic_vector(31 downto 0);
	result : out std_logic_vector(31 downto 0)
  ) ;
end multiplier ;

architecture behaviour_multiplier of multiplier is
signal temp_mul : std_logic_vector(63 downto 0);

begin

	temp_mul <= std_logic_vector(unsigned(op1)*unsigned(op2));
	result <= temp_mul(31 downto 0);

end architecture ; -- behaviour_multiplier