/*
 * CP/M-86 and MS-DOS for EMU57Q-8088/V20_RAM
 * This firmware is only for PICF57Q43.
 * This firmware can run CPM-86 or MS-DOS on CPU i8088/V20.
 *
 * Based on main.c by Tetsuya Suzuki 
 * and emuz80_z80ram.c by Satoshi Okue
 * PIC18F47Q43/PIC18F47Q83/PIC18F47Q84 ROM image uploader
 * and UART emulation firmware.
 * This single source file contains all code.
 *
 * Base source code of this firmware is maked by
 * @hanyazou (https://twitter.com/hanyazou) *
 *
 *  Target: EMU57Q-8088/V20_RAM 1MB Rev2.1
 *  Written by Akihito Honda (Aki.h @akih_san)
 *  https://twitter.com/akih_san
 *  https://github.com/akih-san
 *
 *  Date. 2024.4.20
 */

#define INCLUDE_PIC_PRAGMA
#include "../src/mez88_47q.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../drivers/utils.h"

static FATFS fs;
static DIR fsdir;
static FILINFO fileinfo;
static FIL files[NUM_FILES];
static FIL rom_fl;

uint8_t tmp_buf[2][TMP_BUF_SIZE];
#define BUF_SIZE TMP_BUF_SIZE * 2

static int os_flg;
debug_t debug = {
    0,  // disk
    0,  // disk_read
    0,  // disk_write
    0,  // disk_verbose
    0,  // disk_mask
};

static char *cpmdir	= "CPMDISKS";
static char *msdosdir	= "DOSDISKS";

static int disk_init(void);
static int chk_os(void);
static void setup_cpm(void);
static void setup_msdos(void);
static int open_dskimg(void);
static int load_program(const TCHAR *buf, uint32_t load_adr, uint16_t *load_size);

static char *board_name = "MEZ88/V20_RAM Rev1.2 on EMUZ80";

// main routine
void main(void)
{
	sys_init();
	devio_init();
	setup_uart5();
	setup_sd();

	printf("Board: %s\n\r", board_name);

    mem_init();
    if (disk_init() < 0) while (1);

	GIE = 1;             // Global interrupt enable

	// Check OS
	os_flg = chk_os();		//1: CPM,  2:MSDOS, -1:error
	printf("\n\r");

	// open disk drive
	if ( open_dskimg() < 0 ) {
        printf("No boot disk.\n\r");
		while(1);
	}
	printf("\n\r");

	switch( os_flg ) {
		case CPM:
			setup_cpm();
			break;
		case MSDOS:
			setup_msdos();
			break;
		default:
			printf("No OS directory.\n\r");
			while (1);
	}

	printf("\n\r");

	//
    // Start i8088
    //
    printf("Use PWM1  %.2fMHz(Duty %.1f%%) for 8088 clock\n\r", 
    			1/((PWM1PR+1)*P64)*1000, (double)(PWM1S1P1*100/(PWM1PR+1)));
    printf("\n\r");
	
    start_i88();
	board_event_loop();
}

static void setup_msdos(void) {

	const TCHAR	buf[30];
	int flg;
	uint16_t size, sec_size, ld_adr;

	// set dos operation 
	bus_master_operation = dos_bus_master_operation;

	dosio_init();
	setup_clk_aux();
	printf("\n\r");

	sec_size = dos_sec_size();
	sprintf((char *)buf, "%s/UMON_DOS.BIN", fileinfo.fname);
	flg = load_program(buf, UNIMON_OFF, &size);
	if (!flg) {
		sprintf((char *)buf, "%s/IO.SYS", fileinfo.fname);
		flg = load_program(buf, IOSYS_OFF, &size);
		if (!flg) {
			ld_adr = (((size+sec_size) / sec_size)+1)*sec_size+IOSYS_OFF;
			sprintf((char *)buf, "%s/MSDOS.SYS", fileinfo.fname);
			flg = load_program(buf, (uint32_t)ld_adr, &size);
		}
	}
	if ( flg ) {
		printf("Program File Load Error.\r\n");
		while(1);
	}
}


static void setup_cpm(void) {
	
	const TCHAR	buf[30];
	int flg;
	uint16_t size;

	// set cpm operation
	bus_master_operation = cpm_bus_master_operation;

	cpmio_init();
	setup_I2C();
	chk_i2cdev();
	printf("\n\r");

	sprintf((char *)buf, "%s/UMON_CPM.BIN", fileinfo.fname);
	flg = load_program(buf, UNIMON_OFF, &size);
	if (!flg) {
		sprintf((char *)buf, "%s/CBIOS.BIN", fileinfo.fname);
		flg = load_program(buf, BIOS_OFF, &size);
		if (!flg) {
			sprintf((char *)buf, "%s/CCP_BDOS.BIN", fileinfo.fname);
			flg = load_program(buf, CCP_OFF, &size);
		}
	}
	if ( flg ) {
		printf("Program File Load Error.\r\n");
		while(1);
	}
}

//
// load program from SD card
//
static int load_program(const TCHAR *buf, uint32_t load_adr, uint16_t *load_size) {
	
	FRESULT		fr;
	void		*rdbuf;
	UINT		btr, br;
	uint16_t	cnt;
	uint32_t	adr;

	rdbuf = (void *)&tmp_buf[0][0];		// program load work area(512byte)
	
	fr = f_open(&rom_fl, buf, FA_READ);
	if ( fr != FR_OK ) return((int)fr);

	adr = load_adr;
	cnt = *load_size = (uint16_t)f_size(&rom_fl);	// get file size
	btr = BUF_SIZE;									// default 512byte
	while( cnt ) {
		fr = f_read(&rom_fl, rdbuf, btr, &br);
		if (fr == FR_OK) {
			write_sram(adr, (uint8_t *)rdbuf, (unsigned int)br);
			adr += (uint32_t)br;
			cnt -= (uint16_t)br;
			if (btr > (UINT)cnt) btr = (UINT)cnt;
		}
		else break;
	}
	if (fr == FR_OK) {
		printf("%s Load Adr = %06lx, Size = %04x\r\n", (char *)buf, load_adr, *load_size);
	}
	f_close(&rom_fl);
	return((int)fr);
}

//
// mount SD card
//
static int disk_init(void)
{
    if (f_mount(&fs, "0://", 1) != FR_OK) {
        printf("Failed to mount SD Card.\n\r");
        return -2;
    }

    return 0;
}

//
// check OS and select OS
//
static int chk_os(void)
{
    int selection;
    uint8_t c;

    //
    // Select disk image folder
    //
    if (f_opendir(&fsdir, "/")  != FR_OK) {
        printf("Failed to open SD Card..\n\r");
        return -1;
    }

	selection = 0;
	f_rewinddir(&fsdir);
	while (f_readdir(&fsdir, &fileinfo) == FR_OK && fileinfo.fname[0] != 0) {
		if (strcmp(fileinfo.fname, cpmdir) == 0) selection |= CPM;
		if (strcmp(fileinfo.fname, msdosdir) == 0) selection |= MSDOS;
		if (selection) printf("Detect %s\n\r", fileinfo.fname);
	}
	switch( selection) {
		case 0:			// directory not found
			return(-1);
		case CPM:
			selection = CPM;
			break;
			selection = MSDOS;
		case MSDOS:
			break;
		default:
			// remain CPM+MSDOS:
    	    printf("Select(CPM = 1, MSDOS = 2) : ");
    	    while (1) {
            	c = (uint8_t)getch();  // Wait for input char
    	    	if ( c == '1' || c == '2' ) {
    	    		putch((char)c);
	            	selection = c - '0';
    	    	}
   	    		if ( c == 0x0d || c == 0x0a ) break;
    	    }
   	    	printf("\n\r");
		if ( selection == CPM) strcpy(fileinfo.fname, cpmdir);
		else strcpy(fileinfo.fname, msdosdir);
	}
	printf("%s is selected.\n\r", fileinfo.fname);
	f_closedir(&fsdir);
	
	return(selection);
}

	
//
// Open disk images
//
static int open_dskimg(void) {
	
	int num_files;
    uint16_t drv;
	
	for (drv = num_files = 0; drv < NUM_DRIVES && num_files < NUM_FILES; drv++) {
        char drive_letter = (char)('A' + drv);
        char * const buf = (char *)tmp_buf[0];
        sprintf(buf, "%s/DRIVE%c.DSK", fileinfo.fname, drive_letter);
        if (f_open(&files[num_files], buf, FA_READ|FA_WRITE) == FR_OK) {

        	printf("Image file %s/DRIVE%c.DSK is assigned to drive %c\n\r",
                   fileinfo.fname, drive_letter, drive_letter);
        	if (os_flg == CPM) {
	        	cpm_drives[drv].filep = &files[num_files];
				if (cpm_drives[0].filep == NULL) return -4;
        	}
        	else {
        		dos_drives[drv].filep = &files[num_files];
				if (dos_drives[0].filep == NULL) return -4;
        	}
        	num_files++;
        }
    }
    return 0;
}
