-- fsm_controller.vhd - Simple TPU FSM
-- Copyright (C) 2025 4137314
-- License: GNU GPL v3
--
-- States: IDLE -> LOAD -> COMPUTE -> DONE -> IDLE

library ieee;
use ieee.std_logic_1164.all;

entity fsm_controller is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        start : in  std_logic;
        done  : out std_logic
    );
end entity;

architecture rtl of fsm_controller is
    type state_type is (IDLE, LOAD, COMPUTE, DONE);
    signal state : state_type := IDLE;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
            done <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    done <= '0';
                    if start = '1' then
                        state <= LOAD;
                    end if;
                when LOAD =>
                    state <= COMPUTE;
                when COMPUTE =>
                    state <= DONE;
                when DONE =>
                    done <= '1';
                    state <= IDLE;
            end case;
        end if;
    end process;
end architecture;