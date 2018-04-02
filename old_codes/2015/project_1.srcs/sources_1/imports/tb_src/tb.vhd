library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--The IEEE.std_logic_unsigned contains definitions that allow 
--std_logic_vector types to be used with the + operator to instantiate a 
--counter.
use IEEE.std_logic_unsigned.all;

entity tb is
    Port ( SW 			: in  STD_LOGIC_VECTOR (15 downto 0);
           BTN 			: in  STD_LOGIC_VECTOR (4 downto 0);
           CLK 			: in  STD_LOGIC;
           LED 			: out  STD_LOGIC_VECTOR (15 downto 0);
           SSEG_CA 		: out  STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN 		: out  STD_LOGIC_VECTOR (3 downto 0);
           UART_TXD 	: out  STD_LOGIC;
           UART_RXD     : in   STD_LOGIC;
           VGA_RED      : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_BLUE     : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_GREEN    : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_VS       : out  STD_LOGIC;
           VGA_HS       : out  STD_LOGIC;
           PS2_CLK      : inout STD_LOGIC;
           PS2_DATA     : inout STD_LOGIC
		);
end tb;

architecture Behavioral of tb is

component memory_uart
--  Port ( );
PORT(
    CLK : in std_logic;
    RST : in std_logic;
    UART_TX: out std_logic;
    UART_RX: in std_logic;
    LAST_DATA_RX : out std_logic_vector(7 downto 0);
    ENABLE_TX: in std_logic;
    ENABLE_RX: in std_logic;
    UART_RX_CNT : out std_logic_vector(15 downto 0);
    CLK_MEM : IN STD_LOGIC;
    ENA_MEM : IN STD_LOGIC;
    WEA_MEM : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ADDR_MEM : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    DIN_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOUT_MEM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component;

component ARM_CPU
	PORT (
    CLK_CPU : in STD_LOGIC;
    RST : in std_logic;
    WEA_MEM : out STD_LOGIC_VECTOR(3 DOWNTO 0);
    ADDR_MEM : out STD_LOGIC_VECTOR(11 DOWNTO 0);
    DIN_MEM : out STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOUT_MEM : in STD_LOGIC_VECTOR(31 DOWNTO 0)
	 );
end component;


signal temp: std_logic;
signal UART_RX_CNT : std_logic_vector(15 downto 0);
signal clk_mem : std_logic;
signal ena_mem : std_logic;
signal wea_mem : std_logic_vector(3 downto 0) := (others=>'0');
signal addr_mem : std_logic_vector(11 downto 0):= (others=>'0');
signal din_mem : std_logic_vector(31 downto 0):= (others=>'0');
signal dout_mem : std_logic_vector(31 downto 0);

begin

----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--instantiate the processor here and then connect the below signals appropriately to the memory interface provided above.


clk_mem <= CLK;
ena_mem <= '1';
--wea_mem <= (others=>'0');
--addr_mem <= (others=>'0');
--din_mem <= (others=>'0');

--dout_mem is open currently and needs to be connected to processor





--------------------------------------------------------------------------------------------------------
--CAUTION: DO NOT TOUCH THE CODE PORTION BELOW. The appropriate signals have been already brought out and use them.
--------------------------------------------------------------------------------------------------------

mem_if: memory_uart port map(
    CLK => CLK,
    RST => BTN(4),
    UART_TX => UART_TXD,
    UART_RX => UART_RXD,
    LAST_DATA_RX => LED(7 downto 0),
    ENABLE_TX => SW(0),
    ENABLE_RX => SW(1),
    UART_RX_CNT => UART_RX_CNT,
    CLK_MEM => clk_mem,
    ENA_MEM => ena_mem,
    WEA_MEM => wea_mem,
    ADDR_MEM => addr_mem,
    DIN_MEM => din_mem,
    DOUT_MEM => dout_mem
);

cpu_inst: ARM_CPU port map(
    CLK_CPU => CLK,
    RST => SW(2),
    WEA_MEM => wea_mem,
    ADDR_MEM => addr_mem,
    DIN_MEM => din_mem,
    DOUT_MEM => dout_mem
	 );


LED(15 downto 8) <= UART_RX_CNT(7 downto 0);

--below is self loopback for debug
--mem_if: memory port map(
--    CLK => CLK,
--    RST => BTN(4),
--    UART_TX => temp,
--    UART_RX => temp
--);
--UART_TXD <= temp;

end Behavioral;
