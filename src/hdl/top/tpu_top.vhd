-- tpu_top.vhd - Top-level TPU
-- Copyright (C) 2025 4137314
-- License: GNU GPL v3

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tpu_top is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        start : in  std_logic;
        a_in  : in  signed(15 downto 0);
        b_in  : in  signed(15 downto 0);
        c_out : out signed(31 downto 0);
        done  : out std_logic
    );
end entity;

architecture rtl of tpu_top is
    signal sa_out : signed(31 downto 0);
begin
    fsm_inst: entity work.fsm_controller
        port map(
            clk => clk,
            rst => rst,
            start => start,
            done => done
        );

    accel_inst: entity work.mat2x2_accel
        port map(
            clk => clk,
            rst => rst,
            a_in => a_in,
            b_in => b_in,
            c_out => sa_out
        );

    c_out <= sa_out;
end architecture;