NAME = top
DEPS = vga.v inp.v pll.v disp.v
CLK_MHZ = 25

all: fw

.PHONY: hello
hello:
	verilator --binary -j 0 -Wall helloworld.v
	./obj_dir/Vhelloworld

.PHONY: lint
lint: $(NAME).v $(DEPS)
	verilator --lint-only --Wall --timing --top-module $(NAME) $(DEPS) $(NAME).v

.PHONY: sim_vga
sim_vga:
	verilator --binary --timescale 1ns --timing --trace -j 0 tb_vga.v
	./obj_dir/Vtb_vga

.PHONY: sim_disp
sim_disp:
	verilator --binary --timescale 1ns --timing --trace -j 0 tb_disp.v
	./obj_dir/Vtb_disp


pll-hw.v:
	icepll -i 16 -o $(CLK_MHZ) -m -f $@


.PHONY: upload
upload: $(NAME).bin
	tinyprog -p $(NAME).bin

fw: $(NAME).bin

$(NAME).bin: $(NAME).pcf $(NAME).v $(DEPS)
	yosys -q -p "synth_ice40 -blif $(NAME).blif" -p "write_json $(NAME).json" -r $(NAME) $(NAME).v $(DEPS)
	nextpnr-ice40 --json top.json --pcf top.pcf --asc top.asc --lp8k --package cm81 --freq $(CLK_MHZ)
	icepack -s $(NAME).asc $(NAME).bin

.PHONY: gui
gui: $(NAME).pcf $(NAME).v $(DEPS)
	yosys -p "synth_ice40 -blif $(NAME).blif" -p "write_json $(NAME).json" $(NAME).v $(DEPS)
	nextpnr-ice40 --json $(NAME).json --pcf $(NAME).pcf --asc $(NAME).asc --gui

.PHONY: sim
sim: $(NAME).v $(DEPS) $(NAME)_tb.v $(shell yosys-config --datdir)/ice40/cells_sim.v
	iverilog $^ -o $(NAME)_tb.out
	./$(NAME)_tb.out
	gtkwave $(NAME)_tb.vcd $(NAME)_tb.gtkw &


.PHONY: clean
clean:
	rm *.bin *.blif *.out
