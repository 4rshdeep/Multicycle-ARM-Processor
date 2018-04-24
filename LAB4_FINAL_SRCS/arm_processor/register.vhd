library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;

entity reg is
  port (
  	out_reg_in   : in std_logic_vector(15 downto 0) ;
  	out_reg 	 : out std_logic_vector(31 downto 0) ;
	write_data   : in std_logic_vector(31 downto 0);
	read_add1    : in std_logic_vector(3 downto 0);
	read_add2    : in std_logic_vector(3 downto 0);
	write_add    : in std_logic_vector(3 downto 0);
	clk          : in std_logic;
	reset        : in std_logic;
	write_enable : in std_logic;
	data_out1    : out std_logic_vector(31 downto 0);
	data_out2    : out std_logic_vector(31 downto 0);
	pc           : out std_logic_vector(31 downto 0)
  ) ;
end reg ;

architecture behaviour_reg of reg is
	type register_arr is array (15 downto 0) of std_logic_vector(31 downto 0);
	signal register_files : register_arr := ((others=> (others=>'0')));
	signal rd_add1        : integer := 0;
	signal rd_add2        : integer := 0;
	signal wr_add         : integer := 0;

begin
	-- make address to index
	rd_add1 <= to_integer(unsigned(read_add1)) when reset='0' else 0;
	rd_add2 <= to_integer(unsigned(read_add2)) when reset='0' else 0;
	wr_add  <= to_integer(unsigned(write_add)) when reset='0' else 0;

	-- async read
	data_out1 <= register_files(rd_add1);
	data_out2 <= register_files(rd_add2);

	-- reset pc and show r15 otherwise
	reset_pc : process( reset )
	begin
		if reset = '1' then
			pc <= (others => '0');
		else
			pc <= register_files(15);
		end if ;
	end process ; -- reset_pc

	-- sync write
	clocked_process : process( out_reg_in, clk, write_data, write_add, reset, write_enable )
	begin
		if clk='1' and clk'event then
			if write_enable = '1' then
				register_files(wr_add) <= write_data;
			end if ;
		end if ;

		case(out_reg_in) is
			when "1000000000000000" => out_reg <= register_files(15);
			when "0100000000000000" => out_reg <= register_files(14);
			when "0010000000000000" => out_reg <= register_files(13);
			when "0001000000000000"  => out_reg <= register_files(12);
			when "0000100000000000"  => out_reg <= register_files(11);
			when "0000010000000000" => out_reg <= register_files(10);
			when "0000001000000000" => out_reg <= register_files(9);
			when "0000000100000000" => out_reg <= register_files(8);
			when "0000000010000000" => out_reg <= register_files(7);
			when "0000000001000000" => out_reg <= register_files(6);
			when "0000000000100000"  => out_reg <= register_files(5);
			when "0000000000010000"  => out_reg <= register_files(4);
			when "0000000000001000"  => out_reg <= register_files(3);
			when "0000000000000100"  => out_reg <= register_files(2);
			when "0000000000000010"  => out_reg <= register_files(1);
			when "0000000000000001"  => out_reg <= register_files(0);
			when others => out_reg <= register_files(0);
		end case;
	end process ; -- clocked_process

end architecture ; -- behaviour_register

-- with a&b select c <= '0' when "11"