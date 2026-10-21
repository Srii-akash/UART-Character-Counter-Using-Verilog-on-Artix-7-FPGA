`timescale 1ns / 1ps

module tb_uart;

    reg clk100;
    reg usb_uart_rxd;
    wire [15:0] LED;

    uart #(
        .CLOCK_HZ(1000),
        .BAUD_RATE(100),
        .DISPLAY_SECONDS(5),
        .BLINK_HZ(2)
    ) dut (
        .clk100(clk100),
        .usb_uart_rxd(usb_uart_rxd),
        .LED(LED)
    );

    // 100 MHz simulation clock.
    initial clk100 = 0;
    always #5 clk100 = ~clk100;

    // Send one 8-N-1 UART byte.
    task send_byte;
        input [7:0] value;
        integer i;
        begin
            // Start bit
            usb_uart_rxd = 1'b0;
            repeat (10) @(posedge clk100);

            // Eight data bits, LSB first
            for (i = 0; i < 8; i = i + 1) begin
                usb_uart_rxd = value[i];
                repeat (10) @(posedge clk100);
            end

            // Stop bit
            usb_uart_rxd = 1'b1;
            repeat (10) @(posedge clk100);
        end
    endtask

    initial begin
        usb_uart_rxd = 1'b1;

        repeat (10) @(posedge clk100);

        // Test 1: five printable characters.
        send_byte("a");
        send_byte("k");
        send_byte("a");
        send_byte("s");
        send_byte("h");
        send_byte(8'h0D); // Enter / carriage return

        wait (dut.display_active == 1'b1);
        #1;

        if (dut.display_count != 5)
            $display("FAIL: expected count 5, got %0d",
                     dut.display_count);
        else
            $display("PASS: five characters counted");

        // Wait for the 5-second display interval to finish.
        wait (dut.display_active == 1'b0);
        repeat (5) @(posedge clk100);

        // Test 2: sixteen printable characters.
        repeat (16)
            send_byte("X");

        send_byte(8'h0D);

        wait (dut.display_active == 1'b1);
        #1;

        if (dut.display_count != 16)
            $display("FAIL: expected overflow count 16, got %0d",
                     dut.display_count);
        else
            $display("PASS: 16-character overflow detected");

        // Allow the second display interval to finish.
        wait (dut.display_active == 1'b0);

        $display("Simulation finished.");
        $finish;
    end

endmodule