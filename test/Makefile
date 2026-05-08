SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../src/pm32.v
VERILOG_SOURCES += $(PWD)/../src/spm.v

TOPLEVEL = pm32
MODULE = test

include $(shell cocotb-config --makefiles)/Makefile.sim
