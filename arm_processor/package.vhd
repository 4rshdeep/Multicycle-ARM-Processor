package pkg is
	type opcode is (ANDD, EOR, SUB, RSB, ADD, ADC, SBC, CMP, CMN, RSC, TST, TEQ, SMP, SMN, ORR, MOV, BIC, MVN);
	type DP_type is (IMM, SHIFT_IMM, SHIFT_REG);
	type DT_type is (HALF_WORD, WORD);
    type state_type is (s100, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25);
end package ;

package body pkg is

end pkg;
