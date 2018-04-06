----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    15:48:14 02/28/2017
-- Design Name:
-- Module Name:    Control_FSM - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyTypes.all;


entity Control_FSM is
    Port (    instr_class : in  instr_class_type;
			  DT_subclass : in DT_subclass_type;
			  DP_subclass: in DP_subclass_type;
			  opt : in optype;
			  instr : in std_logic_vector(31 downto 0);
--			  instr_20 : in std_logic;
			  rst : in std_logic;
        control_state_out : out  control_state_type;
			  clock : in std_logic);
end Control_FSM;

architecture Behavioral of Control_FSM is
signal  in_st : control_state_type;
begin

control_state_out <= in_st when rst = '0' else s0;

process(clock)
begin
  if(clock='1' and clock'event) then
    if rst='1' then
      in_st <= s0;
    else
      case in_st is
        when s0 =>
          in_st <= s23;
        when s23 =>
          in_st <= s1;
        when s1 =>
          if (instr_class="00") then --dp
            if (DP_subclass=IMM) then --dp instr (go to alu)
              in_st <= s2;
            elsif (DP_subclass=SFT_IMM) then
              in_st <= s3; --immediate dp
            elsif (DP_subclass=SFT_REG) then
              in_st <= s4;
            end if;
          elsif (instr_class="01") then -- mul instr
            in_st <= s8;
          elsif (instr_class="10") then -- memory
            if (DT_subclass=WRD) then
              if(instr(25)='0') then
                in_st <= s14;
              else
                in_st <= s15;
              end if;
            else
              if(instr(22)='0') then
                in_st <= s16;
              else
                in_st <= s17;
              end if;
            end if;
          elsif (instr_class="11") then -- branchs
            if (instr(24)='0') then
              in_st <= s13; --normal branch
            else
              in_st <= s12; --bl instruct
            end if;
          end if;
          when s2 =>
            in_st <= s6;
          when s3 =>
            in_st <= s6;
          when s4 =>
            in_st <= s5;
          when s5 =>
            in_st <= s6;
          when s6 =>
            in_st <= s7;
          when s7 =>
            in_st <= s0;
          when s8 =>
            in_st <= s9;
          when s9 =>
            in_st <= s10;
          when s10 =>
            in_st <= s11;
          when s11 =>
            in_st <= s0;
          when s12 =>
            in_st <= s13;
          when s13 =>
            in_st <= s0;
          when s14 =>
            in_st <= s18;
          when s15 =>
            in_st <= s18;
          when s16 =>
            in_st <= s18;
          when s17 =>
            in_st <= s18;
          when s18 =>
            if((instr(21)='1')or(instr(24)='0')) then  --do wb
              in_st <= s19;
            else
              if (instr(20)='1') then
                in_st <= s20;
              else
                in_st <= s21;
              end if;
            end if;
          when s19 =>
            if (instr(20)='1') then
              in_st <= s20;
            else
              in_st <= s21;
            end if;
          when s20 =>
            in_st <= s24;
          when s24 =>
            in_st <= s22;
          when s21 =>
            in_st <= s25;
          when s25 =>
            in_st <= s0;
          when s22 =>
            in_st <= s0;
          end case;
      end if;
  end if;
end process;

end Behavioral;
