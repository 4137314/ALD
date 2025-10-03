-- bus_id.vhd - simple bus interface placeholder
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bus_id is
    port (
        clk : in std_logic;
        -- CPU side
        addr_cpu : in std_logic_vector(31 downto 0);
        we_cpu   : in std_logic;
        wdata_cpu: in std_logic_vector(31 downto 0);
        rdata_cpu: out std_logic_vector(31 downto 0);
        -- Memory side
        addr_mem : out std_logic_vector(31 downto 0);
        we_mem   : out std_logic;
        wdata_mem: out std_logic_vector(31 downto 0);
        rdata_mem: in std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of bus_id is
begin
    addr_mem <= addr_cpu;
    we_mem <= we_cpu;
    wdata_mem <= wdata_cpu;
    rdata_cpu <= rdata_mem;
end architecture;