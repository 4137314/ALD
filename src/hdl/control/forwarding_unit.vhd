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
begin
    process(id_ex_rs1, id_ex_rs2, ex_mem_rd, ex_mem_reg_write, mem_wb_rd, mem_wb_reg_write)
    begin
        -- defaults: 00 = no forward
        forward_a <= "00";
        forward_b <= "00";

        -- EX hazard forward
        if (ex_mem_reg_write = '1') and (ex_mem_rd /= "00000") and (ex_mem_rd = id_ex_rs1) then
            forward_a <= "01";
        end if;
        if (ex_mem_reg_write = '1') and (ex_mem_rd /= "00000") and (ex_mem_rd = id_ex_rs2) then
            forward_b <= "01";
        end if;

        -- MEM hazard forward (lower priority than EX)
        if (mem_wb_reg_write = '1') and (mem_wb_rd /= "00000") and (mem_wb_rd = id_ex_rs1) then
            if forward_a = "00" then
                forward_a <= "10";
            end if;
        end if;
        if (mem_wb_reg_write = '1') and (mem_wb_rd /= "00000") and (mem_wb_rd = id_ex_rs2) then
            if forward_b = "00" then
                forward_b <= "10";
            end if;
        end if;
    end process;
end architecture;