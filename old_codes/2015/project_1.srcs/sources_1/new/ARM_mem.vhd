-- 
-- Create Date: 03/17/2017 02:30:17 PM
-- Design Name: 
-- Module Name: ARM_mem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ARM_mem is
 port (
       adr : in std_logic_vector (31 downto 0);
       M_in : in std_logic_vector (31 downto 0);
       mem_read : in std_logic;
       MW: in std_logic_vector (3 downto 0);
       M_out : out std_logic_vector (31 downto 0);       
       clk: in std_logic
   );
   
end ARM_mem;

architecture Behavioral of ARM_mem is

type Mem is array(0 to 1023) of std_logic_vector(31 downto 0) ;
signal data_memory : Mem := (others=>(others=>'0')) ;

begin

process(clk)
begin
    if clk='1' and clk'event then
        if mem_read='1' then
            M_out <= (data_memory(to_integer(unsigned(adr(11 downto 2)))));
        end if;
        if MW(3)='1' then
            data_memory(to_integer(unsigned(adr(11 downto 2))))(31 downto 24)<=M_in(31 downto 24);
        end if;
        if MW(2)='1' then
            data_memory(to_integer(unsigned(adr(11 downto 2))))(23 downto 16)<=M_in(23 downto 16);
        end if;
        if MW(1)='1' then
            data_memory(to_integer(unsigned(adr(11 downto 2))))(15 downto 8)<=M_in(15 downto 8);
        end if;
        if MW(0)='1' then
            data_memory(to_integer(unsigned(adr(11 downto 2))))(7 downto 0)<=M_in(7 downto 0);
        end if;
    end if;
end process;



--HA : entity blk_mem_gen_0 port map(
--    douta => M_out,
--    dina => temp_write,
--    addra => adr(11 downto 2),
--    wea => write,
--    ena => '1',
--    clka => clk
--    );
    
end Behavioral;