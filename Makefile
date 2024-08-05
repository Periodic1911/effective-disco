test:
	verilator --sv --binary -j 0 -Wall helloworld.v
	./obj_dir/Vhelloworld
	verilator --sv --lint-only --Wall vga.sv

sim:
	verilator --sv --binary --timescale 1ns --timing --trace -j 0 tb_vga.sv
	./obj_dir/Vtb_vga
