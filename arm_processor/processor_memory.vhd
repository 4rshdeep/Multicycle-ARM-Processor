library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

entity processor_memory is
  port (
	pr_data : in std_logic_vector(31 downto 0) ; --input from processor
	mem_data : in std_logic_vector(31 downto 0) ; -- input from memory
	proc_to_mem : in std_logic; -- whether it is processor to memory or vice-versa. '1' for proc to mem
	load : in std_logic ; -- '1' for load instruction '0' for store
	optype : in std_logic_vector(1 downto 0) ; -- "11" -> word  |   "01"/"10" -> half word   |   "00" -> byte transfer
	s : in std_logic; -- ldrsh/ldrsb sign extended or not?
	load_addr : in std_logic_vector(1 downto 0) ;  -- 0th bit decides in half word whether lower(15-0) word is loaded or higher word    (memory to processor)(decides which half or quarter of the word goes to the register after extension)
	byte_offset : in std_logic_vector(1 downto 0) ;  -- address where to write in case half word see only 0th bit.	
	out_to_pr : out std_logic_vector(31 downto 0) ; -- data out to processor
	out_to_mem : out std_logic_vector(31 downto 0);  -- data out to memory
	memory_enable : out std_logic_vector(3 downto 0) -- memory enable signals to be given while storing
  ) ;
end processor_memory ;


-- incase of half word see only oth bit of address signals like byte_offset, load_addr
-- memory enable signals decides which bytes to write

architecture arch of processor_memory is

begin

	main : process( pr_data,load_addr, mem_data, proc_to_mem, load, optype, s, byte_offset)
    	variable to_mem  : std_logic_vector(31 downto 0); -- variables used and assigned later
        variable to_proc  : std_logic_vector(31 downto 0);
	begin
		if load = '1' then --load instruction -- memory -> processor
			if optype = "11" then
				to_proc := mem_data;
			elsif ((optype ="01") or (optype = "10"))  then
				if load_addr(0) = '1' then -- load higher word
					to_proc(15 downto 0) := mem_data(31 downto 16);
					if s = '0' then
						to_proc(31 downto 16) := (others => '0');
					else
						to_proc(31 downto 16) := (others => mem_data(31)); --copies 31st bit to all 31 downto 16
					end if ;
				else
					to_proc(15 downto 0) := mem_data(15 downto 0);
					if s = '0' then
						to_proc(31 downto 16) := (others => '0');
					else
						to_proc(31 downto 16) := (others => mem_data(15)); --copies 15th bit to all 31 downto 16
					end if ;
				end if ;
			else -- load byte =8
				if load_addr = "00" then -- 7 to 0
					to_proc(7 downto 0) := mem_data(7 downto 0);
					if s = '0' then
						to_proc(31 downto 8) := (others => '0');
					else
						to_proc(31 downto 8) := (others => mem_data(7));
					end if ;
				elsif load_addr = "01" then -- 15 to 8
					to_proc(7 downto 0) := mem_data(15 downto 8);
					if s = '0' then
						to_proc(31 downto 8) := (others => '0');
					else
						to_proc(31 downto 8) := (others => mem_data(15));
					end if ;
				elsif load_addr = "10" then -- 23 to 16
					to_proc(7 downto 0) := mem_data(23 downto 16);
					if s = '0' then
						to_proc(31 downto 8) := (others => '0');
					else
						to_proc(31 downto 8) := (others => mem_data(23));
					end if ;
				elsif load_addr = "11" then -- 31 to 24
					to_proc(7 downto 0) := mem_data(31 downto 24);
					if s = '0' then
						to_proc(31 downto 8) := (others => '0');
					else
						to_proc(31 downto 8) := (others => mem_data(31));
					end if ;
				end if ;

			end if ;

			out_to_pr <= to_proc;
		else
			--- store -- processor -> memory
			if optype="11" then
				to_mem := pr_data;
				memory_enable <= "1111";

			elsif ((optype="10") or (optype="01")) then
				to_mem(31 downto 16) := pr_data(15 downto 0);
				to_mem(15 downto 0) := pr_data(15 downto 0);

				if byte_offset(0) = '0' then -- document this that need to look at lower byte.
					memory_enable <= "0011";
				else
					memory_enable <= "1100";
				end if ;
			else
				to_mem(31 downto 24) := pr_data(7 downto 0);
				to_mem(23 downto 16) := pr_data(7 downto 0);
				to_mem(15 downto 8) := pr_data(7 downto 0);
				to_mem(7 downto 0) := pr_data(7 downto 0);
				if byte_offset = "00" then
					memory_enable <= "0001";
				elsif byte_offset = "01" then
					memory_enable <= "0010";
				elsif byte_offset = "10" then
					memory_enable <= "0100";
				else
					memory_enable <= "1000";
				end if ;

			end if ;

			out_to_mem <= to_mem;
		end if ;

	end process ; -- main


end architecture ; -- arch