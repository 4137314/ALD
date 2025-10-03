-- mem_wb.vhd - MEM/WB pipeline register
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_wb is
    port (
        clk : in std_logic;
        rst : in std_logic;
        -- inputs
        mem_data_in : in std_logic_vector(31 downto 0);
        alu_result_in : in std_logic_vector(31 downto 0);
        rd_addr_in : in std_logic_vector(4 downto 0);
        mem_to_reg_in : in std_logic;
        reg_write_in : in std_logic;
        -- outputs
        mem_data_out : out std_logic_vector(31 downto 0);
        alu_result_out : out std_logic_vector(31 downto 0);
        rd_addr_out : out std_logic_vector(4 downto 0);
        mem_to_reg_out : out std_logic;
        reg_write_out : out std_logic
    );
end entity;

architecture rtl of mem_wb is
    signal mem_r, alu_r : std_logic_vector(31 downto 0);
    signal rd_r : std_logic_vector(4 downto 0);
    signal mtoreg_r, rwrite_r : std_logic;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            mem_r <= (others=>'0');
            alu_r <= (others=>'0');
            rd_r <= (others=>'0');
            mtoreg_r <= '0';
            rwrite_r <= '0';
        elsif rising_edge(clk) then
            mem_r <= mem_data_in;
            alu_r <= alu_result_in;
            rd_r <= rd_addr_in;
            mtoreg_r <= mem_to_reg_in;
            rwrite_r <= reg_write_in;
        end if;
    end process;

    mem_data_out <= mem_r;
    alu_result_out <= alu_r;
    rd_addr_out <= rd_r;
    mem_to_reg_out <= mtoreg_r;
    reg_write_out <= rwrite_r;
end architecture;