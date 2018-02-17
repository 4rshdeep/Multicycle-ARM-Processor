library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;

entity test is
  port (
	s : in std_logic_vector(16 downto 0) ;
	sig : in std_logic_vector(3 downto 0);
	o : out std_logic_vector(16 downto 0)
  ) ;
end test ;

-- set a signal and rest zeros

architecture arch of test is
-- signal sig_int : integer;
begin
	-- sig_int = to_integer(unsigned(sig));
	o <= ( 3 => sig(3), 2 => sig(2), 1 => sig(1), 0 => sig(0), others => '0');


end architecture ; -- arch