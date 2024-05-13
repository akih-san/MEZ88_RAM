asw -L unimon_8086.asm
p2bin unimon_8086.p
asw -L cbios.asm
p2bin cbios.p cbios_code.bin -segment code
p2bin cbios.p cbios_data.bin -segment data
powershell ./cbios.ps1
copy cbios.bin ..\cpm_bin\CBIOS.BIN
copy unimon_8086.bin ..\cpm_bin\UMON_CPM.BIN
copy ccp_bdos.bin ..\cpm_bin\CCP_BDOS.BIN
