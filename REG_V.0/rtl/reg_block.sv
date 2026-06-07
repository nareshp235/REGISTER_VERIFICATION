//==============================================================================
// File      : reg_block.sv
// Description:
//   Simple Control Register Block
//
// Register Map
//   Address : 0x1000
//
//   31:16 Reserved (RO)
//   15:8  MODE     (RW)
//   7     ENABLE   (RW)
//   6:0   STATUS   (RO)
//==============================================================================

`include "reg_defines.svh"

module reg_block
(
    input  logic        clk,
    input  logic        reset_n,

    input  logic        write_en,
    input  logic        read_en,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,

    output logic [31:0] rdata,

    input  logic [6:0]  hw_status
);

    //--------------------------------------------------------------------------
    // Register Storage
    //--------------------------------------------------------------------------

    logic [7:0] mode;
    logic       enable;

    //--------------------------------------------------------------------------
    // Register Write Logic
    //--------------------------------------------------------------------------

    always_ff @(posedge clk or negedge reset_n)
    begin
        if (!reset_n)
        begin
            mode   <= 8'h01;
            enable <= 1'b0;
        end
        else if (write_en && (addr == `CTRL_REG_ADDR))
        begin
            mode   <= wdata[15:8];
            enable <= wdata[7];
        end
    end

    //--------------------------------------------------------------------------
    // Register Read Logic
    //--------------------------------------------------------------------------

    always_comb
    begin
        rdata = '0;

        if (read_en && (addr == `CTRL_REG_ADDR))
        begin
            rdata[15:8] = mode;
            rdata[7]    = enable;
            rdata[6:0]  = hw_status;
        end
    end

endmodule : reg_block

