-- regfile.vhd - Register file for RV32I
-- Copyright (C) 2025  4137314
--
-- GNU GPLv3
--
-- 32 registers x0..x31, each 32-bit. x0 is hard-wired to zero.
-- Two read ports, one write port (write occurs on rising edge when reg_write = '1').

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regfile is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        rs1_addr  : in  std_logic_vector(4 downto 0);
        rs2_addr  : in  std_logic_vector(4 downto 0);
        rd_addr   : in  std_logic_vector(4 downto 0);
        rs1_data  : out std_logic_vector(31 downto 0);
        rs2_data  : out std_logic_vector(31 downto 0);
        rd_data   : in  std_logic_vector(31 downto 0);
        reg_write : in  std_logic
    );
end entity;

architecture rtl of regfile is
    type reg_array_t is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs : reg_array_t := (others => (others => '0'));
    signal r1_idx, r2_idx, w_idx : integer range 0 to 31;
begin
    -- combinational read ports (as in typical RISC-V regfile)
    r1_idx <= to_integer(unsigned(rs1_addr));
    r2_idx <= to_integer(unsigned(rs2_addr));

    rs1_data <= regs(r1_idx);
    rs2_data <= regs(r2_idx);

    -- synchronous write port
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                regs <= (others => (others => '0'));
            else
                if reg_write = '1' then
                    w_idx := to_integer(unsigned(rd_addr));
                    -- x0 is hardwired to zero, do not write x0
                    if w_idx /= 0 then
                        regs(w_idx) <= rd_data;
                    end if;
                end if;
            end if;
        end if;
    end process;
end architecture;