##Makefile
debug_mode=verdi
CC=vcs
##vcs compiler
CFLAG =-full64 -sverilog -debug_acc+all -timescale=1ns/1ps -LDFLAGS -Wl,--no-as-need \
	   -l com.log

SRC_DIR = ../src
SIM_DIR = ../sim

SRC_SV = $(wildcard $(SRC_DIR)/*.sv)
SIM_SV = $(wildcard $(SIM_DIR)/*.sv)
SRC_V = $(wildcard $(SRC_DIR)/*.v)
SIM_V = $(wildcard $(SIM_DIR)/*.v)

SRC   = $(SRC_SV) $(SRC_V)
SIM   = $(SIM_SV) $(SIM_V)

all:compile sim

add_fsdb:
	@if [ "$(debug_mode)" = "verdi" ]; then \
		awk '/endmodule/ {system("cat verdi.vt");print"";print} !/endmodule/ {print}' $(SIM)>tempfile;\
	fi
	@mv tempfile $(SIM)

find_list:
	@echo $(SRC) | tr " " "\n">rtl.f
	@echo $(SIM) | tr " " "\n">dv.f

compile:
	@$(MAKE) find_list
	$(CC) $(CFLAG) $(SRC) $(SIM)
sim:	
	./simv $(mode) -l sim.log
verdi:
	verdi -2001 \
	      -ssf *.fsdb \
	    &
	    
clean:
	-rm -rf         simv.daidir	\
			verdiLog	\
			csrc		\
			ucli.key	\
			simv		\
			*.log		\
			*.fsdb		\
			*.conf		



