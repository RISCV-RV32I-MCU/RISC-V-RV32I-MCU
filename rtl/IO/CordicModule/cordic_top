//--------------------------------------------------
// Cordic Top-Level Wrapper
//--------------------------------------------------
module cordic_top #(
    parameter int BIT_WIDTH = 16,
    parameter int STAGES    = 16
) (
    input  logic          clk,      // Main clock
    input  logic          reset,    // Active-high reset

    // Slot interface (simple register R/W)
    input  logic          cs,       // Chip select
    input  logic          read,     // Read enable
    input  logic          write,    // Write enable
    input  logic  [4:0]   addr,     // Register address
    input  logic [31:0]   wr_data,  // Data to be written
    output logic [31:0]   rd_data   // Data to be read
);

    // ——————————————————————————————————————————————————
    // Internal registers for inputs
    // ——————————————————————————————————————————————————
    logic signed [BIT_WIDTH-1:0] xin_reg;
    logic signed [BIT_WIDTH-1:0] yin_reg;
    logic signed [BIT_WIDTH-1:0] zin_reg;

    // Outputs from the pipelined CORDIC
    logic signed [BIT_WIDTH-1:0] xout, yout;

    // ——————————————————————————————————————————————————
    // Write logic: capture inputs on write+cs
    // addr 0 → Xin, 1 → Yin, 2 → Zin
    // ——————————————————————————————————————————————————
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            xin_reg <= '0;
            yin_reg <= '0;
            zin_reg <= '0;
        end else if (write && cs) begin
            case (addr)
                5'd0: xin_reg <= wr_data[BIT_WIDTH-1:0];
                5'd1: yin_reg <= wr_data[BIT_WIDTH-1:0];
                5'd2: zin_reg <= wr_data[BIT_WIDTH-1:0];
                default: ; // no action
            endcase
        end
    end

    // ——————————————————————————————————————————————————
    // Read logic: present inputs or outputs based on addr
    // addr 0 → Xin, 1 → Yin, 2 → Zin
    // addr 3 → Xout, 4 → Yout
    // sign-extend to 32 bits
    // ——————————————————————————————————————————————————
    always_comb begin
        if (read && cs) begin
            unique case (addr)
                5'd0: rd_data = {{(32-BIT_WIDTH){xin_reg[BIT_WIDTH-1]}}, xin_reg};
                5'd1: rd_data = {{(32-BIT_WIDTH){yin_reg[BIT_WIDTH-1]}}, yin_reg};
                5'd2: rd_data = {{(32-BIT_WIDTH){zin_reg[BIT_WIDTH-1]}}, zin_reg};
                5'd3: rd_data = {{(32-BIT_WIDTH){xout[BIT_WIDTH-1]}}, xout};
                5'd4: rd_data = {{(32-BIT_WIDTH){yout[BIT_WIDTH-1]}}, yout};
                default: rd_data = 32'hDEADBEEF;
            endcase
        end else begin
            rd_data = 32'h0;
        end
    end

    // ——————————————————————————————————————————————————
    // Instantiate the pipelined CORDIC core
    // ——————————————————————————————————————————————————
    cordic_pipelined #(
        .BIT_WIDTH(BIT_WIDTH),
        .STAGES   (STAGES)
    ) cordic_inst (
        .clk  (clk),
        .Xin  (xin_reg),
        .Yin  (yin_reg),
        .Zin  (zin_reg),
        .Xout (xout),
        .Yout (yout)
    );

endmodule
