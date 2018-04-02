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

entity ARM_pc is
    port (
        inp : in std_logic_vector (31 downto 0);
        write : in std_logic;
        outp : out std_logic_vector (31 downto 0)
    );
end;

architecture Behavioral of ARM_pc is
  signal memo: std_logic_vector(31 downto 0);

begin
    memo <= inp when write = '1' else
             memo;
    outp <= memo;
end Behavioral;
