-- imm_gen.vhd - Immediate generator for RV32I
-- Copyright (C) 2025  4237314
--
-- GNU GPLv3
--
-- Produces 32-bit sign-extended immediates for I,S,B,U,J formats.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity imm_gen is
    port (
        instr   : in  std_logic_vector(31 downto 0);
        imm_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of imm_gen is
    signal opcode : std_logic_vector(6 downto 0);
    signal imm_i, imm_s, imm_b, imm_u, imm_j : std_logic_vector(31 downto 0);
begin
    opcode <= instr(6 downto 0);

    -- I-type immediate (bits 31:20)
    imm_i <= std_logic_vector(resize(signed(instr(31 downto 20)), 32));

    -- S-type imm: bits [31:25][11:7]
    imm_s <= std_logic_vector(resize(signed(instr(31 downto 25) & instr(11 downto 7)), 32));

    -- B-type imm: bits [31],[7],[30:25],[11:8], LSB is zero
    imm_b <= std_logic_vector(
                resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & "0"), 32)
             );

    -- U-type imm: bits [31:12] << 12
    imm_u <= instr(31 downto 12) & x"000";

    -- J-type imm: bits [31],[19:12],[20],[30:21], LSB zero
    imm_j <= std_logic_vector(
                resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & "0"), 32)
             );

    -- Select immediate based on opcode (simple heuristic)
    process(opcode, imm_i, imm_s, imm_b, imm_u, imm_j)
    begin
        case opcode is
            when "0010011" =>   -- I-type ALU
                imm_out <= imm_i;
            when "0000011" =>   -- Load (I-type)
                imm_out <= imm_i;
            when "0100011" =>   -- Store (S-type)
                imm_out <= imm_s;
            when "1100011" =>   -- Branch (B-type)
                imm_out <= imm_b;
            when "0110111" =>   -- LUI (U-type)
                imm_out <= imm_u;
            when "0010111" =>   -- AUIPC (U-type)
                imm_out <= imm_u;
            when "1101111" =>   -- JAL (J-type)
                imm_out <= imm_j;
            when "1100111" =>   -- JALR (I-type)
                imm_out <= imm_i;
            when others =>
                imm_out <= (others => '0');
        end case;
    end process;
end architecture;