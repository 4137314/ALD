-- pc.vhd - Program Counter register
-- Copyright (C) 2025  4137314
-- GNU GPLv3
--
-- Simple PC register with asynchronous reset and next value input.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pc is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        pc_next  : in  std_logic_vector(31 downto 0);
        pc_out   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of pc is
    signal pc_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            pc_reg <= pc_next;
        end if;
    end process;

    pc_out <= pc_reg;
end architecture;