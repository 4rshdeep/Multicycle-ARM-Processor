----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:48 03/18/2017 
-- Design Name: 
-- Module Name:    Shifter - Behavioral 
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
use ieee.numeric_std.all;
use work.MyTypes.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shifter is
	port (
		Shifter_in : in word;
		Shifter_out : out word;
		Shift_type : in bit_pair;
		Shift_amount : in Shift_amount_type;
		c_in : in std_logic;
		c_out : out std_logic
	);
end Shifter;

--0 -> LSL
--1 -> LSR
--2 -> ASR
--3 -> ROR

architecture Behavioral of Shifter is
		
begin
--write your code here
    Shifter_out <= std_logic_vector(shift_left(unsigned(Shifter_in), to_integer(unsigned(Shift_amount))) ) when Shift_type="00" else
          std_logic_vector(shift_right(unsigned (Shifter_in), to_integer(unsigned(Shift_amount))) ) when Shift_type="01" else
          std_logic_vector(shift_right(signed(Shifter_in), to_integer(unsigned(Shift_amount))) ) when Shift_type="10" else
          std_logic_vector(rotate_right(unsigned(Shifter_in), to_integer(unsigned(Shift_amount))) ) when Shift_type="11";
    c_out <=  c_in when to_integer(unsigned(Shift_amount))=0 else
          Shifter_in(32 - to_integer(unsigned(Shift_amount))) when Shift_type="00" else
          Shifter_in(to_integer(unsigned(Shift_amount)) - 1) when Shift_type="01" else
          Shifter_in(to_integer(unsigned(Shift_amount)) - 1) when Shift_type="10" else
          c_in;
end Behavioral;

