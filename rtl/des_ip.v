// DES Initial Permutation (IP): pure wiring, 64 -> 64
// Bit numbering follows FIPS 46-3: bit 1 is the MSB (din[63]).
module des_ip (
    input  [63:0] din,
    output [63:0] dout
);
    localparam [511:0] T = {
        8'd58, 8'd50, 8'd42, 8'd34, 8'd26, 8'd18, 8'd10, 8'd2,
        8'd60, 8'd52, 8'd44, 8'd36, 8'd28, 8'd20, 8'd12, 8'd4,
        8'd62, 8'd54, 8'd46, 8'd38, 8'd30, 8'd22, 8'd14, 8'd6,
        8'd64, 8'd56, 8'd48, 8'd40, 8'd32, 8'd24, 8'd16, 8'd8,
        8'd57, 8'd49, 8'd41, 8'd33, 8'd25, 8'd17, 8'd9,  8'd1,
        8'd59, 8'd51, 8'd43, 8'd35, 8'd27, 8'd19, 8'd11, 8'd3,
        8'd61, 8'd53, 8'd45, 8'd37, 8'd29, 8'd21, 8'd13, 8'd5,
        8'd63, 8'd55, 8'd47, 8'd39, 8'd31, 8'd23, 8'd15, 8'd7
    };

    genvar k;
    generate
        for (k = 1; k <= 64; k = k + 1) begin : g_ip
            assign dout[64-k] = din[64 - T[(64-k)*8 +: 8]];
        end
    endgenerate
endmodule
