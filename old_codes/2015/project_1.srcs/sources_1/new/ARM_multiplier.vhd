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

entity ARM_multiplier is
    port (
        operand1 : in std_logic_vector (31 downto 0);
        operand2 : in std_logic_vector (31 downto 0);
        result : out std_logic_vector (31 downto 0);
        N_mul: out std_logic;
        Z_mul: out std_logic
    );
end;

architecture Behavioral of ARM_multiplier is
    signal temp_result : std_logic_vector(31 downto 0) := (others=>'0');
begin
    temp_result <= std_logic_vector(to_signed(to_integer(signed(operand1))*to_integer(signed(operand2)), 32));
    N_mul <= temp_result(31);
    Z_mul <=   '1'  when temp_result = X"00000000" else
               '0' ;
    result <= temp_result;
end Behavioral;
