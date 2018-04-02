library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.MyTypes.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Actions is
	port (
		clock : in std_logic;
		control_state : in control_state_type;
		instruction : out word;
		operation : in optype;
		op1_alu : out word;
		op2_alu : out word;
		result_alu : in word;
		op1_mul: out word;
		op2_mul: out word;
        N_mul: in std_logic;
        Z_mul: in std_logic;
		result_mul: in word;
		nextFlags : in nibble;
		Flags : out nibble;
		rst : in std_logic;
		predicate : in std_logic;
		Shifter_in : out word;
		Shifter_out : in word;
		Shift_amount : out Shift_amount_type;
		Shift_type : out bit_pair;
		WEA_MEM : out nibble;
		ADDR_MEM : out STD_LOGIC_VECTOR(11 DOWNTO 0);
		DIN_MEM : out word;
		DOUT_MEM : in word;
		not_implemented : in std_logic;
        DT_subclass: in DT_subclass_type;
		undefined : in std_logic
   );
end Actions;


architecture Behavioral of Actions is


component ARM_rf is
    port (
        inp1 : in std_logic_vector (3 downto 0);
        inp2 : in std_logic_vector (3 downto 0);
        data : in std_logic_vector (31 downto 0);
        is_write : in std_logic;
        out1 : out std_logic_vector (31 downto 0);
        out2 : out std_logic_vector (31 downto 0);
        rst: in std_logic
    );
end component;

signal inp1_sig :std_logic_vector (3 downto 0):= (others => '0'  );
signal inp2_sig :std_logic_vector (3 downto 0):= (others => '0'  );
signal data_sig :std_logic_vector (31 downto 0):= (others => '0'  );
signal is_write_sig :std_logic := '0';
signal out1_sig :std_logic_vector (31 downto 0):= (others => '0'  );
signal out2_sig :std_logic_vector (31 downto 0):= (others => '0'  );
signal instr: std_logic_vector (31 downto 0):= (others => '0'  );
signal flags_sig: nibble := (others => '0');

signal A: std_logic_vector(31 downto 0) := (others => '0'  );
signal B: std_logic_vector(31 downto 0):= (others => '0'  );
signal C: std_logic_vector(31 downto 0):= (others => '0'  );
signal D: std_logic_vector(31 downto 0):= (others => '0'  );
signal O: std_logic_vector(31 downto 0):= (others => '0'  );
signal E: std_logic_vector(31 downto 0):= (others => '0'  );
signal Res: std_logic_vector(31 downto 0):= (others => '0'  );
signal DR: std_logic_vector(31 downto 0):= (others => '0'  );
signal PC: std_logic_vector(31 downto 0):= (others => '0'  );

begin


RF: ARM_rf port map (
        inp1=>      inp1_sig,
        inp2 =>     inp2_sig,
        data=>      data_sig,
        is_write => is_write_sig,
        out1 =>     out1_sig,
        out2 =>     out2_sig,
        rst =>      rst
);

--instruction <= instr;
instruction <= instr when rst='0' else
                (others => '0');
process(control_state,PC,result_alu,result_mul,DOUT_MEM,not_implemented,undefined,Shifter_out,predicate,rst,out1_sig,out2_sig)

begin

if (rst = '1') then
    A <= (others => '0');
    B <= (others => '0');
    C <= (others => '0');
    D <= (others => '0');
    O <= (others => '0');
    E <= (others => '0');
    Res <= (others => '0');
    DR <= (others => '0');
    PC <= (others => '0');
    instr <= (others => '0');
    inp1_sig <= (others => '0');
    inp2_sig <= (others => '0');
    data_sig <= (others => '0');
    op1_mul <= (others => '0');
    op2_mul <= (others => '0');
    op1_alu <= (others => '0');
    op2_alu <= (others => '0');
    Flags <= (others => '0');
    flags_sig <= (others => '0');
    is_write_sig <= '0';
else

    case control_state is
         when s0 =>
              WEA_MEM <= "0000";
              inp1_sig <= "1111";
              PC <= out1_sig;
              ADDR_MEM <= PC(13 downto 2);
              is_write_sig <= '0';
         when s23 =>
              inp2_sig <= "1111";
              data_sig <= PC+4;
              is_write_sig <= '1';
         when s24 =>
              is_write_sig <= '0';
         when s25 =>
              is_write_sig <= '0';
         when s1 =>
              instr <= DOUT_MEM;
              inp1_sig <= DOUT_MEM(19 downto 16);
              inp2_sig <= DOUT_MEM(3 downto 0);
              A <= out1_sig;
              B <= out2_sig;
              is_write_sig <= '0';
         when s2 =>
            D <= std_logic_vector(rotate_right(to_unsigned(to_integer(unsigned(instr(7 downto 0))),32),(to_integer(unsigned(instr(11 downto 8))))*2));
         when s3 =>
            Shifter_in <= B;
            Shift_amount <= instr (11 downto 7) ;
            Shift_type <= instr (6 downto 5);
            D <= Shifter_out;
            is_write_sig <= '0';
         when s4 =>
            inp1_sig <= instr(11 downto 8);
            C <= out1_sig;
            is_write_sig <= '0';
         when s5 =>
              Shifter_in <= B;
              Shift_amount <= C (4 downto 0) ;
              Shift_type <= instr (6 downto 5);
              D <= Shifter_out;
            is_write_sig <= '0';
         when s6 =>
            op1_alu <= A;
            op2_alu <= D;
            Flags <= flags_sig;
            Res <= result_alu;
            is_write_sig <= '0';
         when s7 =>
             if( (operation=TST) or (operation=TEQ) or (operation=CMP) or (operation=CMN) or (instr(20)='1')) then
                 flags_sig <= nextFlags;
                 Flags <= nextFlags;
             end if;
             inp2_sig <= instr ( 15 downto 12 );
             data_sig <= Res;
             is_write_sig <= predicate;
         when s8 =>
            inp1_sig <= instr(11 downto 8);
            A <= out1_sig;
            inp2_sig <= instr(15 downto 12);
            C <= out2_sig;
            is_write_sig <= '0';
         when s9 =>
            op1_mul <= A;
            op2_mul <= B;
            D <= result_mul;
            is_write_sig <= '0';
         when s10 =>
            op1_alu <= C;
            op2_alu <= D;
            Flags <= flags_sig;
            Res <= result_alu;
            is_write_sig <= '0';
         when s11 =>
            if( (operation=TST) or (operation=TEQ) or (operation=CMP) or (operation=CMN) or (instr(20)='1')) then
                 flags_sig <= nextFlags;
                 Flags <= nextFlags;
            end if;
            inp2_sig <= instr(19 downto 16);
            data_sig <= Res;
            is_write_sig <= predicate;
         when s12 =>
            inp2_sig <= "1110";
            data_sig <= PC+4;
            is_write_sig <= predicate;
         when s13 =>
            inp2_sig <= "1111";
            data_sig <= std_logic_vector(to_signed((to_integer(signed(instr(23 downto 0)))*4)+to_integer(signed(PC))+8,32));
            is_write_sig <= predicate;
         when s14 =>
            O <= X"00000" & instr (11 downto 0);
            inp1_sig <= instr(15 downto 12);
            C <= out1_sig;
            is_write_sig <= '0';
         when s15 =>
           Shifter_in <= B;
           Shift_amount <= instr( 11 downto 7) ;
           Shift_type <= instr (6 downto 5);
           O <= Shifter_out;
           inp1_sig <= instr(15 downto 12);
           C <= out1_sig;
           is_write_sig <= '0';
         when s16 =>
            inp1_sig <= instr(15 downto 12);
            C <= out1_sig;
            O <= B;
            is_write_sig <= '0';
         when s17 =>
            inp1_sig <= instr(15 downto 12);
            C <= out1_sig;
            O <= X"000000" & instr(11 downto 8) & instr (3 downto 0) ;
            is_write_sig <= '0';
         when s18 =>
            op1_alu <= A;
            op2_alu <= O;
            Flags <= flags_sig;
            D <= result_alu;
            is_write_sig <= '0';

         when s19 =>
            inp2_sig <= instr(19 downto 16);
            data_sig <= D;
            is_write_sig <= predicate;

         when s20 =>
            WEA_MEM <= "0000";
            if (instr(24) = '0') then
                ADDR_MEM <= A(13 downto 2);
                DR <= A;
            else
                ADDR_MEM <= D(13 downto 2);
                DR <= D;
            end if;
         when s21 =>
            -- If Half Word Store
            if (DT_subclass = HWRD) then
                DIN_MEM <= C(15 downto 0)&C(15 downto 0);
                -- Deciding source whether A or D
                if (instr(24) = '0') then
                    ADDR_MEM <= A(13 downto 2);
                    -- Whether to write of lower half word or upper half word
                    if(A(0)='0') then
                        WEA_MEM <= "0011";
                    else
                        WEA_MEM <= "1100";
                    end if;
                else
                    ADDR_MEM <= D(13 downto 2);
                    if(D(0)='0') then
                        WEA_MEM <= "0011";
                    else
                        WEA_MEM <= "1100";
                    end if;
                end if;
            else
                -- Deciding whether Word store or Byte Store
                if(instr(22)='1') then
                    -- Byte Store
                    DIN_MEM <= C(7 downto 0)&C(7 downto 0)&C(7 downto 0)&C(7 downto 0);
                    -- Deciding source whether A or D
                    if (instr(24) = '0') then
                        ADDR_MEM <= A(13 downto 2);
                        if (A(1 downto 0)="00") then
                            WEA_MEM <= "0001";
                        elsif (A(1 downto 0)="01") then
                            WEA_MEM <= "0010";
                        elsif (A(1 downto 0)="10") then
                            WEA_MEM <= "0100";
                        else
                            WEA_MEM <= "1000";
                        end if;
                    else
                        ADDR_MEM <= D(13 downto 2);
                        if (D(1 downto 0)="00") then
                            WEA_MEM <= "0001";
                        elsif (D(1 downto 0)="01") then
                            WEA_MEM <= "0010";
                        elsif (D(1 downto 0)="10") then
                            WEA_MEM <= "0100";
                        else
                            WEA_MEM <= "1000";
                        end if;
                    end if;
                else
                    -- Word Store
                    DIN_MEM <= C;
                    WEA_MEM <= "1111";
                    -- Deciding source whether A or D
                    if (instr(24) = '0') then
                        ADDR_MEM <= A(13 downto 2);
                    else
                        ADDR_MEM <= D(13 downto 2);
                    end if;
                end if;
            end if;
         when s22 =>
            inp2_sig <= instr(15 downto 12);
            is_write_sig <= predicate;
            if (DT_subclass = HWRD) then
                -- LDRH LDRSH LDRSB cases
                if(instr = "00") then
                    -- SWP instruction
                    is_write_sig <= '0';
                elsif (instr = "01") then
                    -- LDRH case
                    data_sig <= (others => '0');
                    if (DR(0)='0') then
                        data_sig(15 downto 0) <= DOUT_MEM(15 downto 0);
                    else
                        data_sig(15 downto 0) <= DOUT_MEM(31 downto 16);
                    end if;
                elsif (instr = "10") then
                    -- LDRSB case
                    if (DR(1 downto 0)= "00") then
                        data_sig(7 downto 0) <= DOUT_MEM(7 downto 0);
                        data_sig(31 downto 8) <= (others => DOUT_MEM(7));
                    elsif (DR(1 downto 0)= "01") then
                        data_sig(7 downto 0) <= DOUT_MEM(15 downto 8);
                        data_sig(31 downto 8) <= (others => DOUT_MEM(15));
                    elsif (DR(1 downto 0)= "10") then
                        data_sig(7 downto 0) <= DOUT_MEM(23 downto 16);
                        data_sig(31 downto 8) <= (others => DOUT_MEM(23));
                    else
                        data_sig(7 downto 0) <= DOUT_MEM(31 downto 24);
                        data_sig(31 downto 8) <= (others => DOUT_MEM(31));
                    end if;
                else
                    -- LDRSH case
                    if (DR(0)='0') then
                        data_sig(15 downto 0) <= DOUT_MEM(15 downto 0);
                        data_sig(31 downto 16) <= (others => DOUT_MEM(15));
                    else
                        data_sig(15 downto 0) <= DOUT_MEM(31 downto 16);
                        data_sig(31 downto 16) <= (others => DOUT_MEM(31));
                    end if;
                end if;
            else
                -- LDR LDRB cases
                if (instr(22)='0') then
                    -- LDR case
                    data_sig <= DOUT_MEM;
                else
                    -- LDRB case
                    data_sig <= (others => '0');
                    if (DR(1 downto 0)= "00") then
                        data_sig(7 downto 0) <= DOUT_MEM(7 downto 0);
                    elsif (DR(1 downto 0)= "01") then
                        data_sig(7 downto 0) <= DOUT_MEM(15 downto 8);
                    elsif (DR(1 downto 0)= "10") then
                        data_sig(7 downto 0) <= DOUT_MEM(23 downto 16);
                    else
                        data_sig(7 downto 0) <= DOUT_MEM(31 downto 24);
                    end if;
                end if;
            end if;
    end case;
end if;
end Process;

end Behavioral;

