-- cache.vhd - simple passthrough cache placeholder
-- Copyright (C) 2025  4137314
-- GNU GPLv3
--
-- For now this module simply forwards requests to memory. Replace with real cache later.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cache is
    port (
        clk : in std_logic;
        addr_in : in std_logic_vector(31 downto 0);
        we_in   : in std_logic;
        wdata_in: in std_logic_vector(31 downto 0);
        rdata_out: out std_logic_vector(31 downto 0);
        addr_out : out std_logic_vector(31 downto 0);
        we_out   : out std_logic;
        wdata_out: out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of cache is
begin
    -- direct pass-through
    addr_out <= addr_in;
    we_out <= we_in;
    wdata_out <= wdata_in;
    rdata_out <= (others => '0'); -- memory will drive
end architecture;