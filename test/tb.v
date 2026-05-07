`timescale 1ns/1ps

module tb;

    // -----------------------
    // Clock + control signals
    // -----------------------
    reg clk;
    reg rst;
    reg start;

    reg [31:0] mc;
    reg [31:0] mp;

    wire [63:0] p;
    wire done;

    // -----------------------
    // Clock generation
    // -----------------------
    always #5 clk = ~clk;

    // -----------------------
    // DUT (PM32)
    // -----------------------
    pm32 dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .mc(mc),
        .mp(mp),
        .p(p),
        .done(done)
    );

    // -----------------------
    // Test sequence
    // -----------------------
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        mc = 0;
        mp = 0;

        #20;
        rst = 0;

        // Test 1
        mc = 20;
        mp = 30;
        start = 1;
        #10;
        start = 0;

        wait(done);
        #20;

        // Test 2
        mc = 5;
        mp = 7;
        start = 1;
        #10;
        start = 0;

        wait(done);
        #20;

        $finish;
    end

endmodule
