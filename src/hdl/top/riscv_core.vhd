-- riscv_core.vhd - Top-level RISC-V CPU core
--
-- Copyright (C) 2025  4137314
--
-- This file is part of the RISC-V CPU project.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity riscv_core is
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        -- Optional external interfaces
        instr_mem_data : in  std_logic_vector(31 downto 0);
        instr_mem_addr : out std_logic_vector(31 downto 0);
        data_mem_data  : inout std_logic_vector(31 downto 0);
        data_mem_addr  : out std_logic_vector(31 downto 0);
        data_mem_we    : out std_logic
    );
end riscv_core;

architecture rtl of riscv_core is

    -- Program Counter
    signal pc        : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_next   : std_logic_vector(31 downto 0);

    -- Instruction
    signal instr     : std_logic_vector(31 downto 0);

    -- Register File
    signal rs1_data, rs2_data : std_logic_vector(31 downto 0);
    signal rd_data             : std_logic_vector(31 downto 0);
    signal rd_addr             : std_logic_vector(4 downto 0);
    signal reg_write           : std_logic;

    -- ALU
    signal alu_a, alu_b : std_logic_vector(31 downto 0);
    signal alu_result   : std_logic_vector(31 downto 0);

    -- Immediate
    signal imm          : std_logic_vector(31 downto 0);

    -- Control signals
    signal alu_op       : std_logic_vector(3 downto 0);
    signal mem_read     : std_logic;
    signal mem_write    : std_logic;
    signal branch       : std_logic;
    signal jump         : std_logic;

begin

    -- Connect instruction memory
    instr <= instr_mem_data;
    instr_mem_addr <= pc;

    -- Program Counter logic
    process(clk, rst)
    begin
        if rst = '1' then
            pc <= (others => '0');
        elsif rising_edge(clk) then
            pc <= pc_next;
        end if;
    end process;

    -- Instantiate Register File
    regfile_inst : entity work.regfile
        port map (
            clk       => clk,
            rst       => rst,
            rs1_addr  => instr(19 downto 15),
            rs2_addr  => instr(24 downto 20),
            rd_addr   => rd_addr,
            rs1_data  => rs1_data,
            rs2_data  => rs2_data,
            rd_data   => rd_data,
            reg_write => reg_write
        );

    -- Instantiate Immediate Generator
    imm_gen_inst : entity work.imm_gen
        port map (
            instr  => instr,
            imm_out => imm
        );

    -- Instantiate ALU
    alu_inst : entity work.alu
        port map (
            a      => alu_a,
            b      => alu_b,
            alu_op => alu_op,
            result => alu_result
        );

    -- Instantiate Control Unit
    control_inst : entity work.control_unit
        port map (
            instr       => instr,
            alu_op      => alu_op,
            reg_write   => reg_write,
            mem_read    => mem_read,
            mem_write   => mem_write,
            branch      => branch,
            jump        => jump,
            rd_addr     => rd_addr
        );

    -- ALU operands selection (simplified)
    alu_a <= rs1_data;
    alu_b <= imm when instr(6 downto 0) = "0010011" else rs2_data; -- ADDI vs ADD

    -- Data memory interface (simplified)
    data_mem_addr <= alu_result;
    data_mem_we   <= mem_write;
    data_mem_data <= rs2_data when mem_write = '1' else (others => 'Z');
    rd_data       <= data_mem_data when mem_read = '1' else alu_result;

    -- PC next logic (simplified)
    pc_next <= std_logic_vector(unsigned(pc) + 4);

end rtl;