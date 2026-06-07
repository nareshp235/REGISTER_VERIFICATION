//==============================================================================
// File      : tb_reg_block.sv
// Description:
//   Directed Verification of reg_block
//
// Testcases:
//     1. Reset Verification
//     2. RW Field Verification
//     3. RO Field Verification
//     4. Reserved Bit Verification
//==============================================================================

`include "reg_defines.svh"

module tb_reg_block;

    //--------------------------------------------------------------------------
    // Parameters
    //--------------------------------------------------------------------------

    localparam CLK_PERIOD = 10;

    //--------------------------------------------------------------------------
    // TB Signals
    //--------------------------------------------------------------------------

    logic        clk;
    logic        reset_n;

    logic        write_en;
    logic        read_en;

    logic [31:0] addr;
    logic [31:0] wdata;
    logic [31:0] rdata;

    logic [6:0]  hw_status;

    integer error_count;

    //--------------------------------------------------------------------------
    // DUT Instance
    //--------------------------------------------------------------------------

    reg_block dut
    (
        .clk       (clk),
        .reset_n   (reset_n),
        .write_en  (write_en),
        .read_en   (read_en),
        .addr      (addr),
        .wdata     (wdata),
        .rdata     (rdata),
        .hw_status (hw_status)
    );

    //--------------------------------------------------------------------------
    // Clock Generation
    //--------------------------------------------------------------------------

    always #(CLK_PERIOD/2) clk = ~clk;

    //--------------------------------------------------------------------------
    // Initialization Task
    //--------------------------------------------------------------------------

    task automatic initialize_tb();
    begin
        clk         = 1'b0;
        reset_n     = 1'b0;

        write_en    = 1'b0;
        read_en     = 1'b0;

        addr        = '0;
        wdata       = '0;

        hw_status   = '0;

        error_count = 0;
    end
    endtask

    //--------------------------------------------------------------------------
    // Reset Task
    //--------------------------------------------------------------------------

    task automatic apply_reset();
    begin
        repeat(3) @(posedge clk);
        reset_n = 1'b1;

        $display("[%0t] Reset Released", $time);
    end
    endtask

    //--------------------------------------------------------------------------
    // Bus Write
    //--------------------------------------------------------------------------

    task automatic bus_write
    (
        input logic [31:0] wr_addr,
        input logic [31:0] wr_data
    );
    begin
        @(posedge clk);

        addr     <= wr_addr;
        wdata    <= wr_data;
        write_en <= 1'b1;
        read_en  <= 1'b0;

	$display("[%0t] WRITE : ADDR=0x%08h DATA=0x%08h", $time, wr_addr, wr_data);

        @(posedge clk);

        write_en <= 1'b0;
        addr     <= 1'b0;
        wdata    <= 1'b0;
    end
    endtask

    //--------------------------------------------------------------------------
    // Bus Read
    //--------------------------------------------------------------------------

    task automatic bus_read
    (
        input  logic [31:0] rd_addr,
        output logic [31:0] rd_data
    );
    begin
        @(posedge clk);

        addr     <= rd_addr;
        read_en  <= 1'b1;
        write_en <= 1'b0;

        #1;
        rd_data = rdata;

	$display("[%0t] READ  : ADDR=0x%08h DATA=0x%08h", $time, rd_addr, rd_data);

        @(posedge clk);

        read_en <= 1'b0;
        addr    <= 1'b0;
    end
    endtask

    //--------------------------------------------------------------------------
    // Reset Check
    //--------------------------------------------------------------------------

    task automatic check_reset_value();
        logic [31:0] data;
    begin
        bus_read(`CTRL_REG_ADDR, data);

        if (data !== 32'h0000_0100)
        begin
            error_count++;
            $error("RESET CHECK FAILED : Exp=0x00000100 Act=0x%08h", data);
        end
        else
            $display("RESET CHECK PASSED");
    end
    endtask

    //--------------------------------------------------------------------------
    // RW Check
    //--------------------------------------------------------------------------

    task automatic check_rw_fields();
        logic [31:0] data;
    begin
        bus_write(`CTRL_REG_ADDR, 32'h0000_AA80);

        bus_read(`CTRL_REG_ADDR, data);

        if (data[15:8] !== 8'hAA)
        begin
            error_count++;
            $error("MODE CHECK FAILED");
        end
        else
            $display("MODE CHECK PASSED");

        if (data[7] !== 1'b1)
        begin
            error_count++;
            $error("ENABLE CHECK FAILED");
        end
        else
            $display("ENABLE CHECK PASSED");
    end
    endtask

    //--------------------------------------------------------------------------
    // RO Check
    //--------------------------------------------------------------------------

    task automatic check_ro_status_field();
        logic [31:0] data;
    begin
        hw_status = 7'h35;

	$display("[%0t] HW_STATUS Driven = 0x%02h", $time, hw_status);

        bus_write(`CTRL_REG_ADDR, 32'h0000_007F);

        bus_read(`CTRL_REG_ADDR, data);

        if (data[6:0] !== 7'h35)
        begin
            error_count++;
            $error("STATUS RO CHECK FAILED");
        end
        else
            $display("STATUS RO CHECK PASSED");
    end
    endtask

    //--------------------------------------------------------------------------
    // Reserved Bit Check
    //--------------------------------------------------------------------------

    task automatic check_reserved_bits();
        logic [31:0] data;
    begin
        bus_write(`CTRL_REG_ADDR, 32'hFFFF_FFFF);

        bus_read(`CTRL_REG_ADDR, data);

        if (data[31:16] !== 16'h0000)
        begin
            error_count++;
            $error("RESERVED BIT CHECK FAILED");
        end
        else
            $display("RESERVED BIT CHECK PASSED");
    end
    endtask

    //--------------------------------------------------------------------------
    // Main Test
    //--------------------------------------------------------------------------

    initial
    begin

        initialize_tb();

        apply_reset();

        $display("\n==================================");
        $display(" Starting Register Verification");
        $display("==================================\n");

        check_reset_value();

        check_rw_fields();

        check_ro_status_field();

        check_reserved_bits();

        $display("\n==================================");

        if (error_count == 0)
            $display("TEST PASSED");
        else
            $display(" TEST FAILED : %0d ERRORS", error_count);

        $display("==================================\n");

        #20;
        $finish;
    end

    initial begin
      $vcdplusfile("waves/reg_block.vpd");
      $vcdpluson(0, tb_reg_block);
    end

endmodule : tb_reg_block
