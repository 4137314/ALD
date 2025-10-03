-- csr_unit.vhd - CSR unit stub (minimal)
-- Copyright (C) 2025  4137314
-- GNU GPLv3
--
-- Minimal CSR support: provides mstatus/mepc and simple read/write interface.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity csr_unit is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        csr_addr: in  std_logic_vector(11 downto 0);
        csr_wdata: in std_logic_vector(31 downto 0);
        csr_we  : in  std_logic;
        csr_rdata: out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of csr_unit is
    signal mstatus : std_logic_vector(31 downto 0) := (others=>'0');
    signal mepc    : std_logic_vector(31 downto 0) := (others=>'0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                mstatus <= (others=>'0');
                mepc <= (others=>'0');
            else
                if csr_we = '1' then
                    case csr_addr is
                        when x"300" => mstatus <= csr_wdata; -- example
                        when x"341" => mepc    <= csr_wdata;
                        when others => null;
                    end case;
                end if;
            end if;
        end if;
    end process;

    process(csr_addr, mstatus, mepc)
    begin
        case csr_addr is
            when x"300" => csr_rdata <= mstatus;
            when x"341" => csr_rdata <= mepc;
            when others => csr_rdata <= (others => '0');
        end case;
    end process;
end architecture;