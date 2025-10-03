-- control_unit.vhd - Simple control unit for RV32I
-- Copyright (C) 2025  4137314
--
-- GNU GPLv3
--
-- Decodes the opcode (and funct3/funct7 for some R-type ops) and generates:
-- alu_op (4 bits), reg_write, mem_read, mem_write, branch, jump, rd_addr.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
    port (
        instr      : in  std_logic_vector(31 downto 0);
        alu_op     : out std_logic_vector(3 downto 0);
        reg_write  : out std_logic;
        mem_read   : out std_logic;
        mem_write  : out std_logic;
        branch     : out std_logic;
        jump       : out std_logic;
        rd_addr    : out std_logic_vector(4 downto 0)
    );
end entity;

architecture rtl of control_unit is
    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    signal funct7 : std_logic_vector(6 downto 0);
begin
    opcode <= instr(6 downto 0);
    funct3 <= instr(14 downto 12);
    funct7 <= instr(31 downto 25);
    rd_addr <= instr(11 downto 7);

    process(opcode, funct3, funct7)
    begin
        -- default signals
        alu_op    <= "0000";  -- ADD default
        reg_write <= '0';
        mem_read  <= '0';
        mem_write <= '0';
        branch    <= '0';
        jump      <= '0';

        case opcode is
            when "0110011" =>  -- R-type
                reg_write <= '1';
                -- decode funct3/funct7 for op
                if funct3 = "000" then
                    if funct7 = "0100000" then
                        alu_op <= "0001"; -- SUB
                    else
                        alu_op <= "0000"; -- ADD
                    end if;
                elsif funct3 = "111" then
                    alu_op <= "0010"; -- AND
                elsif funct3 = "110" then
                    alu_op <= "0011"; -- OR
                elsif funct3 = "100" then
                    alu_op <= "0100"; -- XOR
                elsif funct3 = "001" then
                    alu_op <= "0101"; -- SLL (shift amount from RS2)
                elsif funct3 = "101" then
                    if funct7 = "0100000" then
                        alu_op <= "0111"; -- SRA
                    else
                        alu_op <= "0110"; -- SRL
                    end if;
                elsif funct3 = "010" then
                    alu_op <= "1000"; -- SLT
                elsif funct3 = "011" then
                    alu_op <= "1001"; -- SLTU (we map to 1001)
                else
                    alu_op <= "0000"; -- default ADD
                end if;

            when "0010011" =>  -- I-type ALU immediate (ADDI, SLLI, SRLI, etc)
                reg_write <= '1';
                if funct3 = "000" then
                    alu_op <= "0000"; -- ADDI
                elsif funct3 = "111" then
                    alu_op <= "0010"; -- ANDI
                elsif funct3 = "110" then
                    alu_op <= "0011"; -- ORI
                elsif funct3 = "100" then
                    alu_op <= "0100"; -- XORI
                elsif funct3 = "001" then
                    alu_op <= "0101"; -- SLLI
                elsif funct3 = "101" then
                    -- check funct7 for SRLI/SRAI
                    if funct7(5) = '1' then
                        alu_op <= "0111"; -- SRAI
                    else
                        alu_op <= "0110"; -- SRLI
                    end if;
                elsif funct3 = "010" then
                    alu_op <= "1000"; -- SLTI
                else
                    alu_op <= "0000";
                end if;

            when "0000011" =>  -- LOAD (I-type)
                mem_read <= '1';
                reg_write <= '1';
                alu_op <= "0000"; -- use ADD for address calc
            when "0100011" =>  -- STORE (S-type)
                mem_write <= '1';
                alu_op <= "0000"; -- use ADD for address calc
            when "1100011" =>  -- BRANCH (B-type)
                branch <= '1';
                -- choose ALU op SUB to compare zero or do SLT depending on funct3
                if funct3 = "000" or funct3 = "001" then
                    alu_op <= "0001"; -- SUB (BEQ/BNE compare)
                else
                    alu_op <= "1000"; -- use SLT for BLT/BGE
                end if;
            when "1101111" =>  -- JAL
                jump <= '1';
                reg_write <= '1';
                alu_op <= "0000"; -- not used
            when "1100111" =>  -- JALR
                jump <= '1';
                reg_write <= '1';
                alu_op <= "0000";
            when "0110111" =>  -- LUI
                reg_write <= '1';
                alu_op <= "0000"; -- handled externally using imm << 12
            when "0010111" =>  -- AUIPC
                reg_write <= '1';
                alu_op <= "0000";
            when others =>
                -- unsupported opcodes: keep defaults (no write)
                alu_op <= "0000";
        end case;
    end process;
end architecture;