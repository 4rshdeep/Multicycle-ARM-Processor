library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;

entity shifter is
  port (
	op : in std_logic_vector(31 downto 0);
	opcode : in std_logic_vector(1 downto 0);
	shamt : in std_logic_vector(4 downto 0);
	carry : out std_logic;
	result : out std_logic_vector(31 downto 0)
  ) ;
end shifter ;

architecture behaviour_shifter of shifter is
signal shift_int : integer;

begin
shift_int <= to_integer(unsigned(shamt));

shifter_process : process( op, opcode, shamt, carry )
begin
	-- 00 -> lsl
	-- 01 -> lsr
	-- 11 -> asr
	-- 10 -> ror
	case( opcode ) is

		when "00" =>
				result <= shift_left(unsigned(op), shift_int);
				if shift_int /= 0 then
					carry <= op(32-shift_int);
				end if ;
		when "01" =>
				result <= shift_right(unsigned(op), shift_int);
				if shift_int /= 0 then
					carry <= op(shift_int-1);
				end if ;
		when "11" =>
				result <= shift_right(signed(op), shift_int);
				if shift_int /= 0 then
					carry <= op(shift_int-1);
				end if ;
		when "10" =>
				result <= op(shift_int-1 downto 0) & op(31 downto shift_int);
				if shift_int /= 0 then
					carry <= op(shift_int-1);
				end if ;
		when others =>
				result <= (others => '0');

	end case ;


end process ; -- shifter_process


end architecture ; -- behaviour_shifter