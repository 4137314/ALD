-- forwarding_unit.vhd - simple forwarding for EX stage operands
-- Copyright (C) 2025  4137314
-- GNU GPLv3
--
-- Produces 2-bit control signals for mux selection:
-- 00 -> from register file (no forward)
-- 01 -> from EX/MEM stage (forward result)
-- 10 -> from MEM/WB stage (forward writeback)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity forwarding_unit is
    port (
        id_ex_rs1 : in  std_logic_vector(4 downto 0);
        id_ex_rs2 : in  std_logic_vector(4 downto 0);
        ex_mem_rd : in  std_logic_vector(4 downto 0);
        ex_mem_reg_write : in std_logic;
        mem_wb_rd : in  std_logic_vector(4 downto 0);
        mem_wb_reg_write : in std_logic;
        forward_a : out std_logic_vector(1 downto 0);
        forward_b : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of forwarding_unit is
    signal fwd_a_int, fwd_b_int : std_logic_vector(1 downto 0);
begin
    process(id_ex_rs1, id_ex_rs2, ex_mem_rd, ex_mem_reg_write, mem_wb_rd, mem_wb_reg_write)
    begin
        -- default
        fwd_a_int <= "00";
        fwd_b_int <= "00";

        -- EX hazard
        if (ex_mem_reg_write = '1') and (ex_mem_rd /= "00000") and (ex_mem_rd = id_ex_rs1) then
            fwd_a_int <= "01";
        end if;
        if (ex_mem_reg_write = '1') and (ex_mem_rd /= "00000") and (ex_mem_rd = id_ex_rs2) then
            fwd_b_int <= "01";
        end if;

        -- MEM hazard (solo se EX non ha già forzato)
        if (mem_wb_reg_write = '1') and (mem_wb_rd /= "00000") and (mem_wb_rd = id_ex_rs1) then
            if fwd_a_int = "00" then
                fwd_a_int <= "10";
            end if;
        end if;
        if (mem_wb_reg_write = '1') and (mem_wb_rd /= "00000") and (mem_wb_rd = id_ex_rs2) then
            if fwd_b_int = "00" then
                fwd_b_int <= "10";
            end if;
        end if;
    end process;

    -- assegnazione ai port out
    forward_a <= fwd_a_int;
    forward_b <= fwd_b_int;
end architecture;