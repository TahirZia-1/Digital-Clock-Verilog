`timescale 1ns / 1ps

module digital_clock_tb();
    // Inputs
    reg clk;
    reg reset;
    
    // Outputs
    wire [7:0] an;
    wire [6:0] seg;
    
    // Instantiate the Unit Under Test (UUT)
    digital_clock uut (
        .clk(clk),
        .reset(reset),
        .an(an),
        .seg(seg)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns period)
    end
    
    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        
        // Wait for global reset
        #100;
        reset = 0;
        
        // Let the clock run for a while to see time changes
        // To speed up simulation, you might want to modify the CLK_FREQ parameter
        // in the module to a smaller value for testing
        #1000000000; // Run for 1 second of simulation time
        
        $finish;
    end
    
    // Monitor changes for debugging
    initial begin
        $monitor("Time: %0t, Hours: %0d, Minutes: %0d, Seconds: %0d, AN: %b, SEG: %b",
                 $time, uut.hours, uut.minutes, uut.seconds, an, seg);
    end
    
endmodule
