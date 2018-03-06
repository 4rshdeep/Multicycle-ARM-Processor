library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity data_path is
  port (
	PW 		: in std_logic;
	IorD	: in std_logic;
	MR		: in std_logic;
	MW 		: in std_logic;
	IW 		: in std_logic;
	DW		: in std_logic;
	Rsrc 	: in std_logic;
	M2R		: in std_logic_vector(1 downto 0);	--changed
	RW 		: in std_logic;
	AW 		: in std_logic;
	BW 		: in std_logic;
	Asrc1	: in std_logic_vector(1 downto 0);	--changed
	Asrc2	: in std_logic_vector(1 downto 0);
	op		: in std_logic_vector(3 downto 0);
	Fset	: in std_logic;
	ReW		: in std_logic;

	--NOT IN SLIDES
	clk 	: in std_logic;
	mul_w	: in std_logic;
	shift_w	: in std_logic;
	Rsrc1 	: in std_logic;

	Flags	: out std_logic_vector(3 downto 0);
	IR 		: out std_logic_vector(31 downto 0)
  ) ;
end entity ;
architecture arch1 of data_path is

-- size of mem_out = ir_out = dr_out
signal alu_in1 : std_logic_vector(3 downto 0);
signal alu_in2 : std_logic_vector(3 downto 0);
signal alu_out : std_logic_vector(3 downto 0);
signal flag_out: std_logic_vector(3 downto 0);
signal mem_out : std_logic_vector(31 downto 0);
signal ir_out  : std_logic_vector(31 downto 0);
signal pc_final: std_logic_vector(31 downto 0); --check size
signal dr_out  : std_logic_vector(31 downto 0);
signal rf_rad2 : std_logic_vector(3 downto 0);
signal rf_wd   : std_logic_vector(31 downto 0);
signal res_out : std_logic_vector(31 downto 0);
signal aw_out  : std_logic_vector(31 downto 0);
signal bw_out  : std_logic_vector(31 downto 0);
signal rf_out1 : std_logic_vector(31 downto 0);
signal rf_out2 : std_logic_vector(31 downto 0);
signal mem_ad  : std_logic_vector(31 downto 0); 
signal mul_out : std_logic_vector(31 downto 0); 
signal mul_reg_out   : std_logic_vector(31 downto 0); 
signal shift_reg_out : std_logic_vector(31 downto 0); 
signal shift_reg_out : std_logic_vector(31 downto 0); 
signal shift_carry   : std_logic;

begin

--	MEMORY:
		--memory entity to be mapped here
		--inputs are mem_ad (signal) and res_out
		--output is mem_out

	ALU:
		ENTITY WORK.ALU (behaviour_alu)
			PORT MAP (
			a 		=> alu_in1,
			b 		=> alu_in2,
			result 	=> alu_out,
			nzvc	=> flag_out,
			carry	=> '0',
			opcode	=> op
			);

	RF:
		ENTITY WORK.reg (behaviour_reg)
		  PORT MAP (
			write_data 		=> rf_wd,
			read_add1 		=> ir_out(3 downto 0),
			read_add2 		=> rf_rad2,
			write_add 		=> ir_out(15 downto 12),
			clk 			=> clk,
			reset 			=> '0',
			write_enable 	=> RW,
			data_out1 		=> rf_out1,
			data_out2 		=> rf_out2,
			pc 				=> rf_wd
		  ) ;


	Multiplier:
		ENTITY WORK.multiplier (behaviour_multiplier)
		  PORT MAP (
			op1 	=> aw_out,
			op2 	=> bw_out,
			result 	=> mul_out
		  ) ;
		

	Shifter:
		ENTITY WORK.shifter (behaviour_shifter)
		  PORT MAP (
			op 		=> bw_out,
			opcode 	=> shifter_opcode,	--input from controller
			shamt 	=> aw_out,			--shift amt comes from a_out (First read port of register) 
			carry	=> shift_carry,
			result	=> shift_out
		  ) ;


--------------------------
--- ALU MODULE SIGNALS ---
--------------------------
	--alu_in1 <= pc_final when Asrc1='1' else aw_out;
	with Asrc1 select
		alu_in1 <= pc_final when "00",
				   aw_out when "01",
				   mul_reg_out when others;

	with Asrc2 select
		alu_in2 <= bw_out when "00",
				   (2 => '1', others => '0') when "01",
				   (( 19 downto 0 => '0') & ir_out(11 downto 0)) when "10",
				   ((5 downto 0 => ir_out(23) ) & ir_out(23 downto 0) & "00") when "11",
				   shift_reg_out when others;



-------------------------------
--- REGISTER MODULE SIGNALS ---
-------------------------------
	rf_rad2 <= ir_out(3 downto 0) when Rsrc='0' else ir_out(15 downto 12);
	
	with Rsrc1 select 
		rf_rad1 <= ir_out(19 downto 16) when '0',
			       ir_out(11 downto 8) when others;


	with M2R select
		rf_wd <= dr_out when "01",
				 res_out when "00",
				 mul_reg_out when "10",  -- check if mul_reg_out OR mul_out
				 pc when others;
	--rf_wd <= dr_out when M2R='1' else res_out;



--------------------------
---- REGISTERS OUTPUT ----
--------------------------
	res_out <= alu_out when ReW='1';

	aw_out <= rf_out1 when AW='1';
	bw_out <= rf_out2 when BW='1';

	ir_out <= mem_out when IW='1';

	dr_out <= mem_out when DW='1';

	mul_reg_out <= mul_out when mul_w='1';

	shift_reg_out <= shift_out when shift_w='1';


--------------------------
-- MEMORY MODULE SIGNALS--
--------------------------
	mem_ad <= pc_final when IorD='0' else res_out;


--------------------------
-------- OUTPUT ----------
--------------------------
	--Setting flags when only N and Z are to be set
	Flags <= flag_out when Fset='1';

	IR <= ir_out;  -- check this

end architecture ;