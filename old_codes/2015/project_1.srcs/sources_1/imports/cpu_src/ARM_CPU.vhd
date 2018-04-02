----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 23:10:04 03/24/2017
-- Design Name:
-- Module Name: ARM_CPU - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.MyTypes.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY ARM_CPU IS
	PORT (
		CLK_CPU : IN STD_LOGIC;
		RST : IN std_logic;
		WEA_MEM : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		ADDR_MEM : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		DIN_MEM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DOUT_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ARM_CPU;

ARCHITECTURE Behavioral OF ARM_CPU IS

	COMPONENT ARM_multiplier IS
		PORT (
			operand1 : IN std_logic_vector (31 DOWNTO 0);
			operand2 : IN std_logic_vector (31 DOWNTO 0);
			result : OUT std_logic_vector (31 DOWNTO 0);
			N_mul : OUT std_logic;
			Z_mul : OUT std_logic
		);
	END COMPONENT;
	COMPONENT ARM_alu
		PORT (
			operand1 : IN word;
			operand2 : IN word;
			condition : IN nibble;
			operation : IN optype;
			not_implemented : IN std_logic;
			undefined : IN std_logic;
			Flags : IN nibble;
			shifter_carry : IN std_logic;
			nextFlags : OUT nibble;
			result : OUT word;
			predicate : OUT std_logic
		);
	END COMPONENT;
	COMPONENT Control_FSM
		PORT (
			 instr_class : in  instr_class_type;
                     DT_subclass : in DT_subclass_type;
                     DP_subclass: in DP_subclass_type;
                     opt : in optype;
                     instr : in std_logic_vector(31 downto 0);
       --              instr_20 : in std_logic;
                     rst : in std_logic;
                     control_state_out : out  control_state_type;
                     clock : in std_logic);
	END COMPONENT;
	COMPONENT Shifter
		PORT (
			Shifter_in : IN word;
			Shifter_out : OUT word;
			Shift_type : IN bit_pair;
			Shift_amount : IN Shift_amount_type;
			c_in : IN std_logic;
			c_out : OUT std_logic
		);
	END COMPONENT;
	COMPONENT Decoder
		PORT (
			instruction : IN word;
			instr_class : OUT instr_class_type;
			DT_subclass : OUT DT_subclass_type;
			DP_subclass : OUT DP_subclass_type;
			operation : OUT optype;
			undefined : OUT STD_LOGIC;
			not_implemented : OUT STD_LOGIC
		);
	END COMPONENT;
	COMPONENT Actions
		PORT (
			clock : IN std_logic;
			control_state : IN control_state_type;
			instruction : OUT word;
			operation : IN optype;
			op1_alu : OUT word;
			op2_alu : OUT word;
			result_alu : IN word;
			op1_mul : OUT word;
			op2_mul : OUT word;
			N_mul: in std_logic;
			Z_mul: in std_logic;
			result_mul : IN word;
			nextFlags : IN nibble;
			Flags : OUT nibble;
			rst : IN std_logic;
			predicate : IN std_logic;
			Shifter_in : OUT word;
			Shifter_out : IN word;
			Shift_amount : OUT Shift_amount_type;
			Shift_type : OUT bit_pair;
			WEA_MEM : OUT nibble;
			ADDR_MEM : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			DIN_MEM : OUT word;
			DOUT_MEM : IN word;
			not_implemented : IN std_logic;
			DT_subclass: in DT_subclass_type;
			undefined : IN std_logic
		);
	END COMPONENT;
        SIGNAL op1_alu : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL op2_alu : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL res_alu : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL cond : nibble := (OTHERS => '0');
        SIGNAL operation : optype;
        SIGNAL not_imp : std_logic := '0';
        SIGNAL undef : std_logic := '0';
        SIGNAL shift_carry : std_logic := '0';
        SIGNAL predicate : std_logic := '0';
        SIGNAL flags : nibble:= (others => '0');
        SIGNAL nxt_flags : nibble:= (others => '0'  );
        SIGNAL instruction : word := (others => '0'  );
        SIGNAL instr_class : instr_class_type;
        SIGNAL DT_subclass : DT_subclass_type;
        SIGNAL DP_subclass : DP_subclass_type;
        SIGNAL cont_state : control_state_type;
        SIGNAL op1_mul : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL op2_mul : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL res_mul : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
        SIGNAL Shifter_in : word:= (others => '0'  );
        SIGNAL Shifter_out : word:= (others => '0'  );
        SIGNAL Shift_amount : Shift_amount_type:= (others => '0'  );
        SIGNAL Shift_type : bit_pair:= (others => '0'  );
        SIGNAL WEA_MEM_C : nibble:= (others => '0'  );
        SIGNAL ADDR_MEM_C : STD_LOGIC_VECTOR(11 DOWNTO 0):= (others => '0'  );
        SIGNAL DIN_MEM_C : word:= (others => '0'  );
        SIGNAL c_in : std_logic:= '0';
        SIGNAL c_out : std_logic:= '0';
        SIGNAL N_mul: std_logic:= '0';
        SIGNAL Z_mul: std_logic := '0';
BEGIN
	
	
	Actor :  Actions port map (
        clock  => CLK_CPU,
		control_state => cont_state,
		instruction => instruction,
		operation => operation,
		op1_alu => op1_alu,
		op2_alu => op2_alu,
		result_alu => res_alu,
		op1_mul => op1_mul,
		op2_mul => op2_mul,
        N_mul => N_mul,
        Z_mul => Z_mul,
		result_mul => res_mul,
		nextFlags => nxt_flags, 
		Flags => flags, 
		rst => RST, 
		predicate => predicate, 
		Shifter_in => Shifter_in, 
		Shifter_out => Shifter_out, 
		Shift_amount => Shift_amount, 
		Shift_type => Shift_type, 
		WEA_MEM => WEA_MEM_C, 
		ADDR_MEM => ADDR_MEM_C, 
		DIN_MEM =>  DIN_MEM_C, 
		DOUT_MEM => DOUT_MEM,
		DT_subclass=> DT_subclass,
		not_implemented => not_imp, 
		undefined => undef
	);

	myFSM : Control_FSM port map (
		instr_class  => instr_class , 
		DT_subclass  =>  DT_subclass, 
		DP_subclass =>  DP_subclass, 
		opt  =>  operation, 
		instr  => instruction , 
		rst  =>  RST, 
		control_state_out  => cont_state , 
		clock  =>  CLK_CPU 
	);

	myDec : Decoder
	PORT MAP(
		instruction => instruction,
		instr_class => instr_class,
		DT_subclass => DT_subclass,
		DP_subclass => DP_subclass,
		operation => operation,
		undefined => undef,
		not_implemented => not_imp
	);
	myShift : Shifter
	PORT MAP(

		Shifter_in => Shifter_in,
		Shifter_out => Shifter_out,
		Shift_type => Shift_type,
		Shift_amount => Shift_amount,
		c_in => c_in,
		c_out => c_out
	);

	myALU : ARM_alu
	PORT MAP(
		operand1 => op1_alu,
		operand2 => op2_alu,
		condition => cond,
		operation => operation,
		not_implemented => not_imp,
		undefined => undef,
		Flags => flags,
		shifter_carry => shift_carry,
		nextFlags => nxt_flags,
		result => res_alu,
		predicate => predicate
	);

	myMUL : ARM_multiplier
	PORT MAP(
		operand1 => op1_mul,
		operand2 => op2_mul,
		result => res_mul,
		N_mul => N_mul,
		Z_mul => Z_mul
	);
	WEA_MEM <= WEA_MEM_C ;
    ADDR_MEM <= ADDR_MEM_C;
    DIN_MEM <= DIN_MEM_C; 
	cond <= instruction( 31 downto 28);
END Behavioral;