### README.md

# Garage Parking System

This repository contains a VHDL implementation of a **Garage Parking System**. The system is designed to manage entry and exit of vehicles using servo motors, IR sensors, and a 7-segment display for occupancy display. 

## Features
- **Servo Motor Control**: Handles gate operation for entry and exit using pulse-width modulation (PWM).
- **IR Sensors**: Detects the presence of vehicles at the entry and exit gates with debounce logic for stable signal detection.
- **Digital Counter**: Tracks the number of vehicles in the garage.
- **7-Segment Display**: Displays the current occupancy of the garage, ranging from 0 to 15.

---

## Components

### Input Ports
- **clk**: System clock signal.
- **entry_button**: Push button to manually open the entry gate.
- **exit_button**: Push button to manually open the exit gate.
- **entry_IR**: Infrared sensor to detect vehicle presence at the entry gate.
- **exit_IR**: Infrared sensor to detect vehicle presence at the exit gate.
- **gate_decider**: Control signal to switch between manual and Arduino-controlled gate operation.
- **entry_arduino**: Signal from Arduino for controlling entry gate.
- **exit_arduino**: Signal from Arduino for controlling exit gate.

### Output Ports
- **entry_servo**: Controls the servo motor for the entry gate.
- **exit_servo**: Controls the servo motor for the exit gate.
- **segment_display**: 7-segment display output to show the number of vehicles in the garage.

### Internal Signals
1. **PWM Signals**:
   - `PULSE_WIDTH_1` and `PULSE_WIDTH_2`: Adjusts the pulse width for entry and exit servos.
   - `PWM_COUNTER_1` and `PWM_COUNTER_2`: Tracks the PWM signal duration.
2. **Debounce Signals**:
   - `stable_entry_IR` and `stable_exit_IR`: Stable signals for entry and exit IR sensors.
   - `debounce_entry_counter` and `debounce_exit_counter`: Counters for signal debouncing.
3. **Counters**:
   - `COUNTER`: Tracks the current vehicle count in the garage.
   - `entry_counter` and `exit_counter`: Tracks the number of vehicles entering and exiting.
4. **Helper Signals**:
   - `entry_button_helper` and `exit_button_helper`: Stores the state of entry and exit buttons for toggling functionality.

---

## How It Works
1. **Gate Operation**:
   - Servo motor positions are controlled based on button presses or Arduino signals.
   - PWM signals adjust servo angles for opening and closing gates.
   
2. **IR Sensor Stabilization**:
   - Debounce logic ensures stable IR sensor readings to prevent false triggers.
   
3. **Vehicle Counting**:
   - Vehicle entry and exit increment respective counters.
   - Net count is calculated by subtracting `exit_counter` from `entry_counter`.

4. **Display Logic**:
   - The current count of vehicles is displayed on a 7-segment display.
   - Supports values from 0 to 15.

---

## Files
- `Garage.vhd`: Contains the VHDL implementation of the garage system.

---

## How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/garage-parking-system.git
   ```
2. Synthesize the design using any VHDL-compatible tool (e.g., Xilinx Vivado, Quartus).
3. Connect hardware components as per the input/output specifications.
4. Program the FPGA and test the system functionality.

---

## Future Enhancements
- Integration with IoT for remote monitoring.
- Support for advanced occupancy management with real-time alerts.
- Adding a display for showing remaining spaces dynamically.

