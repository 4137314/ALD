-- if_id.vhd - IF/ID pipeline register
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity if_id is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        -- control (stall/flush)
        stall  : in  std_logic; -- when '1' keep previous (freeze)
        flush  : in  std_logic; -- when '1' clear contents
        -- inputs
        pc_in  : in  std_logic_vector(31 downto 0);
        instr_in : in std_logic_vector(31 downto 0);
        -- outputs
        pc_out : out std_logic_vector(31 downto 0);
        instr_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of if_id is
    signal pc_r : std_logic_vector(31 downto 0) := (others=>'0');
    signal instr_r : std_logic_vector(31 downto 0) := (others=>'0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pc_r <= (others=>'0');
            instr_r <= (others=>'0');
        elsif rising_edge(clk) then
            if flush = '1' then
                pc_r <= (others=>'0');
                instr_r <= (others=>'0');
            elsif stall = '1' then
                -- hold
                pc_r <= pc_r;
                instr_r <= instr_r;
            else
                pc_r <= pc_in;
                instr_r <= instr_in;
            end if;
        end if;
    end process;

    pc_out <= pc_r;
    instr_out <= instr_r;
end architecture;