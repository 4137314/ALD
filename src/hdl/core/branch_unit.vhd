-- branch_unit.vhd - Branch comparator / decision logic (minimal)
-- Copyright (C) 2025  4137314
-- GNU GPLv3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity branch_unit is
    port (
        rs1   : in  std_logic_vector(31 downto 0);
        rs2   : in  std_logic_vector(31 downto 0);
        funct3: in  std_logic_vector(2 downto 0);
        take  : out std_logic
    );
end entity;

architecture rtl of branch_unit is
    signal s1, s2 : signed(31 downto 0);
    signal u1, u2 : unsigned(31 downto 0);
begin
    s1 <= signed(rs1);
    s2 <= signed(rs2);
    u1 <= unsigned(rs1);
    u2 <= unsigned(rs2);

    process(s1, s2, u1, u2, funct3)
    begin
        take <= '0';
        case funct3 is
            when "000" => -- BEQ
                if s1 = s2 then take <= '1'; end if;
            when "001" => -- BNE
                if s1 /= s2 then take <= '1'; end if;
            when "100" => -- BLT
                if s1 < s2 then take <= '1'; end if;
            when "101" => -- BGE
                if s1 >= s2 then take <= '1'; end if;
            when "110" => -- BLTU
                if u1 < u2 then take <= '1'; end if;
            when "111" => -- BGEU
                if u1 >= u2 then take <= '1'; end if;
            when others =>
                take <= '0';
        end case;
    end process;
end architecture;