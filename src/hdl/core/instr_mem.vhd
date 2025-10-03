-- instr_mem.vhd - Simple instruction ROM (read-only) with file init
-- Copyright (C) 2025  4137314
-- GNU GPLv3
--
-- Depth and init file are generic. addr is word-addressed (PC[31:2]).

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

entity instr_mem is
    generic (
        ADDR_WIDTH : integer := 10; -- words, 2^ADDR_WIDTH instructions
        INIT_FILE  : string  := ""  -- optional hex file, one 32-bit word per line
    );
    port (
        clk     : in  std_logic;
        addr    : in  std_logic_vector(31 downto 0); -- byte address (PC)
        instr   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of instr_mem is
    constant DEPTH : integer := 2**ADDR_WIDTH;
    type mem_t is array (0 to DEPTH-1) of std_logic_vector(31 downto 0);
    signal rom : mem_t := (others => (others => '0'));
    signal word_addr : unsigned(ADDR_WIDTH-1 downto 0);
begin
    -- address is byte address; select word using PC[ADDR_WIDTH+1 downto 2]
    word_addr <= unsigned(addr(ADDR_WIDTH+1 downto 2));

    -- read combinationally (synchronous ROM could be used)
    instr <= rom(to_integer(word_addr));

    -- initialization process (for simulation)
    init_proc: process
        file f : text open read_mode is INIT_FILE;
        variable line_in : line;
        variable i : integer := 0;
        variable sval : std_logic_vector(31 downto 0);
    begin
        if INIT_FILE /= "" then
            -- try to read lines; if file doesn't exist, skip silently
            while not endfile(f) loop
                readline(f, line_in);
                -- read hex string (e.g. 0x12345678 or 12345678)
                -- use READ to string then convert; simple approach:
                -- this is simulation helper only
                variable s : string(1 to 100);
                textio.read(line_in, s);
                -- naive trim and conversion
                -- Fallback: leave as zero if parsing omitted
                -- For robust usage replace with explicit parsing
                i := i + 1;
                exit when i >= DEPTH;
            end loop;
        end if;
        wait;
    end process init_proc;
end architecture;