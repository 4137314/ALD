-- ex_mem.vhd - EX/MEM pipeline register
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ex_mem is
    port (
        clk : in std_logic;
        rst : in std_logic;
        -- inputs
        alu_result_in : in std_logic_vector(31 downto 0);
        rs2_in : in std_logic_vector(31 downto 0);
        rd_addr_in : in std_logic_vector(4 downto 0);
        mem_read_in : in std_logic;
        mem_write_in: in std_logic;
        mem_to_reg_in: in std_logic;
        reg_write_in: in std_logic;
        pc_in : in std_logic_vector(31 downto 0);
        -- outputs
        alu_result_out : out std_logic_vector(31 downto 0);
        rs2_out : out std_logic_vector(31 downto 0);
        rd_addr_out : out std_logic_vector(4 downto 0);
        mem_read_out : out std_logic;
        mem_write_out: out std_logic;
        mem_to_reg_out: out std_logic;
        reg_write_out: out std_logic;
        pc_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of ex_mem is
    signal alu_r, rs2_r : std_logic_vector(31 downto 0);
    signal rd_r : std_logic_vector(4 downto 0);
    signal mread_r, mwrite_r, mtoreg_r, rwrite_r : std_logic;
    signal pc_r : std_logic_vector(31 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            alu_r <= (others=>'0');
            rs2_r <= (others=>'0');
            rd_r <= (others=>'0');
            mread_r <= '0';
            mwrite_r <= '0';
            mtoreg_r <= '0';
            rwrite_r <= '0';
            pc_r <= (others=>'0');
        elsif rising_edge(clk) then
            alu_r <= alu_result_in;
            rs2_r <= rs2_in;
            rd_r <= rd_addr_in;
            mread_r <= mem_read_in;
            mwrite_r <= mem_write_in;
            mtoreg_r <= mem_to_reg_in;
            rwrite_r <= reg_write_in;
            pc_r <= pc_in;
        end if;
    end process;

    alu_result_out <= alu_r;
    rs2_out <= rs2_r;
    rd_addr_out <= rd_r;
    mem_read_out <= mread_r;
    mem_write_out <= mwrite_r;
    mem_to_reg_out <= mtoreg_r;
    reg_write_out <= rwrite_r;
    pc_out <= pc_r;
end architecture;