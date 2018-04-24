--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all; -- for addition & counting
--USE ieee.numeric_std.all;
--use ieee.numeric_bit;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity shifter is
  port (
	op : in std_logic_vector(31 downto 0);
	opcode : in std_logic_vector(1 downto 0);
	shamt : in std_logic_vector(4 downto 0);
	carry : out std_logic;
	result : out std_logic_vector(31 downto 0);
	reset : in std_logic
  ) ;
end shifter ;

architecture behaviour_shifter of shifter is
signal shift_int : integer;
--signal res1 : sl

begin
shift_int <= to_integer(unsigned(shamt));

with opcode select
	result <=  (std_logic_vector(shift_left(unsigned(op), shift_int))) when  "00", 
			   (std_logic_vector(shift_right(unsigned(op), shift_int))) when "01",
			   (std_logic_vector(shift_right(signed(op), shift_int))) when "11",
			   (std_logic_vector( unsigned(op) ror shift_int)) when others;

--with shift_int select
--	carry <= carry_sig when shift_int /= 0;

--with opcode select
--	carry_sig <= op(32-shift_int) when "00",
	carry <= '0';			


--shifter_process : process( op, opcode, shamt)
----variable 
--begin
--	-- 00 -> lsl
--	-- 01 -> lsr
--	-- 11 -> asr
--	-- 10 -> ror
--	if (reset = '1') then
--		carry <= '0';
--		result <= (others => '0');
--	else
--		case( opcode ) is

--			when "00" =>
--					result <= std_logic_vector(shift_left(unsigned(op), shift_int));
--					if shift_int /= 0 then
--						carry <= op(32-shift_int);
--					end if ;
--			when "01" =>
--					result <= std_logic_vector(shift_right(unsigned(op), shift_int));
--					if shift_int /= 0 then
--						carry <= op(shift_int-1);
--					end if ;
--			when "11" =>
--					result <= std_logic_vector(shift_right(signed(op), shift_int));
--					if shift_int /= 0 then
--						carry <= op(shift_int-1);
--					end if ;
--			when "10" =>
--	--				result <= op(shift_int-1 downto 0) & op(31 downto shift_int);
--	                result <= std_logic_vector( unsigned(op) ror shift_int);
--					if shift_int /= 0 then
--						carry <= op(shift_int-1);
--					end if ;
--			when others =>
--					result <= (others => '0');

--		end case ;

--	end if;

--end process ; -- shifter_process


end architecture ; -- behaviour_shifter