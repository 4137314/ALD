-- =============================================================================
-- alu.vhd - Arithmetic Logic Unit (RV32I subset)
-- =============================================================================
-- Author: 4137314
-- Year:   2025
-- License: GNU GPLv3
--
-- Description:
--   Simple 32-bit ALU supporting common integer operations from the RISC-V
--   RV32I instruction set. Performs arithmetic, logical, and shift operations
--   on 32-bit operands. The ALU generates a 'zero' flag when the result equals 0.
--
-- alu_op encoding (4 bits):
--   "0000" : ADD    (a + b)
--   "0001" : SUB    (a - b)
--   "0010" : AND    (a and b)
--   "0011" : OR     (a or b)
--   "0100" : XOR    (a xor b)
--   "0101" : SLL    (b << a[4:0])  Logical shift left
--   "0110" : SRL    (b >> a[4:0])  Logical shift right
--   "0111" : SRA    (b >>> a[4:0]) Arithmetic shift right
--   "1000" : SLT    (set if a < b signed)
--   "1001" : SLTU   (set if a < b unsigned)
--   others : result = 0
--
-- Notes:
--   - Signed and unsigned arithmetic are handled separately using `signed` and
--     `unsigned` types.
--   - For shift operations, only the lower 5 bits of 'b' are used as shift amount.
--   - Result multiplexing gives priority to signed results for arithmetic ops.
--
-- =============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================================
-- Entity Declaration
-- ============================================================================
-- Inputs:
--   a, b    : 32-bit operands
--   alu_op  : 4-bit control code selecting the operation
--
-- Outputs:
--   result  : 32-bit operation result
--   zero    : flag = '1' when result = 0
-- ============================================================================
entity alu is
    port (
        a      : in  std_logic_vector(31 downto 0);
        b      : in  std_logic_vector(31 downto 0);
        alu_op : in  std_logic_vector(3 downto 0);
        result : out std_logic_vector(31 downto 0);
        zero   : out std_logic
    );
end entity alu;

-- ============================================================================
-- Architecture: rtl
-- ============================================================================
-- Implements combinational ALU logic using signed and unsigned arithmetic.
-- The result is driven by either 'res_s' (signed) or 'res_u' (unsigned)
-- depending on the operation.
-- ============================================================================
architecture rtl of alu is
    -- Local signed/unsigned versions of the inputs
    signal sa, sb : signed(31 downto 0);
    signal ua, ub : unsigned(31 downto 0);

    -- Internal result signals
    signal res_s  : signed(31 downto 0);
    signal res_u  : unsigned(31 downto 0);
begin
    -- Type casting for arithmetic operations
    sa <= signed(a);
    sb <= signed(b);
    ua <= unsigned(a);
    ub <= unsigned(b);

    process(sa, sb, ua, ub, alu_op)
    variable v_res_s : signed(31 downto 0);
    variable v_res_u : unsigned(31 downto 0);
begin
    -- Default values
    v_res_s := (others => '0');
    v_res_u := (others => '0');

    case alu_op is
        when "0000" =>  -- ADD
            v_res_s := sa + sb;
        when "0001" =>  -- SUB
            v_res_s := sa - sb;
        when "0010" =>  -- AND
            v_res_u := ua and ub;
        when "0011" =>  -- OR
            v_res_u := ua or ub;
        when "0100" =>  -- XOR
            v_res_u := ua xor ub;
        when "0101" =>  -- SLL
            v_res_u := shift_left(ub, to_integer(unsigned(b(4 downto 0))));
        when "0110" =>  -- SRL
            v_res_u := shift_right(ub, to_integer(unsigned(b(4 downto 0))));
        when "0111" =>  -- SRA
            v_res_s := shift_right(sa, to_integer(unsigned(b(4 downto 0))));
        when "1000" =>  -- SLT
            if sa < sb then
                v_res_u := (others => '0');
                v_res_u(0) := '1';
            else
                v_res_u := (others => '0');
            end if;
        when "1001" =>  -- SLTU
            if ua < ub then
                v_res_u := (others => '0');
                v_res_u(0) := '1';
            else
                v_res_u := (others => '0');
            end if;
        when others =>
            v_res_s := (others => '0');
            v_res_u := (others => '0');
    end case;

    -- Result selection
    if alu_op = "0000" or alu_op = "0001" or alu_op = "0111" then
        result <= std_logic_vector(v_res_s);
    else
        result <= std_logic_vector(v_res_u);
    end if;

    -- Zero flag generation
    if (alu_op = "0000" or alu_op = "0001" or alu_op = "0111") then
        if v_res_s = 0 then
            zero <= '1';
        else
            zero <= '0';
        end if;
    else
        if v_res_u = 0 then
            zero <= '1';
        else
            zero <= '0';
        end if;
    end if;

end process;
end architecture rtl;
