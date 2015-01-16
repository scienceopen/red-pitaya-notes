source projects/cfg_test/block_design.tcl

# Create xlslice
cell xilinx.com:ip:xlslice:1.0 slice_2 {
  DIN_WIDTH 1024 DIN_FROM 0 DIN_TO 0 DOUT_WIDTH 1
} {
  Din cfg_0/cfg_data
}

# Create xlslice
cell xilinx.com:ip:xlslice:1.0 slice_3 {
  DIN_WIDTH 1024 DIN_FROM 1 DIN_TO 1 DOUT_WIDTH 1
} {
  Din cfg_0/cfg_data
}

# Create xlslice
cell xilinx.com:ip:xlslice:1.0 slice_4 {
  DIN_WIDTH 1024 DIN_FROM 2 DIN_TO 2 DOUT_WIDTH 1
} {
  Din cfg_0/cfg_data
}

# Create xlslice
cell xilinx.com:ip:xlslice:1.0 slice_5 {
  DIN_WIDTH 1024 DIN_FROM 63 DIN_TO 32 DOUT_WIDTH 32
} {
  Din cfg_0/cfg_data
}

# Create xlslice
cell xilinx.com:ip:xlslice:1.0 slice_6 {
  DIN_WIDTH 1024 DIN_FROM 95 DIN_TO 64 DOUT_WIDTH 32
} {
  Din cfg_0/cfg_data
}

# Create axis_counter
cell pavel-demin:user:axis_counter:1.0 cntr_1 {} {
  cfg_data slice_5/Dout
  aclk ps_0/FCLK_CLK0
  aresetn slice_2/Dout
}

# Create blk_mem_gen
cell xilinx.com:ip:blk_mem_gen:8.2 bram_0 {
  MEMORY_TYPE True_Dual_Port_RAM
  USE_BRAM_BLOCK Stand_Alone
  WRITE_WIDTH_A 32
  WRITE_DEPTH_A 16384
  ENABLE_A Always_Enabled
  ENABLE_B Always_Enabled
  REGISTER_PORTA_OUTPUT_OF_MEMORY_PRIMITIVES false
  REGISTER_PORTB_OUTPUT_OF_MEMORY_PRIMITIVES false
}

# Create axis_histogram
cell pavel-demin:user:axis_histogram:1.0 hist_0 {
  BRAM_ADDR_WIDTH 14
  S_AXIS_TDATA_WIDTH 16
  M_AXIS_TDATA_WIDTH 32
} {
  S_AXIS cntr_1/M_AXIS
  BRAM_PORTA bram_0/BRAM_PORTA
  BRAM_PORTB bram_0/BRAM_PORTB
}

# Create axis_packetizer
cell pavel-demin:user:axis_packetizer:1.0 pktzr_0 {} {
  S_AXIS hist_0/M_AXIS
  cfg_data slice_6/Dout
  aclk ps_0/FCLK_CLK0
  aresetn slice_3/Dout
}

# Create axis_ram_writer
cell pavel-demin:user:axis_ram_writer:1.0 writer_0 {} {
  S_AXIS pktzr_0/M_AXIS
  M_AXI ps_0/S_AXI_HP0
  aclk ps_0/FCLK_CLK0
  aresetn slice_4/Dout
}

create_bd_addr_seg -range 8M -offset 0x1E000000 [get_bd_addr_spaces writer_0/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
