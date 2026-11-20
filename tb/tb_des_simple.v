`timescale 1ns/1ps
// Testbench for IP, FP, E and P using the classic DES worked example
// (key 133457799BBCDFF1, plaintext 0123456789ABCDEF).
module tb_des_simple;
    reg  [63:0] ip_in;
    wire [63:0] ip_out, fp_out;
    reg  [31:0] e_in, p_in;
    wire [47:0] e_out;
    wire [31:0] p_out;
    integer errors;

    des_ip     u_ip (.din(ip_in),  .dout(ip_out));
    des_fp     u_fp (.din(ip_out), .dout(fp_out));   // FP(IP(x)) must equal x
    des_expand u_e  (.din(e_in),   .dout(e_out));
    des_pbox   u_p  (.din(p_in),   .dout(p_out));

    task check64(input [255:0] name, input [63:0] got, input [63:0] exp);
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

        ip_in = 64'h0123456789ABCDEF; #1;
        check64("IP",       ip_out,       64'hCC00CCFFF0AAF0AA);
        check64("FP(IP)",   fp_out,       64'h0123456789ABCDEF);

        ip_in = 64'hFEDCBA9876543210; #1;
        check64("FP(IP) 2", fp_out,       64'hFEDCBA9876543210);

        e_in = 32'hF0AAF0AA; #1;
        check64("E(R0)",    {16'h0, e_out}, 64'h00007A15557A1555);

        p_in = 32'h5C82B597; #1;
        check64("P",        {32'h0, p_out}, 64'h00000000234AA9BB);

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
