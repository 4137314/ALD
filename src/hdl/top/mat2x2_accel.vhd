-- mat2x2_accel.vhd - Minimal 2x2 TPU accelerator
-- Copyright (C) 2025 4137314
-- License: GNU GPL v3

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mat2x2_accel is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        a_in  : in  signed(15 downto 0);
        b_in  : in  signed(15 downto 0);
        c_out : out signed(31 downto 0)
    );
end entity;

architecture rtl of mat2x2_accel is
    signal internal_out : signed(31 downto 0);
begin
    sa_inst: entity work.systolic_array
        port map(
            clk => clk,
            rst => rst,
            a_in => a_in,
            b_in => b_in,
            c_out => internal_out
        );

    c_out <= internal_out;
end architecture;