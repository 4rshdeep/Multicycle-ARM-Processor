library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity Bctrl is
  port (
	IR : in std_logic_vector(31 downto 0);
	nzvc : in std_logic_vector(3 downto 0); --flags
	p : out std_logic
  ) ;
end Bctrl ;

architecture arch of Bctrl is
	signal instr : std_logic_vector(3 downto 0) ;
begin
	instr <= IR(31 downto 28);
	main : process( instr, nzvc )
	begin
		case( instr ) is
			when "0000" =>	p <= nzvc(2);						--eq
			when "0001" =>	p <= not(nzvc(2));					--ne
			when "0010" =>	p <= nzvc(0);						--cs|hs
			when "0011" =>	p <= not(nzvc(0));					--cc|lo
			when "0100" =>	p <= nzvc(3);						--mi
			when "0101" =>	p <= not(nzvc(3));					--pl
			when "0110" =>	p <= nzvc(1);						--vs
			when "0111" =>	p <= not(nzvc(1));					--vc
			when "1000" =>	p <= (nzvc(0) and not(nzvc(2)));	--hi
			when "1001" =>	p <= not(nzvc(0) and not(nzvc(2)));	--ls
			when "1010" =>	p <= nzvc(3) xnor nzvc(1);			--ge
			when "1011" =>	p <= not(nzvc(3) xnor nzvc(1));		--lt
			when "1100" =>	p <= not(nzvc(2)) and (nzvc(3) xnor nzvc(1));		--gt
			when "1101" =>	p <= not(not(nzvc(2)) and (nzvc(3) xnor nzvc(1)));	--le
			when "1110" =>	p <= '1';											--al
			when others =>	p <= '0';							-- ow
		end case ;
	end process ; -- main
end architecture ; -- arch