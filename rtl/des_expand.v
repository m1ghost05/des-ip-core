// DES Expansion (E): pure wiring, 32 -> 48
module des_expand (
    input  [31:0] din,
    output [47:0] dout
);
    localparam [383:0] T = {
        8'd32, 8'd1,  8'd2,  8'd3,  8'd4,  8'd5,
        8'd4,  8'd5,  8'd6,  8'd7,  8'd8,  8'd9,
        8'd8,  8'd9,  8'd10, 8'd11, 8'd12, 8'd13,
        8'd12, 8'd13, 8'd14, 8'd15, 8'd16, 8'd17,
        8'd16, 8'd17, 8'd18, 8'd19, 8'd20, 8'd21,
        8'd20, 8'd21, 8'd22, 8'd23, 8'd24, 8'd25,
        8'd24, 8'd25, 8'd26, 8'd27, 8'd28, 8'd29,
        8'd28, 8'd29, 8'd30, 8'd31, 8'd32, 8'd1
    };

    genvar k;
    generate
        for (k = 1; k <= 48; k = k + 1) begin : g_e
            assign dout[48-k] = din[32 - T[(48-k)*8 +: 8]];
        end
    endgenerate
endmodule
