module RISC_V_MCU(
    input logic clk,
    input logic reset_in
);

    logic reset;

    // Button on DE10 lite is default high unpressed
    // Change according to needs
    assign reset = ~reset_in;

    KLP32V2 processor(
        .clk(clk),
        .reset(reset)
    );

endmodule