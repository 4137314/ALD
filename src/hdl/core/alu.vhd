-- alu.vhd - Arithmetic Logic Unit (RV32I subset)
-- Copyright (C) 2025  4137314
--
-- GNU GPLv3
--
-- Small ALU supporting common integer operations.
-- alu_op is 4 bits: encoding below in comments.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    port (
        a      : in  std_logic_vector(31 downto 0);
        b      : in  std_logic_vector(31 downto 0);
        alu_op : in  std_logic_vector(3 downto 0);
        result : out std_logic_vector(31 downto 0);
        zero   : out std_logic    -- flag, '1' if result = 0
    );
end entity;

architecture rtl of alu is
    signal sa, sb : signed(31 downto 0);
    signal ua, ub : unsigned(31 downto 0);
    signal res_s  : signed(31 downto 0);
    signal res_u  : unsigned(31 downto 0);
begin
    sa <= signed(a);
    sb <= signed(b);
    ua <= unsigned(a);
    ub <= unsigned(b);

    process(sa, sb, ua, ub, alu_op)
    begin
        -- default
        res_s := (others => '0');
        res_u := (others => '0');
        case alu_op is
            when "0000" =>   -- ADD (signed/unsigned)
                res_s := sa + sb;
            when "0001" =>   -- SUB
                res_s := sa - sb;
            when "0010" =>   -- AND
                res_u := ua and ub;
            when "0011" =>   -- OR
                res_u := ua or ub;
            when "0100" =>   -- XOR
                res_u := ua xor ub;
            when "0101" =>   -- SLL (logical shift left)
                res_u := shift_left(ub, to_integer(unsigned(a(4 downto 0))));
            when "0110" =>   -- SRL (logical shift right)
                res_u := shift_right(ub, to_integer(unsigned(a(4 downto 0))));
            when "0111" =>   -- SRA (arithmetic shift right)
                res_s := shift_right(sa, to_integer(unsigned(a(4 downto 0))));
            when "1000" =>   -- SLT (set less than signed)
                if sa < sb then
                    res_u := (others => '0');
                    res_u(0) := '1';
                else
                    res_u := (others => '0');
                end if;
            when "1001" =>   -- SLTU (set less than unsigned)
                if ua < ub then
                    res_u := (others => '0');
                    res_u(0) := '1';
                else
                    res_u := (others => '0');
                end if;
            when others =>
                res_s := (others => '0');
                res_u := (others => '0');
        end case;

        -- prioritize signed result when applicable (ADD/SUB/SRA/SLT)
        if alu_op = "0000" or alu_op = "0001" or alu_op = "0111" then
            result <= std_logic_vector(res_s);
        elsif alu_op = "1000" then
            -- SLT result is in res_u LSB
            result <= std_logic_vector(res_u);
        else
            result <= std_logic_vector(res_u);
        end if;

        if result = (others => '0') then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end process;
end architecture;