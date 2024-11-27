module fp_subtractor(
    input [31:0] a,   // First floating-point input (A)
    input [31:0] b,   // Second floating-point input (B)
    output [31:0] diff // Output (A - B)
);

wire [31:0] neg_b;   // To store -B
wire [31:0] result;  // To store the result of A + (-B)

// Flip the sign of b (negate B)
assign neg_b = {~b[31], b[30:0]}; // Invert the sign bit of B

// Instantiate the floating-point adder to perform A + (-B)
fp_adder u_fp_adder (
    .a(a),
    .b(neg_b),
    .sum(result)
);

// Assign the result to diff (output)
assign diff = result;

endmodule

module fp_adder(
    input [31:0] a,    // First floating-point number (32-bit IEEE 754)
    input [31:0] b,    // Second floating-point number (32-bit IEEE 754)
    output [31:0] sum  // Sum of the two floating-point numbers (32-bit IEEE 754)
);

// Breaking down the inputs into sign, exponent, and mantissa
wire sign_a, sign_b;
wire [7:0] exp_a, exp_b;
wire [23:0] mant_a, mant_b;

assign sign_a = a[31];
assign sign_b = b[31];
assign exp_a = a[30:23];
assign exp_b = b[30:23];
assign mant_a = {1'b1, a[22:0]};  // Add hidden bit (1 at MSB for normalized numbers)
assign mant_b = {1'b1, b[22:0]};  // Add hidden bit (1 at MSB for normalized numbers)

// Intermediate signals
wire [7:0] exp_diff;
wire [23:0] shifted_mant_a, shifted_mant_b;
wire [24:0] mant_sum;
reg [23:0] mantissa_result;
reg [7:0] exp_result;
reg sign_result;
reg [31:0] final_sum;

// Align the exponents
assign exp_diff = (exp_a > exp_b) ? (exp_a - exp_b) : (exp_b - exp_a);

assign shifted_mant_a = (exp_a > exp_b) ? mant_a : (mant_a >> exp_diff);
assign shifted_mant_b = (exp_b > exp_a) ? mant_b : (mant_b >> exp_diff);

// Add or subtract the mantissas based on the signs
assign mant_sum = (sign_a == sign_b) ? (shifted_mant_a + shifted_mant_b) : (shifted_mant_a - shifted_mant_b);

always @(*) begin
    if (mant_sum[24]) begin
        // Normalize the result (if overflow)
        mantissa_result = mant_sum[24:1];
        exp_result = ((exp_a > exp_b) ? exp_a : exp_b) + 1;
    end else begin
        mantissa_result = mant_sum[23:0];
        exp_result = (exp_a > exp_b) ? exp_a : exp_b;
    end
    
    // Determine the sign of the result
    sign_result = (mant_sum == 0) ? 1'b0 : ((shifted_mant_a > shifted_mant_b) ? sign_a : sign_b);
    
    // Construct the final result (handle zero exponent case)
    if (mantissa_result == 0) begin
        final_sum = 32'b0;  // Result is zero
    end else begin
        final_sum = {sign_result, exp_result, mantissa_result[22:0]};
    end
end

// Output the final sum
assign sum = final_sum;

endmodule
