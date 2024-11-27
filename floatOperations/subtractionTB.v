module tb_fp_subtractor;

// Testbench signals
reg [31:0] a, b;   // Inputs to the floating-point subtractor
wire [31:0] diff;  // Output from the floating-point subtractor

// Instantiate the floating-point subtractor
fp_subtractor uut (
    .a(a),
    .b(b),
    .diff(diff)
);

// Function to display floating-point numbers in a readable format (as real numbers)
real real_a, real_b, real_diff;
task print_result;
    begin
        real_a = $bitstoshortreal(a);
        real_b = $bitstoshortreal(b);
        real_diff = $bitstoshortreal(diff);
        $display("Time: %0t | a: %h (%f) | b: %h (%f) | diff: %h (%f)", 
                 $time, a, real_a, b, real_b, diff, real_diff);
    end
endtask

// Initialize test cases
initial begin
    // Display header
    $display("Floating-Point Subtractor Test");
    $display("---------------------------------------------------");

    // Test Case 1: Subtract two positive numbers
    a = 32'h40400000;  // 3.0 in IEEE 754
    b = 32'h3E400000;  // 0.1875 in IEEE 754
    #10;               // Wait for 10 time units
    print_result;

    // Test Case 2: Subtract a positive and a negative number
    a = 32'h40400000;  // 3.0 in IEEE 754
    b = 32'hc0000000;  // -2.0 in IEEE 754
    #10;
    print_result;

    // Test Case 3: Subtract two negative numbers
    a = 32'hc0400000;  // -3.0 in IEEE 754
    b = 32'h3E400000;  // 0.1875 in IEEE 754
    #10;
    print_result;

    // Test Case 4: Subtract a positive number and zero
    a = 32'h3f800000;  // 1.0 in IEEE 754
    b = 32'h00000000;  // 0.0 in IEEE 754
    #10;
    print_result;

    // Test Case 5: Subtract 7.875 - 0.1875
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
