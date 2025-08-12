asw -L cbios.asm
p2bin cbios.p cbios_code.bin -segment code
p2bin cbios.p cbios_data.bin -segment data
powershell ./cbios.ps1
