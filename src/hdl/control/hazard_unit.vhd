-- hazard_unit.vhd - simple load-use hazard detection
-- Copyright (C) 2025  4137314
-- GNU GPLv3
--
-- If ID stage requires a register that is being loaded by EX stage, assert stall.
-- Outputs:
--  stall_if_id: insert bubble in IF/ID (freeze fetch)
--  stall_pc: freeze PC (hold)
--  flush_id_ex: clear control signals in ID/EX (insert bubble)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hazard_unit is
    port (
        -- ID stage source regs
        id_rs1 : in  std_logic_vector(4 downto 0);
        id_rs2 : in  std_logic_vector(4 downto 0);
        -- EX stage destination and mem_read flag
        ex_rd  : in  std_logic_vector(4 downto 0);
        ex_mem_read : in std_logic;
        -- outputs
        stall_pc     : out std_logic;
        stall_if_id  : out std_logic;
        flush_id_ex  : out std_logic
    );
end entity;

architecture rtl of hazard_unit is
begin
    process(id_rs1, id_rs2, ex_rd, ex_mem_read)
    begin
        stall_pc <= '0';
        stall_if_id <= '0';
        flush_id_ex <= '0';
        if ex_mem_read = '1' then
            if (ex_rd /= "00000") and ((ex_rd = id_rs1) or (ex_rd = id_rs2)) then
                -- load-use hazard: stall one cycle
                stall_pc <= '1';
                stall_if_id <= '1';
                flush_id_ex <= '1';
            end if;
        end if;
    end process;
end architecture;