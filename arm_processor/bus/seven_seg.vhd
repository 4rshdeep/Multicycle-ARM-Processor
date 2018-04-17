library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity seven_segment_display is
port(
	clk: in std_logic;
    bcd_integer : in std_logic_vector(15 downto 0) ;
	anode : out std_logic_vector(3 downto 0);
	cathode : out std_logic_vector(6 downto 0)
);
end entity seven_segment_display;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

architecture ssd of seven_segment_display is
signal clock : std_logic;
signal flag  : integer range 1 to 4;
signal cathode1, cathode2, cathode3, cathode4, cath : std_logic_vector (6 downto 0);
signal counter : integer range 0 to 1000000;

begin

with bcd_integer(15 downto 12) select 
cathode1<= "0000001" when "0000", --0 
           "1001111" when "0001", --1
           "0010010" when "0010", --2
           "0000110" when "0011", --3
           "1001100" when "0100", --4
           "0100100" when "0101", --5
           "0100000" when "0110", --6
           "0001111" when "0111", --7 
           "0000000" when "1000", --8
           "0000100" when "1001", --9
           "0000000" when others;

with bcd_integer(11 downto 8) select 
cathode2<= "0000001" when "0000", --0 
           "1001111" when "0001", --1
           "0010010" when "0010", --2
           "0000110" when "0011", --3
           "1001100" when "0100", --4
           "0100100" when "0101", --5
           "0100000" when "0110", --6
           "0001111" when "0111", --7 
           "0000000" when "1000", --8
           "0000100" when "1001", --9
           "0000000" when others;

with bcd_integer(7 downto 4) select 
cathode3<= "0000001" when "0000", --0 
           "1001111" when "0001", --1
           "0010010" when "0010", --2
           "0000110" when "0011", --3
           "1001100" when "0100", --4
           "0100100" when "0101", --5
           "0100000" when "0110", --6
           "0001111" when "0111", --7 
           "0000000" when "1000", --8
           "0000100" when "1001", --9
           "0000000" when others;

with bcd_integer(3 downto 0) select 
cathode4<= "0000001" when "0000", --0 
           "1001111" when "0001", --1
           "0010010" when "0010", --2
           "0000110" when "0011", --3
           "1001100" when "0100", --4
           "0100100" when "0101", --5
           "0100000" when "0110", --6
           "0001111" when "0111", --7 
           "0000000" when "1000", --8
           "0000100" when "1001", --9
           "0000000" when others;

process(clk)
    begin
        if ((clk'event) and (clk='1')) then
            if(counter >= 100000) then
                counter <= 0;
                if(clock = '0') then
                    clock <= '1';
                else
                    clock <= '0';
                end if;
            else
            	counter <= counter + 1;
            end if;
            
        end if;
    end process;		    

process(clock)
begin

if(clock='1' and clock'event) then
    if flag=4 then flag <=1; 
    else flag <= flag+1 ;
    end if;

    case flag is
    when 1 => 
    		anode <= "0111";
            cath <= cathode1;
    when 2 => 
    		anode <= "1011";
            cath <= cathode2;
    when 3 => 
    		anode <= "1101";
            cath <= cathode3;
    when 4 => 
    		anode <= "1110";
            cath <= cathode4;
    when others => 
    		anode <= "1111";
    		flag <= 1;
    end case; 
end if;                  
end process;

cathode <= cath;         
         
end architecture ;