module fp_multiplier (
    input [31:0] a,       // First floating-point input
    input [31:0] b,       // Second floating-point input
    output [31:0] product // Floating-point output (a * b)
);

    // Extract the sign, exponent, and mantissa from both inputs
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] mant_a = a[22:0];
    wire [22:0] mant_b = b[22:0];

    // XOR the sign bits to determine the sign of the product
    wire sign_result = sign_a ^ sign_b;

    // Handle special cases: zero, infinity, or NaN
    wire is_zero_a = (exp_a == 8'h00 && mant_a == 23'h0);
    wire is_zero_b = (exp_b == 8'h00 && mant_b == 23'h0);
    wire is_inf_a = (exp_a == 8'hFF && mant_a == 23'h0);
    wire is_inf_b = (exp_b == 8'hFF && mant_b == 23'h0);
    wire is_nan_a = (exp_a == 8'hFF && mant_a != 23'h0);
    wire is_nan_b = (exp_b == 8'hFF && mant_b != 23'h0);

    // If one of the inputs is NaN, the product is NaN
    wire is_nan = is_nan_a | is_nan_b;

    // If either input is zero, the product is zero (unless the other is infinity)
    wire is_zero = (is_zero_a | is_zero_b) & ~(is_inf_a | is_inf_b);

    // If one of the inputs is infinity, the product is infinity (unless the other is zero)
    wire is_inf = (is_inf_a | is_inf_b) & ~is_zero;

    // Add the exponents and subtract the bias (127 for single-precision)
    wire [8:0] exp_result = exp_a + exp_b - 8'd127;

    // Add the implicit 1 to the mantissas and multiply them
    wire [47:0] mant_result = {1'b1, mant_a} * {1'b1, mant_b};

    // Normalize the mantissa (shift right if needed) and adjust the exponent
    reg [22:0] final_mantissa;
    reg [7:0] final_exponent;
	always @(*) begin
    if (mant_result[47]) begin
        final_mantissa = mant_result[46:24];  // Already normalized
        final_exponent = exp_result + 1;      // Adjust exponent for normalization
    end else begin
        final_mantissa = mant_result[45:23];  // Normalized after shifting
        final_exponent = exp_result;
    end
	end

    // Assign the final result based on special cases
    assign product = (is_nan) ? 32'h7FC00000 :                  // NaN
                     (is_inf) ? {sign_result, 8'hFF, 23'h0} :  // Infinity
                     (is_zero) ? 32'h0 :                       // Zero
                     {sign_result, final_exponent[7:0], final_mantissa[22:0]}; // Normal result

endmodule
