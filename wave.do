onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_safe_box/uut/CLK
add wave -noupdate -expand /tb_safe_box/uut/KEY
add wave -noupdate /tb_safe_box/uut/SW
add wave -noupdate -expand /tb_safe_box/uut/LEDR
add wave -noupdate /tb_safe_box/uut/HEX0
add wave -noupdate /tb_safe_box/uut/s_enter_pulse
add wave -noupdate /tb_safe_box/uut/s_attempts
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999398 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {487290 ps}
