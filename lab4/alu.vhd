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
			when "0000" => rslt := a and b;		   		-- and
			when "0001" => rslt := a xor b;				-- xor
			when "0010" => rslt := a + not(b) + 1;		-- sub
			when "0011" => rslt := b + not(a) + 1;		-- rsb
			when "0100" => rslt := a + b;				-- add
			when "0101" => rslt := a + b + carry;		-- adc
			when "0110" => rslt := a + not(b) + carry;	-- sbc
			when "0111" => rslt := not(a) + b + carry;	-- rsc
			when "1000" => rslt := a and b;				-- tst
			when "1001" => rslt := a xor b;				-- teq
			when "1010" => rslt := a + not(b) + 1;		-- cmp
			when "1011" => rslt := a + b;				-- cmn
			when "1100" => rslt := a or b;				-- orr
			when "1101" => rslt := b;					-- mov
			when "1110" => rslt := a and not(b);		-- bic
			when "1111" => rslt := not(b);				-- mvn
			when others => rslt := (others => '0');
		end case;

		case opcode is
			when "0101" => tmp := a + b;				-- adc
			when "0110" => tmp := a + not(b);			-- sbc
			when "0111" => tmp := not(a) + b;			-- rsc
			when others => tmp := (others => '0');
		end case;

		case opcode is
			when "0101" => tmp2 := a(31) xor b(31) xor tmp(31);         -- adc
			when "0110" => tmp2 := a(31) xor not( b(31) ) xor tmp(31);	-- sbc
			when "0111" => tmp2 := not( a(31) ) xor b(31) xor tmp(31);	-- rsc
			when others => tmp2 := '0'
		end case;

		case(opcode) is
			when "0010" => c31 := a(31) xor b(31) xor rslt(31);					-- sub
			when "0011" => c31 := a(31) xor b(31) xor rslt(31);					-- rsb
			when "0100" => c31 := a(31) xor b(31) xor rslt(31);					-- add
			when "0101" => c31 := ( tmp(31) xor '0' xor rslt(31) ) or tmp2 ;	-- adc
			when "0110" => c31 := ( tmp(31) xor '0' xor rslt(31) ) or tmp2 ;	-- sbc
			when "0111" => c31 := ( tmp(31) xor '0' xor rslt(31) ) or tmp2 ;	-- rsc
			when "1010" => c31 := a(31) xor b(31) xor rslt(31);					-- cmp
			when "1011" => c31 := a(31) xor b(31) xor rslt(31);					-- cmn
			when others => c31 := '0';
		end case ;

		case(opcode) is
			when "0010" => c32 := (not(a(31)) and b(31)) or (not(a(31)) and c31) or (b(31) and c31);  	-- sub
			when "0011" => c32 := (a(31) and (not(b(31)))) or (a(31) and c31) or (not(b(31)) and c31);  -- rsb
			when "0100" => c32 := (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);				-- add
			-- write for adc, sbc and rsc
			when "1010" => c32 := (not(a(31)) and b(31)) or (not(a(31)) and c31) or (b(31) and c31);	-- cmp
			when "1011" => c32 := (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);				-- cmn
			when others => c32 := 0;


			nzvf(3) <= rslt(31);
			if rslt = "00000000000000000000000000000000" then
				nzvf(2) <= '1';
			else
				nzvf(2) <= '0';
			end if ;
			nzvf(1) <= cs31 xor c32;
			nzvf(0) <= rslt(31);

			result 	<= rslt;
			carry 	<= c32;

		end case;

	end process ; -- p1


end behaviour_alu ; -- behaviour_alu