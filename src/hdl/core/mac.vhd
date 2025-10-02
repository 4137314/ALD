-- mac.vhd - Multiply-Accumulate unit
-- Copyright (C) 2025 4137314
-- License: GNU GPL v3
--
-- This module implements a single MAC operation: C <= A*B + C

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mac is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        a     : in  signed(15 downto 0);
        b     : in  signed(15 downto 0);
        c_in  : in  signed(31 downto 0);
        c_out : out signed(31 downto 0)
    );
end entity;

architecture rtl of mac is
    signal acc : signed(31 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            acc <= (others => '0');
        elsif rising_edge(clk) then
            acc <= a * b + c_in;
        end if;
    end process;

    c_out <= acc;
end architecture;