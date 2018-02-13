library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting

entity ALU is
port(
		a : in std_logic_vector(31 downto 0);
		b : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0);
		nzvf : out std_logic_vector(3 downto 0);
		carry : in std_logic;
		opcode : in std_logic_vector(3 downto 0)
	);
end entity;

architecture behaviour_alu of ALU is

begin
	p1 : process( a, b, carry, opcode )
	variable rslt  : std_logic_vector(31 downto 0);
	variable c31   : std_logic;
 	variable c32   : std_logic;
 	variable tmp   : std_logic_vector(31 downto 0);

	begin
		case(opcode) is
			when "0000" => rslt := a and b;
			when "0001" => rslt := a xor b;
			when "0010" => rslt := a + not(b) + 1;
			when "0011" => rslt := b + not(a) + 1;
			when "0100" => rslt := a + b;
			when "0101" => rslt := a + b + carry;
			when "0110" => rslt := a + not(b) + carry;
			when "0111" => rslt := not(a) + b + carry;
			when "1000" => rslt := a and b;
			when "1001" => rslt := a xor b;
			when "1010" => rslt := a + not(b) + 1;
			when "1011" => rslt := a + b;
			when "1100" => rslt := a or b;
			when "1101" => rslt := b;
			when "1110" => rslt := a and not(b);
			when "1111" => rslt := not(b);
			when others => rslt := "00000000000000000000000000000000";
		end case;

		case opcode is 
			when "0101" => tmp := a + b;
			when "0110" => tmp := a + not(b);
			when "0111" => tmp := not(a) + b;
			when others => tmp := "00000000000000000000000000000000";
		end case;

		case opcode is 
			when "0101" => tmp2 := a(31) xor b(31) xor tmp(31);
			when "0110" => tmp2 := a(31) xor not( b(31) ) xor tmp(31);
			when "0111" => tmp2 := not( a(31) ) xor b(31) xor tmp(31);
			when others => tmp2 := '0'
		end case;

		case(opcode) is
			when "0010" => c31 := a(31) xor b(31) xor rslt(31);
			when "0011" => c31 := a(31) xor b(31) xor rslt(31);
			when "0100" => c31 := a(31) xor b(31) xor rslt(31);
			when "0101" => c31 := ( tmp(31) xor '0' xor rslt(31) ) or tmp2 ;
			when "0110" => c31 := ( tmp(31) xor '0' xor rslt(31) ) or tmp2 ;
			when "0111" => c31 := ( tmp(31) xor '0' xor rslt(31) ) or tmp2 ;
			when "1010" => c31 := a(31) xor b(31) xor rslt(31);
			when "1011" => c31 := a(31) xor b(31) xor rslt(31);
			when others => c31 := '0';
		end case ;

	end process ; -- p1


end behaviour_alu ; -- behaviour_alu