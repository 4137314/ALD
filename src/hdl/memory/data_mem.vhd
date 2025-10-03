-- data_mem.vhd - simple synchronous data memory (word-addressable)
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_mem is
    generic (
        ADDR_WIDTH : integer := 10  -- words
    );
    port (
        clk   : in std_logic;
        addr  : in std_logic_vector(31 downto 0); -- byte address
        we    : in std_logic;
        wdata : in std_logic_vector(31 downto 0);
        rdata : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of data_mem is
    constant DEPTH : integer := 2**ADDR_WIDTH;
    type mem_t is array (0 to DEPTH-1) of std_logic_vector(31 downto 0);
    signal ram : mem_t := (others => (others => '0'));
    signal idx : integer range 0 to DEPTH-1;
begin
    idx <= to_integer(unsigned(addr(ADDR_WIDTH+1 downto 2)));

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(idx) <= wdata;
            end if;
            rdata <= ram(idx);
        end if;
    end process;
end architecture;