entity processor_memory is
  port (
	pr_data : in std_logic_vector(31 downto 0) ;
	mem_data : in std_logic_vector(31 downto 0) ;
	proc_to_mem : in std_logic; -- whether it is processor to memory or vice-versa. '1' for proc to mem
	load : in std_logic ; -- '1' for load instruction '0' for store
	optype : in std_logic_vector(1 downto 0) ; -- "11" -> word "01" -> half word "00" -> byte transfer
	s : in std_logic; -- ldrsh/ldrsb sign extended or not?
	byte_offset : in std_logic_vector(2 downto 0) ;
	out_to_pr : out std_logic_vector(31 downto 0) ; -- data out to processor
	out_to_mem : out std_logic_vector(31 downto 0);  -- data out to memory
	memory_enable : out std_logic_vector(3 downto 0)
  ) ;
end processor_memory ;

architecture arch of processor_memory is

begin

	main : process( pr_data, mem_data, proc_to_mem, load, optype, s, byte_offset)
	begin
		if load = '1' then --load instruction -- memory -> processor

		else
			--- store -- processor -> memory
		end if ;

	end process ; -- main


end architecture ; -- arch