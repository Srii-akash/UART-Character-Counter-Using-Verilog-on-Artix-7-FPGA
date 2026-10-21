UART Character Counter Using Verilog on Artix-7 FPGA

A UART-based character counter implemented in Verilog HDL for the **Helix Artix-7 FPGA development board (XC7A35FTG256-1)**. The design receives serial characters through the onboard USB-UART interface and displays the character count using 16 LEDs.

**Features**

- UART serial reception using 115200 baud, 8-N-1 configuration
- Printable ASCII character counting
- Enter key terminates a counting session
- LED output represents the received character count
- Counts of 16 or more activate all 16 LEDs
- LED blinking at a target frequency of 2 Hz
- Five-second display interval
- Verilog testbench for simulation

**Hardware and Tools**

- FPGA board: Helix Artix-7, XC7A35FTG256-1
- FPGA clock: 100 MHz
- HDL: Verilog
- FPGA design and simulation: AMD Xilinx Vivado
- Serial terminal: Tera Term or another serial terminal application
- Input interface: Onboard USB-UART

**Repository Structure**

```text
uart-character-counter/
├── uart.v
├── tb_uart.v
├── uart.xdc
├── README.md
└── .gitignore
```

**Pin Assignments**

| Signal | FPGA pin | Purpose |
|---|---|---|
| `clk100` | P10 | 100 MHz clock |
| `usb_uart_rxd` | R12 | UART receive input |
| `LED[0]` | F5 | LED output 0 |
| `LED[1]` | G4 | LED output 1 |
| `LED[2]` | H3 | LED output 2 |
| `LED[3]` | J5 | LED output 3 |
| `LED[4]` | J4 | LED output 4 |
| `LED[5]` | K5 | LED output 5 |
| `LED[6]` | N3 | LED output 6 |
| `LED[7]` | N4 | LED output 7 |
| `LED[8]` | D14 | LED output 8 |
| `LED[9]` | D13 | LED output 9 |
| `LED[10]` | F14 | LED output 10 |
| `LED[11]` | G12 | LED output 11 |
| `LED[12]` | H14 | LED output 12 |
| `LED[13]` | H11 | LED output 13 |
| `LED[14]` | K12 | LED output 14 |
| `LED[15]` | M12 | LED output 15 |

The pin assignments are based on the board's Master XDC file.

**How It Works**

1. Characters are entered in a serial terminal on the computer.
2. The onboard USB-UART interface sends the serial data to the FPGA.
3. The UART receiver reconstructs each 8-bit character.
4. The character counter counts printable ASCII characters until Enter is received.
5. The count is displayed as a pattern of blinking LEDs.
6. The LEDs turn off after the five-second display interval.

**Expected Behavior**

| Input | Expected LED behavior |
|---|---|
| `A` + Enter | LED 0 blinks |
| `AKASH` + Enter | LEDs 0–4 blink |
| 10 printable characters + Enter | LEDs 0–9 blink |
| 16 or more printable characters + Enter | All 16 LEDs blink |

The intended blink frequency is 2 Hz, with a five-second display interval.

**UART Configuration**

Configure the serial terminal with:

- Baud rate: 115200
- Data bits: 8
- Parity: None
- Stop bits: 1
- Flow control: None

Connect the FPGA board to the computer using the onboard USB-UART connection and select the corresponding COM port.

**Simulation**

1. Open the project in AMD Xilinx Vivado.
2. Add `uart.v` as a design source.
3. Add `tb_uart.v` as a simulation source.
4. Set `uart` as the synthesis top module.
5. Set `tb_uart` as the simulation top module when running behavioral simulation.
6. Run behavioral simulation and inspect the simulator console and waveforms.

The testbench contains a five-character test and a 16-character test. Confirm the simulation results before treating the design as hardware-verified.

**Future Improvements**

- Add a UART transmitter for serial status messages.
- Display the character count on a seven-segment display.
- Add a reset input and explicit error handling.
- Improve UART frame timing and expand automated verification.

**Disclaimer**

This project is intended for learning and experimentation. Verify the design in simulation and on the target FPGA board before relying on its behavior.
