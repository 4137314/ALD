-- bram_model.vhd - Simple Block RAM model
-- Copyright (C) 2025 4137314
-- License: GNU GPL v3

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram_model is
    generic (
        ADDR_WIDTH : integer := 4;
        DATA_WIDTH : integer := 16
    );
    port (
        clk   : in  std_logic;
        we    : in  std_logic;
        addr  : in  unsigned(ADDR_WIDTH-1 downto 0);
        din   : in  signed(DATA_WIDTH-1 downto 0);
        dout  : out signed(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of bram_model is
    type mem_type is array (0 to 2**ADDR_WIDTH-1) of signed(DATA_WIDTH-1 downto 0);
    signal ram : mem_type := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(to_integer(addr)) <= din;
            end if;
            dout <= ram(to_integer(addr));
        end if;
    end process;
end architecture;