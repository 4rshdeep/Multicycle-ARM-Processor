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
begin
	main : process( IR, nzvc )
	begin
		p <= '0';
			-- z set
		if IR(31 downto 28) = "0000" and nzvc(2) = '1' then
			p <= '1';
			-- z clear
		elsif IR(31 downto 28) = "0001" and nzvc(2) = '0' then
			p <= '1';
			-- c set
		elsif IR(31 downto 28) = "0010" and nzvc(0) = '1' then
			p <= '1';
			-- c clear
		elsif IR(31 downto 28) = "0011" and nzvc(0) = '0' then
			p <= '1';
			-- n set
		elsif IR(31 downto 28) = "0100" and nzvc(3) = '1' then
			p <= '1';
			-- n clear
		elsif IR(31 downto 28) = "0101" and nzvc(3) = '0' then
			p <= '1';
			-- v set
		elsif IR(31 downto 28) = "0110" and nzvc(1) = '1' then
			p <= '1';
			-- v clear
		elsif IR(31 downto 28) = "0111" and nzvc(1) = '0' then
			p <= '1';
			-- c set and z clear
		elsif IR(31 downto 28) = "1000" and nzvc(0) = '1'  and nzvc(2) = '0' then
			p <= '1';
			-- c clear or z set
		elsif IR(31 downto 28) = "1001"  then
			if nzvc(0) = '0' or nzvc(2) = '1' then
				p <= '1'
			end if ;
			-- N == V
		elsif IR(31 downto 28) = "1010" and nzvc(2) = '0' then
			p <= nzvc(3) nor nzvc(1);
			-- N != V
		elsif IR(31 downto 28) = "1011" and nzvc(2) = '0' then
			p <= not(nzvc(3) nor nzvc(1));
			-- Z clear and N=V
		elsif IR(31 downto 28) = "1100" and nzvc(2) = '0' then
			p <= (nzvc(3) nor nzvc(1)) and not(nzvc(2));
			-- Z set or N!=V
		elsif IR(31 downto 28) = "1101" and nzvc(2) = '0' then
			p <= not((nzvc(3) nor nzvc(1)) and not(nzvc(2)));
			-- ignore
		elsif IR(31 downto 28) = "1110" and nzvc(2) = '0' then
			p <= '1';
		end if ;
	end process ; -- main


end architecture ; -- arch