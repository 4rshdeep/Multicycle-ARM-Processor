library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;

--package pkg is
--	type opcode is (ANDD, EOR, SUB, RSB, ADD, ADC, SBC, CMP, CMN, RSC, TST, TEQ, SMP, SMN, ORR, MOV, BIC, MVN);
--	type DP_type is (IMM, SHIFT_IMM, SHIFT_REG);
--	type DT_type is (HALF_WORD, WORD);
--end package ;

--package body pkg is

--end pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;
use work.pkg.all;

entity decoder is
  port (
	-- "00" for DP, "10" for DT, "11" for branching
	instruction      : in std_logic_vector(31 downto 0) ;
	-- decide whether dp,etc
	instruction_type : out std_logic_vector(1 downto 0);
	DP_subtype       : out DP_type;
	DT_subtype       : out DT_type;
	op               : out opcode;
	undef            : out std_logic;
	not_implemented  : out std_logic
  ) ;
end decoder ;

architecture arch of decoder is

begin

	main : process( instruction )
	begin
		undef <= '0';
		not_implemented <= '0';

		case( instruction(27 downto 26) ) is
			when "00" =>
				instruction_type <= "00";
				if instruction(25) = '1' then
					DP_subtype <= IMM;
				else
					if instruction(4) = '0' then
						DP_subtype <= SHIFT_IMM;
					elsif instruction(7) = '0' and instruction(4) = '1' then
						DP_subtype <= SHIFT_REG;
					end if ;
				end if ;

				case( instruction(24 downto 21) ) is

					when "0000" => op <= ANDD;
					when "0001" => op <= EOR;
					when "0010" => op <= SUB;
					when "0011" => op <= RSB;
					when "0100" => op <= ADD;
					when "0101" => op <= ADC;
					when "0110" => op <= SBC;
					when "0111" => op <= RSC;
					when "1000" => op <= TST;
					when "1001" => op <= TEQ;
					when "1010" => op <= CMP;
					when "1011" => op <= CMN;
					when "1100" => op <= ORR;
					when "1101" => op <= MOV;
					when "1110" => op <= BIC;
					when "1111" => op <= MVN;
                    when others => op <= ANDD;
				end case ;

				if ( instruction(25) = '0' and instruction(11 downto 7) = "11110" ) then
					not_implemented <= '1';
				elsif (instruction(25 downto 24)="00" and instruction(7 downto 4)="1001") then
					instruction_type <= "01";
					if instruction(23) = '0' then
						-- mul
						op <= MOV;
					else
						--mla
						op <= ADD;
					end if ;
				elsif ( instruction(25 downto 23)="001" and instruction(7 downto 4)= "1001") then
					not_implemented <= '1';
				elsif( instruction(25 downto 24) ="01" and instruction(7 downto 4) = "1001") then
					not_implemented <= '1';
				elsif(instruction(25) = '0' and instruction(7) = '1' and instruction(4)='1' and instruction(6 downto 4)/="00") then
					instruction_type <= "10"; -- dt
					DT_subtype <= HALF_WORD;
					if (instruction(23)='0') then
						op <= SUB; -- U Bit = 0 => Subtract offset
					else
						op <= ADD;
					end if;
				end if ;
			when "01" =>
				instruction_type <= "10";
				DT_subtype <= WORD;
				if (instruction(25)='1' and instruction(4)='1') then
					undef <= '1';
				else
					if (instruction(23) = '0') then
						op <= SUB;
					else
						op <= ADD;
					end if;
				end if;
			when "10" =>
				instruction_type <= "11";
				if (instruction(25)='0') then
					not_implemented <= '1';
				end if;
			when others => not_implemented <= '1';
		end case ;
	end process ; -- main
end architecture ; -- arch