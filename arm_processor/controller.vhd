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
    type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25);
end package ;

package body pkg is

end pkg;

entity controller is
  port (
    -- signals same as datapath but with input changed to output
    PW      : out std_logic;
    IorD    : out std_logic;
    MR      : out std_logic;
    MW      : out std_logic;
    IW      : out std_logic;
    DW      : out std_logic;
    Rsrc    : out std_logic;
    M2R     : out std_logic_vector(1 downto 0); --changed
    RW      : out std_logic;
    AW      : out std_logic;
    BW      : out std_logic;
    Asrc1   : out std_logic_vector(1 downto 0); --changed
    Asrc2   : out std_logic_vector(1 downto 0);
    Fset    : out std_logic;
    ReW     : out std_logic;
    mem_enable : out std_logic_vector(3 downto 0) ;
    --NOT in SLIDES
    --clk           : out std_logic;
    mul_w           : out std_logic;
    shift_w         : out std_logic;
    Rsrc1           : out std_logic;
    L               : out std_logic;
    p2m_opcode      : out std_logic_vector(1 downto 0);
    sign_opcode     : out std_logic;
    p2m_offset      : out std_logic_vector(1 downto 0);
    RWAD            : out std_logic;
------------------------------------
    state           : in state_type
    --instruction   : out std_logic_vector(31 downto 0) ;
    --IR        : in std_logic_vector(31 downto 0)
    --op                : in opcode;
    reset           : in std_logic;

-- newly added shifter
    sh_code         : out std_logic;
    sh_op           : out std_logic;
    sh_amt          : out std_logic;

-- predicate
    predicate       : in std_logic
-------------------------------------------------------------
  ) ;
end controller ;

signal MW_signal   : std_logic;
signal Fset_signal : std_logic;
signal RW          : std_logic;

architecture arch of controller is

    MW   <= predicate and MW_signal;
    Fset <= predicate and Fset_signal;
    RW   <= predicate and RW_signal;

begin

----------------------------------------

--Take care of these signals
-- PW, DW, L ,RW

-- DW not assigned in any state

    process(state, reset, p)
    begin
        if (reset = '1') then
            PW          <= (others => '0');
            IorD        <= (others => '0');
            MR          <= (others => '0');
            MW_signal   <= (others => '0');
            IW          <= (others => '0');
            DW          <= (others => '0');
            Rsrc        <= (others => '0');
            M2R         <= (others => '0');
            RW_signal   <= (others => '0');
            AW          <= (others => '0');
            BW          <= (others => '0');
            Asrc1       <= (others => '0');
            Asrc2       <= (others => '0');
            Fset_signal <= (others => '0');
            ReW         <= (others => '0');
            mem_enable  <= (others => '0');
            mul_w       <= (others => '0');
            shift_w     <= (others => '0');
            Rsrc1       <= (others => '0');
            L           <= (others => '0');
            p2m_opcode  <= (others => '0');
            sign_opcode <= (others => '0');
            p2m_offset  <= (others => '0');
            RWAD        <= (others => '0');
            sh_code     <= (others => '0');
            sh_op       <= (others => '0');
            sh_amt      <= (others => '0');
        else
            case(state) is
                when s0  =>  
                    IorD        <= "00";
                    IW          <= '1';
                    MR          <= '1';

                    -- Fetch PC = PC + 4
                    PW  <= '1';

                when s1  =>  
                    AW          <= '1';
                    BW          <= '1';
                    Rsrc1       <= '0';
                    Rsrc        <= '0';
                
                when s2  =>  
                    AW          <= '1';
                    BW          <= '1';
                    Rsrc        <= '0';
                    Rsrc1       <= '1';
                
                when s3  =>  
                    AW          <= '0';
                    BW          <= '1';
                    Rsrc        <= '1';
                    -- Rsrc1 not assigned rdB
                
                when s4  =>  
                    shift_w     <= '1';
                    sh_op       <= '1';
                    sh_code     <= '1';
                    sh_amt      <= "10";

                when s5  =>  
                    shift_w     <= '1';
                    sh_amt      <= "01";
                    sh_op       <= '0';
                    sh_code     <= '0';
                
                when s6  =>  
                    shift_w     <= '1';
                    sh_op       <= '0';
                    sh_code     <= '0';
                    sh_amt      <= "00";

                when s7  =>  
                    mul_w <= '1';
                
                when s8  =>  
                    Asrc1       <= "01";
                    Asrc2       <= "100";
                    Fset_signal <= predicate;
                    ReW         <= '1';

                when s9  =>  
                    Asrc1 <= "00";
                    Asrc2 <= "001";
                    Fset_signal <= predicate;
                    ReW <= '1';
                    -- write PC + 4
                    PW <= '1';

                when s10 =>  
                    Asrc1       <= "00";
                    Asrc2       <= "011";
                    Fset_signal <= predicate;
                    ReW         <= '1';
                    -- write PC + offset
                    PW <= '1';

                when s11 =>  
                    Asrc1       <= "10";
                    Asrc2       <= "011";
                    Fset_signal <= predicate;
                    ReW         <= '1';

                when s12 =>  
                    Asrc1       <= "01";
                    Asrc2       <= "010";
                    Fset_signal <= '1';
                    ReW         <= '1';

                when s13 =>  
                    Asrc1       <= "01";
                    Asrc2       <= "010";
                    Fset_signal <= predicate;
                    ReW         <= '1';
                    BW          <= '1';
                    Rsrc        <= '1';

                when s14 =>  
                    Asrc1       <= "01";
                    Asrc2       <= "100";
                    Fset_signal <= predicate;
                    ReW         <= '1';
                    BW          <= '1';
                    Rsrc        <= '1';

                when s15 =>  
                    MR          <= '1';
                    IorD        <= "01";
                    IW          <= '0';

                when s16 =>  
                    MR          <= '1';
                    IorD        <= "10";
                    IW          <= '0';

                when s17 =>  
                    MR          <= '1';
                    IorD        <= "01";
                    RWAD        <= "10";
                    M2R         <= "001";
                    RW_signal   <= '1';

                when s18 =>  
                    MR          <= '1';
                    IorD        <= "10";
                    RWAD        <= "10";
                    M2R         <= "001";
                    RW_signal   <= '1';
                
                when s19 =>  
                    RWAD        <= "01";
                    M2R         <= "001";
                    RW_signal   <= '1';
                
                when s20 =>  
                    RWAD        <= "00";
                    M2R         <= "011";
                    RW_signal   <= '1';
                
                when s21 =>  
                    RWAD        <= "10";
                    M2R         <= "010";
                    RW_signal   <= '1';
                
                when s22 =>  
                    RWAD        <= "10";
                    M2R         <= "001";
                    RW_signal   <= '1';
                
                when s23 =>
                    RWAD        <= "01";
                    M2R         <= "100";
                    RW_signal   <= '1';

                when s24 =>  
                    IorD        <= "01";
                    mem_enable  <= "1111";

                when s25 =>
                    IorD        <= "10";
                    mem_enable  <= "1111";
            end case;
        end if;

    end process;

end architecture ; -- arch