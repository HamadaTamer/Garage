LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Garage IS
  PORT(
    clk, entry_button, exit_button, entry_IR, exit_IR: IN STD_LOGIC;
	 gate_decider, entry_arduino, exit_arduino: IN STD_LOGIC;
    entry_servo, exit_servo: OUT STD_LOGIC;
    segment_display : OUT STD_LOGIC_VECTOR(0 TO 6)
  );
END Garage;

ARCHITECTURE Garage_Behaviour OF Garage IS

  SIGNAL COUNTER: INTEGER RANGE 0 TO 15 := 0;
  SIGNAL entry_counter, exit_counter: INTEGER RANGE 0 TO 1000 := 0;

  -- stuff for PWM 
  CONSTANT COUNT_1_MS : INTEGER := 50000;     -- 0 degrees
  CONSTANT COUNT_2_MS : INTEGER := 100000;    -- 90 degrees
  CONSTANT PWM_PERIOD : INTEGER := 1000000;   -- frequency 
  SIGNAL PWM_COUNTER_1  : INTEGER RANGE 0 TO PWM_PERIOD - 1 := 0;
  SIGNAL PULSE_WIDTH_1  : INTEGER := COUNT_1_MS;  
  SIGNAL PWM_COUNTER_2  : INTEGER RANGE 0 TO PWM_PERIOD - 1 := 0;
  SIGNAL PULSE_WIDTH_2  : INTEGER := COUNT_1_MS;
  
  -- entry and exit detection with debouncing
  SIGNAL stable_entry_IR: STD_LOGIC := '0';
  SIGNAL stable_exit_IR: STD_LOGIC := '0';
  SIGNAL debounce_entry_counter: INTEGER RANGE 0 TO 10000 := 0;
  SIGNAL debounce_exit_counter: INTEGER RANGE 0 TO 10000 := 0;
  SIGNAL entry_button_helper : STD_LOGIC := '0';
  SIGNAL exit_button_helper : STD_LOGIC := '0';
  
  

BEGIN	

PROCESS(entry_button)
	BEGIN
		IF entry_button = '1' THEN
			entry_button_helper <= NOT entry_button_helper;
		END IF;
	END PROCESS;

PROCESS(exit_button)
	BEGIN
		IF exit_button = '1' THEN
			exit_button_helper <= NOT exit_button_helper;
		END IF;
	END PROCESS;
		
	
PROCESS(clk)
BEGIN
    IF rising_edge(clk) THEN
        -- Check if inner_IR is stable
		IF entry_IR = stable_entry_IR THEN
            debounce_entry_counter <= 0; -- Reset COUNTER if stable
			ELSE
            debounce_entry_counter <= debounce_entry_counter + 1;
            
            IF debounce_entry_counter = 10000 THEN -- Stability threshold
                stable_entry_IR <= entry_IR; -- Update stable SIGNAL
                debounce_entry_counter <= 0;
            END IF;
				
	   END IF;
			
		IF (exit_IR = stable_exit_IR) THEN
            debounce_exit_counter <= 0; -- Reset COUNTER if stable
		ELSE
            debounce_exit_counter <= debounce_exit_counter + 1;
            
            IF debounce_exit_counter = 10000 THEN -- Stability threshold
                stable_exit_IR <= exit_IR; -- Update stable SIGNAL
                debounce_exit_counter <= 0;
            END IF;
		END IF;
		 
		IF (entry_button_helper= '0' AND gate_decider = '0') OR (gate_decider = '1' AND entry_arduino = '0') THEN
			PULSE_WIDTH_1 <= COUNT_1_MS; 
		ELSIF (entry_button_helper= '1' AND gate_decider = '0') OR (gate_decider = '1' AND entry_arduino = '1') THEN 
			PULSE_WIDTH_1 <= COUNT_2_MS; 
		END IF;
	  
		IF (exit_button_helper = '0' AND gate_decider = '0') OR (gate_decider = '1' AND exit_arduino = '0') THEN
			PULSE_WIDTH_2 <= COUNT_1_MS; 
		ELSIF (exit_button_helper = '1' AND gate_decider = '0') OR (gate_decider = '1' AND exit_arduino = '1') THEN 
			PULSE_WIDTH_2 <= COUNT_2_MS; 
		END IF;


      
		IF PWM_COUNTER_1 < PWM_PERIOD - 1 THEN
			PWM_COUNTER_1 <= PWM_COUNTER_1 + 1;
		ELSE
       PWM_COUNTER_1 <= 0;
      END IF;
		
		IF PWM_COUNTER_2 < PWM_PERIOD - 1 THEN
       PWM_COUNTER_2 <= PWM_COUNTER_2 + 1;
     ELSE
       PWM_COUNTER_2 <= 0;
      END IF;

      
      IF PWM_COUNTER_1 < PULSE_WIDTH_1 THEN
      entry_servo <= '1';
     ELSE
        entry_servo <= '0';
      END IF;
		
		IF PWM_COUNTER_2 < PULSE_WIDTH_2 THEN
      exit_servo <= '1';
     ELSE
        exit_servo <= '0';
      END IF;
		  
    END IF;
END PROCESS;

-- Use stable_IR for your logic
PROCESS(stable_entry_IR)
BEGIN
    IF stable_entry_IR = '0' THEN
        entry_counter <= entry_counter + 1;
    END IF;
END PROCESS;

PROCESS(stable_exit_IR)
BEGIN
    IF stable_exit_IR = '0' THEN
        exit_counter <= exit_counter + 1;
    END IF;
END PROCESS;
	
	PROCESS(entry_counter, exit_counter)
	BEGIN
	COUNTER <= entry_counter - exit_counter;
	END PROCESS;
	
	PROCESS(COUNTER)
	BEGIN
	CASE COUNTER IS
		WHEN 0 => segment_display <= "0000001";
      WHEN 1 => segment_display <= "1001111";
      WHEN 2 => segment_display <= "0010010";
      WHEN 3 => segment_display <= "0000110";
      WHEN 4 => segment_display <= "1001100";
      WHEN 5 => segment_display <= "0100100";
      WHEN 6 => segment_display <= "0100000";
      WHEN 7 => segment_display <= "0001111";
      WHEN 8 => segment_display <= "0000000";
      WHEN 9 => segment_display <= "0000100";
		WHEN 10 => segment_display <= "0001000";
		WHEN 11 => segment_display <= "1100000";
		WHEN 12 => segment_display <= "0110001";
		WHEN 13 => segment_display <= "1000010";
		WHEN 14 => segment_display <= "0110000";
	   WHEN 15 => segment_display <= "0111000";
      WHEN OTHERS => segment_display <= "1111111";
    END CASE;	
	END PROCESS;	

END Garage_Behaviour;