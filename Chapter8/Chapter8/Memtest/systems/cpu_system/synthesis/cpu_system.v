// cpu_system.v


module cpu_system (
		input  wire        mem_reset_reset_n,                 //                   mem_reset.reset_n
		input  wire        mem_clk_clk,                       //                     mem_clk.clk
		input  wire        cpu_clk_clk,                       //                     cpu_clk.clk
		input  wire        cpu_reset_reset_n,                 //                   cpu_reset.reset_n
		output wire        cpu_jtag_debug_module_reset_reset, // cpu_jtag_debug_module_reset.reset
		input  wire        master_waitrequest,                //                      master.waitrequest
		input  wire [31:0] master_readdata,                   //                            .readdata
		input  wire        master_readdatavalid,              //                            .readdatavalid
		output wire [2:0]  master_burstcount,                 //                            .burstcount
		output wire [31:0] master_writedata,                  //                            .writedata
		output wire [29:0] master_address,                    //                            .address
		output wire        master_write,                      //                            .write
		output wire        master_read,                       //                            .read
		output wire [3:0]  master_byteenable,                 //                            .byteenable
		output wire        master_debugaccess                 //                            .debugaccess
	);

	wire         cpu_instruction_master_waitrequest;                                                               // cpu_instruction_master_translator:av_waitrequest -> cpu:i_waitrequest
	wire  [18:0] cpu_instruction_master_address;                                                                   // cpu:i_address -> cpu_instruction_master_translator:av_address
	wire         cpu_instruction_master_read;                                                                      // cpu:i_read -> cpu_instruction_master_translator:av_read
	wire  [31:0] cpu_instruction_master_readdata;                                                                  // cpu_instruction_master_translator:av_readdata -> cpu:i_readdata
	wire         cpu_data_master_waitrequest;                                                                      // cpu_data_master_translator:av_waitrequest -> cpu:d_waitrequest
	wire  [31:0] cpu_data_master_writedata;                                                                        // cpu:d_writedata -> cpu_data_master_translator:av_writedata
	wire  [30:0] cpu_data_master_address;                                                                          // cpu:d_address -> cpu_data_master_translator:av_address
	wire         cpu_data_master_write;                                                                            // cpu:d_write -> cpu_data_master_translator:av_write
	wire         cpu_data_master_read;                                                                             // cpu:d_read -> cpu_data_master_translator:av_read
	wire  [31:0] cpu_data_master_readdata;                                                                         // cpu_data_master_translator:av_readdata -> cpu:d_readdata
	wire         cpu_data_master_debugaccess;                                                                      // cpu:jtag_debug_module_debugaccess_to_roms -> cpu_data_master_translator:av_debugaccess
	wire   [3:0] cpu_data_master_byteenable;                                                                       // cpu:d_byteenable -> cpu_data_master_translator:av_byteenable
	wire  [31:0] cpu_jtag_debug_module_translator_avalon_anti_slave_0_writedata;                                   // cpu_jtag_debug_module_translator:av_writedata -> cpu:jtag_debug_module_writedata
	wire   [8:0] cpu_jtag_debug_module_translator_avalon_anti_slave_0_address;                                     // cpu_jtag_debug_module_translator:av_address -> cpu:jtag_debug_module_address
	wire         cpu_jtag_debug_module_translator_avalon_anti_slave_0_chipselect;                                  // cpu_jtag_debug_module_translator:av_chipselect -> cpu:jtag_debug_module_select
	wire         cpu_jtag_debug_module_translator_avalon_anti_slave_0_write;                                       // cpu_jtag_debug_module_translator:av_write -> cpu:jtag_debug_module_write
	wire  [31:0] cpu_jtag_debug_module_translator_avalon_anti_slave_0_readdata;                                    // cpu:jtag_debug_module_readdata -> cpu_jtag_debug_module_translator:av_readdata
	wire         cpu_jtag_debug_module_translator_avalon_anti_slave_0_begintransfer;                               // cpu_jtag_debug_module_translator:av_begintransfer -> cpu:jtag_debug_module_begintransfer
	wire         cpu_jtag_debug_module_translator_avalon_anti_slave_0_debugaccess;                                 // cpu_jtag_debug_module_translator:av_debugaccess -> cpu:jtag_debug_module_debugaccess
	wire   [3:0] cpu_jtag_debug_module_translator_avalon_anti_slave_0_byteenable;                                  // cpu_jtag_debug_module_translator:av_byteenable -> cpu:jtag_debug_module_byteenable
	wire  [31:0] onchip_ram_s1_translator_avalon_anti_slave_0_writedata;                                           // onchip_ram_s1_translator:av_writedata -> onchip_ram:writedata
	wire  [14:0] onchip_ram_s1_translator_avalon_anti_slave_0_address;                                             // onchip_ram_s1_translator:av_address -> onchip_ram:address
	wire         onchip_ram_s1_translator_avalon_anti_slave_0_chipselect;                                          // onchip_ram_s1_translator:av_chipselect -> onchip_ram:chipselect
	wire         onchip_ram_s1_translator_avalon_anti_slave_0_clken;                                               // onchip_ram_s1_translator:av_clken -> onchip_ram:clken
	wire         onchip_ram_s1_translator_avalon_anti_slave_0_write;                                               // onchip_ram_s1_translator:av_write -> onchip_ram:write
	wire  [31:0] onchip_ram_s1_translator_avalon_anti_slave_0_readdata;                                            // onchip_ram:readdata -> onchip_ram_s1_translator:av_readdata
	wire   [3:0] onchip_ram_s1_translator_avalon_anti_slave_0_byteenable;                                          // onchip_ram_s1_translator:av_byteenable -> onchip_ram:byteenable
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_waitrequest;                           // jtag_uart:av_waitrequest -> jtag_uart_avalon_jtag_slave_translator:av_waitrequest
	wire  [31:0] jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_writedata;                             // jtag_uart_avalon_jtag_slave_translator:av_writedata -> jtag_uart:av_writedata
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_address;                               // jtag_uart_avalon_jtag_slave_translator:av_address -> jtag_uart:av_address
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_chipselect;                            // jtag_uart_avalon_jtag_slave_translator:av_chipselect -> jtag_uart:av_chipselect
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_write;                                 // jtag_uart_avalon_jtag_slave_translator:av_write -> jtag_uart:av_write_n
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_read;                                  // jtag_uart_avalon_jtag_slave_translator:av_read -> jtag_uart:av_read_n
	wire  [31:0] jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_readdata;                              // jtag_uart:av_readdata -> jtag_uart_avalon_jtag_slave_translator:av_readdata
	wire         pipeline_bridge_s0_translator_avalon_anti_slave_0_waitrequest;                                    // pipeline_bridge:s0_waitrequest -> pipeline_bridge_s0_translator:av_waitrequest
	wire   [2:0] pipeline_bridge_s0_translator_avalon_anti_slave_0_burstcount;                                     // pipeline_bridge_s0_translator:av_burstcount -> pipeline_bridge:s0_burstcount
	wire  [31:0] pipeline_bridge_s0_translator_avalon_anti_slave_0_writedata;                                      // pipeline_bridge_s0_translator:av_writedata -> pipeline_bridge:s0_writedata
	wire  [29:0] pipeline_bridge_s0_translator_avalon_anti_slave_0_address;                                        // pipeline_bridge_s0_translator:av_address -> pipeline_bridge:s0_address
	wire         pipeline_bridge_s0_translator_avalon_anti_slave_0_write;                                          // pipeline_bridge_s0_translator:av_write -> pipeline_bridge:s0_write
	wire         pipeline_bridge_s0_translator_avalon_anti_slave_0_read;                                           // pipeline_bridge_s0_translator:av_read -> pipeline_bridge:s0_read
	wire  [31:0] pipeline_bridge_s0_translator_avalon_anti_slave_0_readdata;                                       // pipeline_bridge:s0_readdata -> pipeline_bridge_s0_translator:av_readdata
	wire         pipeline_bridge_s0_translator_avalon_anti_slave_0_debugaccess;                                    // pipeline_bridge_s0_translator:av_debugaccess -> pipeline_bridge:s0_debugaccess
	wire         pipeline_bridge_s0_translator_avalon_anti_slave_0_readdatavalid;                                  // pipeline_bridge:s0_readdatavalid -> pipeline_bridge_s0_translator:av_readdatavalid
	wire   [3:0] pipeline_bridge_s0_translator_avalon_anti_slave_0_byteenable;                                     // pipeline_bridge_s0_translator:av_byteenable -> pipeline_bridge:s0_byteenable
	wire         cpu_instruction_master_translator_avalon_universal_master_0_waitrequest;                          // cpu_instruction_master_translator_avalon_universal_master_0_agent:av_waitrequest -> cpu_instruction_master_translator:uav_waitrequest
	wire   [2:0] cpu_instruction_master_translator_avalon_universal_master_0_burstcount;                           // cpu_instruction_master_translator:uav_burstcount -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_burstcount
	wire  [31:0] cpu_instruction_master_translator_avalon_universal_master_0_writedata;                            // cpu_instruction_master_translator:uav_writedata -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_writedata
	wire  [30:0] cpu_instruction_master_translator_avalon_universal_master_0_address;                              // cpu_instruction_master_translator:uav_address -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_address
	wire         cpu_instruction_master_translator_avalon_universal_master_0_write;                                // cpu_instruction_master_translator:uav_write -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_write
	wire         cpu_instruction_master_translator_avalon_universal_master_0_read;                                 // cpu_instruction_master_translator:uav_read -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_read
	wire         cpu_instruction_master_translator_avalon_universal_master_0_arbiterlock;                          // cpu_instruction_master_translator:uav_arbiterlock -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_arbiterlock
	wire  [31:0] cpu_instruction_master_translator_avalon_universal_master_0_readdata;                             // cpu_instruction_master_translator_avalon_universal_master_0_agent:av_readdata -> cpu_instruction_master_translator:uav_readdata
	wire         cpu_instruction_master_translator_avalon_universal_master_0_debugaccess;                          // cpu_instruction_master_translator:uav_debugaccess -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_debugaccess
	wire   [3:0] cpu_instruction_master_translator_avalon_universal_master_0_byteenable;                           // cpu_instruction_master_translator:uav_byteenable -> cpu_instruction_master_translator_avalon_universal_master_0_agent:av_byteenable
	wire         cpu_instruction_master_translator_avalon_universal_master_0_readdatavalid;                        // cpu_instruction_master_translator_avalon_universal_master_0_agent:av_readdatavalid -> cpu_instruction_master_translator:uav_readdatavalid
	wire         cpu_data_master_translator_avalon_universal_master_0_waitrequest;                                 // cpu_data_master_translator_avalon_universal_master_0_agent:av_waitrequest -> cpu_data_master_translator:uav_waitrequest
	wire   [2:0] cpu_data_master_translator_avalon_universal_master_0_burstcount;                                  // cpu_data_master_translator:uav_burstcount -> cpu_data_master_translator_avalon_universal_master_0_agent:av_burstcount
	wire  [31:0] cpu_data_master_translator_avalon_universal_master_0_writedata;                                   // cpu_data_master_translator:uav_writedata -> cpu_data_master_translator_avalon_universal_master_0_agent:av_writedata
	wire  [30:0] cpu_data_master_translator_avalon_universal_master_0_address;                                     // cpu_data_master_translator:uav_address -> cpu_data_master_translator_avalon_universal_master_0_agent:av_address
	wire         cpu_data_master_translator_avalon_universal_master_0_write;                                       // cpu_data_master_translator:uav_write -> cpu_data_master_translator_avalon_universal_master_0_agent:av_write
	wire         cpu_data_master_translator_avalon_universal_master_0_read;                                        // cpu_data_master_translator:uav_read -> cpu_data_master_translator_avalon_universal_master_0_agent:av_read
	wire         cpu_data_master_translator_avalon_universal_master_0_arbiterlock;                                 // cpu_data_master_translator:uav_arbiterlock -> cpu_data_master_translator_avalon_universal_master_0_agent:av_arbiterlock
	wire  [31:0] cpu_data_master_translator_avalon_universal_master_0_readdata;                                    // cpu_data_master_translator_avalon_universal_master_0_agent:av_readdata -> cpu_data_master_translator:uav_readdata
	wire         cpu_data_master_translator_avalon_universal_master_0_debugaccess;                                 // cpu_data_master_translator:uav_debugaccess -> cpu_data_master_translator_avalon_universal_master_0_agent:av_debugaccess
	wire   [3:0] cpu_data_master_translator_avalon_universal_master_0_byteenable;                                  // cpu_data_master_translator:uav_byteenable -> cpu_data_master_translator_avalon_universal_master_0_agent:av_byteenable
	wire         cpu_data_master_translator_avalon_universal_master_0_readdatavalid;                               // cpu_data_master_translator_avalon_universal_master_0_agent:av_readdatavalid -> cpu_data_master_translator:uav_readdatavalid
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_waitrequest;                   // cpu_jtag_debug_module_translator:uav_waitrequest -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_burstcount;                    // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_burstcount -> cpu_jtag_debug_module_translator:uav_burstcount
	wire  [31:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_writedata;                     // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_writedata -> cpu_jtag_debug_module_translator:uav_writedata
	wire  [30:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_address;                       // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_address -> cpu_jtag_debug_module_translator:uav_address
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_write;                         // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_write -> cpu_jtag_debug_module_translator:uav_write
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_read;                          // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_read -> cpu_jtag_debug_module_translator:uav_read
	wire  [31:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdata;                      // cpu_jtag_debug_module_translator:uav_readdata -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_arbiterlock;                   // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_arbiterlock -> cpu_jtag_debug_module_translator:uav_arbiterlock
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdatavalid;                 // cpu_jtag_debug_module_translator:uav_readdatavalid -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_debugaccess;                   // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_debugaccess -> cpu_jtag_debug_module_translator:uav_debugaccess
	wire   [3:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_byteenable;                    // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:m0_byteenable -> cpu_jtag_debug_module_translator:uav_byteenable
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;            // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_valid;                  // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_valid -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;          // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [86:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_data;                   // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_data -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_ready;                  // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;         // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;               // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket;       // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [86:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;                // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;               // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rf_sink_ready -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;             // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;              // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;             // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest;                           // onchip_ram_s1_translator:uav_waitrequest -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_burstcount;                            // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_burstcount -> onchip_ram_s1_translator:uav_burstcount
	wire  [31:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_writedata;                             // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_writedata -> onchip_ram_s1_translator:uav_writedata
	wire  [30:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_address;                               // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_address -> onchip_ram_s1_translator:uav_address
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_write;                                 // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_write -> onchip_ram_s1_translator:uav_write
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_read;                                  // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_read -> onchip_ram_s1_translator:uav_read
	wire  [31:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdata;                              // onchip_ram_s1_translator:uav_readdata -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_arbiterlock;                           // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_arbiterlock -> onchip_ram_s1_translator:uav_arbiterlock
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid;                         // onchip_ram_s1_translator:uav_readdatavalid -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess;                           // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_debugaccess -> onchip_ram_s1_translator:uav_debugaccess
	wire   [3:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_byteenable;                            // onchip_ram_s1_translator_avalon_universal_slave_0_agent:m0_byteenable -> onchip_ram_s1_translator:uav_byteenable
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;                    // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_valid;                          // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_source_valid -> onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;                  // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [86:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_data;                           // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_source_data -> onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_ready;                          // onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;                 // onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;                       // onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket;               // onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [86:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;                        // onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;                       // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rf_sink_ready -> onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;                     // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;                      // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;                     // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_waitrequest;             // jtag_uart_avalon_jtag_slave_translator:uav_waitrequest -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_burstcount;              // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_burstcount -> jtag_uart_avalon_jtag_slave_translator:uav_burstcount
	wire  [31:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_writedata;               // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_writedata -> jtag_uart_avalon_jtag_slave_translator:uav_writedata
	wire  [30:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_address;                 // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_address -> jtag_uart_avalon_jtag_slave_translator:uav_address
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_write;                   // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_write -> jtag_uart_avalon_jtag_slave_translator:uav_write
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_read;                    // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_read -> jtag_uart_avalon_jtag_slave_translator:uav_read
	wire  [31:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_readdata;                // jtag_uart_avalon_jtag_slave_translator:uav_readdata -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_arbiterlock;             // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_arbiterlock -> jtag_uart_avalon_jtag_slave_translator:uav_arbiterlock
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_readdatavalid;           // jtag_uart_avalon_jtag_slave_translator:uav_readdatavalid -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_debugaccess;             // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_debugaccess -> jtag_uart_avalon_jtag_slave_translator:uav_debugaccess
	wire   [3:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_byteenable;              // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:m0_byteenable -> jtag_uart_avalon_jtag_slave_translator:uav_byteenable
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;      // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_valid;            // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_source_valid -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;    // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [86:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_data;             // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_source_data -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_ready;            // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;   // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;         // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket; // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [86:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;          // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;         // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rf_sink_ready -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;       // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;        // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;       // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_waitrequest;                      // pipeline_bridge_s0_translator:uav_waitrequest -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_waitrequest
	wire   [2:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_burstcount;                       // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_burstcount -> pipeline_bridge_s0_translator:uav_burstcount
	wire  [31:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_writedata;                        // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_writedata -> pipeline_bridge_s0_translator:uav_writedata
	wire  [30:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_address;                          // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_address -> pipeline_bridge_s0_translator:uav_address
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_write;                            // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_write -> pipeline_bridge_s0_translator:uav_write
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_read;                             // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_read -> pipeline_bridge_s0_translator:uav_read
	wire  [31:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_readdata;                         // pipeline_bridge_s0_translator:uav_readdata -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_readdata
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_arbiterlock;                      // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_arbiterlock -> pipeline_bridge_s0_translator:uav_arbiterlock
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_readdatavalid;                    // pipeline_bridge_s0_translator:uav_readdatavalid -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_readdatavalid
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_debugaccess;                      // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_debugaccess -> pipeline_bridge_s0_translator:uav_debugaccess
	wire   [3:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_byteenable;                       // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:m0_byteenable -> pipeline_bridge_s0_translator:uav_byteenable
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_endofpacket;               // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_source_endofpacket -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:in_endofpacket
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_valid;                     // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_source_valid -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:in_valid
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_startofpacket;             // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_source_startofpacket -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:in_startofpacket
	wire  [86:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_data;                      // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_source_data -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:in_data
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_ready;                     // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:in_ready -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_source_ready
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket;            // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:out_endofpacket -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_sink_endofpacket
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid;                  // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:out_valid -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_sink_valid
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket;          // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:out_startofpacket -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_sink_startofpacket
	wire  [86:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data;                   // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:out_data -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_sink_data
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready;                  // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rf_sink_ready -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:out_ready
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid;                // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rdata_fifo_src_valid -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo:in_valid
	wire  [31:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data;                 // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rdata_fifo_src_data -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo:in_data
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready;                // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo:in_ready -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rdata_fifo_src_ready
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_valid;                // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo:out_valid -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_valid
	wire  [31:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_data;                 // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo:out_data -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_data
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_ready;                // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rdata_fifo_sink_ready -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo:out_ready
	wire         cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_endofpacket;                 // cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_endofpacket -> addr_router:sink_endofpacket
	wire         cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_valid;                       // cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_valid -> addr_router:sink_valid
	wire         cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_startofpacket;               // cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_startofpacket -> addr_router:sink_startofpacket
	wire  [85:0] cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_data;                        // cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_data -> addr_router:sink_data
	wire         cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_ready;                       // addr_router:sink_ready -> cpu_instruction_master_translator_avalon_universal_master_0_agent:cp_ready
	wire         cpu_data_master_translator_avalon_universal_master_0_agent_cp_endofpacket;                        // cpu_data_master_translator_avalon_universal_master_0_agent:cp_endofpacket -> addr_router_001:sink_endofpacket
	wire         cpu_data_master_translator_avalon_universal_master_0_agent_cp_valid;                              // cpu_data_master_translator_avalon_universal_master_0_agent:cp_valid -> addr_router_001:sink_valid
	wire         cpu_data_master_translator_avalon_universal_master_0_agent_cp_startofpacket;                      // cpu_data_master_translator_avalon_universal_master_0_agent:cp_startofpacket -> addr_router_001:sink_startofpacket
	wire  [85:0] cpu_data_master_translator_avalon_universal_master_0_agent_cp_data;                               // cpu_data_master_translator_avalon_universal_master_0_agent:cp_data -> addr_router_001:sink_data
	wire         cpu_data_master_translator_avalon_universal_master_0_agent_cp_ready;                              // addr_router_001:sink_ready -> cpu_data_master_translator_avalon_universal_master_0_agent:cp_ready
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_endofpacket;                   // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router:sink_endofpacket
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_valid;                         // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_valid -> id_router:sink_valid
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_startofpacket;                 // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router:sink_startofpacket
	wire  [85:0] cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_data;                          // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_data -> id_router:sink_data
	wire         cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_ready;                         // id_router:sink_ready -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:rp_ready
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket;                           // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router_001:sink_endofpacket
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_valid;                                 // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rp_valid -> id_router_001:sink_valid
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket;                         // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router_001:sink_startofpacket
	wire  [85:0] onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_data;                                  // onchip_ram_s1_translator_avalon_universal_slave_0_agent:rp_data -> id_router_001:sink_data
	wire         onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_ready;                                 // id_router_001:sink_ready -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:rp_ready
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_endofpacket;             // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router_002:sink_endofpacket
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_valid;                   // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rp_valid -> id_router_002:sink_valid
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_startofpacket;           // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router_002:sink_startofpacket
	wire  [85:0] jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_data;                    // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rp_data -> id_router_002:sink_data
	wire         jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_ready;                   // id_router_002:sink_ready -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:rp_ready
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_endofpacket;                      // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rp_endofpacket -> id_router_003:sink_endofpacket
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_valid;                            // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rp_valid -> id_router_003:sink_valid
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_startofpacket;                    // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rp_startofpacket -> id_router_003:sink_startofpacket
	wire  [85:0] pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_data;                             // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rp_data -> id_router_003:sink_data
	wire         pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_ready;                            // id_router_003:sink_ready -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:rp_ready
	wire         addr_router_src_endofpacket;                                                                      // addr_router:src_endofpacket -> limiter:cmd_sink_endofpacket
	wire         addr_router_src_valid;                                                                            // addr_router:src_valid -> limiter:cmd_sink_valid
	wire         addr_router_src_startofpacket;                                                                    // addr_router:src_startofpacket -> limiter:cmd_sink_startofpacket
	wire  [85:0] addr_router_src_data;                                                                             // addr_router:src_data -> limiter:cmd_sink_data
	wire   [3:0] addr_router_src_channel;                                                                          // addr_router:src_channel -> limiter:cmd_sink_channel
	wire         addr_router_src_ready;                                                                            // limiter:cmd_sink_ready -> addr_router:src_ready
	wire         limiter_rsp_src_endofpacket;                                                                      // limiter:rsp_src_endofpacket -> cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_endofpacket
	wire         limiter_rsp_src_valid;                                                                            // limiter:rsp_src_valid -> cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_valid
	wire         limiter_rsp_src_startofpacket;                                                                    // limiter:rsp_src_startofpacket -> cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_startofpacket
	wire  [85:0] limiter_rsp_src_data;                                                                             // limiter:rsp_src_data -> cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_data
	wire   [3:0] limiter_rsp_src_channel;                                                                          // limiter:rsp_src_channel -> cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_channel
	wire         limiter_rsp_src_ready;                                                                            // cpu_instruction_master_translator_avalon_universal_master_0_agent:rp_ready -> limiter:rsp_src_ready
	wire         addr_router_001_src_endofpacket;                                                                  // addr_router_001:src_endofpacket -> limiter_001:cmd_sink_endofpacket
	wire         addr_router_001_src_valid;                                                                        // addr_router_001:src_valid -> limiter_001:cmd_sink_valid
	wire         addr_router_001_src_startofpacket;                                                                // addr_router_001:src_startofpacket -> limiter_001:cmd_sink_startofpacket
	wire  [85:0] addr_router_001_src_data;                                                                         // addr_router_001:src_data -> limiter_001:cmd_sink_data
	wire   [3:0] addr_router_001_src_channel;                                                                      // addr_router_001:src_channel -> limiter_001:cmd_sink_channel
	wire         addr_router_001_src_ready;                                                                        // limiter_001:cmd_sink_ready -> addr_router_001:src_ready
	wire         limiter_001_rsp_src_endofpacket;                                                                  // limiter_001:rsp_src_endofpacket -> cpu_data_master_translator_avalon_universal_master_0_agent:rp_endofpacket
	wire         limiter_001_rsp_src_valid;                                                                        // limiter_001:rsp_src_valid -> cpu_data_master_translator_avalon_universal_master_0_agent:rp_valid
	wire         limiter_001_rsp_src_startofpacket;                                                                // limiter_001:rsp_src_startofpacket -> cpu_data_master_translator_avalon_universal_master_0_agent:rp_startofpacket
	wire  [85:0] limiter_001_rsp_src_data;                                                                         // limiter_001:rsp_src_data -> cpu_data_master_translator_avalon_universal_master_0_agent:rp_data
	wire   [3:0] limiter_001_rsp_src_channel;                                                                      // limiter_001:rsp_src_channel -> cpu_data_master_translator_avalon_universal_master_0_agent:rp_channel
	wire         limiter_001_rsp_src_ready;                                                                        // cpu_data_master_translator_avalon_universal_master_0_agent:rp_ready -> limiter_001:rsp_src_ready
	wire         rst_controller_reset_out_reset;                                                                   // rst_controller:reset_out -> [addr_router:reset, addr_router_001:reset, async_fifo:in_reset_n, async_fifo_001:in_reset_n, async_fifo_002:out_reset_n, async_fifo_003:out_reset_n, cmd_xbar_demux:reset, cmd_xbar_demux_001:reset, cmd_xbar_mux:reset, cmd_xbar_mux_001:reset, cmd_xbar_mux_002:reset, cpu:reset_n, cpu_data_master_translator:reset, cpu_data_master_translator_avalon_universal_master_0_agent:reset, cpu_instruction_master_translator:reset, cpu_instruction_master_translator_avalon_universal_master_0_agent:reset, cpu_jtag_debug_module_translator:reset, cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:reset, cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo:reset, id_router:reset, id_router_001:reset, id_router_002:reset, irq_mapper:reset, jtag_uart:rst_n, jtag_uart_avalon_jtag_slave_translator:reset, jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:reset, jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo:reset, limiter:reset, limiter_001:reset, limiter_pipeline:reset, limiter_pipeline_001:reset, limiter_pipeline_002:reset, limiter_pipeline_003:reset, onchip_ram:reset, onchip_ram_s1_translator:reset, onchip_ram_s1_translator_avalon_universal_slave_0_agent:reset, onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo:reset, rsp_xbar_demux:reset, rsp_xbar_demux_001:reset, rsp_xbar_demux_002:reset, rsp_xbar_mux:reset, rsp_xbar_mux_001:reset]
	wire         rst_controller_001_reset_out_reset;                                                               // rst_controller_001:reset_out -> [async_fifo:out_reset_n, async_fifo_001:out_reset_n, async_fifo_002:in_reset_n, async_fifo_003:in_reset_n, cmd_xbar_mux_003:reset, id_router_003:reset, pipeline_bridge:reset, pipeline_bridge_s0_translator:reset, pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:reset, pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo:reset, pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo:reset, rsp_xbar_demux_003:reset]
	wire         cmd_xbar_demux_src0_endofpacket;                                                                  // cmd_xbar_demux:src0_endofpacket -> cmd_xbar_mux:sink0_endofpacket
	wire         cmd_xbar_demux_src0_valid;                                                                        // cmd_xbar_demux:src0_valid -> cmd_xbar_mux:sink0_valid
	wire         cmd_xbar_demux_src0_startofpacket;                                                                // cmd_xbar_demux:src0_startofpacket -> cmd_xbar_mux:sink0_startofpacket
	wire  [85:0] cmd_xbar_demux_src0_data;                                                                         // cmd_xbar_demux:src0_data -> cmd_xbar_mux:sink0_data
	wire   [3:0] cmd_xbar_demux_src0_channel;                                                                      // cmd_xbar_demux:src0_channel -> cmd_xbar_mux:sink0_channel
	wire         cmd_xbar_demux_src0_ready;                                                                        // cmd_xbar_mux:sink0_ready -> cmd_xbar_demux:src0_ready
	wire         cmd_xbar_demux_src1_endofpacket;                                                                  // cmd_xbar_demux:src1_endofpacket -> cmd_xbar_mux_001:sink0_endofpacket
	wire         cmd_xbar_demux_src1_valid;                                                                        // cmd_xbar_demux:src1_valid -> cmd_xbar_mux_001:sink0_valid
	wire         cmd_xbar_demux_src1_startofpacket;                                                                // cmd_xbar_demux:src1_startofpacket -> cmd_xbar_mux_001:sink0_startofpacket
	wire  [85:0] cmd_xbar_demux_src1_data;                                                                         // cmd_xbar_demux:src1_data -> cmd_xbar_mux_001:sink0_data
	wire   [3:0] cmd_xbar_demux_src1_channel;                                                                      // cmd_xbar_demux:src1_channel -> cmd_xbar_mux_001:sink0_channel
	wire         cmd_xbar_demux_src1_ready;                                                                        // cmd_xbar_mux_001:sink0_ready -> cmd_xbar_demux:src1_ready
	wire         cmd_xbar_demux_src2_endofpacket;                                                                  // cmd_xbar_demux:src2_endofpacket -> cmd_xbar_mux_002:sink0_endofpacket
	wire         cmd_xbar_demux_src2_valid;                                                                        // cmd_xbar_demux:src2_valid -> cmd_xbar_mux_002:sink0_valid
	wire         cmd_xbar_demux_src2_startofpacket;                                                                // cmd_xbar_demux:src2_startofpacket -> cmd_xbar_mux_002:sink0_startofpacket
	wire  [85:0] cmd_xbar_demux_src2_data;                                                                         // cmd_xbar_demux:src2_data -> cmd_xbar_mux_002:sink0_data
	wire   [3:0] cmd_xbar_demux_src2_channel;                                                                      // cmd_xbar_demux:src2_channel -> cmd_xbar_mux_002:sink0_channel
	wire         cmd_xbar_demux_src2_ready;                                                                        // cmd_xbar_mux_002:sink0_ready -> cmd_xbar_demux:src2_ready
	wire         cmd_xbar_demux_001_src0_endofpacket;                                                              // cmd_xbar_demux_001:src0_endofpacket -> cmd_xbar_mux:sink1_endofpacket
	wire         cmd_xbar_demux_001_src0_valid;                                                                    // cmd_xbar_demux_001:src0_valid -> cmd_xbar_mux:sink1_valid
	wire         cmd_xbar_demux_001_src0_startofpacket;                                                            // cmd_xbar_demux_001:src0_startofpacket -> cmd_xbar_mux:sink1_startofpacket
	wire  [85:0] cmd_xbar_demux_001_src0_data;                                                                     // cmd_xbar_demux_001:src0_data -> cmd_xbar_mux:sink1_data
	wire   [3:0] cmd_xbar_demux_001_src0_channel;                                                                  // cmd_xbar_demux_001:src0_channel -> cmd_xbar_mux:sink1_channel
	wire         cmd_xbar_demux_001_src0_ready;                                                                    // cmd_xbar_mux:sink1_ready -> cmd_xbar_demux_001:src0_ready
	wire         cmd_xbar_demux_001_src1_endofpacket;                                                              // cmd_xbar_demux_001:src1_endofpacket -> cmd_xbar_mux_001:sink1_endofpacket
	wire         cmd_xbar_demux_001_src1_valid;                                                                    // cmd_xbar_demux_001:src1_valid -> cmd_xbar_mux_001:sink1_valid
	wire         cmd_xbar_demux_001_src1_startofpacket;                                                            // cmd_xbar_demux_001:src1_startofpacket -> cmd_xbar_mux_001:sink1_startofpacket
	wire  [85:0] cmd_xbar_demux_001_src1_data;                                                                     // cmd_xbar_demux_001:src1_data -> cmd_xbar_mux_001:sink1_data
	wire   [3:0] cmd_xbar_demux_001_src1_channel;                                                                  // cmd_xbar_demux_001:src1_channel -> cmd_xbar_mux_001:sink1_channel
	wire         cmd_xbar_demux_001_src1_ready;                                                                    // cmd_xbar_mux_001:sink1_ready -> cmd_xbar_demux_001:src1_ready
	wire         cmd_xbar_demux_001_src2_endofpacket;                                                              // cmd_xbar_demux_001:src2_endofpacket -> cmd_xbar_mux_002:sink1_endofpacket
	wire         cmd_xbar_demux_001_src2_valid;                                                                    // cmd_xbar_demux_001:src2_valid -> cmd_xbar_mux_002:sink1_valid
	wire         cmd_xbar_demux_001_src2_startofpacket;                                                            // cmd_xbar_demux_001:src2_startofpacket -> cmd_xbar_mux_002:sink1_startofpacket
	wire  [85:0] cmd_xbar_demux_001_src2_data;                                                                     // cmd_xbar_demux_001:src2_data -> cmd_xbar_mux_002:sink1_data
	wire   [3:0] cmd_xbar_demux_001_src2_channel;                                                                  // cmd_xbar_demux_001:src2_channel -> cmd_xbar_mux_002:sink1_channel
	wire         cmd_xbar_demux_001_src2_ready;                                                                    // cmd_xbar_mux_002:sink1_ready -> cmd_xbar_demux_001:src2_ready
	wire         rsp_xbar_demux_src0_endofpacket;                                                                  // rsp_xbar_demux:src0_endofpacket -> rsp_xbar_mux:sink0_endofpacket
	wire         rsp_xbar_demux_src0_valid;                                                                        // rsp_xbar_demux:src0_valid -> rsp_xbar_mux:sink0_valid
	wire         rsp_xbar_demux_src0_startofpacket;                                                                // rsp_xbar_demux:src0_startofpacket -> rsp_xbar_mux:sink0_startofpacket
	wire  [85:0] rsp_xbar_demux_src0_data;                                                                         // rsp_xbar_demux:src0_data -> rsp_xbar_mux:sink0_data
	wire   [3:0] rsp_xbar_demux_src0_channel;                                                                      // rsp_xbar_demux:src0_channel -> rsp_xbar_mux:sink0_channel
	wire         rsp_xbar_demux_src0_ready;                                                                        // rsp_xbar_mux:sink0_ready -> rsp_xbar_demux:src0_ready
	wire         rsp_xbar_demux_src1_endofpacket;                                                                  // rsp_xbar_demux:src1_endofpacket -> rsp_xbar_mux_001:sink0_endofpacket
	wire         rsp_xbar_demux_src1_valid;                                                                        // rsp_xbar_demux:src1_valid -> rsp_xbar_mux_001:sink0_valid
	wire         rsp_xbar_demux_src1_startofpacket;                                                                // rsp_xbar_demux:src1_startofpacket -> rsp_xbar_mux_001:sink0_startofpacket
	wire  [85:0] rsp_xbar_demux_src1_data;                                                                         // rsp_xbar_demux:src1_data -> rsp_xbar_mux_001:sink0_data
	wire   [3:0] rsp_xbar_demux_src1_channel;                                                                      // rsp_xbar_demux:src1_channel -> rsp_xbar_mux_001:sink0_channel
	wire         rsp_xbar_demux_src1_ready;                                                                        // rsp_xbar_mux_001:sink0_ready -> rsp_xbar_demux:src1_ready
	wire         rsp_xbar_demux_001_src0_endofpacket;                                                              // rsp_xbar_demux_001:src0_endofpacket -> rsp_xbar_mux:sink1_endofpacket
	wire         rsp_xbar_demux_001_src0_valid;                                                                    // rsp_xbar_demux_001:src0_valid -> rsp_xbar_mux:sink1_valid
	wire         rsp_xbar_demux_001_src0_startofpacket;                                                            // rsp_xbar_demux_001:src0_startofpacket -> rsp_xbar_mux:sink1_startofpacket
	wire  [85:0] rsp_xbar_demux_001_src0_data;                                                                     // rsp_xbar_demux_001:src0_data -> rsp_xbar_mux:sink1_data
	wire   [3:0] rsp_xbar_demux_001_src0_channel;                                                                  // rsp_xbar_demux_001:src0_channel -> rsp_xbar_mux:sink1_channel
	wire         rsp_xbar_demux_001_src0_ready;                                                                    // rsp_xbar_mux:sink1_ready -> rsp_xbar_demux_001:src0_ready
	wire         rsp_xbar_demux_001_src1_endofpacket;                                                              // rsp_xbar_demux_001:src1_endofpacket -> rsp_xbar_mux_001:sink1_endofpacket
	wire         rsp_xbar_demux_001_src1_valid;                                                                    // rsp_xbar_demux_001:src1_valid -> rsp_xbar_mux_001:sink1_valid
	wire         rsp_xbar_demux_001_src1_startofpacket;                                                            // rsp_xbar_demux_001:src1_startofpacket -> rsp_xbar_mux_001:sink1_startofpacket
	wire  [85:0] rsp_xbar_demux_001_src1_data;                                                                     // rsp_xbar_demux_001:src1_data -> rsp_xbar_mux_001:sink1_data
	wire   [3:0] rsp_xbar_demux_001_src1_channel;                                                                  // rsp_xbar_demux_001:src1_channel -> rsp_xbar_mux_001:sink1_channel
	wire         rsp_xbar_demux_001_src1_ready;                                                                    // rsp_xbar_mux_001:sink1_ready -> rsp_xbar_demux_001:src1_ready
	wire         rsp_xbar_demux_002_src0_endofpacket;                                                              // rsp_xbar_demux_002:src0_endofpacket -> rsp_xbar_mux:sink2_endofpacket
	wire         rsp_xbar_demux_002_src0_valid;                                                                    // rsp_xbar_demux_002:src0_valid -> rsp_xbar_mux:sink2_valid
	wire         rsp_xbar_demux_002_src0_startofpacket;                                                            // rsp_xbar_demux_002:src0_startofpacket -> rsp_xbar_mux:sink2_startofpacket
	wire  [85:0] rsp_xbar_demux_002_src0_data;                                                                     // rsp_xbar_demux_002:src0_data -> rsp_xbar_mux:sink2_data
	wire   [3:0] rsp_xbar_demux_002_src0_channel;                                                                  // rsp_xbar_demux_002:src0_channel -> rsp_xbar_mux:sink2_channel
	wire         rsp_xbar_demux_002_src0_ready;                                                                    // rsp_xbar_mux:sink2_ready -> rsp_xbar_demux_002:src0_ready
	wire         rsp_xbar_demux_002_src1_endofpacket;                                                              // rsp_xbar_demux_002:src1_endofpacket -> rsp_xbar_mux_001:sink2_endofpacket
	wire         rsp_xbar_demux_002_src1_valid;                                                                    // rsp_xbar_demux_002:src1_valid -> rsp_xbar_mux_001:sink2_valid
	wire         rsp_xbar_demux_002_src1_startofpacket;                                                            // rsp_xbar_demux_002:src1_startofpacket -> rsp_xbar_mux_001:sink2_startofpacket
	wire  [85:0] rsp_xbar_demux_002_src1_data;                                                                     // rsp_xbar_demux_002:src1_data -> rsp_xbar_mux_001:sink2_data
	wire   [3:0] rsp_xbar_demux_002_src1_channel;                                                                  // rsp_xbar_demux_002:src1_channel -> rsp_xbar_mux_001:sink2_channel
	wire         rsp_xbar_demux_002_src1_ready;                                                                    // rsp_xbar_mux_001:sink2_ready -> rsp_xbar_demux_002:src1_ready
	wire         cmd_xbar_mux_src_endofpacket;                                                                     // cmd_xbar_mux:src_endofpacket -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_src_valid;                                                                           // cmd_xbar_mux:src_valid -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_src_startofpacket;                                                                   // cmd_xbar_mux:src_startofpacket -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [85:0] cmd_xbar_mux_src_data;                                                                            // cmd_xbar_mux:src_data -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_src_channel;                                                                         // cmd_xbar_mux:src_channel -> cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_src_ready;                                                                           // cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux:src_ready
	wire         id_router_src_endofpacket;                                                                        // id_router:src_endofpacket -> rsp_xbar_demux:sink_endofpacket
	wire         id_router_src_valid;                                                                              // id_router:src_valid -> rsp_xbar_demux:sink_valid
	wire         id_router_src_startofpacket;                                                                      // id_router:src_startofpacket -> rsp_xbar_demux:sink_startofpacket
	wire  [85:0] id_router_src_data;                                                                               // id_router:src_data -> rsp_xbar_demux:sink_data
	wire   [3:0] id_router_src_channel;                                                                            // id_router:src_channel -> rsp_xbar_demux:sink_channel
	wire         id_router_src_ready;                                                                              // rsp_xbar_demux:sink_ready -> id_router:src_ready
	wire         cmd_xbar_mux_001_src_endofpacket;                                                                 // cmd_xbar_mux_001:src_endofpacket -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_001_src_valid;                                                                       // cmd_xbar_mux_001:src_valid -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_001_src_startofpacket;                                                               // cmd_xbar_mux_001:src_startofpacket -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [85:0] cmd_xbar_mux_001_src_data;                                                                        // cmd_xbar_mux_001:src_data -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_001_src_channel;                                                                     // cmd_xbar_mux_001:src_channel -> onchip_ram_s1_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_001_src_ready;                                                                       // onchip_ram_s1_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux_001:src_ready
	wire         id_router_001_src_endofpacket;                                                                    // id_router_001:src_endofpacket -> rsp_xbar_demux_001:sink_endofpacket
	wire         id_router_001_src_valid;                                                                          // id_router_001:src_valid -> rsp_xbar_demux_001:sink_valid
	wire         id_router_001_src_startofpacket;                                                                  // id_router_001:src_startofpacket -> rsp_xbar_demux_001:sink_startofpacket
	wire  [85:0] id_router_001_src_data;                                                                           // id_router_001:src_data -> rsp_xbar_demux_001:sink_data
	wire   [3:0] id_router_001_src_channel;                                                                        // id_router_001:src_channel -> rsp_xbar_demux_001:sink_channel
	wire         id_router_001_src_ready;                                                                          // rsp_xbar_demux_001:sink_ready -> id_router_001:src_ready
	wire         cmd_xbar_mux_002_src_endofpacket;                                                                 // cmd_xbar_mux_002:src_endofpacket -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_002_src_valid;                                                                       // cmd_xbar_mux_002:src_valid -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_002_src_startofpacket;                                                               // cmd_xbar_mux_002:src_startofpacket -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [85:0] cmd_xbar_mux_002_src_data;                                                                        // cmd_xbar_mux_002:src_data -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_002_src_channel;                                                                     // cmd_xbar_mux_002:src_channel -> jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_002_src_ready;                                                                       // jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux_002:src_ready
	wire         id_router_002_src_endofpacket;                                                                    // id_router_002:src_endofpacket -> rsp_xbar_demux_002:sink_endofpacket
	wire         id_router_002_src_valid;                                                                          // id_router_002:src_valid -> rsp_xbar_demux_002:sink_valid
	wire         id_router_002_src_startofpacket;                                                                  // id_router_002:src_startofpacket -> rsp_xbar_demux_002:sink_startofpacket
	wire  [85:0] id_router_002_src_data;                                                                           // id_router_002:src_data -> rsp_xbar_demux_002:sink_data
	wire   [3:0] id_router_002_src_channel;                                                                        // id_router_002:src_channel -> rsp_xbar_demux_002:sink_channel
	wire         id_router_002_src_ready;                                                                          // rsp_xbar_demux_002:sink_ready -> id_router_002:src_ready
	wire         cmd_xbar_mux_003_src_endofpacket;                                                                 // cmd_xbar_mux_003:src_endofpacket -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:cp_endofpacket
	wire         cmd_xbar_mux_003_src_valid;                                                                       // cmd_xbar_mux_003:src_valid -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:cp_valid
	wire         cmd_xbar_mux_003_src_startofpacket;                                                               // cmd_xbar_mux_003:src_startofpacket -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:cp_startofpacket
	wire  [85:0] cmd_xbar_mux_003_src_data;                                                                        // cmd_xbar_mux_003:src_data -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:cp_data
	wire   [3:0] cmd_xbar_mux_003_src_channel;                                                                     // cmd_xbar_mux_003:src_channel -> pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:cp_channel
	wire         cmd_xbar_mux_003_src_ready;                                                                       // pipeline_bridge_s0_translator_avalon_universal_slave_0_agent:cp_ready -> cmd_xbar_mux_003:src_ready
	wire         id_router_003_src_endofpacket;                                                                    // id_router_003:src_endofpacket -> rsp_xbar_demux_003:sink_endofpacket
	wire         id_router_003_src_valid;                                                                          // id_router_003:src_valid -> rsp_xbar_demux_003:sink_valid
	wire         id_router_003_src_startofpacket;                                                                  // id_router_003:src_startofpacket -> rsp_xbar_demux_003:sink_startofpacket
	wire  [85:0] id_router_003_src_data;                                                                           // id_router_003:src_data -> rsp_xbar_demux_003:sink_data
	wire   [3:0] id_router_003_src_channel;                                                                        // id_router_003:src_channel -> rsp_xbar_demux_003:sink_channel
	wire         id_router_003_src_ready;                                                                          // rsp_xbar_demux_003:sink_ready -> id_router_003:src_ready
	wire         async_fifo_out_endofpacket;                                                                       // async_fifo:out_endofpacket -> cmd_xbar_mux_003:sink0_endofpacket
	wire         async_fifo_out_valid;                                                                             // async_fifo:out_valid -> cmd_xbar_mux_003:sink0_valid
	wire         async_fifo_out_startofpacket;                                                                     // async_fifo:out_startofpacket -> cmd_xbar_mux_003:sink0_startofpacket
	wire  [85:0] async_fifo_out_data;                                                                              // async_fifo:out_data -> cmd_xbar_mux_003:sink0_data
	wire   [3:0] async_fifo_out_channel;                                                                           // async_fifo:out_channel -> cmd_xbar_mux_003:sink0_channel
	wire         async_fifo_out_ready;                                                                             // cmd_xbar_mux_003:sink0_ready -> async_fifo:out_ready
	wire         cmd_xbar_demux_src3_endofpacket;                                                                  // cmd_xbar_demux:src3_endofpacket -> async_fifo:in_endofpacket
	wire         cmd_xbar_demux_src3_valid;                                                                        // cmd_xbar_demux:src3_valid -> async_fifo:in_valid
	wire         cmd_xbar_demux_src3_startofpacket;                                                                // cmd_xbar_demux:src3_startofpacket -> async_fifo:in_startofpacket
	wire  [85:0] cmd_xbar_demux_src3_data;                                                                         // cmd_xbar_demux:src3_data -> async_fifo:in_data
	wire   [3:0] cmd_xbar_demux_src3_channel;                                                                      // cmd_xbar_demux:src3_channel -> async_fifo:in_channel
	wire         cmd_xbar_demux_src3_ready;                                                                        // async_fifo:in_ready -> cmd_xbar_demux:src3_ready
	wire         async_fifo_001_out_endofpacket;                                                                   // async_fifo_001:out_endofpacket -> cmd_xbar_mux_003:sink1_endofpacket
	wire         async_fifo_001_out_valid;                                                                         // async_fifo_001:out_valid -> cmd_xbar_mux_003:sink1_valid
	wire         async_fifo_001_out_startofpacket;                                                                 // async_fifo_001:out_startofpacket -> cmd_xbar_mux_003:sink1_startofpacket
	wire  [85:0] async_fifo_001_out_data;                                                                          // async_fifo_001:out_data -> cmd_xbar_mux_003:sink1_data
	wire   [3:0] async_fifo_001_out_channel;                                                                       // async_fifo_001:out_channel -> cmd_xbar_mux_003:sink1_channel
	wire         async_fifo_001_out_ready;                                                                         // cmd_xbar_mux_003:sink1_ready -> async_fifo_001:out_ready
	wire         cmd_xbar_demux_001_src3_endofpacket;                                                              // cmd_xbar_demux_001:src3_endofpacket -> async_fifo_001:in_endofpacket
	wire         cmd_xbar_demux_001_src3_valid;                                                                    // cmd_xbar_demux_001:src3_valid -> async_fifo_001:in_valid
	wire         cmd_xbar_demux_001_src3_startofpacket;                                                            // cmd_xbar_demux_001:src3_startofpacket -> async_fifo_001:in_startofpacket
	wire  [85:0] cmd_xbar_demux_001_src3_data;                                                                     // cmd_xbar_demux_001:src3_data -> async_fifo_001:in_data
	wire   [3:0] cmd_xbar_demux_001_src3_channel;                                                                  // cmd_xbar_demux_001:src3_channel -> async_fifo_001:in_channel
	wire         cmd_xbar_demux_001_src3_ready;                                                                    // async_fifo_001:in_ready -> cmd_xbar_demux_001:src3_ready
	wire         async_fifo_002_out_endofpacket;                                                                   // async_fifo_002:out_endofpacket -> rsp_xbar_mux:sink3_endofpacket
	wire         async_fifo_002_out_valid;                                                                         // async_fifo_002:out_valid -> rsp_xbar_mux:sink3_valid
	wire         async_fifo_002_out_startofpacket;                                                                 // async_fifo_002:out_startofpacket -> rsp_xbar_mux:sink3_startofpacket
	wire  [85:0] async_fifo_002_out_data;                                                                          // async_fifo_002:out_data -> rsp_xbar_mux:sink3_data
	wire   [3:0] async_fifo_002_out_channel;                                                                       // async_fifo_002:out_channel -> rsp_xbar_mux:sink3_channel
	wire         async_fifo_002_out_ready;                                                                         // rsp_xbar_mux:sink3_ready -> async_fifo_002:out_ready
	wire         rsp_xbar_demux_003_src0_endofpacket;                                                              // rsp_xbar_demux_003:src0_endofpacket -> async_fifo_002:in_endofpacket
	wire         rsp_xbar_demux_003_src0_valid;                                                                    // rsp_xbar_demux_003:src0_valid -> async_fifo_002:in_valid
	wire         rsp_xbar_demux_003_src0_startofpacket;                                                            // rsp_xbar_demux_003:src0_startofpacket -> async_fifo_002:in_startofpacket
	wire  [85:0] rsp_xbar_demux_003_src0_data;                                                                     // rsp_xbar_demux_003:src0_data -> async_fifo_002:in_data
	wire   [3:0] rsp_xbar_demux_003_src0_channel;                                                                  // rsp_xbar_demux_003:src0_channel -> async_fifo_002:in_channel
	wire         rsp_xbar_demux_003_src0_ready;                                                                    // async_fifo_002:in_ready -> rsp_xbar_demux_003:src0_ready
	wire         async_fifo_003_out_endofpacket;                                                                   // async_fifo_003:out_endofpacket -> rsp_xbar_mux_001:sink3_endofpacket
	wire         async_fifo_003_out_valid;                                                                         // async_fifo_003:out_valid -> rsp_xbar_mux_001:sink3_valid
	wire         async_fifo_003_out_startofpacket;                                                                 // async_fifo_003:out_startofpacket -> rsp_xbar_mux_001:sink3_startofpacket
	wire  [85:0] async_fifo_003_out_data;                                                                          // async_fifo_003:out_data -> rsp_xbar_mux_001:sink3_data
	wire   [3:0] async_fifo_003_out_channel;                                                                       // async_fifo_003:out_channel -> rsp_xbar_mux_001:sink3_channel
	wire         async_fifo_003_out_ready;                                                                         // rsp_xbar_mux_001:sink3_ready -> async_fifo_003:out_ready
	wire         rsp_xbar_demux_003_src1_endofpacket;                                                              // rsp_xbar_demux_003:src1_endofpacket -> async_fifo_003:in_endofpacket
	wire         rsp_xbar_demux_003_src1_valid;                                                                    // rsp_xbar_demux_003:src1_valid -> async_fifo_003:in_valid
	wire         rsp_xbar_demux_003_src1_startofpacket;                                                            // rsp_xbar_demux_003:src1_startofpacket -> async_fifo_003:in_startofpacket
	wire  [85:0] rsp_xbar_demux_003_src1_data;                                                                     // rsp_xbar_demux_003:src1_data -> async_fifo_003:in_data
	wire   [3:0] rsp_xbar_demux_003_src1_channel;                                                                  // rsp_xbar_demux_003:src1_channel -> async_fifo_003:in_channel
	wire         rsp_xbar_demux_003_src1_ready;                                                                    // async_fifo_003:in_ready -> rsp_xbar_demux_003:src1_ready
	wire         limiter_pipeline_source0_endofpacket;                                                             // limiter_pipeline:out_endofpacket -> cmd_xbar_demux:sink_endofpacket
	wire         limiter_pipeline_source0_valid;                                                                   // limiter_pipeline:out_valid -> cmd_xbar_demux:sink_valid
	wire         limiter_pipeline_source0_startofpacket;                                                           // limiter_pipeline:out_startofpacket -> cmd_xbar_demux:sink_startofpacket
	wire  [85:0] limiter_pipeline_source0_data;                                                                    // limiter_pipeline:out_data -> cmd_xbar_demux:sink_data
	wire   [3:0] limiter_pipeline_source0_channel;                                                                 // limiter_pipeline:out_channel -> cmd_xbar_demux:sink_channel
	wire         limiter_pipeline_source0_ready;                                                                   // cmd_xbar_demux:sink_ready -> limiter_pipeline:out_ready
	wire         limiter_cmd_src_endofpacket;                                                                      // limiter:cmd_src_endofpacket -> limiter_pipeline:in_endofpacket
	wire   [0:0] limiter_cmd_src_valid;                                                                            // limiter:cmd_src_valid -> limiter_pipeline:in_valid
	wire         limiter_cmd_src_startofpacket;                                                                    // limiter:cmd_src_startofpacket -> limiter_pipeline:in_startofpacket
	wire  [85:0] limiter_cmd_src_data;                                                                             // limiter:cmd_src_data -> limiter_pipeline:in_data
	wire   [3:0] limiter_cmd_src_channel;                                                                          // limiter:cmd_src_channel -> limiter_pipeline:in_channel
	wire         limiter_cmd_src_ready;                                                                            // limiter_pipeline:in_ready -> limiter:cmd_src_ready
	wire         rsp_xbar_mux_src_endofpacket;                                                                     // rsp_xbar_mux:src_endofpacket -> limiter_pipeline_001:in_endofpacket
	wire         rsp_xbar_mux_src_valid;                                                                           // rsp_xbar_mux:src_valid -> limiter_pipeline_001:in_valid
	wire         rsp_xbar_mux_src_startofpacket;                                                                   // rsp_xbar_mux:src_startofpacket -> limiter_pipeline_001:in_startofpacket
	wire  [85:0] rsp_xbar_mux_src_data;                                                                            // rsp_xbar_mux:src_data -> limiter_pipeline_001:in_data
	wire   [3:0] rsp_xbar_mux_src_channel;                                                                         // rsp_xbar_mux:src_channel -> limiter_pipeline_001:in_channel
	wire         rsp_xbar_mux_src_ready;                                                                           // limiter_pipeline_001:in_ready -> rsp_xbar_mux:src_ready
	wire         limiter_pipeline_001_source0_endofpacket;                                                         // limiter_pipeline_001:out_endofpacket -> limiter:rsp_sink_endofpacket
	wire         limiter_pipeline_001_source0_valid;                                                               // limiter_pipeline_001:out_valid -> limiter:rsp_sink_valid
	wire         limiter_pipeline_001_source0_startofpacket;                                                       // limiter_pipeline_001:out_startofpacket -> limiter:rsp_sink_startofpacket
	wire  [85:0] limiter_pipeline_001_source0_data;                                                                // limiter_pipeline_001:out_data -> limiter:rsp_sink_data
	wire   [3:0] limiter_pipeline_001_source0_channel;                                                             // limiter_pipeline_001:out_channel -> limiter:rsp_sink_channel
	wire         limiter_pipeline_001_source0_ready;                                                               // limiter:rsp_sink_ready -> limiter_pipeline_001:out_ready
	wire         limiter_pipeline_002_source0_endofpacket;                                                         // limiter_pipeline_002:out_endofpacket -> cmd_xbar_demux_001:sink_endofpacket
	wire         limiter_pipeline_002_source0_valid;                                                               // limiter_pipeline_002:out_valid -> cmd_xbar_demux_001:sink_valid
	wire         limiter_pipeline_002_source0_startofpacket;                                                       // limiter_pipeline_002:out_startofpacket -> cmd_xbar_demux_001:sink_startofpacket
	wire  [85:0] limiter_pipeline_002_source0_data;                                                                // limiter_pipeline_002:out_data -> cmd_xbar_demux_001:sink_data
	wire   [3:0] limiter_pipeline_002_source0_channel;                                                             // limiter_pipeline_002:out_channel -> cmd_xbar_demux_001:sink_channel
	wire         limiter_pipeline_002_source0_ready;                                                               // cmd_xbar_demux_001:sink_ready -> limiter_pipeline_002:out_ready
	wire         limiter_001_cmd_src_endofpacket;                                                                  // limiter_001:cmd_src_endofpacket -> limiter_pipeline_002:in_endofpacket
	wire   [0:0] limiter_001_cmd_src_valid;                                                                        // limiter_001:cmd_src_valid -> limiter_pipeline_002:in_valid
	wire         limiter_001_cmd_src_startofpacket;                                                                // limiter_001:cmd_src_startofpacket -> limiter_pipeline_002:in_startofpacket
	wire  [85:0] limiter_001_cmd_src_data;                                                                         // limiter_001:cmd_src_data -> limiter_pipeline_002:in_data
	wire   [3:0] limiter_001_cmd_src_channel;                                                                      // limiter_001:cmd_src_channel -> limiter_pipeline_002:in_channel
	wire         limiter_001_cmd_src_ready;                                                                        // limiter_pipeline_002:in_ready -> limiter_001:cmd_src_ready
	wire         rsp_xbar_mux_001_src_endofpacket;                                                                 // rsp_xbar_mux_001:src_endofpacket -> limiter_pipeline_003:in_endofpacket
	wire         rsp_xbar_mux_001_src_valid;                                                                       // rsp_xbar_mux_001:src_valid -> limiter_pipeline_003:in_valid
	wire         rsp_xbar_mux_001_src_startofpacket;                                                               // rsp_xbar_mux_001:src_startofpacket -> limiter_pipeline_003:in_startofpacket
	wire  [85:0] rsp_xbar_mux_001_src_data;                                                                        // rsp_xbar_mux_001:src_data -> limiter_pipeline_003:in_data
	wire   [3:0] rsp_xbar_mux_001_src_channel;                                                                     // rsp_xbar_mux_001:src_channel -> limiter_pipeline_003:in_channel
	wire         rsp_xbar_mux_001_src_ready;                                                                       // limiter_pipeline_003:in_ready -> rsp_xbar_mux_001:src_ready
	wire         limiter_pipeline_003_source0_endofpacket;                                                         // limiter_pipeline_003:out_endofpacket -> limiter_001:rsp_sink_endofpacket
	wire         limiter_pipeline_003_source0_valid;                                                               // limiter_pipeline_003:out_valid -> limiter_001:rsp_sink_valid
	wire         limiter_pipeline_003_source0_startofpacket;                                                       // limiter_pipeline_003:out_startofpacket -> limiter_001:rsp_sink_startofpacket
	wire  [85:0] limiter_pipeline_003_source0_data;                                                                // limiter_pipeline_003:out_data -> limiter_001:rsp_sink_data
	wire   [3:0] limiter_pipeline_003_source0_channel;                                                             // limiter_pipeline_003:out_channel -> limiter_001:rsp_sink_channel
	wire         limiter_pipeline_003_source0_ready;                                                               // limiter_001:rsp_sink_ready -> limiter_pipeline_003:out_ready
	wire         irq_mapper_receiver0_irq;                                                                         // jtag_uart:av_irq -> irq_mapper:receiver0_irq
	wire  [31:0] cpu_d_irq_irq;                                                                                    // irq_mapper:sender_irq -> cpu:d_irq

	altera_avalon_onchip_memory2_mejd6mmm onchip_ram (
		.clk        (cpu_clk_clk),                                             //   clk1.clk
		.address    (onchip_ram_s1_translator_avalon_anti_slave_0_address),    //     s1.address
		.chipselect (onchip_ram_s1_translator_avalon_anti_slave_0_chipselect), //       .chipselect
		.clken      (onchip_ram_s1_translator_avalon_anti_slave_0_clken),      //       .clken
		.readdata   (onchip_ram_s1_translator_avalon_anti_slave_0_readdata),   //       .readdata
		.write      (onchip_ram_s1_translator_avalon_anti_slave_0_write),      //       .write
		.writedata  (onchip_ram_s1_translator_avalon_anti_slave_0_writedata),  //       .writedata
		.byteenable (onchip_ram_s1_translator_avalon_anti_slave_0_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset)                           // reset1.reset
	);

	altera_avalon_jtag_uart_nbmdwotd jtag_uart (
		.clk            (cpu_clk_clk),                                                            //               clk.clk
		.rst_n          (~rst_controller_reset_out_reset),                                        //             reset.reset_n
		.av_chipselect  (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_chipselect),  // avalon_jtag_slave.chipselect
		.av_address     (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_address),     //                  .address
		.av_read_n      (~jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_read),       //                  .read_n
		.av_readdata    (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_readdata),    //                  .readdata
		.av_write_n     (~jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_write),      //                  .write_n
		.av_writedata   (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_writedata),   //                  .writedata
		.av_waitrequest (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_waitrequest), //                  .waitrequest
		.dataavailable  (),                                                                       //                  .dataavailable
		.readyfordata   (),                                                                       //                  .readyfordata
		.av_irq         (irq_mapper_receiver0_irq)                                                //               irq.irq
	);

	altera_nios2_qsys_be44pvus cpu (
		.clk                                   (cpu_clk_clk),                                                        //                       clk.clk
		.reset_n                               (~rst_controller_reset_out_reset),                                    //                   reset_n.reset_n
		.d_address                             (cpu_data_master_address),                                            //               data_master.address
		.d_byteenable                          (cpu_data_master_byteenable),                                         //                          .byteenable
		.d_read                                (cpu_data_master_read),                                               //                          .read
		.d_readdata                            (cpu_data_master_readdata),                                           //                          .readdata
		.d_waitrequest                         (cpu_data_master_waitrequest),                                        //                          .waitrequest
		.d_write                               (cpu_data_master_write),                                              //                          .write
		.d_writedata                           (cpu_data_master_writedata),                                          //                          .writedata
		.jtag_debug_module_debugaccess_to_roms (cpu_data_master_debugaccess),                                        //                          .debugaccess
		.i_address                             (cpu_instruction_master_address),                                     //        instruction_master.address
		.i_read                                (cpu_instruction_master_read),                                        //                          .read
		.i_readdata                            (cpu_instruction_master_readdata),                                    //                          .readdata
		.i_waitrequest                         (cpu_instruction_master_waitrequest),                                 //                          .waitrequest
		.d_irq                                 (cpu_d_irq_irq),                                                      //                     d_irq.irq
		.jtag_debug_module_resetrequest        (cpu_jtag_debug_module_reset_reset),                                  //   jtag_debug_module_reset.reset
		.jtag_debug_module_address             (cpu_jtag_debug_module_translator_avalon_anti_slave_0_address),       //         jtag_debug_module.address
		.jtag_debug_module_begintransfer       (cpu_jtag_debug_module_translator_avalon_anti_slave_0_begintransfer), //                          .begintransfer
		.jtag_debug_module_byteenable          (cpu_jtag_debug_module_translator_avalon_anti_slave_0_byteenable),    //                          .byteenable
		.jtag_debug_module_debugaccess         (cpu_jtag_debug_module_translator_avalon_anti_slave_0_debugaccess),   //                          .debugaccess
		.jtag_debug_module_readdata            (cpu_jtag_debug_module_translator_avalon_anti_slave_0_readdata),      //                          .readdata
		.jtag_debug_module_select              (cpu_jtag_debug_module_translator_avalon_anti_slave_0_chipselect),    //                          .chipselect
		.jtag_debug_module_write               (cpu_jtag_debug_module_translator_avalon_anti_slave_0_write),         //                          .write
		.jtag_debug_module_writedata           (cpu_jtag_debug_module_translator_avalon_anti_slave_0_writedata),     //                          .writedata
		.no_ci_readra                          ()                                                                    // custom_instruction_master.readra
	);

	altera_avalon_mm_bridge #(
		.DATA_WIDTH        (32),
		.SYMBOL_WIDTH      (8),
		.ADDRESS_WIDTH     (30),
		.BURSTCOUNT_WIDTH  (3),
		.PIPELINE_COMMAND  (1),
		.PIPELINE_RESPONSE (1)
	) pipeline_bridge (
		.clk              (mem_clk_clk),                                                     //   clk.clk
		.reset            (rst_controller_001_reset_out_reset),                              // reset.reset
		.s0_waitrequest   (pipeline_bridge_s0_translator_avalon_anti_slave_0_waitrequest),   //    s0.waitrequest
		.s0_readdata      (pipeline_bridge_s0_translator_avalon_anti_slave_0_readdata),      //      .readdata
		.s0_readdatavalid (pipeline_bridge_s0_translator_avalon_anti_slave_0_readdatavalid), //      .readdatavalid
		.s0_burstcount    (pipeline_bridge_s0_translator_avalon_anti_slave_0_burstcount),    //      .burstcount
		.s0_writedata     (pipeline_bridge_s0_translator_avalon_anti_slave_0_writedata),     //      .writedata
		.s0_address       (pipeline_bridge_s0_translator_avalon_anti_slave_0_address),       //      .address
		.s0_write         (pipeline_bridge_s0_translator_avalon_anti_slave_0_write),         //      .write
		.s0_read          (pipeline_bridge_s0_translator_avalon_anti_slave_0_read),          //      .read
		.s0_byteenable    (pipeline_bridge_s0_translator_avalon_anti_slave_0_byteenable),    //      .byteenable
		.s0_debugaccess   (pipeline_bridge_s0_translator_avalon_anti_slave_0_debugaccess),   //      .debugaccess
		.m0_waitrequest   (master_waitrequest),                                              //    m0.waitrequest
		.m0_readdata      (master_readdata),                                                 //      .readdata
		.m0_readdatavalid (master_readdatavalid),                                            //      .readdatavalid
		.m0_burstcount    (master_burstcount),                                               //      .burstcount
		.m0_writedata     (master_writedata),                                                //      .writedata
		.m0_address       (master_address),                                                  //      .address
		.m0_write         (master_write),                                                    //      .write
		.m0_read          (master_read),                                                     //      .read
		.m0_byteenable    (master_byteenable),                                               //      .byteenable
		.m0_debugaccess   (master_debugaccess)                                               //      .debugaccess
	);

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (19),
		.AV_DATA_W                   (32),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (4),
		.UAV_ADDRESS_W               (31),
		.UAV_BURSTCOUNT_W            (3),
		.USE_READ                    (1),
		.USE_WRITE                   (0),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.AV_SYMBOLS_PER_WORD         (4),
		.AV_ADDRESS_SYMBOLS          (1),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (1),
		.AV_REGISTERINCOMINGSIGNALS  (0)
	) cpu_instruction_master_translator (
		.clk                   (cpu_clk_clk),                                                               //                       clk.clk
		.reset                 (rst_controller_reset_out_reset),                                            //                     reset.reset
		.uav_address           (cpu_instruction_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount        (cpu_instruction_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read              (cpu_instruction_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write             (cpu_instruction_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest       (cpu_instruction_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid     (cpu_instruction_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable        (cpu_instruction_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata          (cpu_instruction_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata         (cpu_instruction_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_arbiterlock       (cpu_instruction_master_translator_avalon_universal_master_0_arbiterlock),   //                          .arbiterlock
		.uav_debugaccess       (cpu_instruction_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address            (cpu_instruction_master_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest        (cpu_instruction_master_waitrequest),                                        //                          .waitrequest
		.av_read               (cpu_instruction_master_read),                                               //                          .read
		.av_readdata           (cpu_instruction_master_readdata),                                           //                          .readdata
		.av_burstcount         (1'b1),                                                                      //               (terminated)
		.av_byteenable         (4'b1111),                                                                   //               (terminated)
		.av_beginbursttransfer (1'b0),                                                                      //               (terminated)
		.av_begintransfer      (1'b0),                                                                      //               (terminated)
		.av_chipselect         (1'b0),                                                                      //               (terminated)
		.av_readdatavalid      (),                                                                          //               (terminated)
		.av_write              (1'b0),                                                                      //               (terminated)
		.av_writedata          (32'b00000000000000000000000000000000),                                      //               (terminated)
		.av_arbiterlock        (1'b0),                                                                      //               (terminated)
		.av_debugaccess        (1'b0),                                                                      //               (terminated)
		.uav_clken             (),                                                                          //               (terminated)
		.av_clken              (1'b1)                                                                       //               (terminated)
	);

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (31),
		.AV_DATA_W                   (32),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (4),
		.UAV_ADDRESS_W               (31),
		.UAV_BURSTCOUNT_W            (3),
		.USE_READ                    (1),
		.USE_WRITE                   (1),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.AV_SYMBOLS_PER_WORD         (4),
		.AV_ADDRESS_SYMBOLS          (1),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (0),
		.AV_REGISTERINCOMINGSIGNALS  (1)
	) cpu_data_master_translator (
		.clk                   (cpu_clk_clk),                                                        //                       clk.clk
		.reset                 (rst_controller_reset_out_reset),                                     //                     reset.reset
		.uav_address           (cpu_data_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount        (cpu_data_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read              (cpu_data_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write             (cpu_data_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest       (cpu_data_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid     (cpu_data_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable        (cpu_data_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata          (cpu_data_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata         (cpu_data_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_arbiterlock       (cpu_data_master_translator_avalon_universal_master_0_arbiterlock),   //                          .arbiterlock
		.uav_debugaccess       (cpu_data_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address            (cpu_data_master_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest        (cpu_data_master_waitrequest),                                        //                          .waitrequest
		.av_byteenable         (cpu_data_master_byteenable),                                         //                          .byteenable
		.av_read               (cpu_data_master_read),                                               //                          .read
		.av_readdata           (cpu_data_master_readdata),                                           //                          .readdata
		.av_write              (cpu_data_master_write),                                              //                          .write
		.av_writedata          (cpu_data_master_writedata),                                          //                          .writedata
		.av_debugaccess        (cpu_data_master_debugaccess),                                        //                          .debugaccess
		.av_burstcount         (1'b1),                                                               //               (terminated)
		.av_beginbursttransfer (1'b0),                                                               //               (terminated)
		.av_begintransfer      (1'b0),                                                               //               (terminated)
		.av_chipselect         (1'b0),                                                               //               (terminated)
		.av_readdatavalid      (),                                                                   //               (terminated)
		.av_arbiterlock        (1'b0),                                                               //               (terminated)
		.uav_clken             (),                                                                   //               (terminated)
		.av_clken              (1'b1)                                                                //               (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (9),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (31),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (0),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (1),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) cpu_jtag_debug_module_translator (
		.clk                   (cpu_clk_clk),                                                                      //                      clk.clk
		.reset                 (rst_controller_reset_out_reset),                                                   //                    reset.reset
		.uav_address           (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_arbiterlock       (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_arbiterlock),   //                         .arbiterlock
		.uav_debugaccess       (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (cpu_jtag_debug_module_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_write              (cpu_jtag_debug_module_translator_avalon_anti_slave_0_write),                       //                         .write
		.av_readdata           (cpu_jtag_debug_module_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_writedata          (cpu_jtag_debug_module_translator_avalon_anti_slave_0_writedata),                   //                         .writedata
		.av_begintransfer      (cpu_jtag_debug_module_translator_avalon_anti_slave_0_begintransfer),               //                         .begintransfer
		.av_byteenable         (cpu_jtag_debug_module_translator_avalon_anti_slave_0_byteenable),                  //                         .byteenable
		.av_chipselect         (cpu_jtag_debug_module_translator_avalon_anti_slave_0_chipselect),                  //                         .chipselect
		.av_debugaccess        (cpu_jtag_debug_module_translator_avalon_anti_slave_0_debugaccess),                 //                         .debugaccess
		.av_read               (),                                                                                 //              (terminated)
		.av_beginbursttransfer (),                                                                                 //              (terminated)
		.av_burstcount         (),                                                                                 //              (terminated)
		.av_readdatavalid      (1'b0),                                                                             //              (terminated)
		.av_waitrequest        (1'b0),                                                                             //              (terminated)
		.av_writebyteenable    (),                                                                                 //              (terminated)
		.av_arbiterlock        (),                                                                                 //              (terminated)
		.av_clken              (),                                                                                 //              (terminated)
		.uav_clken             (1'b0),                                                                             //              (terminated)
		.av_outputenable       ()                                                                                  //              (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (15),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (31),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (1),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) onchip_ram_s1_translator (
		.clk                   (cpu_clk_clk),                                                              //                      clk.clk
		.reset                 (rst_controller_reset_out_reset),                                           //                    reset.reset
		.uav_address           (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_arbiterlock       (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_arbiterlock),   //                         .arbiterlock
		.uav_debugaccess       (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (onchip_ram_s1_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_write              (onchip_ram_s1_translator_avalon_anti_slave_0_write),                       //                         .write
		.av_readdata           (onchip_ram_s1_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_writedata          (onchip_ram_s1_translator_avalon_anti_slave_0_writedata),                   //                         .writedata
		.av_byteenable         (onchip_ram_s1_translator_avalon_anti_slave_0_byteenable),                  //                         .byteenable
		.av_chipselect         (onchip_ram_s1_translator_avalon_anti_slave_0_chipselect),                  //                         .chipselect
		.av_clken              (onchip_ram_s1_translator_avalon_anti_slave_0_clken),                       //                         .clken
		.av_read               (),                                                                         //              (terminated)
		.av_begintransfer      (),                                                                         //              (terminated)
		.av_beginbursttransfer (),                                                                         //              (terminated)
		.av_burstcount         (),                                                                         //              (terminated)
		.av_readdatavalid      (1'b0),                                                                     //              (terminated)
		.av_waitrequest        (1'b0),                                                                     //              (terminated)
		.av_writebyteenable    (),                                                                         //              (terminated)
		.av_arbiterlock        (),                                                                         //              (terminated)
		.uav_clken             (1'b0),                                                                     //              (terminated)
		.av_debugaccess        (),                                                                         //              (terminated)
		.av_outputenable       ()                                                                          //              (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (1),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (1),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (31),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (0),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (1),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (1),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) jtag_uart_avalon_jtag_slave_translator (
		.clk                   (cpu_clk_clk),                                                                            //                      clk.clk
		.reset                 (rst_controller_reset_out_reset),                                                         //                    reset.reset
		.uav_address           (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_arbiterlock       (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_arbiterlock),   //                         .arbiterlock
		.uav_debugaccess       (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_write              (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_write),                       //                         .write
		.av_read               (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_read),                        //                         .read
		.av_readdata           (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_writedata          (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_writedata),                   //                         .writedata
		.av_waitrequest        (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_waitrequest),                 //                         .waitrequest
		.av_chipselect         (jtag_uart_avalon_jtag_slave_translator_avalon_anti_slave_0_chipselect),                  //                         .chipselect
		.av_begintransfer      (),                                                                                       //              (terminated)
		.av_beginbursttransfer (),                                                                                       //              (terminated)
		.av_burstcount         (),                                                                                       //              (terminated)
		.av_byteenable         (),                                                                                       //              (terminated)
		.av_readdatavalid      (1'b0),                                                                                   //              (terminated)
		.av_writebyteenable    (),                                                                                       //              (terminated)
		.av_arbiterlock        (),                                                                                       //              (terminated)
		.av_clken              (),                                                                                       //              (terminated)
		.uav_clken             (1'b0),                                                                                   //              (terminated)
		.av_debugaccess        (),                                                                                       //              (terminated)
		.av_outputenable       ()                                                                                        //              (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (30),
		.AV_DATA_W                      (32),
		.UAV_DATA_W                     (32),
		.AV_BURSTCOUNT_W                (3),
		.AV_BYTEENABLE_W                (4),
		.UAV_BYTEENABLE_W               (4),
		.UAV_ADDRESS_W                  (31),
		.UAV_BURSTCOUNT_W               (3),
		.AV_READLATENCY                 (0),
		.USE_READDATAVALID              (1),
		.USE_WAITREQUEST                (1),
		.USE_UAV_CLKEN                  (0),
		.AV_SYMBOLS_PER_WORD            (4),
		.AV_ADDRESS_SYMBOLS             (1),
		.AV_BURSTCOUNT_SYMBOLS          (1),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) pipeline_bridge_s0_translator (
		.clk                   (mem_clk_clk),                                                                   //                      clk.clk
		.reset                 (rst_controller_001_reset_out_reset),                                            //                    reset.reset
		.uav_address           (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_address),       // avalon_universal_slave_0.address
		.uav_burstcount        (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_burstcount),    //                         .burstcount
		.uav_read              (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_read),          //                         .read
		.uav_write             (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_write),         //                         .write
		.uav_waitrequest       (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid     (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_readdatavalid), //                         .readdatavalid
		.uav_byteenable        (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_byteenable),    //                         .byteenable
		.uav_readdata          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_readdata),      //                         .readdata
		.uav_writedata         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_writedata),     //                         .writedata
		.uav_arbiterlock       (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_arbiterlock),   //                         .arbiterlock
		.uav_debugaccess       (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_debugaccess),   //                         .debugaccess
		.av_address            (pipeline_bridge_s0_translator_avalon_anti_slave_0_address),                     //      avalon_anti_slave_0.address
		.av_write              (pipeline_bridge_s0_translator_avalon_anti_slave_0_write),                       //                         .write
		.av_read               (pipeline_bridge_s0_translator_avalon_anti_slave_0_read),                        //                         .read
		.av_readdata           (pipeline_bridge_s0_translator_avalon_anti_slave_0_readdata),                    //                         .readdata
		.av_writedata          (pipeline_bridge_s0_translator_avalon_anti_slave_0_writedata),                   //                         .writedata
		.av_burstcount         (pipeline_bridge_s0_translator_avalon_anti_slave_0_burstcount),                  //                         .burstcount
		.av_byteenable         (pipeline_bridge_s0_translator_avalon_anti_slave_0_byteenable),                  //                         .byteenable
		.av_readdatavalid      (pipeline_bridge_s0_translator_avalon_anti_slave_0_readdatavalid),               //                         .readdatavalid
		.av_waitrequest        (pipeline_bridge_s0_translator_avalon_anti_slave_0_waitrequest),                 //                         .waitrequest
		.av_debugaccess        (pipeline_bridge_s0_translator_avalon_anti_slave_0_debugaccess),                 //                         .debugaccess
		.av_begintransfer      (),                                                                              //              (terminated)
		.av_beginbursttransfer (),                                                                              //              (terminated)
		.av_writebyteenable    (),                                                                              //              (terminated)
		.av_arbiterlock        (),                                                                              //              (terminated)
		.av_chipselect         (),                                                                              //              (terminated)
		.av_clken              (),                                                                              //              (terminated)
		.uav_clken             (1'b0),                                                                          //              (terminated)
		.av_outputenable       ()                                                                               //              (terminated)
	);

	altera_merlin_master_agent #(
		.PKT_PROTECTION_H          (85),
		.PKT_PROTECTION_L          (85),
		.PKT_BEGIN_BURST           (78),
		.PKT_BURSTWRAP_H           (77),
		.PKT_BURSTWRAP_L           (75),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_ADDR_H                (66),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (67),
		.PKT_TRANS_POSTED          (68),
		.PKT_TRANS_WRITE           (69),
		.PKT_TRANS_READ            (70),
		.PKT_TRANS_LOCK            (71),
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_SRC_ID_H              (81),
		.PKT_SRC_ID_L              (79),
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.ST_DATA_W                 (86),
		.ST_CHANNEL_W              (4),
		.AV_BURSTCOUNT_W           (3),
		.SUPPRESS_0_BYTEEN_RSP     (0),
		.ID                        (1),
		.BURSTWRAP_VALUE           (3)
	) cpu_instruction_master_translator_avalon_universal_master_0_agent (
		.clk              (cpu_clk_clk),                                                                        //       clk.clk
		.reset            (rst_controller_reset_out_reset),                                                     // clk_reset.reset
		.av_address       (cpu_instruction_master_translator_avalon_universal_master_0_address),                //        av.address
		.av_write         (cpu_instruction_master_translator_avalon_universal_master_0_write),                  //          .write
		.av_read          (cpu_instruction_master_translator_avalon_universal_master_0_read),                   //          .read
		.av_writedata     (cpu_instruction_master_translator_avalon_universal_master_0_writedata),              //          .writedata
		.av_readdata      (cpu_instruction_master_translator_avalon_universal_master_0_readdata),               //          .readdata
		.av_waitrequest   (cpu_instruction_master_translator_avalon_universal_master_0_waitrequest),            //          .waitrequest
		.av_readdatavalid (cpu_instruction_master_translator_avalon_universal_master_0_readdatavalid),          //          .readdatavalid
		.av_byteenable    (cpu_instruction_master_translator_avalon_universal_master_0_byteenable),             //          .byteenable
		.av_burstcount    (cpu_instruction_master_translator_avalon_universal_master_0_burstcount),             //          .burstcount
		.av_debugaccess   (cpu_instruction_master_translator_avalon_universal_master_0_debugaccess),            //          .debugaccess
		.av_arbiterlock   (cpu_instruction_master_translator_avalon_universal_master_0_arbiterlock),            //          .arbiterlock
		.cp_valid         (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_valid),         //        cp.valid
		.cp_data          (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.cp_startofpacket (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.cp_endofpacket   (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.cp_ready         (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_ready),         //          .ready
		.rp_valid         (limiter_rsp_src_valid),                                                              //        rp.valid
		.rp_data          (limiter_rsp_src_data),                                                               //          .data
		.rp_channel       (limiter_rsp_src_channel),                                                            //          .channel
		.rp_startofpacket (limiter_rsp_src_startofpacket),                                                      //          .startofpacket
		.rp_endofpacket   (limiter_rsp_src_endofpacket),                                                        //          .endofpacket
		.rp_ready         (limiter_rsp_src_ready)                                                               //          .ready
	);

	altera_merlin_master_agent #(
		.PKT_PROTECTION_H          (85),
		.PKT_PROTECTION_L          (85),
		.PKT_BEGIN_BURST           (78),
		.PKT_BURSTWRAP_H           (77),
		.PKT_BURSTWRAP_L           (75),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_ADDR_H                (66),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (67),
		.PKT_TRANS_POSTED          (68),
		.PKT_TRANS_WRITE           (69),
		.PKT_TRANS_READ            (70),
		.PKT_TRANS_LOCK            (71),
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_SRC_ID_H              (81),
		.PKT_SRC_ID_L              (79),
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.ST_DATA_W                 (86),
		.ST_CHANNEL_W              (4),
		.AV_BURSTCOUNT_W           (3),
		.SUPPRESS_0_BYTEEN_RSP     (0),
		.ID                        (2),
		.BURSTWRAP_VALUE           (7)
	) cpu_data_master_translator_avalon_universal_master_0_agent (
		.clk              (cpu_clk_clk),                                                                 //       clk.clk
		.reset            (rst_controller_reset_out_reset),                                              // clk_reset.reset
		.av_address       (cpu_data_master_translator_avalon_universal_master_0_address),                //        av.address
		.av_write         (cpu_data_master_translator_avalon_universal_master_0_write),                  //          .write
		.av_read          (cpu_data_master_translator_avalon_universal_master_0_read),                   //          .read
		.av_writedata     (cpu_data_master_translator_avalon_universal_master_0_writedata),              //          .writedata
		.av_readdata      (cpu_data_master_translator_avalon_universal_master_0_readdata),               //          .readdata
		.av_waitrequest   (cpu_data_master_translator_avalon_universal_master_0_waitrequest),            //          .waitrequest
		.av_readdatavalid (cpu_data_master_translator_avalon_universal_master_0_readdatavalid),          //          .readdatavalid
		.av_byteenable    (cpu_data_master_translator_avalon_universal_master_0_byteenable),             //          .byteenable
		.av_burstcount    (cpu_data_master_translator_avalon_universal_master_0_burstcount),             //          .burstcount
		.av_debugaccess   (cpu_data_master_translator_avalon_universal_master_0_debugaccess),            //          .debugaccess
		.av_arbiterlock   (cpu_data_master_translator_avalon_universal_master_0_arbiterlock),            //          .arbiterlock
		.cp_valid         (cpu_data_master_translator_avalon_universal_master_0_agent_cp_valid),         //        cp.valid
		.cp_data          (cpu_data_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.cp_startofpacket (cpu_data_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.cp_endofpacket   (cpu_data_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.cp_ready         (cpu_data_master_translator_avalon_universal_master_0_agent_cp_ready),         //          .ready
		.rp_valid         (limiter_001_rsp_src_valid),                                                   //        rp.valid
		.rp_data          (limiter_001_rsp_src_data),                                                    //          .data
		.rp_channel       (limiter_001_rsp_src_channel),                                                 //          .channel
		.rp_startofpacket (limiter_001_rsp_src_startofpacket),                                           //          .startofpacket
		.rp_endofpacket   (limiter_001_rsp_src_endofpacket),                                             //          .endofpacket
		.rp_ready         (limiter_001_rsp_src_ready)                                                    //          .ready
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (78),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (66),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (67),
		.PKT_TRANS_POSTED          (68),
		.PKT_TRANS_WRITE           (69),
		.PKT_TRANS_READ            (70),
		.PKT_TRANS_LOCK            (71),
		.PKT_SRC_ID_H              (81),
		.PKT_SRC_ID_L              (79),
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.PKT_BURSTWRAP_H           (77),
		.PKT_BURSTWRAP_L           (75),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_PROTECTION_H          (85),
		.PKT_PROTECTION_L          (85),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (86),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent (
		.clk                     (cpu_clk_clk),                                                                                //             clk.clk
		.reset                   (rst_controller_reset_out_reset),                                                             //       clk_reset.reset
		.m0_address              (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_arbiterlock          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_arbiterlock),             //                .arbiterlock
		.m0_readdata             (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_src_ready),                                                                     //              cp.ready
		.cp_valid                (cmd_xbar_mux_src_valid),                                                                     //                .valid
		.cp_data                 (cmd_xbar_mux_src_data),                                                                      //                .data
		.cp_startofpacket        (cmd_xbar_mux_src_startofpacket),                                                             //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_src_endofpacket),                                                               //                .endofpacket
		.cp_channel              (cmd_xbar_mux_src_channel),                                                                   //                .channel
		.rf_sink_ready           (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_sink_data    (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),        //                .data
		.rdata_fifo_src_ready    (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (87),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (cpu_clk_clk),                                                                                //       clk.clk
		.reset             (rst_controller_reset_out_reset),                                                             // clk_reset.reset
		.in_data           (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                                      // (terminated)
		.csr_read          (1'b0),                                                                                       // (terminated)
		.csr_write         (1'b0),                                                                                       // (terminated)
		.csr_readdata      (),                                                                                           // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                                       // (terminated)
		.almost_full_data  (),                                                                                           // (terminated)
		.almost_empty_data (),                                                                                           // (terminated)
		.in_empty          (1'b0),                                                                                       // (terminated)
		.out_empty         (),                                                                                           // (terminated)
		.in_error          (1'b0),                                                                                       // (terminated)
		.out_error         (),                                                                                           // (terminated)
		.in_channel        (1'b0),                                                                                       // (terminated)
		.out_channel       ()                                                                                            // (terminated)
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (78),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (66),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (67),
		.PKT_TRANS_POSTED          (68),
		.PKT_TRANS_WRITE           (69),
		.PKT_TRANS_READ            (70),
		.PKT_TRANS_LOCK            (71),
		.PKT_SRC_ID_H              (81),
		.PKT_SRC_ID_L              (79),
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.PKT_BURSTWRAP_H           (77),
		.PKT_BURSTWRAP_L           (75),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_PROTECTION_H          (85),
		.PKT_PROTECTION_L          (85),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (86),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) onchip_ram_s1_translator_avalon_universal_slave_0_agent (
		.clk                     (cpu_clk_clk),                                                                        //             clk.clk
		.reset                   (rst_controller_reset_out_reset),                                                     //       clk_reset.reset
		.m0_address              (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_arbiterlock          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_arbiterlock),             //                .arbiterlock
		.m0_readdata             (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (onchip_ram_s1_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_001_src_ready),                                                         //              cp.ready
		.cp_valid                (cmd_xbar_mux_001_src_valid),                                                         //                .valid
		.cp_data                 (cmd_xbar_mux_001_src_data),                                                          //                .data
		.cp_startofpacket        (cmd_xbar_mux_001_src_startofpacket),                                                 //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_001_src_endofpacket),                                                   //                .endofpacket
		.cp_channel              (cmd_xbar_mux_001_src_channel),                                                       //                .channel
		.rf_sink_ready           (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_sink_data    (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),        //                .data
		.rdata_fifo_src_ready    (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (87),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (cpu_clk_clk),                                                                        //       clk.clk
		.reset             (rst_controller_reset_out_reset),                                                     // clk_reset.reset
		.in_data           (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                              // (terminated)
		.csr_read          (1'b0),                                                                               // (terminated)
		.csr_write         (1'b0),                                                                               // (terminated)
		.csr_readdata      (),                                                                                   // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                               // (terminated)
		.almost_full_data  (),                                                                                   // (terminated)
		.almost_empty_data (),                                                                                   // (terminated)
		.in_empty          (1'b0),                                                                               // (terminated)
		.out_empty         (),                                                                                   // (terminated)
		.in_error          (1'b0),                                                                               // (terminated)
		.out_error         (),                                                                                   // (terminated)
		.in_channel        (1'b0),                                                                               // (terminated)
		.out_channel       ()                                                                                    // (terminated)
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (78),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (66),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (67),
		.PKT_TRANS_POSTED          (68),
		.PKT_TRANS_WRITE           (69),
		.PKT_TRANS_READ            (70),
		.PKT_TRANS_LOCK            (71),
		.PKT_SRC_ID_H              (81),
		.PKT_SRC_ID_L              (79),
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.PKT_BURSTWRAP_H           (77),
		.PKT_BURSTWRAP_L           (75),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_PROTECTION_H          (85),
		.PKT_PROTECTION_L          (85),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (86),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent (
		.clk                     (cpu_clk_clk),                                                                                      //             clk.clk
		.reset                   (rst_controller_reset_out_reset),                                                                   //       clk_reset.reset
		.m0_address              (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_arbiterlock          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_arbiterlock),             //                .arbiterlock
		.m0_readdata             (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_002_src_ready),                                                                       //              cp.ready
		.cp_valid                (cmd_xbar_mux_002_src_valid),                                                                       //                .valid
		.cp_data                 (cmd_xbar_mux_002_src_data),                                                                        //                .data
		.cp_startofpacket        (cmd_xbar_mux_002_src_startofpacket),                                                               //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_002_src_endofpacket),                                                                 //                .endofpacket
		.cp_channel              (cmd_xbar_mux_002_src_channel),                                                                     //                .channel
		.rf_sink_ready           (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_sink_data    (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),        //                .data
		.rdata_fifo_src_ready    (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (87),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (cpu_clk_clk),                                                                                      //       clk.clk
		.reset             (rst_controller_reset_out_reset),                                                                   // clk_reset.reset
		.in_data           (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                                            // (terminated)
		.csr_read          (1'b0),                                                                                             // (terminated)
		.csr_write         (1'b0),                                                                                             // (terminated)
		.csr_readdata      (),                                                                                                 // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                                             // (terminated)
		.almost_full_data  (),                                                                                                 // (terminated)
		.almost_empty_data (),                                                                                                 // (terminated)
		.in_empty          (1'b0),                                                                                             // (terminated)
		.out_empty         (),                                                                                                 // (terminated)
		.in_error          (1'b0),                                                                                             // (terminated)
		.out_error         (),                                                                                                 // (terminated)
		.in_channel        (1'b0),                                                                                             // (terminated)
		.out_channel       ()                                                                                                  // (terminated)
	);

	altera_merlin_slave_agent #(
		.PKT_DATA_H                (31),
		.PKT_DATA_L                (0),
		.PKT_BEGIN_BURST           (78),
		.PKT_SYMBOL_W              (8),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32),
		.PKT_ADDR_H                (66),
		.PKT_ADDR_L                (36),
		.PKT_TRANS_COMPRESSED_READ (67),
		.PKT_TRANS_POSTED          (68),
		.PKT_TRANS_WRITE           (69),
		.PKT_TRANS_READ            (70),
		.PKT_TRANS_LOCK            (71),
		.PKT_SRC_ID_H              (81),
		.PKT_SRC_ID_L              (79),
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.PKT_BURSTWRAP_H           (77),
		.PKT_BURSTWRAP_L           (75),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_PROTECTION_H          (85),
		.PKT_PROTECTION_L          (85),
		.ST_CHANNEL_W              (4),
		.ST_DATA_W                 (86),
		.AVS_BURSTCOUNT_W          (3),
		.SUPPRESS_0_BYTEEN_CMD     (0),
		.PREVENT_FIFO_OVERFLOW     (1)
	) pipeline_bridge_s0_translator_avalon_universal_slave_0_agent (
		.clk                     (mem_clk_clk),                                                                             //             clk.clk
		.reset                   (rst_controller_001_reset_out_reset),                                                      //       clk_reset.reset
		.m0_address              (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_address),                 //              m0.address
		.m0_burstcount           (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_burstcount),              //                .burstcount
		.m0_byteenable           (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_byteenable),              //                .byteenable
		.m0_debugaccess          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_debugaccess),             //                .debugaccess
		.m0_arbiterlock          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_arbiterlock),             //                .arbiterlock
		.m0_readdata             (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_readdata),                //                .readdata
		.m0_readdatavalid        (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_readdatavalid),           //                .readdatavalid
		.m0_read                 (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_read),                    //                .read
		.m0_waitrequest          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_waitrequest),             //                .waitrequest
		.m0_writedata            (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_writedata),               //                .writedata
		.m0_write                (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_m0_write),                   //                .write
		.rp_endofpacket          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_endofpacket),             //              rp.endofpacket
		.rp_ready                (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_ready),                   //                .ready
		.rp_valid                (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_valid),                   //                .valid
		.rp_data                 (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_data),                    //                .data
		.rp_startofpacket        (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_startofpacket),           //                .startofpacket
		.cp_ready                (cmd_xbar_mux_003_src_ready),                                                              //              cp.ready
		.cp_valid                (cmd_xbar_mux_003_src_valid),                                                              //                .valid
		.cp_data                 (cmd_xbar_mux_003_src_data),                                                               //                .data
		.cp_startofpacket        (cmd_xbar_mux_003_src_startofpacket),                                                      //                .startofpacket
		.cp_endofpacket          (cmd_xbar_mux_003_src_endofpacket),                                                        //                .endofpacket
		.cp_channel              (cmd_xbar_mux_003_src_channel),                                                            //                .channel
		.rf_sink_ready           (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //         rf_sink.ready
		.rf_sink_valid           (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //                .valid
		.rf_sink_startofpacket   (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //                .startofpacket
		.rf_sink_endofpacket     (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //                .endofpacket
		.rf_sink_data            (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //                .data
		.rf_source_ready         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_ready),            //       rf_source.ready
		.rf_source_valid         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_valid),            //                .valid
		.rf_source_startofpacket (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //                .startofpacket
		.rf_source_endofpacket   (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //                .endofpacket
		.rf_source_data          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_data),             //                .data
		.rdata_fifo_sink_ready   (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_ready),       // rdata_fifo_sink.ready
		.rdata_fifo_sink_valid   (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_valid),       //                .valid
		.rdata_fifo_sink_data    (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_data),        //                .data
		.rdata_fifo_src_ready    (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready),       //  rdata_fifo_src.ready
		.rdata_fifo_src_valid    (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid),       //                .valid
		.rdata_fifo_src_data     (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data)         //                .data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (87),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (1),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo (
		.clk               (mem_clk_clk),                                                                             //       clk.clk
		.reset             (rst_controller_001_reset_out_reset),                                                      // clk_reset.reset
		.in_data           (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_data),             //        in.data
		.in_valid          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_valid),            //          .valid
		.in_ready          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_ready),            //          .ready
		.in_startofpacket  (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_startofpacket),    //          .startofpacket
		.in_endofpacket    (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rf_source_endofpacket),      //          .endofpacket
		.out_data          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_data),          //       out.data
		.out_valid         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_valid),         //          .valid
		.out_ready         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_ready),         //          .ready
		.out_startofpacket (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_startofpacket), //          .startofpacket
		.out_endofpacket   (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rsp_fifo_out_endofpacket),   //          .endofpacket
		.csr_address       (2'b00),                                                                                   // (terminated)
		.csr_read          (1'b0),                                                                                    // (terminated)
		.csr_write         (1'b0),                                                                                    // (terminated)
		.csr_readdata      (),                                                                                        // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                                    // (terminated)
		.almost_full_data  (),                                                                                        // (terminated)
		.almost_empty_data (),                                                                                        // (terminated)
		.in_empty          (1'b0),                                                                                    // (terminated)
		.out_empty         (),                                                                                        // (terminated)
		.in_error          (1'b0),                                                                                    // (terminated)
		.out_error         (),                                                                                        // (terminated)
		.in_channel        (1'b0),                                                                                    // (terminated)
		.out_channel       ()                                                                                         // (terminated)
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (1),
		.BITS_PER_SYMBOL     (32),
		.FIFO_DEPTH          (2),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (0),
		.USE_FILL_LEVEL      (0),
		.EMPTY_LATENCY       (0),
		.USE_MEMORY_BLOCKS   (0),
		.USE_STORE_FORWARD   (0),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo (
		.clk               (mem_clk_clk),                                                                       //       clk.clk
		.reset             (rst_controller_001_reset_out_reset),                                                // clk_reset.reset
		.in_data           (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_data),  //        in.data
		.in_valid          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_valid), //          .valid
		.in_ready          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_src_ready), //          .ready
		.out_data          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_data),  //       out.data
		.out_valid         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_valid), //          .valid
		.out_ready         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rdata_fifo_out_ready), //          .ready
		.csr_address       (2'b00),                                                                             // (terminated)
		.csr_read          (1'b0),                                                                              // (terminated)
		.csr_write         (1'b0),                                                                              // (terminated)
		.csr_readdata      (),                                                                                  // (terminated)
		.csr_writedata     (32'b00000000000000000000000000000000),                                              // (terminated)
		.almost_full_data  (),                                                                                  // (terminated)
		.almost_empty_data (),                                                                                  // (terminated)
		.in_startofpacket  (1'b0),                                                                              // (terminated)
		.in_endofpacket    (1'b0),                                                                              // (terminated)
		.out_startofpacket (),                                                                                  // (terminated)
		.out_endofpacket   (),                                                                                  // (terminated)
		.in_empty          (1'b0),                                                                              // (terminated)
		.out_empty         (),                                                                                  // (terminated)
		.in_error          (1'b0),                                                                              // (terminated)
		.out_error         (),                                                                                  // (terminated)
		.in_channel        (1'b0),                                                                              // (terminated)
		.out_channel       ()                                                                                   // (terminated)
	);

	altera_merlin_router_kzjlm7w5 addr_router (
		.sink_ready         (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_ready),         //      sink.ready
		.sink_valid         (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_valid),         //          .valid
		.sink_data          (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.sink_startofpacket (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.sink_endofpacket   (cpu_instruction_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.clk                (cpu_clk_clk),                                                                        //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                                     // clk_reset.reset
		.src_ready          (addr_router_src_ready),                                                              //       src.ready
		.src_valid          (addr_router_src_valid),                                                              //          .valid
		.src_data           (addr_router_src_data),                                                               //          .data
		.src_channel        (addr_router_src_channel),                                                            //          .channel
		.src_startofpacket  (addr_router_src_startofpacket),                                                      //          .startofpacket
		.src_endofpacket    (addr_router_src_endofpacket)                                                         //          .endofpacket
	);

	altera_merlin_router_afjukysr addr_router_001 (
		.sink_ready         (cpu_data_master_translator_avalon_universal_master_0_agent_cp_ready),         //      sink.ready
		.sink_valid         (cpu_data_master_translator_avalon_universal_master_0_agent_cp_valid),         //          .valid
		.sink_data          (cpu_data_master_translator_avalon_universal_master_0_agent_cp_data),          //          .data
		.sink_startofpacket (cpu_data_master_translator_avalon_universal_master_0_agent_cp_startofpacket), //          .startofpacket
		.sink_endofpacket   (cpu_data_master_translator_avalon_universal_master_0_agent_cp_endofpacket),   //          .endofpacket
		.clk                (cpu_clk_clk),                                                                 //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                              // clk_reset.reset
		.src_ready          (addr_router_001_src_ready),                                                   //       src.ready
		.src_valid          (addr_router_001_src_valid),                                                   //          .valid
		.src_data           (addr_router_001_src_data),                                                    //          .data
		.src_channel        (addr_router_001_src_channel),                                                 //          .channel
		.src_startofpacket  (addr_router_001_src_startofpacket),                                           //          .startofpacket
		.src_endofpacket    (addr_router_001_src_endofpacket)                                              //          .endofpacket
	);

	altera_merlin_router_ieor7irj id_router (
		.sink_ready         (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (cpu_jtag_debug_module_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (cpu_clk_clk),                                                                      //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                                   // clk_reset.reset
		.src_ready          (id_router_src_ready),                                                              //       src.ready
		.src_valid          (id_router_src_valid),                                                              //          .valid
		.src_data           (id_router_src_data),                                                               //          .data
		.src_channel        (id_router_src_channel),                                                            //          .channel
		.src_startofpacket  (id_router_src_startofpacket),                                                      //          .startofpacket
		.src_endofpacket    (id_router_src_endofpacket)                                                         //          .endofpacket
	);

	altera_merlin_router_ieor7irj id_router_001 (
		.sink_ready         (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (onchip_ram_s1_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (cpu_clk_clk),                                                              //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                           // clk_reset.reset
		.src_ready          (id_router_001_src_ready),                                                  //       src.ready
		.src_valid          (id_router_001_src_valid),                                                  //          .valid
		.src_data           (id_router_001_src_data),                                                   //          .data
		.src_channel        (id_router_001_src_channel),                                                //          .channel
		.src_startofpacket  (id_router_001_src_startofpacket),                                          //          .startofpacket
		.src_endofpacket    (id_router_001_src_endofpacket)                                             //          .endofpacket
	);

	altera_merlin_router_ieor7irj id_router_002 (
		.sink_ready         (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (jtag_uart_avalon_jtag_slave_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (cpu_clk_clk),                                                                            //       clk.clk
		.reset              (rst_controller_reset_out_reset),                                                         // clk_reset.reset
		.src_ready          (id_router_002_src_ready),                                                                //       src.ready
		.src_valid          (id_router_002_src_valid),                                                                //          .valid
		.src_data           (id_router_002_src_data),                                                                 //          .data
		.src_channel        (id_router_002_src_channel),                                                              //          .channel
		.src_startofpacket  (id_router_002_src_startofpacket),                                                        //          .startofpacket
		.src_endofpacket    (id_router_002_src_endofpacket)                                                           //          .endofpacket
	);

	altera_merlin_router_ieor7irj id_router_003 (
		.sink_ready         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_ready),         //      sink.ready
		.sink_valid         (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_valid),         //          .valid
		.sink_data          (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_data),          //          .data
		.sink_startofpacket (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_startofpacket), //          .startofpacket
		.sink_endofpacket   (pipeline_bridge_s0_translator_avalon_universal_slave_0_agent_rp_endofpacket),   //          .endofpacket
		.clk                (mem_clk_clk),                                                                   //       clk.clk
		.reset              (rst_controller_001_reset_out_reset),                                            // clk_reset.reset
		.src_ready          (id_router_003_src_ready),                                                       //       src.ready
		.src_valid          (id_router_003_src_valid),                                                       //          .valid
		.src_data           (id_router_003_src_data),                                                        //          .data
		.src_channel        (id_router_003_src_channel),                                                     //          .channel
		.src_startofpacket  (id_router_003_src_startofpacket),                                               //          .startofpacket
		.src_endofpacket    (id_router_003_src_endofpacket)                                                  //          .endofpacket
	);

	altera_merlin_traffic_limiter #(
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.PKT_TRANS_POSTED          (68),
		.MAX_OUTSTANDING_RESPONSES (25),
		.PIPELINED                 (0),
		.ST_DATA_W                 (86),
		.ST_CHANNEL_W              (4),
		.VALID_WIDTH               (1),
		.ENFORCE_ORDER             (0),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32)
	) limiter (
		.clk                    (cpu_clk_clk),                                //       clk.clk
		.reset                  (rst_controller_reset_out_reset),             // clk_reset.reset
		.cmd_sink_ready         (addr_router_src_ready),                      //  cmd_sink.ready
		.cmd_sink_valid         (addr_router_src_valid),                      //          .valid
		.cmd_sink_data          (addr_router_src_data),                       //          .data
		.cmd_sink_channel       (addr_router_src_channel),                    //          .channel
		.cmd_sink_startofpacket (addr_router_src_startofpacket),              //          .startofpacket
		.cmd_sink_endofpacket   (addr_router_src_endofpacket),                //          .endofpacket
		.cmd_src_ready          (limiter_cmd_src_ready),                      //   cmd_src.ready
		.cmd_src_data           (limiter_cmd_src_data),                       //          .data
		.cmd_src_channel        (limiter_cmd_src_channel),                    //          .channel
		.cmd_src_startofpacket  (limiter_cmd_src_startofpacket),              //          .startofpacket
		.cmd_src_endofpacket    (limiter_cmd_src_endofpacket),                //          .endofpacket
		.cmd_src_valid          (limiter_cmd_src_valid),                      //          .valid
		.rsp_sink_ready         (limiter_pipeline_001_source0_ready),         //  rsp_sink.ready
		.rsp_sink_valid         (limiter_pipeline_001_source0_valid),         //          .valid
		.rsp_sink_channel       (limiter_pipeline_001_source0_channel),       //          .channel
		.rsp_sink_data          (limiter_pipeline_001_source0_data),          //          .data
		.rsp_sink_startofpacket (limiter_pipeline_001_source0_startofpacket), //          .startofpacket
		.rsp_sink_endofpacket   (limiter_pipeline_001_source0_endofpacket),   //          .endofpacket
		.rsp_src_ready          (limiter_rsp_src_ready),                      //   rsp_src.ready
		.rsp_src_valid          (limiter_rsp_src_valid),                      //          .valid
		.rsp_src_data           (limiter_rsp_src_data),                       //          .data
		.rsp_src_channel        (limiter_rsp_src_channel),                    //          .channel
		.rsp_src_startofpacket  (limiter_rsp_src_startofpacket),              //          .startofpacket
		.rsp_src_endofpacket    (limiter_rsp_src_endofpacket)                 //          .endofpacket
	);

	altera_merlin_traffic_limiter #(
		.PKT_DEST_ID_H             (84),
		.PKT_DEST_ID_L             (82),
		.PKT_TRANS_POSTED          (68),
		.MAX_OUTSTANDING_RESPONSES (25),
		.PIPELINED                 (0),
		.ST_DATA_W                 (86),
		.ST_CHANNEL_W              (4),
		.VALID_WIDTH               (1),
		.ENFORCE_ORDER             (0),
		.PKT_BYTE_CNT_H            (74),
		.PKT_BYTE_CNT_L            (72),
		.PKT_BYTEEN_H              (35),
		.PKT_BYTEEN_L              (32)
	) limiter_001 (
		.clk                    (cpu_clk_clk),                                //       clk.clk
		.reset                  (rst_controller_reset_out_reset),             // clk_reset.reset
		.cmd_sink_ready         (addr_router_001_src_ready),                  //  cmd_sink.ready
		.cmd_sink_valid         (addr_router_001_src_valid),                  //          .valid
		.cmd_sink_data          (addr_router_001_src_data),                   //          .data
		.cmd_sink_channel       (addr_router_001_src_channel),                //          .channel
		.cmd_sink_startofpacket (addr_router_001_src_startofpacket),          //          .startofpacket
		.cmd_sink_endofpacket   (addr_router_001_src_endofpacket),            //          .endofpacket
		.cmd_src_ready          (limiter_001_cmd_src_ready),                  //   cmd_src.ready
		.cmd_src_data           (limiter_001_cmd_src_data),                   //          .data
		.cmd_src_channel        (limiter_001_cmd_src_channel),                //          .channel
		.cmd_src_startofpacket  (limiter_001_cmd_src_startofpacket),          //          .startofpacket
		.cmd_src_endofpacket    (limiter_001_cmd_src_endofpacket),            //          .endofpacket
		.cmd_src_valid          (limiter_001_cmd_src_valid),                  //          .valid
		.rsp_sink_ready         (limiter_pipeline_003_source0_ready),         //  rsp_sink.ready
		.rsp_sink_valid         (limiter_pipeline_003_source0_valid),         //          .valid
		.rsp_sink_channel       (limiter_pipeline_003_source0_channel),       //          .channel
		.rsp_sink_data          (limiter_pipeline_003_source0_data),          //          .data
		.rsp_sink_startofpacket (limiter_pipeline_003_source0_startofpacket), //          .startofpacket
		.rsp_sink_endofpacket   (limiter_pipeline_003_source0_endofpacket),   //          .endofpacket
		.rsp_src_ready          (limiter_001_rsp_src_ready),                  //   rsp_src.ready
		.rsp_src_valid          (limiter_001_rsp_src_valid),                  //          .valid
		.rsp_src_data           (limiter_001_rsp_src_data),                   //          .data
		.rsp_src_channel        (limiter_001_rsp_src_channel),                //          .channel
		.rsp_src_startofpacket  (limiter_001_rsp_src_startofpacket),          //          .startofpacket
		.rsp_src_endofpacket    (limiter_001_rsp_src_endofpacket)             //          .endofpacket
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS        (2),
		.OUTPUT_RESET_SYNC_EDGES ("deassert"),
		.SYNC_DEPTH              (2)
	) rst_controller (
		.reset_in0  (~cpu_reset_reset_n),             // reset_in0.reset
		.reset_in1  (~mem_reset_reset_n),             // reset_in1.reset
		.clk        (cpu_clk_clk),                    //       clk.clk
		.reset_out  (rst_controller_reset_out_reset), // reset_out.reset
		.reset_in2  (1'b0),                           // (terminated)
		.reset_in3  (1'b0),                           // (terminated)
		.reset_in4  (1'b0),                           // (terminated)
		.reset_in5  (1'b0),                           // (terminated)
		.reset_in6  (1'b0),                           // (terminated)
		.reset_in7  (1'b0),                           // (terminated)
		.reset_in8  (1'b0),                           // (terminated)
		.reset_in9  (1'b0),                           // (terminated)
		.reset_in10 (1'b0),                           // (terminated)
		.reset_in11 (1'b0),                           // (terminated)
		.reset_in12 (1'b0),                           // (terminated)
		.reset_in13 (1'b0),                           // (terminated)
		.reset_in14 (1'b0),                           // (terminated)
		.reset_in15 (1'b0)                            // (terminated)
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS        (2),
		.OUTPUT_RESET_SYNC_EDGES ("deassert"),
		.SYNC_DEPTH              (2)
	) rst_controller_001 (
		.reset_in0  (~cpu_reset_reset_n),                 // reset_in0.reset
		.reset_in1  (~mem_reset_reset_n),                 // reset_in1.reset
		.clk        (mem_clk_clk),                        //       clk.clk
		.reset_out  (rst_controller_001_reset_out_reset), // reset_out.reset
		.reset_in2  (1'b0),                               // (terminated)
		.reset_in3  (1'b0),                               // (terminated)
		.reset_in4  (1'b0),                               // (terminated)
		.reset_in5  (1'b0),                               // (terminated)
		.reset_in6  (1'b0),                               // (terminated)
		.reset_in7  (1'b0),                               // (terminated)
		.reset_in8  (1'b0),                               // (terminated)
		.reset_in9  (1'b0),                               // (terminated)
		.reset_in10 (1'b0),                               // (terminated)
		.reset_in11 (1'b0),                               // (terminated)
		.reset_in12 (1'b0),                               // (terminated)
		.reset_in13 (1'b0),                               // (terminated)
		.reset_in14 (1'b0),                               // (terminated)
		.reset_in15 (1'b0)                                // (terminated)
	);

	altera_merlin_demultiplexer_4sitf4to cmd_xbar_demux (
		.clk                (cpu_clk_clk),                            //       clk.clk
		.reset              (rst_controller_reset_out_reset),         // clk_reset.reset
		.sink_ready         (limiter_pipeline_source0_ready),         //      sink.ready
		.sink_channel       (limiter_pipeline_source0_channel),       //          .channel
		.sink_data          (limiter_pipeline_source0_data),          //          .data
		.sink_startofpacket (limiter_pipeline_source0_startofpacket), //          .startofpacket
		.sink_endofpacket   (limiter_pipeline_source0_endofpacket),   //          .endofpacket
		.sink_valid         (limiter_pipeline_source0_valid),         //          .valid
		.src0_ready         (cmd_xbar_demux_src0_ready),              //      src0.ready
		.src0_valid         (cmd_xbar_demux_src0_valid),              //          .valid
		.src0_data          (cmd_xbar_demux_src0_data),               //          .data
		.src0_channel       (cmd_xbar_demux_src0_channel),            //          .channel
		.src0_startofpacket (cmd_xbar_demux_src0_startofpacket),      //          .startofpacket
		.src0_endofpacket   (cmd_xbar_demux_src0_endofpacket),        //          .endofpacket
		.src1_ready         (cmd_xbar_demux_src1_ready),              //      src1.ready
		.src1_valid         (cmd_xbar_demux_src1_valid),              //          .valid
		.src1_data          (cmd_xbar_demux_src1_data),               //          .data
		.src1_channel       (cmd_xbar_demux_src1_channel),            //          .channel
		.src1_startofpacket (cmd_xbar_demux_src1_startofpacket),      //          .startofpacket
		.src1_endofpacket   (cmd_xbar_demux_src1_endofpacket),        //          .endofpacket
		.src2_ready         (cmd_xbar_demux_src2_ready),              //      src2.ready
		.src2_valid         (cmd_xbar_demux_src2_valid),              //          .valid
		.src2_data          (cmd_xbar_demux_src2_data),               //          .data
		.src2_channel       (cmd_xbar_demux_src2_channel),            //          .channel
		.src2_startofpacket (cmd_xbar_demux_src2_startofpacket),      //          .startofpacket
		.src2_endofpacket   (cmd_xbar_demux_src2_endofpacket),        //          .endofpacket
		.src3_ready         (cmd_xbar_demux_src3_ready),              //      src3.ready
		.src3_valid         (cmd_xbar_demux_src3_valid),              //          .valid
		.src3_data          (cmd_xbar_demux_src3_data),               //          .data
		.src3_channel       (cmd_xbar_demux_src3_channel),            //          .channel
		.src3_startofpacket (cmd_xbar_demux_src3_startofpacket),      //          .startofpacket
		.src3_endofpacket   (cmd_xbar_demux_src3_endofpacket)         //          .endofpacket
	);

	altera_merlin_demultiplexer_4sitf4to cmd_xbar_demux_001 (
		.clk                (cpu_clk_clk),                                //       clk.clk
		.reset              (rst_controller_reset_out_reset),             // clk_reset.reset
		.sink_ready         (limiter_pipeline_002_source0_ready),         //      sink.ready
		.sink_channel       (limiter_pipeline_002_source0_channel),       //          .channel
		.sink_data          (limiter_pipeline_002_source0_data),          //          .data
		.sink_startofpacket (limiter_pipeline_002_source0_startofpacket), //          .startofpacket
		.sink_endofpacket   (limiter_pipeline_002_source0_endofpacket),   //          .endofpacket
		.sink_valid         (limiter_pipeline_002_source0_valid),         //          .valid
		.src0_ready         (cmd_xbar_demux_001_src0_ready),              //      src0.ready
		.src0_valid         (cmd_xbar_demux_001_src0_valid),              //          .valid
		.src0_data          (cmd_xbar_demux_001_src0_data),               //          .data
		.src0_channel       (cmd_xbar_demux_001_src0_channel),            //          .channel
		.src0_startofpacket (cmd_xbar_demux_001_src0_startofpacket),      //          .startofpacket
		.src0_endofpacket   (cmd_xbar_demux_001_src0_endofpacket),        //          .endofpacket
		.src1_ready         (cmd_xbar_demux_001_src1_ready),              //      src1.ready
		.src1_valid         (cmd_xbar_demux_001_src1_valid),              //          .valid
		.src1_data          (cmd_xbar_demux_001_src1_data),               //          .data
		.src1_channel       (cmd_xbar_demux_001_src1_channel),            //          .channel
		.src1_startofpacket (cmd_xbar_demux_001_src1_startofpacket),      //          .startofpacket
		.src1_endofpacket   (cmd_xbar_demux_001_src1_endofpacket),        //          .endofpacket
		.src2_ready         (cmd_xbar_demux_001_src2_ready),              //      src2.ready
		.src2_valid         (cmd_xbar_demux_001_src2_valid),              //          .valid
		.src2_data          (cmd_xbar_demux_001_src2_data),               //          .data
		.src2_channel       (cmd_xbar_demux_001_src2_channel),            //          .channel
		.src2_startofpacket (cmd_xbar_demux_001_src2_startofpacket),      //          .startofpacket
		.src2_endofpacket   (cmd_xbar_demux_001_src2_endofpacket),        //          .endofpacket
		.src3_ready         (cmd_xbar_demux_001_src3_ready),              //      src3.ready
		.src3_valid         (cmd_xbar_demux_001_src3_valid),              //          .valid
		.src3_data          (cmd_xbar_demux_001_src3_data),               //          .data
		.src3_channel       (cmd_xbar_demux_001_src3_channel),            //          .channel
		.src3_startofpacket (cmd_xbar_demux_001_src3_startofpacket),      //          .startofpacket
		.src3_endofpacket   (cmd_xbar_demux_001_src3_endofpacket)         //          .endofpacket
	);

	altera_merlin_multiplexer_7t5ew22p cmd_xbar_mux (
		.clk                 (cpu_clk_clk),                           //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (cmd_xbar_mux_src_ready),                //       src.ready
		.src_valid           (cmd_xbar_mux_src_valid),                //          .valid
		.src_data            (cmd_xbar_mux_src_data),                 //          .data
		.src_channel         (cmd_xbar_mux_src_channel),              //          .channel
		.src_startofpacket   (cmd_xbar_mux_src_startofpacket),        //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_src_endofpacket),          //          .endofpacket
		.sink0_ready         (cmd_xbar_demux_src0_ready),             //     sink0.ready
		.sink0_valid         (cmd_xbar_demux_src0_valid),             //          .valid
		.sink0_channel       (cmd_xbar_demux_src0_channel),           //          .channel
		.sink0_data          (cmd_xbar_demux_src0_data),              //          .data
		.sink0_startofpacket (cmd_xbar_demux_src0_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (cmd_xbar_demux_src0_endofpacket),       //          .endofpacket
		.sink1_ready         (cmd_xbar_demux_001_src0_ready),         //     sink1.ready
		.sink1_valid         (cmd_xbar_demux_001_src0_valid),         //          .valid
		.sink1_channel       (cmd_xbar_demux_001_src0_channel),       //          .channel
		.sink1_data          (cmd_xbar_demux_001_src0_data),          //          .data
		.sink1_startofpacket (cmd_xbar_demux_001_src0_startofpacket), //          .startofpacket
		.sink1_endofpacket   (cmd_xbar_demux_001_src0_endofpacket)    //          .endofpacket
	);

	altera_merlin_multiplexer_7t5ew22p cmd_xbar_mux_001 (
		.clk                 (cpu_clk_clk),                           //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (cmd_xbar_mux_001_src_ready),            //       src.ready
		.src_valid           (cmd_xbar_mux_001_src_valid),            //          .valid
		.src_data            (cmd_xbar_mux_001_src_data),             //          .data
		.src_channel         (cmd_xbar_mux_001_src_channel),          //          .channel
		.src_startofpacket   (cmd_xbar_mux_001_src_startofpacket),    //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_001_src_endofpacket),      //          .endofpacket
		.sink0_ready         (cmd_xbar_demux_src1_ready),             //     sink0.ready
		.sink0_valid         (cmd_xbar_demux_src1_valid),             //          .valid
		.sink0_channel       (cmd_xbar_demux_src1_channel),           //          .channel
		.sink0_data          (cmd_xbar_demux_src1_data),              //          .data
		.sink0_startofpacket (cmd_xbar_demux_src1_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (cmd_xbar_demux_src1_endofpacket),       //          .endofpacket
		.sink1_ready         (cmd_xbar_demux_001_src1_ready),         //     sink1.ready
		.sink1_valid         (cmd_xbar_demux_001_src1_valid),         //          .valid
		.sink1_channel       (cmd_xbar_demux_001_src1_channel),       //          .channel
		.sink1_data          (cmd_xbar_demux_001_src1_data),          //          .data
		.sink1_startofpacket (cmd_xbar_demux_001_src1_startofpacket), //          .startofpacket
		.sink1_endofpacket   (cmd_xbar_demux_001_src1_endofpacket)    //          .endofpacket
	);

	altera_merlin_multiplexer_7t5ew22p cmd_xbar_mux_002 (
		.clk                 (cpu_clk_clk),                           //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (cmd_xbar_mux_002_src_ready),            //       src.ready
		.src_valid           (cmd_xbar_mux_002_src_valid),            //          .valid
		.src_data            (cmd_xbar_mux_002_src_data),             //          .data
		.src_channel         (cmd_xbar_mux_002_src_channel),          //          .channel
		.src_startofpacket   (cmd_xbar_mux_002_src_startofpacket),    //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_002_src_endofpacket),      //          .endofpacket
		.sink0_ready         (cmd_xbar_demux_src2_ready),             //     sink0.ready
		.sink0_valid         (cmd_xbar_demux_src2_valid),             //          .valid
		.sink0_channel       (cmd_xbar_demux_src2_channel),           //          .channel
		.sink0_data          (cmd_xbar_demux_src2_data),              //          .data
		.sink0_startofpacket (cmd_xbar_demux_src2_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (cmd_xbar_demux_src2_endofpacket),       //          .endofpacket
		.sink1_ready         (cmd_xbar_demux_001_src2_ready),         //     sink1.ready
		.sink1_valid         (cmd_xbar_demux_001_src2_valid),         //          .valid
		.sink1_channel       (cmd_xbar_demux_001_src2_channel),       //          .channel
		.sink1_data          (cmd_xbar_demux_001_src2_data),          //          .data
		.sink1_startofpacket (cmd_xbar_demux_001_src2_startofpacket), //          .startofpacket
		.sink1_endofpacket   (cmd_xbar_demux_001_src2_endofpacket)    //          .endofpacket
	);

	altera_merlin_multiplexer_7t5ew22p cmd_xbar_mux_003 (
		.clk                 (mem_clk_clk),                        //       clk.clk
		.reset               (rst_controller_001_reset_out_reset), // clk_reset.reset
		.src_ready           (cmd_xbar_mux_003_src_ready),         //       src.ready
		.src_valid           (cmd_xbar_mux_003_src_valid),         //          .valid
		.src_data            (cmd_xbar_mux_003_src_data),          //          .data
		.src_channel         (cmd_xbar_mux_003_src_channel),       //          .channel
		.src_startofpacket   (cmd_xbar_mux_003_src_startofpacket), //          .startofpacket
		.src_endofpacket     (cmd_xbar_mux_003_src_endofpacket),   //          .endofpacket
		.sink0_ready         (async_fifo_out_ready),               //     sink0.ready
		.sink0_valid         (async_fifo_out_valid),               //          .valid
		.sink0_channel       (async_fifo_out_channel),             //          .channel
		.sink0_data          (async_fifo_out_data),                //          .data
		.sink0_startofpacket (async_fifo_out_startofpacket),       //          .startofpacket
		.sink0_endofpacket   (async_fifo_out_endofpacket),         //          .endofpacket
		.sink1_ready         (async_fifo_001_out_ready),           //     sink1.ready
		.sink1_valid         (async_fifo_001_out_valid),           //          .valid
		.sink1_channel       (async_fifo_001_out_channel),         //          .channel
		.sink1_data          (async_fifo_001_out_data),            //          .data
		.sink1_startofpacket (async_fifo_001_out_startofpacket),   //          .startofpacket
		.sink1_endofpacket   (async_fifo_001_out_endofpacket)      //          .endofpacket
	);

	altera_merlin_demultiplexer_2hdz7hhu rsp_xbar_demux (
		.clk                (cpu_clk_clk),                       //       clk.clk
		.reset              (rst_controller_reset_out_reset),    // clk_reset.reset
		.sink_ready         (id_router_src_ready),               //      sink.ready
		.sink_channel       (id_router_src_channel),             //          .channel
		.sink_data          (id_router_src_data),                //          .data
		.sink_startofpacket (id_router_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_src1_endofpacket)    //          .endofpacket
	);

	altera_merlin_demultiplexer_2hdz7hhu rsp_xbar_demux_001 (
		.clk                (cpu_clk_clk),                           //       clk.clk
		.reset              (rst_controller_reset_out_reset),        // clk_reset.reset
		.sink_ready         (id_router_001_src_ready),               //      sink.ready
		.sink_channel       (id_router_001_src_channel),             //          .channel
		.sink_data          (id_router_001_src_data),                //          .data
		.sink_startofpacket (id_router_001_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_001_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_001_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_001_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_001_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_001_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_001_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_001_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_001_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_001_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_001_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_001_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_001_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_001_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_001_src1_endofpacket)    //          .endofpacket
	);

	altera_merlin_demultiplexer_2hdz7hhu rsp_xbar_demux_002 (
		.clk                (cpu_clk_clk),                           //       clk.clk
		.reset              (rst_controller_reset_out_reset),        // clk_reset.reset
		.sink_ready         (id_router_002_src_ready),               //      sink.ready
		.sink_channel       (id_router_002_src_channel),             //          .channel
		.sink_data          (id_router_002_src_data),                //          .data
		.sink_startofpacket (id_router_002_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_002_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_002_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_002_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_002_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_002_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_002_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_002_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_002_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_002_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_002_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_002_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_002_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_002_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_002_src1_endofpacket)    //          .endofpacket
	);

	altera_merlin_demultiplexer_2hdz7hhu rsp_xbar_demux_003 (
		.clk                (mem_clk_clk),                           //       clk.clk
		.reset              (rst_controller_001_reset_out_reset),    // clk_reset.reset
		.sink_ready         (id_router_003_src_ready),               //      sink.ready
		.sink_channel       (id_router_003_src_channel),             //          .channel
		.sink_data          (id_router_003_src_data),                //          .data
		.sink_startofpacket (id_router_003_src_startofpacket),       //          .startofpacket
		.sink_endofpacket   (id_router_003_src_endofpacket),         //          .endofpacket
		.sink_valid         (id_router_003_src_valid),               //          .valid
		.src0_ready         (rsp_xbar_demux_003_src0_ready),         //      src0.ready
		.src0_valid         (rsp_xbar_demux_003_src0_valid),         //          .valid
		.src0_data          (rsp_xbar_demux_003_src0_data),          //          .data
		.src0_channel       (rsp_xbar_demux_003_src0_channel),       //          .channel
		.src0_startofpacket (rsp_xbar_demux_003_src0_startofpacket), //          .startofpacket
		.src0_endofpacket   (rsp_xbar_demux_003_src0_endofpacket),   //          .endofpacket
		.src1_ready         (rsp_xbar_demux_003_src1_ready),         //      src1.ready
		.src1_valid         (rsp_xbar_demux_003_src1_valid),         //          .valid
		.src1_data          (rsp_xbar_demux_003_src1_data),          //          .data
		.src1_channel       (rsp_xbar_demux_003_src1_channel),       //          .channel
		.src1_startofpacket (rsp_xbar_demux_003_src1_startofpacket), //          .startofpacket
		.src1_endofpacket   (rsp_xbar_demux_003_src1_endofpacket)    //          .endofpacket
	);

	altera_merlin_multiplexer_cuej2q2z rsp_xbar_mux (
		.clk                 (cpu_clk_clk),                           //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (rsp_xbar_mux_src_ready),                //       src.ready
		.src_valid           (rsp_xbar_mux_src_valid),                //          .valid
		.src_data            (rsp_xbar_mux_src_data),                 //          .data
		.src_channel         (rsp_xbar_mux_src_channel),              //          .channel
		.src_startofpacket   (rsp_xbar_mux_src_startofpacket),        //          .startofpacket
		.src_endofpacket     (rsp_xbar_mux_src_endofpacket),          //          .endofpacket
		.sink0_ready         (rsp_xbar_demux_src0_ready),             //     sink0.ready
		.sink0_valid         (rsp_xbar_demux_src0_valid),             //          .valid
		.sink0_channel       (rsp_xbar_demux_src0_channel),           //          .channel
		.sink0_data          (rsp_xbar_demux_src0_data),              //          .data
		.sink0_startofpacket (rsp_xbar_demux_src0_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (rsp_xbar_demux_src0_endofpacket),       //          .endofpacket
		.sink1_ready         (rsp_xbar_demux_001_src0_ready),         //     sink1.ready
		.sink1_valid         (rsp_xbar_demux_001_src0_valid),         //          .valid
		.sink1_channel       (rsp_xbar_demux_001_src0_channel),       //          .channel
		.sink1_data          (rsp_xbar_demux_001_src0_data),          //          .data
		.sink1_startofpacket (rsp_xbar_demux_001_src0_startofpacket), //          .startofpacket
		.sink1_endofpacket   (rsp_xbar_demux_001_src0_endofpacket),   //          .endofpacket
		.sink2_ready         (rsp_xbar_demux_002_src0_ready),         //     sink2.ready
		.sink2_valid         (rsp_xbar_demux_002_src0_valid),         //          .valid
		.sink2_channel       (rsp_xbar_demux_002_src0_channel),       //          .channel
		.sink2_data          (rsp_xbar_demux_002_src0_data),          //          .data
		.sink2_startofpacket (rsp_xbar_demux_002_src0_startofpacket), //          .startofpacket
		.sink2_endofpacket   (rsp_xbar_demux_002_src0_endofpacket),   //          .endofpacket
		.sink3_ready         (async_fifo_002_out_ready),              //     sink3.ready
		.sink3_valid         (async_fifo_002_out_valid),              //          .valid
		.sink3_channel       (async_fifo_002_out_channel),            //          .channel
		.sink3_data          (async_fifo_002_out_data),               //          .data
		.sink3_startofpacket (async_fifo_002_out_startofpacket),      //          .startofpacket
		.sink3_endofpacket   (async_fifo_002_out_endofpacket)         //          .endofpacket
	);

	altera_merlin_multiplexer_cuej2q2z rsp_xbar_mux_001 (
		.clk                 (cpu_clk_clk),                           //       clk.clk
		.reset               (rst_controller_reset_out_reset),        // clk_reset.reset
		.src_ready           (rsp_xbar_mux_001_src_ready),            //       src.ready
		.src_valid           (rsp_xbar_mux_001_src_valid),            //          .valid
		.src_data            (rsp_xbar_mux_001_src_data),             //          .data
		.src_channel         (rsp_xbar_mux_001_src_channel),          //          .channel
		.src_startofpacket   (rsp_xbar_mux_001_src_startofpacket),    //          .startofpacket
		.src_endofpacket     (rsp_xbar_mux_001_src_endofpacket),      //          .endofpacket
		.sink0_ready         (rsp_xbar_demux_src1_ready),             //     sink0.ready
		.sink0_valid         (rsp_xbar_demux_src1_valid),             //          .valid
		.sink0_channel       (rsp_xbar_demux_src1_channel),           //          .channel
		.sink0_data          (rsp_xbar_demux_src1_data),              //          .data
		.sink0_startofpacket (rsp_xbar_demux_src1_startofpacket),     //          .startofpacket
		.sink0_endofpacket   (rsp_xbar_demux_src1_endofpacket),       //          .endofpacket
		.sink1_ready         (rsp_xbar_demux_001_src1_ready),         //     sink1.ready
		.sink1_valid         (rsp_xbar_demux_001_src1_valid),         //          .valid
		.sink1_channel       (rsp_xbar_demux_001_src1_channel),       //          .channel
		.sink1_data          (rsp_xbar_demux_001_src1_data),          //          .data
		.sink1_startofpacket (rsp_xbar_demux_001_src1_startofpacket), //          .startofpacket
		.sink1_endofpacket   (rsp_xbar_demux_001_src1_endofpacket),   //          .endofpacket
		.sink2_ready         (rsp_xbar_demux_002_src1_ready),         //     sink2.ready
		.sink2_valid         (rsp_xbar_demux_002_src1_valid),         //          .valid
		.sink2_channel       (rsp_xbar_demux_002_src1_channel),       //          .channel
		.sink2_data          (rsp_xbar_demux_002_src1_data),          //          .data
		.sink2_startofpacket (rsp_xbar_demux_002_src1_startofpacket), //          .startofpacket
		.sink2_endofpacket   (rsp_xbar_demux_002_src1_endofpacket),   //          .endofpacket
		.sink3_ready         (async_fifo_003_out_ready),              //     sink3.ready
		.sink3_valid         (async_fifo_003_out_valid),              //          .valid
		.sink3_channel       (async_fifo_003_out_channel),            //          .channel
		.sink3_data          (async_fifo_003_out_data),               //          .data
		.sink3_startofpacket (async_fifo_003_out_startofpacket),      //          .startofpacket
		.sink3_endofpacket   (async_fifo_003_out_endofpacket)         //          .endofpacket
	);

	altera_avalon_dc_fifo #(
		.SYMBOLS_PER_BEAT   (1),
		.BITS_PER_SYMBOL    (86),
		.FIFO_DEPTH         (8),
		.CHANNEL_WIDTH      (4),
		.ERROR_WIDTH        (0),
		.USE_PACKETS        (1),
		.USE_IN_FILL_LEVEL  (0),
		.USE_OUT_FILL_LEVEL (0),
		.WR_SYNC_DEPTH      (2),
		.RD_SYNC_DEPTH      (2)
	) async_fifo (
		.in_clk            (cpu_clk_clk),                         //        in_clk.clk
		.in_reset_n        (~rst_controller_reset_out_reset),     //  in_clk_reset.reset_n
		.out_clk           (mem_clk_clk),                         //       out_clk.clk
		.out_reset_n       (~rst_controller_001_reset_out_reset), // out_clk_reset.reset_n
		.in_data           (cmd_xbar_demux_src3_data),            //            in.data
		.in_valid          (cmd_xbar_demux_src3_valid),           //              .valid
		.in_ready          (cmd_xbar_demux_src3_ready),           //              .ready
		.in_startofpacket  (cmd_xbar_demux_src3_startofpacket),   //              .startofpacket
		.in_endofpacket    (cmd_xbar_demux_src3_endofpacket),     //              .endofpacket
		.in_channel        (cmd_xbar_demux_src3_channel),         //              .channel
		.out_data          (async_fifo_out_data),                 //           out.data
		.out_valid         (async_fifo_out_valid),                //              .valid
		.out_ready         (async_fifo_out_ready),                //              .ready
		.out_startofpacket (async_fifo_out_startofpacket),        //              .startofpacket
		.out_endofpacket   (async_fifo_out_endofpacket),          //              .endofpacket
		.out_channel       (async_fifo_out_channel)               //              .channel
	);

	altera_avalon_dc_fifo #(
		.SYMBOLS_PER_BEAT   (1),
		.BITS_PER_SYMBOL    (86),
		.FIFO_DEPTH         (8),
		.CHANNEL_WIDTH      (4),
		.ERROR_WIDTH        (0),
		.USE_PACKETS        (1),
		.USE_IN_FILL_LEVEL  (0),
		.USE_OUT_FILL_LEVEL (0),
		.WR_SYNC_DEPTH      (2),
		.RD_SYNC_DEPTH      (2)
	) async_fifo_001 (
		.in_clk            (cpu_clk_clk),                           //        in_clk.clk
		.in_reset_n        (~rst_controller_reset_out_reset),       //  in_clk_reset.reset_n
		.out_clk           (mem_clk_clk),                           //       out_clk.clk
		.out_reset_n       (~rst_controller_001_reset_out_reset),   // out_clk_reset.reset_n
		.in_data           (cmd_xbar_demux_001_src3_data),          //            in.data
		.in_valid          (cmd_xbar_demux_001_src3_valid),         //              .valid
		.in_ready          (cmd_xbar_demux_001_src3_ready),         //              .ready
		.in_startofpacket  (cmd_xbar_demux_001_src3_startofpacket), //              .startofpacket
		.in_endofpacket    (cmd_xbar_demux_001_src3_endofpacket),   //              .endofpacket
		.in_channel        (cmd_xbar_demux_001_src3_channel),       //              .channel
		.out_data          (async_fifo_001_out_data),               //           out.data
		.out_valid         (async_fifo_001_out_valid),              //              .valid
		.out_ready         (async_fifo_001_out_ready),              //              .ready
		.out_startofpacket (async_fifo_001_out_startofpacket),      //              .startofpacket
		.out_endofpacket   (async_fifo_001_out_endofpacket),        //              .endofpacket
		.out_channel       (async_fifo_001_out_channel)             //              .channel
	);

	altera_avalon_dc_fifo #(
		.SYMBOLS_PER_BEAT   (1),
		.BITS_PER_SYMBOL    (86),
		.FIFO_DEPTH         (8),
		.CHANNEL_WIDTH      (4),
		.ERROR_WIDTH        (0),
		.USE_PACKETS        (1),
		.USE_IN_FILL_LEVEL  (0),
		.USE_OUT_FILL_LEVEL (0),
		.WR_SYNC_DEPTH      (2),
		.RD_SYNC_DEPTH      (2)
	) async_fifo_002 (
		.in_clk            (mem_clk_clk),                           //        in_clk.clk
		.in_reset_n        (~rst_controller_001_reset_out_reset),   //  in_clk_reset.reset_n
		.out_clk           (cpu_clk_clk),                           //       out_clk.clk
		.out_reset_n       (~rst_controller_reset_out_reset),       // out_clk_reset.reset_n
		.in_data           (rsp_xbar_demux_003_src0_data),          //            in.data
		.in_valid          (rsp_xbar_demux_003_src0_valid),         //              .valid
		.in_ready          (rsp_xbar_demux_003_src0_ready),         //              .ready
		.in_startofpacket  (rsp_xbar_demux_003_src0_startofpacket), //              .startofpacket
		.in_endofpacket    (rsp_xbar_demux_003_src0_endofpacket),   //              .endofpacket
		.in_channel        (rsp_xbar_demux_003_src0_channel),       //              .channel
		.out_data          (async_fifo_002_out_data),               //           out.data
		.out_valid         (async_fifo_002_out_valid),              //              .valid
		.out_ready         (async_fifo_002_out_ready),              //              .ready
		.out_startofpacket (async_fifo_002_out_startofpacket),      //              .startofpacket
		.out_endofpacket   (async_fifo_002_out_endofpacket),        //              .endofpacket
		.out_channel       (async_fifo_002_out_channel)             //              .channel
	);

	altera_avalon_dc_fifo #(
		.SYMBOLS_PER_BEAT   (1),
		.BITS_PER_SYMBOL    (86),
		.FIFO_DEPTH         (8),
		.CHANNEL_WIDTH      (4),
		.ERROR_WIDTH        (0),
		.USE_PACKETS        (1),
		.USE_IN_FILL_LEVEL  (0),
		.USE_OUT_FILL_LEVEL (0),
		.WR_SYNC_DEPTH      (2),
		.RD_SYNC_DEPTH      (2)
	) async_fifo_003 (
		.in_clk            (mem_clk_clk),                           //        in_clk.clk
		.in_reset_n        (~rst_controller_001_reset_out_reset),   //  in_clk_reset.reset_n
		.out_clk           (cpu_clk_clk),                           //       out_clk.clk
		.out_reset_n       (~rst_controller_reset_out_reset),       // out_clk_reset.reset_n
		.in_data           (rsp_xbar_demux_003_src1_data),          //            in.data
		.in_valid          (rsp_xbar_demux_003_src1_valid),         //              .valid
		.in_ready          (rsp_xbar_demux_003_src1_ready),         //              .ready
		.in_startofpacket  (rsp_xbar_demux_003_src1_startofpacket), //              .startofpacket
		.in_endofpacket    (rsp_xbar_demux_003_src1_endofpacket),   //              .endofpacket
		.in_channel        (rsp_xbar_demux_003_src1_channel),       //              .channel
		.out_data          (async_fifo_003_out_data),               //           out.data
		.out_valid         (async_fifo_003_out_valid),              //              .valid
		.out_ready         (async_fifo_003_out_ready),              //              .ready
		.out_startofpacket (async_fifo_003_out_startofpacket),      //              .startofpacket
		.out_endofpacket   (async_fifo_003_out_endofpacket),        //              .endofpacket
		.out_channel       (async_fifo_003_out_channel)             //              .channel
	);

	altera_avalon_st_pipeline_stage #(
		.SYMBOLS_PER_BEAT (1),
		.BITS_PER_SYMBOL  (86),
		.USE_PACKETS      (1),
		.USE_EMPTY        (0),
		.EMPTY_WIDTH      (0),
		.CHANNEL_WIDTH    (4),
		.PACKET_WIDTH     (2),
		.ERROR_WIDTH      (0),
		.PIPELINE_READY   (1)
	) limiter_pipeline (
		.clk               (cpu_clk_clk),                            //       cr0.clk
		.reset             (rst_controller_reset_out_reset),         // cr0_reset.reset
		.in_ready          (limiter_cmd_src_ready),                  //     sink0.ready
		.in_valid          (limiter_cmd_src_valid),                  //          .valid
		.in_startofpacket  (limiter_cmd_src_startofpacket),          //          .startofpacket
		.in_endofpacket    (limiter_cmd_src_endofpacket),            //          .endofpacket
		.in_data           (limiter_cmd_src_data),                   //          .data
		.in_channel        (limiter_cmd_src_channel),                //          .channel
		.out_ready         (limiter_pipeline_source0_ready),         //   source0.ready
		.out_valid         (limiter_pipeline_source0_valid),         //          .valid
		.out_startofpacket (limiter_pipeline_source0_startofpacket), //          .startofpacket
		.out_endofpacket   (limiter_pipeline_source0_endofpacket),   //          .endofpacket
		.out_data          (limiter_pipeline_source0_data),          //          .data
		.out_channel       (limiter_pipeline_source0_channel),       //          .channel
		.in_empty          (1'b0),                                   // (terminated)
		.out_empty         (),                                       // (terminated)
		.out_error         (),                                       // (terminated)
		.in_error          (1'b0)                                    // (terminated)
	);

	altera_avalon_st_pipeline_stage #(
		.SYMBOLS_PER_BEAT (1),
		.BITS_PER_SYMBOL  (86),
		.USE_PACKETS      (1),
		.USE_EMPTY        (0),
		.EMPTY_WIDTH      (0),
		.CHANNEL_WIDTH    (4),
		.PACKET_WIDTH     (2),
		.ERROR_WIDTH      (0),
		.PIPELINE_READY   (1)
	) limiter_pipeline_001 (
		.clk               (cpu_clk_clk),                                //       cr0.clk
		.reset             (rst_controller_reset_out_reset),             // cr0_reset.reset
		.in_ready          (rsp_xbar_mux_src_ready),                     //     sink0.ready
		.in_valid          (rsp_xbar_mux_src_valid),                     //          .valid
		.in_startofpacket  (rsp_xbar_mux_src_startofpacket),             //          .startofpacket
		.in_endofpacket    (rsp_xbar_mux_src_endofpacket),               //          .endofpacket
		.in_data           (rsp_xbar_mux_src_data),                      //          .data
		.in_channel        (rsp_xbar_mux_src_channel),                   //          .channel
		.out_ready         (limiter_pipeline_001_source0_ready),         //   source0.ready
		.out_valid         (limiter_pipeline_001_source0_valid),         //          .valid
		.out_startofpacket (limiter_pipeline_001_source0_startofpacket), //          .startofpacket
		.out_endofpacket   (limiter_pipeline_001_source0_endofpacket),   //          .endofpacket
		.out_data          (limiter_pipeline_001_source0_data),          //          .data
		.out_channel       (limiter_pipeline_001_source0_channel),       //          .channel
		.in_empty          (1'b0),                                       // (terminated)
		.out_empty         (),                                           // (terminated)
		.out_error         (),                                           // (terminated)
		.in_error          (1'b0)                                        // (terminated)
	);

	altera_avalon_st_pipeline_stage #(
		.SYMBOLS_PER_BEAT (1),
		.BITS_PER_SYMBOL  (86),
		.USE_PACKETS      (1),
		.USE_EMPTY        (0),
		.EMPTY_WIDTH      (0),
		.CHANNEL_WIDTH    (4),
		.PACKET_WIDTH     (2),
		.ERROR_WIDTH      (0),
		.PIPELINE_READY   (1)
	) limiter_pipeline_002 (
		.clk               (cpu_clk_clk),                                //       cr0.clk
		.reset             (rst_controller_reset_out_reset),             // cr0_reset.reset
		.in_ready          (limiter_001_cmd_src_ready),                  //     sink0.ready
		.in_valid          (limiter_001_cmd_src_valid),                  //          .valid
		.in_startofpacket  (limiter_001_cmd_src_startofpacket),          //          .startofpacket
		.in_endofpacket    (limiter_001_cmd_src_endofpacket),            //          .endofpacket
		.in_data           (limiter_001_cmd_src_data),                   //          .data
		.in_channel        (limiter_001_cmd_src_channel),                //          .channel
		.out_ready         (limiter_pipeline_002_source0_ready),         //   source0.ready
		.out_valid         (limiter_pipeline_002_source0_valid),         //          .valid
		.out_startofpacket (limiter_pipeline_002_source0_startofpacket), //          .startofpacket
		.out_endofpacket   (limiter_pipeline_002_source0_endofpacket),   //          .endofpacket
		.out_data          (limiter_pipeline_002_source0_data),          //          .data
		.out_channel       (limiter_pipeline_002_source0_channel),       //          .channel
		.in_empty          (1'b0),                                       // (terminated)
		.out_empty         (),                                           // (terminated)
		.out_error         (),                                           // (terminated)
		.in_error          (1'b0)                                        // (terminated)
	);

	altera_avalon_st_pipeline_stage #(
		.SYMBOLS_PER_BEAT (1),
		.BITS_PER_SYMBOL  (86),
		.USE_PACKETS      (1),
		.USE_EMPTY        (0),
		.EMPTY_WIDTH      (0),
		.CHANNEL_WIDTH    (4),
		.PACKET_WIDTH     (2),
		.ERROR_WIDTH      (0),
		.PIPELINE_READY   (1)
	) limiter_pipeline_003 (
		.clk               (cpu_clk_clk),                                //       cr0.clk
		.reset             (rst_controller_reset_out_reset),             // cr0_reset.reset
		.in_ready          (rsp_xbar_mux_001_src_ready),                 //     sink0.ready
		.in_valid          (rsp_xbar_mux_001_src_valid),                 //          .valid
		.in_startofpacket  (rsp_xbar_mux_001_src_startofpacket),         //          .startofpacket
		.in_endofpacket    (rsp_xbar_mux_001_src_endofpacket),           //          .endofpacket
		.in_data           (rsp_xbar_mux_001_src_data),                  //          .data
		.in_channel        (rsp_xbar_mux_001_src_channel),               //          .channel
		.out_ready         (limiter_pipeline_003_source0_ready),         //   source0.ready
		.out_valid         (limiter_pipeline_003_source0_valid),         //          .valid
		.out_startofpacket (limiter_pipeline_003_source0_startofpacket), //          .startofpacket
		.out_endofpacket   (limiter_pipeline_003_source0_endofpacket),   //          .endofpacket
		.out_data          (limiter_pipeline_003_source0_data),          //          .data
		.out_channel       (limiter_pipeline_003_source0_channel),       //          .channel
		.in_empty          (1'b0),                                       // (terminated)
		.out_empty         (),                                           // (terminated)
		.out_error         (),                                           // (terminated)
		.in_error          (1'b0)                                        // (terminated)
	);

	altera_irq_mapper_2ia6qhff irq_mapper (
		.clk           (cpu_clk_clk),                    //       clk.clk
		.reset         (rst_controller_reset_out_reset), // clk_reset.reset
		.receiver0_irq (irq_mapper_receiver0_irq),       // receiver0.irq
		.sender_irq    (cpu_d_irq_irq)                   //    sender.irq
	);

endmodule
