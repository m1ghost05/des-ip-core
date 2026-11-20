`timescale 1ns/1ps
// Testbench for the 8 S-boxes (classic DES worked example, round 1).
module tb_des_sbox;
    reg  [47:0] din;
    wire [31:0] dout;
    wire [3:0]  s1_out, s8_out;
    integer errors;

    des_sboxes u_all (.din(din), .dout(dout));
    des_sbox1  u_s1  (.din(din[47:42]), .dout(s1_out));
    des_sbox8  u_s8  (.din(din[5:0]),   .dout(s8_out));

    task check(input [127:0] name, input [31:0] got, input [31:0] exp);
        begin
            if (got === exp) $display("PASS %0s = %h", name, got);
            else begin
                $display("FAIL %0s: got %h expected %h", name, got, exp);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;

        // K1 xor E(R0) = 011000 010001 011110 111010 100001 100110 010100 100111
        din = 48'h6117BA866527; #1;
        check("S-boxes", dout,   32'h5C82B597);
        check("S1 alone", s1_out, 32'h5);      // row 0, col 12
        check("S8 alone", s8_out, 32'h7);      // 100111 -> row 3, col 3

        din = 48'h000000000000; #1;
        check("zeros", dout,     32'hEFA72C4D);

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
