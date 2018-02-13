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
	begin
		case(opcode) is
			when "0000" => result <= a and b;
			when "0001" => result <= a xor b;
			when
			when others =>

		end case ;

	end process ; -- p1


end behaviour_alu ; -- behaviour_alu