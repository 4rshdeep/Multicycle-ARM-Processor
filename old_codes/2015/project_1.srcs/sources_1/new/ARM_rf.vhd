library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- Writes data to address specified by inp2
entity ARM_rf is
    port (
        inp1 : in std_logic_vector (3 downto 0);
        inp2 : in std_logic_vector (3 downto 0);
        data : in std_logic_vector (31 downto 0);
        is_write : in std_logic;
        out1 : out std_logic_vector (31 downto 0);
        out2 : out std_logic_vector (31 downto 0);
        rst : in std_logic
    );
end;

architecture Behavioral of ARM_rf is
  type REG_FILE is array (15 downto 0) of std_logic_vector(31 downto 0) ;
  signal rf: REG_FILE:= ((others=> (others=>'0')));

begin
  out1 <= rf(to_integer(unsigned(inp1)));
  out2 <= rf(to_integer(unsigned(inp2)));
  
  process(is_write,rst,inp1,inp2,data)
    begin
      if(rst = '1') then
          rf <= ((others=> (others=>'0')));
      elsif (is_write='1') then
          rf(to_integer(unsigned(inp2))) <= data;
--      else
--          out1 <= rf(to_integer(unsigned(inp1)));
--          out2 <= rf(to_integer(unsigned(inp2)));
      end if;
    end process;

end Behavioral;
