test:
	verilator --sv --binary -j 0 -Wall helloworld.v
	./obj_dir/Vhelloworld
	verilator --sv --lint-only --Wall vga.sv

