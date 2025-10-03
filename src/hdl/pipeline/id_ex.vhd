-- id_ex.vhd - ID/EX pipeline register (holds decoded fields and control signals)
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity id_ex is
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        flush : in std_logic; -- clear pipeline stage
        -- inputs from ID
        pc_in : in std_logic_vector(31 downto 0);
        rs1_in: in std_logic_vector(31 downto 0);
        rs2_in: in std_logic_vector(31 downto 0);
        imm_in: in std_logic_vector(31 downto 0);
        rs1_addr_in : in std_logic_vector(4 downto 0);
        rs2_addr_in : in std_logic_vector(4 downto 0);
        rd_addr_in  : in std_logic_vector(4 downto 0);
        -- control signals
        alu_op_in : in std_logic_vector(3 downto 0);
        alu_src_in: in std_logic;
        mem_read_in: in std_logic;
        mem_write_in: in std_logic;
        mem_to_reg_in: in std_logic;
        reg_write_in: in std_logic;
        branch_in  : in std_logic;
        jump_in    : in std_logic;
        -- outputs to EX
        pc_out : out std_logic_vector(31 downto 0);
        rs1_out: out std_logic_vector(31 downto 0);
        rs2_out: out std_logic_vector(31 downto 0);
        imm_out: out std_logic_vector(31 downto 0);
        rs1_addr_out : out std_logic_vector(4 downto 0);
        rs2_addr_out : out std_logic_vector(4 downto 0);
        rd_addr_out  : out std_logic_vector(4 downto 0);
        alu_op_out : out std_logic_vector(3 downto 0);
        alu_src_out: out std_logic;
        mem_read_out: out std_logic;
        mem_write_out: out std_logic;
        mem_to_reg_out: out std_logic;
        reg_write_out: out std_logic;
        branch_out: out std_logic;
        jump_out  : out std_logic
    );
end entity;

architecture rtl of id_ex is
    signal pc_r, rs1_r, rs2_r, imm_r : std_logic_vector(31 downto 0);
    signal rs1a_r, rs2a_r, rda_r : std_logic_vector(4 downto 0);
    signal aluop_r : std_logic_vector(3 downto 0);
    signal alusrc_r, mread_r, mwrite_r, mtoreg_r, rwrite_r, br_r, j_r : std_logic;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pc_r <= (others=>'0');
            rs1_r <= (others=>'0');
            rs2_r <= (others=>'0');
            imm_r <= (others=>'0');
            rs1a_r <= (others=>'0');
            rs2a_r <= (others=>'0');
            rda_r <= (others=>'0');
            aluop_r <= (others=>'0');
            alusrc_r <= '0';
            mread_r <= '0';
            mwrite_r <= '0';
            mtoreg_r <= '0';
            rwrite_r <= '0';
            br_r <= '0';
            j_r <= '0';
        elsif rising_edge(clk) then
            if flush = '1' then
                pc_r <= (others=>'0');
                rs1_r <= (others=>'0');
                rs2_r <= (others=>'0');
                imm_r <= (others=>'0');
                rs1a_r <= (others=>'0');
                rs2a_r <= (others=>'0');
                rda_r <= (others=>'0');
                aluop_r <= (others=>'0');
                alusrc_r <= '0';
                mread_r <= '0';
                mwrite_r <= '0';
                mtoreg_r <= '0';
                rwrite_r <= '0';
                br_r <= '0';
                j_r <= '0';
            else
                pc_r <= pc_in;
                rs1_r <= rs1_in;
                rs2_r <= rs2_in;
                imm_r <= imm_in;
                rs1a_r <= rs1_addr_in;
                rs2a_r <= rs2_addr_in;
                rda_r <= rd_addr_in;
                aluop_r <= alu_op_in;
                alusrc_r <= alu_src_in;
                mread_r <= mem_read_in;
                mwrite_r <= mem_write_in;
                mtoreg_r <= mem_to_reg_in;
                rwrite_r <= reg_write_in;
                br_r <= branch_in;
                j_r <= jump_in;
            end if;
        end if;
    end process;

    -- outputs
    pc_out <= pc_r;
    rs1_out <= rs1_r;
    rs2_out <= rs2_r;
    imm_out <= imm_r;
    rs1_addr_out <= rs1a_r;
    rs2_addr_out <= rs2a_r;
    rd_addr_out <= rda_r;
    alu_op_out <= aluop_r;
    alu_src_out <= alusrc_r;
    mem_read_out <= mread_r;
    mem_write_out <= mwrite_r;
    mem_to_reg_out <= mtoreg_r;
    reg_write_out <= rwrite_r;
    branch_out <= br_r;
    jump_out <= j_r;
end architecture;