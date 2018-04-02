library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MyTypes.all;

entity ARM_alu is
  port (
    operand1 : in word;
    operand2 : in word;
    condition : in nibble;
    operation : in optype;
    not_implemented : in std_logic;
    undefined : in std_logic;
    Flags : in nibble;
    shifter_carry : in std_logic;
    nextFlags : out nibble;
    result : out word;
    predicate : out std_logic
  );
end;

-- what is use of shifter_carry??

-- Flags are in order N Z C V => Flags(0),Flags(1),Flags(2),Flags(3)

architecture behavioural of ARM_alu is

signal temp_result: STD_LOGIC_VECTOR (31 downto 0) := (others=>'0');
signal carry_last_second: STD_LOGIC := '0';
signal carry_last: STD_LOGIC := '0';
signal valid_instruction: STD_LOGIC := '1';
signal is_set: STD_LOGIC := '0';

begin
  nextFlags(0) <= (is_set and valid_instruction and temp_result(31)) or ((not is_set) and Flags(0));
  with temp_result select
    nextFlags(1) <=  (is_set and valid_instruction and '1') or ((not is_set) and Flags(1)) when X"00000000",
               (is_set and valid_instruction and '0') or ((not is_set) and Flags(1)) when others ;
  carry_last_second <= temp_result(31) xor operand1(31) xor operand2(31);
  carry_last <= ((operand1(31) and operand2(31))or(operand1(31) and carry_last_second)or(operand2(31) and carry_last_second));
  nextFlags(2) <= (is_set and valid_instruction and carry_last) or ((not is_set) and Flags(2));
  nextFlags(3) <= (is_set and valid_instruction and (carry_last xor carry_last_second)) or ((not is_set) and Flags(3));

  valid_instruction <= not(not_implemented or undefined);

  result <= temp_result ;
  with operation select
    temp_result <=  (operand1 and operand2) when ANDD,
                    (operand1 xor operand2) when EOR,
                    std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(not operand2))+to_integer(unsigned'('0'&'1'))),32)) when SUB,
                    std_logic_vector(to_signed((to_integer(signed(not operand1))+to_integer(signed(operand2))+to_integer(unsigned'('0'&'1'))),32)) when RSB,
                    std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))),32))  when ADD,
                    std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(operand1))+to_integer(unsigned'('0'&Flags(2)))),32)) when ADC,
                    std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(not operand2))+to_integer(unsigned'('0'&Flags(2)))),32)) when SBC,
                    std_logic_vector(to_signed((to_integer(signed(operand2))+to_integer(signed(not operand1))+to_integer(unsigned'('0'&Flags(2)))),32)) when RSC,
                    (operand1 and operand2) when TST,
                    (operand1 xor operand2) when TEQ,
                    std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(not operand2)))+1,32))  when CMP,
                    std_logic_vector(to_signed((to_integer(signed(operand1))+to_integer(signed(operand2))),32)) when CMN,
                    (operand1 or operand2) when ORR,
                    (operand2)  when MOV,
                    (operand1 and (not operand2)) when BIC,
                    (not operand2)  when MVN;

  predicate <= is_set;
  with condition select
    is_set <=  (valid_instruction and (Flags(1))) when "0000",
               (valid_instruction and (not Flags(1))) when "0001",
               (valid_instruction and (Flags(2))) when "0010",
               (valid_instruction and (not Flags(2))) when "0011",
               (valid_instruction and (Flags(0))) when "0100",
               (valid_instruction and (not Flags(0))) when "0101",
               (valid_instruction and (Flags(3))) when "0110",
               (valid_instruction and (not Flags(3))) when "0111",
               (valid_instruction and (Flags(2) and (not Flags(1)))) when "1000",
               (valid_instruction and ((not Flags(2)) or (Flags(1)))) when "1001",
               (valid_instruction and (not (Flags(0) xor Flags(3)))) when "1010",
               (valid_instruction and ((Flags(0) xor Flags(3)))) when "1011",
               (valid_instruction and ((not Flags(1)) and (not (Flags(0) xor Flags(3))))) when "1100",
               (valid_instruction and ((Flags(1)) or (Flags(0) xor Flags(3)))) when "1101",
               (valid_instruction and ('1')) when "1110",
               (valid_instruction and ('0' )) when others;

end behavioural;

