library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity Actrl is
  port (
	IR : in std_logic_vector(31 downto 0);
	op : out std_logic_vector(3 downto 0)
  ) ;
end Actrl ;

architecture arch of Actrl is
begin

    process(IR) 
    begin
    
        if (IR(27 downto 26) = "01") then -- ldr, str
            if IR(23) = '1' then
                op <= "0100";
            else
                op <= "0010";
            end if ;
        elsif IR(27 downto 25) = "101" then -- b, bl
            op <= "0100";
        elsif IR(27 downto 23) = "00001" and IR(7 downto 4) = "1001" then --mul and mla confirm condition!
            if IR(21) = '0' then --mul
                op <= "1101";
            else                -- mla
                op <= "0100";
            end if ;
        else
            op <= IR(24 downto 21);  -- normal alu operations
        end if ;
    
    end process;

end architecture ; -- arch