library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
use ieee.numeric_std.all;
library work;
use work.all;



-- TODO MW is not used in datapath
entity data_path is
  port (

  	-- I think instead of MW we should have mem_enable 4 bits and remove corresponding signal inn the architecture.
	--MW 		: in std_logic;
	PW 		: in std_logic;
	IorD	: in std_logic_vector(1 downto 0);
	MR		: in std_logic;
	IW 		: in std_logic;
	DW		: in std_logic;
	Rsrc 	: in std_logic;
	M2R		: in std_logic_vector(2 downto 0);	--changed
	RW 		: in std_logic;
	AW 		: in std_logic;
	BW 		: in std_logic;
	Asrc1	: in std_logic_vector(1 downto 0);	--changed
	Asrc2	: in std_logic_vector(2 downto 0);
	op		: in std_logic_vector(3 downto 0);
	Fset	: in std_logic;
	ReW		: in std_logic;
	--NOT IN SLIDES
	clk 	: in std_logic;
	mul_w	: in std_logic;

	shift_w	: in std_logic;
	sh_op 	: in std_logic;
	sh_code : in std_logic;
	sh_amt 	: in std_logic_vector(1 downto 0);

	Rsrc1 	: in std_logic;
	L       : in std_logic;
	p2m_opcode: in std_logic_vector(1 downto 0);
    sign_opcode: in std_logic;
    p2m_offset : in std_logic_vector(1 downto 0);
    RWAD 	: in std_logic_vector(1 downto 0);
-- -------------------------------
	
    mem_enable : in std_logic_vector(3 downto 0) ;
-------------------------------------------------------------
	Flags	: out std_logic_vector(3 downto 0);
	IR 		: out std_logic_vector(31 downto 0)
  ) ;
end entity ;
architecture arch1 of data_path is

-- size of mem_out = ir_out = dr_out
signal alu_in1 : std_logic_vector(31 downto 0);
signal alu_in2 : std_logic_vector(31 downto 0);
signal alu_out : std_logic_vector(31 downto 0);
signal flag_out: std_logic_vector(3 downto 0);
signal mem_out : std_logic_vector(31 downto 0);
signal ir_out  : std_logic_vector(31 downto 0);
signal pc_final: std_logic_vector(31 downto 0); --check size
signal dr_out  : std_logic_vector(31 downto 0);
signal rf_rad1 : std_logic_vector(3 downto 0);
signal rf_rad2 : std_logic_vector(3 downto 0);
signal rf_wd   : std_logic_vector(31 downto 0);
signal res_out : std_logic_vector(31 downto 0);
signal aw_out  : std_logic_vector(31 downto 0);
signal bw_out  : std_logic_vector(31 downto 0);
signal rf_out1 : std_logic_vector(31 downto 0);
signal rf_out2 : std_logic_vector(31 downto 0);
signal mem_ad  : std_logic_vector(9 downto 0);
signal mul_out : std_logic_vector(31 downto 0);
signal mul_reg_out   : std_logic_vector(31 downto 0);
signal shift_reg_out : std_logic_vector(31 downto 0);
signal shift_out : std_logic_vector(31 downto 0);
signal shifter_op : std_logic_vector(1 downto 0);
signal shift_amount : std_logic_vector(4 downto 0);
signal shifter_opcode : std_logic_vector(7 downto 0);

--signal rf_rad2      : std_logic_vector(3 downto 0);
signal shift_carry   : std_logic;
signal mem_data		 : std_logic_vector(31 downto 0);

signal rf_wad		: std_logic_vector(3 downto 0);

signal p2m_in		: std_logic_vector(31 downto 0);
signal p2m_out		: std_logic_vector(31 downto 0);
signal p2m_enable	: std_logic_vector(3 downto 0);

signal rf_pc    : std_logic_vector(31 downto 0);

begin

--	MEMORY:
		--memory entity to be mapped here
		--inputs are mem_ad (signal) and res_out
		--output is mem_out

	P2M:
		ENTITY WORK.processor_memory (arch)
		-- change pr_data and mem_data to data_in only
		-- change byte_offset and load_addr to single offset only
		-- Isn't proc_to_mem same as load
			PORT MAP(
				pr_data 	=> p2m_in,
				mem_data 	=> p2m_in,
				proc_to_mem => L, 		--input from controller (load/store)
				load 		=> L,
				optype 		=> p2m_opcode,	--input from controller
				s 			=> sign_opcode, --input from controller
				load_addr 	=> p2m_offset,	--input from controller
				byte_offset => p2m_offset,	--input from controller
				out_to_pr	=> p2m_out,		--define signal
				out_to_mem	=> p2m_out,
				memory_enable => p2m_enable
			);

	MEMORY:
		ENTITY WORK.memory (arch)
			PORT MAP (
				address 	=> mem_ad,
				data_in 	=> mem_data,
				rd_enable 	=> MR,
				data_out 	=> mem_out,
				byte_offset => mem_enable,		 -- processor memory datapath gives a 4 bit signal which one to activate (memory enable)
				clk			=> clk
			);

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
			write_add 		=> rf_wad,
			--write_add 		=> ir_out(15 downto 12),
			clk 			=> clk,
			reset 			=> '0',
			write_enable 	=> RW,
			data_out1 		=> rf_out1,
			data_out2 		=> rf_out2,
			pc 				=> rf_pc      --changed rf_wd to rf_pc due to multiple driver error (CHECK)
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
			op 		=> shifter_op,
			opcode 	=> shifter_opcode,				--input from controller
			shamt 	=> shift_amount,			
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
				   (2 => '1', others => '0') when "01",		-- constant 4
				   (( 19 downto 0 => '0') & ir_out(11 downto 0)) when "10",		-- ex  ins[11-0] 
				   ((5 downto 0 => ir_out(23) ) & ir_out(23 downto 0) & "00") when "11",	-- s2 ins[23-0]
				   shift_reg_out when others;


------------------------------
--- SHIFTER MODULE SIGNALS ---
------------------------------
	shifter_opcode <= bw_out when sh_op='0' else ir_out(7 downto 0);

	shifter_op <= ir_out(6 downto 5) when sh_code='0' else "11";

	with sh_amt select 
		shift_amount <= aw_out(4 downto 0) when  "00",
						ir_out(11 downto 7) when "01",
						ir_out(11 downto 8) & '0' when others;



-------------------------------
--- REGISTER MODULE SIGNALS ---
-------------------------------
	rf_rad2 <= ir_out(3 downto 0) when Rsrc='0' else
			   ir_out(15 downto 12) ;
			  --"1110" when others ; -- link register

	with Rsrc1 select
		rf_rad1 <= ir_out(19 downto 16) when '0',
			       ir_out(11 downto 8) when others;


	with M2R select
		rf_wd <= p2m_out when "000",
				 res_out when "001",
				 mul_reg_out when "010",  -- check if mul_reg_out OR mul_out
				 pc_final when "011",
				 mem_out when others;   

	with RWAD select 
		rf_wd <= "1110" when "00",
				 ir_out(15 downto 12) when "01",
				 ir_out(19 downto 16) when others;


------------------------------
----- P2M MODULE SIGNALS -----
------------------------------
	p2m_in <= dr_out when L='1' else bw_out;


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
	with IorD select
		mem_ad <= pc_final(9 downto 0) when "01",
				  res_out(9 downto 0) when "00",
				  aw_out(9 downto 0) when others;
--    WHY PC AND RESULT ??? IT SHOULD BE ADDRESS

	mem_data <= p2m_out when L='0' else (others => '0');

	mem_enable <= p2m_enable when L='0' else (others => '0');

--------------------------
-------- OUTPUT ----------
--------------------------
	--Setting flags when only N and Z are to be set
	Flags <= flag_out when Fset='1';

	IR <= ir_out;  -- check this

end architecture ;