library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

package pkg is
	type opcode is (AND, EOR, SUB, RSB, ADD, SBC, RSC, TST, TEQ, SMP, SMN, ORR, MOV, BIC, MVN);
	type DP_type is (IMM, SHIFT_IMM, SHIFT_REG);
	type DT_type is (HALF_WORD, WORD);
end package ;

package body pkg is

end pkg;

entity controller is
  port (
	-- signals same as datapath but with input changed to output
	PW 		: out std_logic;
	IorD	: out std_logic;
	MR		: out std_logic;
	MW 		: out std_logic;
	IW 		: out std_logic;
	DW		: out std_logic;
	Rsrc 	: out std_logic;
	M2R		: out std_logic_vector(1 downto 0);	--changed
	RW 		: out std_logic;
	AW 		: out std_logic;
	BW 		: out std_logic;
	Asrc1	: out std_logic_vector(1 downto 0);	--changed
	Asrc2	: out std_logic_vector(1 downto 0);
	op		: out std_logic_vector(3 downto 0);
	Fset	: out std_logic;
	ReW		: out std_logic;
	--NOT in SLIDES
	clk 	: out std_logic;
	mul_w	: out std_logic;
	shift_w	: out std_logic;
	Rsrc1 	: out std_logic;
	L       : out std_logic;
	p2m_opcode: out std_logic_vector(1 downto 0);
    sign_opcode: out std_logic;
    p2m_offset : out std_logic_vector(1 downto 0);
    shifter_opcode: out std_logic_vector(1 downto 0);
	RWAD 	: out std_logic;

-------------------------------------------------------------
	Flags	: in std_logic_vector(3 downto 0);
	IR 		: in std_logic_vector(31 downto 0)
  ) ;
end controller ;

architecture arch of controller is

begin



end architecture ; -- arch