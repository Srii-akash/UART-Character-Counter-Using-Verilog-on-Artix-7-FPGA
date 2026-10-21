## Helix Artix-7 FPGA - XC7A35FTG256-1

## 100 MHz onboard clock
set_property -dict { PACKAGE_PIN P10 IOSTANDARD LVCMOS33 } [get_ports { clk100 }]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk100 }]

## Onboard USB-UART receive input
set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 } [get_ports { usb_uart_rxd }]

## LEDs [0:15]
set_property -dict { PACKAGE_PIN F5  IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]
set_property -dict { PACKAGE_PIN G4  IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]
set_property -dict { PACKAGE_PIN H3  IOSTANDARD LVCMOS33 } [get_ports { LED[2] }]
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { LED[3] }]
set_property -dict { PACKAGE_PIN J4  IOSTANDARD LVCMOS33 } [get_ports { LED[4] }]
set_property -dict { PACKAGE_PIN K5  IOSTANDARD LVCMOS33 } [get_ports { LED[5] }]
set_property -dict { PACKAGE_PIN N3  IOSTANDARD LVCMOS33 } [get_ports { LED[6] }]
set_property -dict { PACKAGE_PIN N4  IOSTANDARD LVCMOS33 } [get_ports { LED[7] }]
set_property -dict { PACKAGE_PIN D14 IOSTANDARD LVCMOS33 } [get_ports { LED[8] }]
set_property -dict { PACKAGE_PIN D13 IOSTANDARD LVCMOS33 } [get_ports { LED[9] }]
set_property -dict { PACKAGE_PIN F14 IOSTANDARD LVCMOS33 } [get_ports { LED[10] }]
set_property -dict { PACKAGE_PIN G12 IOSTANDARD LVCMOS33 } [get_ports { LED[11] }]
set_property -dict { PACKAGE_PIN H14 IOSTANDARD LVCMOS33 } [get_ports { LED[12] }]
set_property -dict { PACKAGE_PIN H11 IOSTANDARD LVCMOS33 } [get_ports { LED[13] }]
set_property -dict { PACKAGE_PIN K12 IOSTANDARD LVCMOS33 } [get_ports { LED[14] }]
set_property -dict { PACKAGE_PIN M12 IOSTANDARD LVCMOS33 } [get_ports { LED[15] }]