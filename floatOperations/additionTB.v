module tb_fp_adder;

// Testbench signals
reg [31:0] a, b;   // Inputs to the floating point adder
wire [31:0] sum;   // Output from the floating point adder

// Instantiate the floating point adder
fp_adder uut (
    .a(a),
    .b(b),
    .sum(sum)
);

// Function to display floating-point numbers in a readable format (as real numbers)
real real_a, real_b, real_sum;
task print_result;
    begin
        real_a = $bitstoshortreal(a);
        real_b = $bitstoshortreal(b);
        real_sum = $bitstoshortreal(sum);
        $display("Time: %0t | a: %h (%f) | b: %h (%f) | sum: %h (%f)", 
                 $time, a, real_a, b, real_b, sum, real_sum);
    end
endtask

// Initialize test cases
initial begin
    // Display header
    $display("Floating-Point Adder Test");
    $display("---------------------------------------------------");

    // Test Case 1: Add two positive numbers
    a = 32'h3f800000;  // 1.0 in IEEE 754
    b = 32'h40000000;  // 2.0 in IEEE 754
    #10;               // Wait for 10 time units
    print_result;

    // Test Case 2: 
    a = 32'h40400000;  // 3.0 in IEEE 754
    b = 32'h40FC0000;  // 7.875 in IEEE 754
    #10;
    print_result;

    // Test Case 3: Add two negative numbers
    a = 32'hc0400000;  // -3.0 in IEEE 754
    b = 32'hc0000000;  // -2.0 in IEEE 754
    #10;
    print_result;

    // Test Case 4: Add a positive number and zero
    a = 32'h3f800000;  // 1.0 in IEEE 754
    b = 32'h00000000;  // 0.0 in IEEE 754
    #10;
    print_result;

    // Test Case 5: Add the two numbers in prelab
    a = 32'h40FC0000;  // 7.875 in IEEE 754
    b = 32'h3E400000;  // 0.1875 in IEEE 754
    #10;
    print_result;

    // Test Case 6: 
    a = 32'h40400000;  // 3.0 in IEEE 754
    b = 32'h3E400000;  // 0.1875 in IEEE 754
    #10;
    print_result;
	#10
    // End of tests
    $display("Test completed.");
    $finish;
end

endmodule
