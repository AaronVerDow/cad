; Communication and general
M111 S0                                 ; Debug off
M550 PDuetTest                  ; Machine name and Netbios name (can be anything you like)
M551 Preprap                            ; Machine password (used for FTP)

;*** Networking
M587 S"RedWagon" P"nope"
M552 S1                     ; Turn network on

M555 P2                     ; Set output to look like Marlin
G21                     ; Work in millimetres
G90                     ; Send absolute coordinates...
M83                     ; ...but relative extruder moves

; No bed heater
M140 H-1

; Axis and motor configuration
M569 P0 S0                  ; Drive 0 goes forwards
M569 P1 S1                  ; Drive 1 goes forwards
M569 P2 S0                  ; Drive 2 goes forwards
M569 P3 S0                  ; Drive 3 goes forwards
M558 P4 I1                  ; use E0 endstop as Z probe
M574 X1 S2                  ; bind X homing switch to Z probe
M574 Z1 S2
M574 Y0                     ; radius homing switch present, no turntable homing switch
M669 K7 R0:100 H0.3 F30 A30             ; set Polar kinematics parameters
M350 X16 Y16 Z16 E16:16 I1          ; Set 16x microstepping with interpolation
M92 X80 Y42 Z3200               ; Set axis steps/mm
M906 X1000 Y1000 Z1000 E800 I60         ; Set motor currents (mA) and increase idle current to 60%
M201 X1000 Y1000 Z100 E1000         ; Accelerations (mm/s^2)
M203 X6000 Y6000 Z100 E3600             ; maximum linear speeds mm/minute
M566 X1200 Y1200 Z1200 E1200            ; Maximum instant speed changes mm/minute

; Endstop offset
G31 Z0.965

; Thermistors
M305 P1 T100000 B3974 R4700 H30 L0      ; Put your own H and/or L values here to set first nozzle thermistor ADC correction

M570 S180                   ; Hot end may be a little slow to heat up so allow it 180 seconds

; Fans
M106 P0 T45 H1


; Tool definitions
M563 P0 D0 H1                   ; Define tool 0
G10 P0 S0 R0                    ; Set tool 0 operating and standby temperatures
M92 E100:100                    ; Set extruder steps per mm

;*** If you are using axis compensation, put the figures in the following command
M556 S78 X0 Y0 Z0               ; Axis compensation here

M208 Z-0.2:200                  ; set axis travel limits

; PID Tuning
M307 H1 A278.6 C149.8 D8.3 S1.00 V11.5 B0

T0                      ; select first hot end
