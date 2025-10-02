-- pe.vhd - Processing Element
-- Copyright (C) 2025 4137314
-- License: GNU GPL v3
--
-- This module implements a PE: a MAC followed by optional activation (ReLU)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pe is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        a     : in  signed(15 downto 0);
        b     : in  signed(15 downto 0);
        c_in  : in  signed(31 downto 0);
        c_out : out signed(31 downto 0)
    );
end entity;

architecture rtl of pe is
    signal mac_out : signed(31 downto 0);
begin
    mac_inst: entity work.mac
        port map (
            clk   => clk,
            rst   => rst,
            a     => a,
            b     => b,
            c_in  => c_in,
            c_out => mac_out
        );

    -- Simple ReLU activation
    process(mac_out)
    begin
        if mac_out < 0 then
            c_out <= (others => '0');
        else
            c_out <= mac_out;
        end if;
    end process;
end architecture;