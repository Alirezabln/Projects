module tb_fp_multiplier;

// Testbench signals
reg [31:0] a, b;         // Inputs to the multiplier
wire [31:0] product;     // Output from the multiplier

// Instantiate the floating-point multiplier
fp_multiplier uut (
    .a(a),
    .b(b),
    .product(product)
);

// Function to display floating-point numbers in a readable format (as real numbers)
real real_a, real_b, real_product;
task print_result;
    begin
        real_a = $bitstoshortreal(a);
        real_b = $bitstoshortreal(b);
        real_product = $bitstoshortreal(product);
        $display("Time: %0t | a: %h (%f) | b: %h (%f) | product: %h (%f)", 
                 $time, a, real_a, b, real_b, product, real_product);
    end
endtask

// Initialize test cases
initial begin
    // Display header
    $display("Floating-Point Multiplier Test");
    $display("---------------------------------------------------");

    // Test Case 1: Multiply two positive numbers
    a = 32'h40000000;  // 2.0 in IEEE 754
    b = 32'h3F800000;  // 1.0 in IEEE 754
    #10;
    print_result;

    // Test Case 2: Multiply a positive and a negative number
    a = 32'h40400000;  // 3.0 in IEEE 754
    b = 32'hC0000000;  // -2.0 in IEEE 754
    #10;
    print_result;

    // Test Case 3: Multiply two negative numbers
    a = 32'hC0400000;  // -3.0 in IEEE 754
    b = 32'hC0000000;  // -2.0 in IEEE 754
    #10;
    print_result;

    // Test Case 4: Multiply a number and zero
    a = 32'h3F800000;  // 1.0 in IEEE 754
    b = 32'h00000000;  // 0.0 in IEEE 754
    #10;
    print_result;

    // Test Case 5: Multiply 7.875 * 0.1875
    a = 32'h40FC0000;  // 7.875 in IEEE 754
    b = 32'h3E400000;  // 0.1875 in IEEE 754
    #10;
    print_result;
	#10
	
    // End of tests
    $display("Test completed.");
    $finish;
end

endmodule
