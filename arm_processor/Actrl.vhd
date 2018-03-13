library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity Actrl is
  port (
	IR : in std_logic_vector(31 downto 0);
	op : out std_logic_vector(3 downto 0)
  ) ;
end Actrl ;

architecture arch of Actrl is
begin

	op <= IR(24 downto 21);

end architecture ; -- arch