module digital_clock(
    input wire clk,             // 100MHz system clock from FPGA
    input wire reset,           // Reset button
    output reg [7:0] an,        // Anode signals for 8 displays
    output reg [6:0] seg        // 7-segment display signals
);

    // Parameters
    parameter CLK_FREQ = 100000000; // 100MHz clock
    
    // Internal signals
    reg [26:0] counter;         // Counter for generating 1Hz clock
    reg clk_1hz;                // 1Hz clock for seconds
    
    // Time registers
    reg [5:0] seconds;          // 0-59
    reg [5:0] minutes;          // 0-59
    reg [4:0] hours;            // 0-23
    
    // Display refresh signals
    reg [2:0] digit_select;     // For selecting which digit to display
    reg [19:0] refresh_counter; // Counter for display refresh
    
    // BCD values for display
    reg [3:0] digit_value;      // Current digit value to display
    
    // Initialize values
    initial begin
        counter = 0;
        clk_1hz = 0;
        seconds = 0;
        minutes = 0;
        hours = 0;
        digit_select = 0;
        refresh_counter = 0;
        an = 8'b11111111;
        seg = 7'b1111111;
    end
    
    // 1Hz clock generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_1hz <= 0;
        end else begin
            if (counter == CLK_FREQ/2 - 1) begin
                counter <= 0;
                clk_1hz <= ~clk_1hz;
            end else begin
                counter <= counter + 1;
            end
        end
    end
    
    // Time counting logic
    always @(posedge clk_1hz or posedge reset) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
        end else begin
            seconds <= seconds + 1;
            
            if (seconds == 59) begin
                seconds <= 0;
                minutes <= minutes + 1;
                
                if (minutes == 59) begin
                    minutes <= 0;
                    hours <= hours + 1;
                    
                    if (hours == 23) begin
                        hours <= 0;
                    end
                end
            end
        end
    end
    
    // Display refresh counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
    
    // Digit select from refresh counter
    always @(*) begin
        digit_select = refresh_counter[19:17]; // Use upper bits for slower refresh
    end
    
    // Digit multiplexing
    always @(*) begin
        // Default values
        digit_value = 4'b0000;
        an = 8'b11111111; // All displays off
        
        case(digit_select)
            3'b000: begin // Rightmost digit - seconds ones place
                digit_value = seconds % 10;
                an = 8'b11111110;
            end
            3'b001: begin // Seconds tens place
                digit_value = seconds / 10;
                an = 8'b11111101;
            end
            3'b010: begin // Minutes ones place
                digit_value = minutes % 10;
                an = 8'b11111011;
            end
            3'b011: begin // Minutes tens place
                digit_value = minutes / 10;
                an = 8'b11110111;
            end
            3'b100: begin // Hours ones place
                digit_value = hours % 10;
                an = 8'b11101111;
            end
            3'b101: begin // Hours tens place
                digit_value = hours / 10;
                an = 8'b11011111;
            end
            default: begin
                digit_value = 0;
                an = 8'b11111111;
            end
        endcase
    end
    
    // 7-segment decoder
    always @(*) begin
        case(digit_value)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // All segments off
        endcase
    end
    
endmodule
