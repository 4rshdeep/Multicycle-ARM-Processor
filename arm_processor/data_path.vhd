entity data_path is
  port (
	PW 		: in std_logic;
	IorD	: in std_logic;
	MR		: in std_logic;
	MW 		: in std_logic;
	IW 		: in std_logic;
	DW		: in std_logic;
	Rsrc 	: in std_logic;
	M2R		: in std_logic;
	RW 		: in std_logic;
	AW 		: in std_logic;
	BW 		: in std_logic;
	Asrc1	: in std_logic;
	Asrc2	: in std_logic_vector(1 downto 0);
	op		: in std_logic_vector(3 downto 0);
	Fset	: in std_logic;
	ReW		: in std_logic;

	clk 	: in std_logic;

	Flags	: out std_logic_vector(3 downto 0);
	IR 		: out std_logic_vector(31 downto 0)
  ) ;
end entity ; 
architecture arch1 of data_path is

--component memory
--port();
--end component; --memory

-- size of mem_out = ir_out = dr_out
signal alu_in1 : std_logic_vector(3 downto 0);
signal alu_in2 : std_logic_vector(3 downto 0);
signal alu_out : std_logic_vector(3 downto 0);
signal flag_out: std_logic_vector(3 downto 0);
signal mem_out : std_logic_vector(31 downto 0); 
signal ir_out  : std_logic_vector(31 downto 0); 
signal pc_final: std_logic_vector(31 downto 0); --check size
signal alu_in2 : std_logic_vector(3 downto 0);
signal dr_out  : std_logic_vector(31 downto 0);
signal rf_rad2 : std_logic_vector(3 downto 0);
signal rf_wd   : std_logic_vector(31 downto 0);
	
begin

	MEMORY:
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
			write_data 		=> rf_wd
			read_add1 		=> ir_out(3 downto 0),
			read_add2 		=> rf_rad2,
			write_add 		=> ir_out(15 downto 12),
			clk 			=> clk,
			reset 			=> '0',
			write_enable 	=> RW,
			data_out1 		=> rf_out1,
			data_out2 		=> rf_out2,
			pc 				=> rf_wd,
		  ) ;

--------------------------
--- ALU MODULE SIGNALS ---
--------------------------
	alu_in1 <= pc_final when Asrc1='1' else aw_out;

	with Asrc2 select 
		alu_in2 <= bw_out when "00",
				   (2 => '1', others => '0') when "01",
				   ((others => '0') & ir_out(11 downto 0)) when "10",
				   ((others => ir_out(23) ) & ir_out(23 downto 0) & "00") when others;


-------------------------------
--- REGISTER MODULE SIGNALS ---
-------------------------------
	rf_rad2 <= ir_out(3 downto 0) when Rsrc='0' else ir_out(15 downto 12);
	rf_wd <= dr_out when M2R='1' else res_out;


--------------------------
---- REGISTERS OUTPUT ----
--------------------------
	res_out <= alu_out when ReW='1';

	aw_out <= rf_out1 when AW='1';
	bw_out <= rf_out2 when BW='1';

	ir_out <= mem_out when IW='1';

	dr_out <= mem_out when DW='1';


--------------------------
-- MEMORY MODULE SIGNALS--
--------------------------
	mem_ad <= pc_final when IorD='0' else res_out;


--------------------------
-------- OUTPUT ----------
--------------------------
	Flags <= flag_out when Fset='1';

	IR <= ir_out;  -- check this

end architecture ;	