`default_nettype none

module spm #(parameter SIZE = 32) (
    input  wire              clk,
    input  wire              rst,
    input  wire              y,
    input  wire [SIZE-1:0]   x,
    output wire              p
);

    wire [SIZE-1:1] pp;
    wire [SIZE-1:0] xy;

    assign xy = x & {SIZE{y}};

    genvar i;

    CSADD csa0 (
        .clk(clk),
        .rst(rst),
        .x(xy[0]),
        .y(pp[1]),
        .sum(p)
    );

    generate
        for (i = 1; i < SIZE-1; i = i + 1) begin : csa_array
            CSADD csa (
                .clk(clk),
                .rst(rst),
                .x(xy[i]),
                .y(pp[i+1]),
                .sum(pp[i])
            );
        end
    endgenerate

    TCMP tcmp (
        .clk(clk),
        .rst(rst),
        .a(xy[SIZE-1]),
        .s(pp[SIZE-1])
    );

endmodule


module CSADD (
    input  wire clk,
    input  wire rst,
    input  wire x,
    input  wire y,
    output reg  sum
);

    reg sc;

    wire hsum1, hco1;
    assign hsum1 = y ^ sc;
    assign hco1  = y & sc;

    wire hsum2, hco2;
    assign hsum2 = x ^ hsum1;
    assign hco2  = x & hsum1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 1'b0;
            sc  <= 1'b0;
        end else begin
            sum <= hsum2;
            sc  <= hco1 ^ hco2;
        end
    end

endmodule


module TCMP (
    input  wire clk,
    input  wire rst,
    input  wire a,
    output reg  s
);

    reg z;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s <= 1'b0;
            z <= 1'b0;
        end else begin
            z <= a | z;
            s <= a ^ z;
        end
    end

endmodule
