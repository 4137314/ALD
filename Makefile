# =========================================================
# Makefile for VHDL Simulation (GHDL)
# Project: RISC-V
# Author: 4137314
# =========================================================

# Name of testbench entity (default)
TB ?= tb_alu

# Source directories
HDL_DIR = src/hdl
TB_DIR  = src/tb

# Collect source files recursively
SRC := $(shell find $(HDL_DIR) -type f -name "*.vhd" | sort)
TB_SRC := $(TB_DIR)/$(TB).vhd

# Output waveform file
WAVE = $(TB).vcd

# =========================================================
# Main targets
# =========================================================

.PHONY: all analyze elaborate run wave clean

# Default: compile + simulate
all: run

# Analyze all VHDL files
analyze:
	@echo "[GHDL] Analyzing source files..."
	ghdl -a $(SRC) $(TB_SRC)

# Elaborate selected testbench
elaborate: analyze
	@echo "[GHDL] Elaborating $(TB)..."
	ghdl -e $(TB)

# Run simulation and dump waveform
run: elaborate
	@echo "[GHDL] Running simulation..."
	ghdl -r $(TB) --vcd=$(WAVE)

# View waveform with GTKWave
wave:
	gtkwave $(WAVE) &

# Clean generated files
clean:
	@echo "[CLEAN] Removing build artifacts..."
	rm -f *.o *.cf $(TB) $(WAVE)