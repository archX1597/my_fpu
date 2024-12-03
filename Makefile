# Directory Structure
MY_SRC_DIR     := $(abspath ./src)
MY_TB_DIR      := $(abspath ./testbench)
MY_ENV_DIR     := $(abspath ./verify)
MY_SIM_DIR     := $(abspath ./sim)
MY_LOG_DIR     := $(MY_SIM_DIR)/log
MY_OUT_DIR     := $(MY_SIM_DIR)/out
MY_COMPILE_DIR := $(MY_SIM_DIR)/build
MY_COVERAGE_DIR := $(MY_SIM_DIR)/cov.vdb
MY_VERDI_RC     := ~/.script/novas.rc

# Compiler and viewer
MY_COMPILER    := vcs
MY_WAVE_VIEWER := Verdi-Ultra -rcFile $(MY_VERDI_RC)

# Variables
MY_TEST_NAME   ?= test1
MY_USE_UVM     ?= 0
MY_GUI_MODE    ?= 0
MY_COV_MODE    ?= 1
MY_COV_DIR     ?= ./sim/${MY_TEST_NAME}.vdb

# Find all relevant files
MY_SRC_FILES   := $(shell find ${MY_SRC_DIR} -type f \( -name "*.sv" -o -name "*.v" -o -name "*.svh" \))
MY_ENV_FILES   := $(shell find ${MY_ENV_DIR} -type f \( -name "*.sv" -o -name "*.v" -o -name "*.svh" \))
MY_TB_TOP      := $(shell find ${MY_TB_DIR} -type f \( -name "top_tb.sv" -o -name "top_tb.v" -o -name "tb.sv" \))

# Simulation and Coverage Output
MY_SIM_EXEC      := ${MY_SIM_DIR}/simv
MY_COMP_LOG_FILE := ${MY_LOG_DIR}/${MY_TEST_NAME}_compile.log
MY_SIM_LOG_FILE  := ${MY_LOG_DIR}/${MY_TEST_NAME}.log

# Compile Options
MY_VCS_OPTS    := -full64 -sverilog -debug_access+all -kdb +lint=TFIPC-L -l $(MY_COMP_LOG_FILE) -Mdir=${MY_COMPILE_DIR}

# Include UVM library if MY_USE_UVM is set to 1
ifeq (${MY_USE_UVM}, 1)
    MY_VCS_OPTS += +incdir+$(UVM_HOME)/src -ntb_opts uvm
endif
   
# Simulation Options (conditional GUI mode)
MY_SIM_OPTS := -l ${MY_SIM_LOG_FILE}
ifeq (${MY_GUI_MODE}, 1)
    MY_SIM_OPTS += -gui=${MY_WAVE_VIEWER}
endif

ifeq (${MY_COV_MODE}, 1)
    MY_VCS_OPTS += -cm line+cond+fsm+tgl+branch+assert -cm_dir  ${MY_COV_DIR}
    MY_SIM_OPTS += -cm line+cond+fsm+tgl+branch+assert -cov_dir ${MY_COV_DIR}
endif

# Marker files for tracking changes
TEST_NAME_MARKER := ${MY_SIM_DIR}/.test_name_marker
SIM_NAME_MARKER := ${MY_SIM_DIR}/.sim_name_marker

# Create necessary directories if they don't exist
.PHONY: directories
directories:
	@mkdir -p ${MY_SIM_DIR} ${MY_LOG_DIR} ${MY_COMPILE_DIR} ${MY_OUT_DIR}

# Default target: compile and simulate
.PHONY: all
all: compile sim wave

.PHONY:rev
rev: compile sim

# Update marker whenever MY_TEST_NAME changes for compilation
.PHONY: update_marker
update_marker:
	@echo "Current Test Name: ${MY_TEST_NAME}" > ${TEST_NAME_MARKER}

# Update marker for simulation whenever MY_TEST_NAME changes
.PHONY: update_sim_marker
update_sim_marker:
	@echo "Current Simulation Name: ${MY_TEST_NAME}" > ${SIM_NAME_MARKER}

# Remove old log files if MY_TEST_NAME changes to generate new logs
.PHONY: clean_logs
clean_logs:
	@rm -f ${MY_COMP_LOG_FILE} ${MY_SIM_LOG_FILE}

# Compile target with dependency on TEST_NAME_MARKER and clean_logs
.PHONY: compile
compile: directories update_marker clean_logs ${MY_SIM_EXEC} 

${MY_SIM_EXEC}: ${MY_SRC_FILES} ${MY_ENV_FILES} ${MY_TB_TOP} ${TEST_NAME_MARKER}
	@echo "Compiling with ${MY_COMPILER} for ${MY_TEST_NAME}..."
	${MY_COMPILER} ${MY_VCS_OPTS} ${MY_SRC_FILES} ${MY_ENV_FILES} ${MY_TB_TOP} -o ${MY_SIM_EXEC}

# Simulate target with dependency on SIM_NAME_MARKER
.PHONY: sim 
sim: update_sim_marker
	@echo "Running simulation in ${MY_OUT_DIR} for ${MY_TEST_NAME}..."
	cd ${MY_OUT_DIR} && ${MY_SIM_EXEC} ${MY_SIM_OPTS}

# Coverage report target
.PHONY: merge_cov
merge_cov:
	@echo "Merging coverage data..."
	cd $(MY_SIM_DIR) && urg -full64 -dir *.vdb -dbname merged -parallel -report urgReport

.PHONY: coverage
coverage:
	@echo "Generating coverage report..."
	cd $(MY_SIM_DIR) && ${MY_WAVE_VIEWER} -cov -covdir *.vdb &

# Waveform viewing target
.PHONY: wave
wave:
	@echo "Opening waveform in ${MY_WAVE_VIEWER} with design..."
	cd ${MY_OUT_DIR} && ${MY_WAVE_VIEWER} -logdir $(MY_OUT_DIR)/VerdiLog \
	-simflow \
	-dbdir ${MY_SIM_DIR}/simv.daidir \
	-simBin ${MY_SIM_DIR}/simv \
	-ssf ${MY_OUT_DIR}/*.fsdb \
	&
.PHONY: verdi
verdi:
	$(MY_WAVE_VIEWER) &
# Clean target
.PHONY: clean
clean:
	@echo "Cleaning simulation and log files..."
	@if [ "${MY_SIM_DIR}" = "${MY_SIM_DIR}" ]; then \
	    find ${MY_SIM_DIR} -mindepth 1 -delete; \
	else \
	    echo "Warning: MY_SIM_DIR is not set to ./sim, skipping clean for MY_SIM_DIR."; \
	fi
