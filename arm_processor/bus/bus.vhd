library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; -- for addition & counting
USE ieee.numeric_std.all;
library work;
use work.all;

package pkg is
    type s_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
end package ;

package body pkg is

end pkg;

entity state_slave is
    port (
        haddr       : in std_logic_vector(31 downto 0) ;
        hwrite      : in std_logic;
        hsize       : in std_logic_vector(2 downto 0) ;
        htrans      : in std_logic_vector(1 downto 0) ; 
        -- htrans 00 -> idle, 01 -> busy, 10 -> nonseq, 11 -> seq
        hready      : in std_logic;
        hwdata      : in std_logic_vector(31 downto 0) ;
        hreset      : in std_logic;
        hreadyout   : out std_logic;
        hresp       : out std_logic;
        hrdata      : out std_logic_vector(31 downto 0) ;
        hclk        : in std_logic;
        we          : out std_logic
    );
end state_slave;

architecture arc of state_slave is
    signal mem_select : std_logic;
    signal io : std_logic;
    signal state : s_type;
begin
    io <= haddr(2) and haddr(3) and haddr(4) and haddr(5) and haddr(6) and haddr(7) and haddr(8) and haddr(9) and haddr(10) and haddr(11) ;
    mem_select <= not(io);

    process (reset, clock)
    begin
      if (reset = '1') then
        state <= s0; 
      else
        case(state) is
            when s0 =>
                if (htrans="10") then
                    if (mem_select = '1') then
                        state <= s1;
                    elsif (port_select = '1') then
                        if (hwrite = '0') then
                            state <= s7;
                        elsif (hwrite = '1') then
                            state <= s8;                        
                        end if;
                        
                    end if;
                end if;
            when s1 =>
                state <= s2;
            when s2 =>
                state <= s3;
            when s3 => 
                state <= s4;
            when s4 => 
                if (w = '1') then
                    state <= s5;
                else
                    state <= s6;
                end if;

            when others =>
                state <= s0;
        end case;
    
      end if;
    end process ;

end arc;

entity slave_signal is
    port (
        clk : std_logic
    );
end slave_signal;

architecture slave_signal_arc of slave_signal is
begin
    state : process (reset, clock)
    begin
      if (reset = '1') then
      
      else
        case(state) is
            when s0 => ;
            when s1 => 
                addr <= haddr;
                w <= hwrite;
                hready <= '0';
            when s2 => 
                hready <= '0';
            when s3 =>
                hready <= '0'
            when s4 =>
                hready <= '1'
            when s5 => 
                we <= '1';
            when s6 => 
                hrdata <= mem_out;
            when s7 => 
                hrdata <= switches;
            when s8 => 
                hrdata <= hwdata;
            when others =>
                state <= s0;
        end case;
      end if;
    end process state;

end slave_signal_arc;


entity master_signal is
    port (
        clock : std_logic;
    );
end master_signal;

architecture master_signal_arc of master_signal is
begin

end master_signal_arc;

entity master_state is
    port (
        load : std_logic;

    );
end master_state;

architecture master_state_arc of master_state is
begin

    process (reset, clock)
    begin
      if (reset = '1') then
        state <= s0;
      else
            if (load = '1') then
                case(state) is
                    when s0 =>  
                        state <= s1;
                    when s1 => 
                        state <= s2;
                    when s2 =>
                        if (hready='1') then
                            state <= s3;
                        end if;
                    when others =>
                        state <= s0;
                end case;    
            else
                case(state) is
                    when s0 =>

                    when others =>
                        state <= s0;
                end case;
                
            end if;

      end if;
    end process;

end master_state_arc;