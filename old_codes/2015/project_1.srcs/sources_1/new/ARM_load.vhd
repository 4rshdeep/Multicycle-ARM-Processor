----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2017 02:30:17 PM
-- Design Name: 
-- Module Name: ARM_load - Behavioral
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

entity ARM_load is
 port (
       adr : in std_logic_vector (31 downto 0);
       M_out : in std_logic_vector (31 downto 0);
       instr_type: in std_logic_vector (2 downto 0);
       R_in : out std_logic_vector (31 downto 0)       
   );
   
end ARM_load;

architecture Behavioral of ARM_load is
begin


process(adr,M_out,instr_type)
begin
    R_in <= (others => '0');
    if instr_type="000" then
        R_in <= M_out;
    elsif instr_type="001" then
        if adr(0) = '0' then
            R_in(15 downto 0) <= M_out(15 downto 0);
        else
            R_in(15 downto 0) <= M_out(31 downto 16);
        end if;
    elsif instr_type="010" then
        if adr(1 downto 0)="00" then
            R_in(7 downto 0) <= M_out(7 downto 0);
        elsif adr(1 downto 0)="01" then
            R_in(7 downto 0) <= M_out(15 downto 8);
        elsif adr(1 downto 0)="01" then
            R_in(7 downto 0) <= M_out(23 downto 16);
        else
            R_in(7 downto 0) <= M_out(31 downto 24);
        end if;
    elsif instr_type="011" then
        if adr(0) = '0' then
            R_in(15 downto 0) <= M_out(15 downto 0);
            R_in(31 downto 16) <= (others => M_out(15));
        else
            R_in(15 downto 0) <= M_out(31 downto 16);
            R_in(31 downto 16) <= (others => M_out(31));
        end if;
    elsif instr_type="100" then
        if adr(1 downto 0)="00" then
            R_in(7 downto 0) <= M_out(7 downto 0);
            R_in(31 downto 8) <= (others => M_out(7));
            
        elsif adr(1 downto 0)="01" then
            R_in(7 downto 0) <= M_out(15 downto 8);
            R_in(31 downto 8) <= (others => M_out(15));
            
        elsif adr(1 downto 0)="01" then
            R_in(7 downto 0) <= M_out(23 downto 16);
            R_in(31 downto 8) <= (others => M_out(23));
            
        else
            R_in(7 downto 0) <= M_out(31 downto 24);
            R_in(31 downto 8) <= (others => M_out(31));
            
        end if;
    end if; 
end process;

    
end Behavioral;
