library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;
use work.pkg.all;

--package pkg is
--	type opcode is (ANDD, EOR, SUB, RSB, ADD, SBC, RSC, TST, TEQ, SMP, SMN, ORR, MOV, BIC, MVN);
--	type DP_type is (IMM, SHIFT_IMM, SHIFT_REG);
--	type DT_type is (HALF_WORD, WORD);
--	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25);

--end package ;

--package body pkg is

--end pkg;

entity controller_states is
  port (
	instruction_type : in std_logic_vector(1 downto 0);
	DP_subtype 		 : in DP_type;
	DT_subtype 		 : in DT_type;
	reset 			 : in std_logic;
	instruction 	 : in std_logic_vector(31 downto 0) ;
	clock 			 : in std_logic;
	state_out 		 : out state_type
  ) ;
end controller_states ;

architecture arch of controller_states is
signal state : state_type;
begin

state_out <= s0 when reset = '1' else state;

-- in others clause go to s0 is done in case statements

process( clock )
begin
	if clock='1' and clock'event then
		if reset = '1' then
			state <= s0;
		--elsif (state = s0) then
		--	state <= s100;
		else
			if (instruction_type = "00") then --dp
				 
				if (DP_subtype = IMM) then
					case(state) is
						when s0 => state <= s100;
						when s100 => state <= s1;
						when s1 => state <= s4;
						when s4 => state <= s8;
						when s8 => state <= s19;
						when others => state <= s0;
					end case;
				elsif (DP_subtype = SHIFT_IMM) then
					case(state) is
 						when s0 => state <= s100;
						when s100 => state <= s1;
						when s1 => state <= s5;
						when s5 => state <= s8;
						when s8 => state <= s19;
						when others => state <= s0;
					end case;
				elsif (DP_subtype = SHIFT_REG) then
					case(state) is
 						when s0 => state <= s100;
						when s100 => state <= s2;
						when s2 => state <= s6;
						when s6 => state <= s1;
						when s1 => state <= s8;
						when s8 => state <= s19;
						when others => state <= s0;
					end case;
				end if;
			elsif instruction_type = "01" then --mul mla
				
				if instruction(21) = '0' then --mul
					case(state) is
 						when s0 => state <= s100;
						when s100 => state <= s2;
						when s2 => state <= s7;
						when s7 => state <= s21;
						when others => state <= s0;
					end case;
				else --mla
					case(state) is
 						when s0 => state <= s100;
						when s100 => state <= s2;
						when s2 => state <= s7;
						when s7 => state <= s3;
						when s3 => state <= s11;
						when s11 => state <= s22;
						when others => state <= s0;
					end case;
				end if ;
			elsif (instruction_type = "10") then --dt
				
				if (instruction(25) = '0') then -- imm offset
					if (instruction(20)='1') then -- load
						case(state) is
							when s0 => state <= s100;
							when s100 => state <= s1;
							when s1 => state <= s12;
							when s12 => state <= s15;
							when s15 => state <= s23;
							when s23 => state <= s22;
							when others => state <= s0;
						end case;
					else
						case(state) is
							when s0 => state <= s100;
							when s100 => state <= s1;
							when s1 => state <= s13;
							when s13 => state <= s24;
							when s24 => state <= s22;
							when others => state <= s0;
						end case;
					end if;
				else --reg offset
					if (instruction(20)='1') then -- load
						case(state) is
							when s0 => state <= s100;
							when s100 => state <= s1;
							when s1 => state <= s5;
							when s5 => state <= s8;
							when s8 => state <= s17;
							when s17 => state <= s23;	
							when others => state <= s0;
						end case;
					else
						case(state) is
							when s0 => state <= s100;
							when s100 => state <= s1;
							when s1 => state <= s5;
							when s5 => state <= s14;
							when s14 => state <= s24;
							when s24 => state <= s22;
							when others => state <= s0;
						end case;
					end if;
				end if;
			elsif (instruction_type = "11") then -- b and bl
				
				if (instruction(24)='0') then --b
					case(state) is
						when s0 => state <= s100;
						when s100 => state <= s9;
						when s9 => state <= s10;
						when others => state <= s0;
					end case;
				else --bl
					case(state) is
						when s0 => state <= s100;
						when s100 => state <= s20;
						when s2 => state <= s9;
						when s9 => state <= s10;
						when others => state <= s0;
					end case;
				end if;
			end if ;
		end if ;
	end if ;
--
end process ; --
end architecture ; -- arch