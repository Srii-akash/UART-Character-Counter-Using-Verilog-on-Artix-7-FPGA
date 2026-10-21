`timescale 1ns / 1ps

module uart #(
    parameter integer CLOCK_HZ = 100_000_000,
    parameter integer BAUD_RATE = 115200,
    parameter integer DISPLAY_SECONDS = 5,
    parameter integer BLINK_HZ = 2
)(
    input  wire        clk100,
    input  wire        usb_uart_rxd,
    output wire [15:0] LED
);

    wire [7:0] rx_data;
    wire       rx_valid;

    reg [4:0] char_count;
    reg [4:0] display_count;

    reg display_active;
    reg [31:0] display_timer;
    reg [31:0] blink_timer;
    reg blink_state;

    localparam integer DISPLAY_CYCLES =
        CLOCK_HZ * DISPLAY_SECONDS;

    localparam integer BLINK_HALF_CYCLES =
        CLOCK_HZ / (2 * BLINK_HZ);

    uart_rx #(
        .CLOCK_HZ(CLOCK_HZ),
        .BAUD_RATE(BAUD_RATE)
    ) receiver (
        .clk(clk100),
        .rx(usb_uart_rxd),
        .data_out(rx_data),
        .data_valid(rx_valid)
    );

    initial begin
        char_count    = 0;
        display_count = 0;
        display_active = 0;
        display_timer = 0;
        blink_timer   = 0;
        blink_state   = 0;
    end

    always @(posedge clk100) begin

        if (display_active) begin

            if (display_timer >= DISPLAY_CYCLES - 1) begin
                display_active <= 0;
                display_timer  <= 0;
                blink_timer    <= 0;
                blink_state    <= 0;
                display_count  <= 0;
            end
            else begin
                display_timer <= display_timer + 1;

                if (blink_timer >= BLINK_HALF_CYCLES - 1) begin
                    blink_timer <= 0;
                    blink_state <= ~blink_state;
                end
                else begin
                    blink_timer <= blink_timer + 1;
                end
            end

        end
        else begin

            if (rx_valid) begin

                // Enter key ends the character-counting session.
                if ((rx_data == 8'h0D) || (rx_data == 8'h0A)) begin

                    if (char_count != 0) begin
                        display_count  <= char_count;
                        display_active <= 1;
                        display_timer  <= 0;
                        blink_timer    <= 0;
                        blink_state    <= 0;
                    end

                    char_count <= 0;
                end

                // Count printable ASCII characters only.
                else if ((rx_data >= 8'h20) &&
                         (rx_data <= 8'h7E)) begin

                    // Saturate at 16; 16 means 16 or more.
                    if (char_count < 16)
                        char_count <= char_count + 1'b1;
                end

            end
        end
    end

    // Count N: blink LEDs LED[0] through LED[N-1].
    // Count 16: all LEDs blink.
    assign LED = (display_active && blink_state)
               ? ((display_count >= 16)
                    ? 16'hFFFF
                    : ((16'h0001 << display_count) - 1'b1))
               : 16'h0000;

endmodule


module uart_rx #(
    parameter integer CLOCK_HZ = 100_000_000,
    parameter integer BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rx,
    output reg [7:0]  data_out,
    output reg        data_valid
);

    localparam integer CLKS_PER_BIT = CLOCK_HZ / BAUD_RATE;
    localparam integer HALF_BIT     = CLKS_PER_BIT / 2;

    localparam [1:0] IDLE  = 2'd0;
    localparam [1:0] START = 2'd1;
    localparam [1:0] DATA  = 2'd2;
    localparam [1:0] STOP  = 2'd3;

    reg rx_meta;
    reg rx_sync;

    reg [1:0] state;
    reg [31:0] clock_count;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    initial begin
        rx_meta     = 1'b1;
        rx_sync     = 1'b1;
        state       = IDLE;
        clock_count = 0;
        bit_index   = 0;
        shift_reg   = 0;
        data_out    = 0;
        data_valid  = 0;
    end

    // Synchronize asynchronous UART input.
    always @(posedge clk) begin
        rx_meta <= rx;
        rx_sync <= rx_meta;
    end

    always @(posedge clk) begin

        data_valid <= 1'b0;

        case (state)

            IDLE: begin
                clock_count <= 0;
                bit_index   <= 0;

                if (rx_sync == 1'b0)
                    state <= START;
            end

            START: begin
                if (clock_count >= HALF_BIT - 1) begin
                    clock_count <= 0;

                    if (rx_sync == 1'b0)
                        state <= DATA;
                    else
                        state <= IDLE;
                end
                else begin
                    clock_count <= clock_count + 1;
                end
            end

            DATA: begin
                if (clock_count >= CLKS_PER_BIT - 1) begin
                    clock_count <= 0;
                    shift_reg[bit_index] <= rx_sync;

                    if (bit_index == 3'd7) begin
                        bit_index <= 0;
                        state <= STOP;
                    end
                    else begin
                        bit_index <= bit_index + 1'b1;
                    end
                end
                else begin
                    clock_count <= clock_count + 1;
                end
            end

            STOP: begin
                if (clock_count >= CLKS_PER_BIT - 1) begin
                    clock_count <= 0;
                    state <= IDLE;

                    // Valid UART stop bit must be high.
                    if (rx_sync == 1'b1) begin
                        data_out   <= shift_reg;
                        data_valid <= 1'b1;
                    end
                end
                else begin
                    clock_count <= clock_count + 1;
                end
            end

            default: begin
                state       <= IDLE;
                clock_count <= 0;
            end

        endcase
    end

endmodule