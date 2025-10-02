-- systolic_array.vhd - NxN PE array
-- Copyright (C) 2025 4137314
-- License: GNU GPL v3
--
-- Simple systolic array example for 2x2 PE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity systolic_array is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        a_in  : in  signed(15 downto 0);
        b_in  : in  signed(15 downto 0);
        c_out : out signed(31 downto 0)
    );
end entity;

architecture rtl of systolic_array is
    signal c0, c1, c2 : signed(31 downto 0);
begin
    -- PE(0,0)
    pe00: entity work.pe
        port map(clk, rst, a_in, b_in, (others=>'0'), c0);

    -- PE(0,1)
    pe01: entity work.pe
        port map(clk, rst, a_in, b_in, c0, c1);

    -- PE(1,0)
    pe10: entity work.pe
        port map(clk, rst, a_in, b_in, c0, c2);

    -- Output
    c_out <= c1 + c2;
end architecture;