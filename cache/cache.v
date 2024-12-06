module cache (
    input [5:0] addr,          // 6-bit address
    input clk,                 // Clock for read/write operations
    input reset,               // Reset signal
    output reg [31:0] rd,      // 32-bit read data
    output reg [31:0] misses,  // Output the number of cache misses
    output reg [31:0] total_reads // Output the total number of instruction reads
);
    // Cache definition: 2 sets, each holding 2 words (64 bits)
    reg [63:0] cache_data [1:0];    // Data storage for each cache set (64 bits per set)
    reg [3:0] cache_tag [1:0];      // Tag storage for each cache set (4 bits per set)
    reg cache_valid [1:0];          // Valid bits for each cache set

    // Control wires derived from the address
    wire [3:0] tag = addr[5:2];     // Upper 4 bits as the tag
    wire index = addr[1];           // 1-bit index for 2 sets
    wire offset = addr[0];          // 1-bit offset for selecting word in the cache line

    // Instruction memory instantiation
    wire [31:0] imem_rd1, imem_rd2;
    imem imem_inst1 (.a({tag, index, 1'b0}), .rd(imem_rd1)); // Read first word from instruction memory
    imem imem_inst2 (.a({tag, index, 1'b1}), .rd(imem_rd2)); // Read second word from instruction memory

    // Cache miss and read counters
    reg [31:0] miss_counter;         // Counter for cache misses
    reg [31:0] read_counter;         // Counter for total instruction reads

    // Combinational logic for cache access and data selection
    always @(*) begin
        // Default output (for cache hit scenario or miss fallback)
        rd = 32'b0;

        // Always increment the total reads counter
        read_counter = read_counter + 1;

        if (cache_valid[index] && cache_tag[index] == tag) begin
            // Cache hit: Read the appropriate word from the cache
            if (offset)
                rd = cache_data[index][63:32];  // Upper word from cache
            else
                rd = cache_data[index][31:0];   // Lower word from cache
        end else begin
            // Cache miss: Fetch data from instruction memory
            miss_counter = miss_counter + 1;  // Increment the miss counter

            cache_valid[index] = 1'b1;
            cache_tag[index] = tag;
            cache_data[index][31:0] = imem_rd1;    // Store first word in cache
            cache_data[index][63:32] = imem_rd2;   // Store second word in cache

            // Provide the requested word from memory (before it's cached)
            if (offset)
                rd = imem_rd2;  // Upper word from instruction memory
            else
                rd = imem_rd1;  // Lower word from instruction memory
        end
    end

    // Cache update logic (handled synchronously)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all cache state
            cache_valid[0] <= 1'b0;
            cache_valid[1] <= 1'b0;
            cache_tag[0] <= 4'b0;
            cache_tag[1] <= 4'b0;
            cache_data[0] <= 64'b0;
            cache_data[1] <= 64'b0;
            
            // Reset counters
            miss_counter <= 32'b0;
            read_counter <= 32'b0;
        end else begin
            if (cache_valid[index] && cache_tag[index] == tag) begin
                // Cache hit: No need to update anything, just provide data via combinational logic
            end else begin
                // Cache miss: Update the cache with new data
                cache_valid[index] <= 1'b1;
                cache_tag[index] <= tag;
                cache_data[index][31:0] <= imem_rd1;    // Store first word in cache
                cache_data[index][63:32] <= imem_rd2;   // Store second word in cache
            end
        end
    end

    // Output the counters for misses and total reads
    always @(*) begin
        misses = miss_counter;
        total_reads = read_counter;
    end

endmodule
