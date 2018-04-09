library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
use ieee.numeric_std.all;
library work;
use work.all;
use work.pkg.all;

entity arm_cpu is
	port (
		ok : out std_logic
		--clock : std_logic;
	);
end arm_cpu;

architecture arm_cpu_arc of arm_cpu is
begin

	entity work.controller(arch)
	port map (


			);


end arm_cpu_arc;

entity controller is
  port (
    PW          : out std_logic;
    IorD        : out std_logic_vector(1 downto 0);
    MR          : out std_logic;
    MW          : out std_logic;
    IW          : out std_logic;
    DW          : out std_logic;
    Rsrc        : out std_logic;
    M2R         : out std_logic_vector(1 downto 0); --changed
    RW          : out std_logic;
    AW          : out std_logic;
    BW          : out std_logic;
    Asrc1       : out std_logic_vector(1 downto 0); --changed
    Asrc2       : out std_logic_vector(1 downto 0);
    Fset        : out std_logic;
    ReW         : out std_logic;
    mem_enable  : out std_logic_vector(3 downto 0) ;
    mul_w       : out std_logic;
    shift_w     : out std_logic;
    Rsrc1       : out std_logic;
    L           : out std_logic;
    p2m_opcode  : out std_logic_vector(1 downto 0);
    sign_opcode : out std_logic;
    p2m_offset  : out std_logic_vector(1 downto 0);
    RWAD        : out std_logic_vector(1 downto 0);
    state       : in state_type;
    reset       : in std_logic;
    sh_code     : out std_logic;
    sh_op       : out std_logic;
    sh_amt      : out std_logic_vector(1 downto 0);
    predicate   : in std_logic
  ) ;
end controller ;


entity data_path is
  port (
    PW          : in std_logic;
    IorD        : in std_logic_vector(1 downto 0);
    MR          : in std_logic;
    IW          : in std_logic;
    DW          : in std_logic;
    Rsrc        : in std_logic;
    M2R         : in std_logic_vector(2 downto 0);  --changed
    RW          : in std_logic;
    AW          : in std_logic;
    BW          : in std_logic;
    Asrc1       : in std_logic_vector(1 downto 0);  --changed
    Asrc2       : in std_logic_vector(2 downto 0);
    op          : in std_logic_vector(3 downto 0);
    Fset        : in std_logic;
    ReW         : in std_logic;
    clk         : in std_logic;
    mul_w       : in std_logic;
    shift_w     : in std_logic;
    sh_op       : in std_logic;
    sh_code     : in std_logic;
    sh_amt      : in std_logic_vector(1 downto 0);
    Rsrc1       : in std_logic;
    L           : in std_logic;
    p2m_opcode  : in std_logic_vector(1 downto 0);
    sign_opcode : in std_logic;
    p2m_offset  : in std_logic_vector(1 downto 0);
    RWAD        : in std_logic_vector(1 downto 0);
    Flags       : out std_logic_vector(3 downto 0);
    IR          : out std_logic_vector(31 downto 0)
  ) ;
end entity ;


entity Actrl is
  port (
	IR : in std_logic_vector(31 downto 0);
	op : out std_logic_vector(3 downto 0)
  ) ;
end Actrl ;

entity Bctrl is
  port (
	IR : in std_logic_vector(31 downto 0);
	nzvc : in std_logic_vector(3 downto 0); --flags
	p : out std_logic
  ) ;
end Bctrl ;