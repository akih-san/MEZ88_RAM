/*
 *  This source is for PIC18F47Q43 UART, I2C, SPI and TIMER0
 *
 * Base source code is maked by @hanyazou
 *  https://twitter.com/hanyazou
 *
 * Redesigned by Akihito Honda(Aki.h @akih_san)
 *  https://twitter.com/akih_san
 *  https://github.com/akih-san
 *
 *  Target: MEZ88_47Q RAM
 *  Date. 2024.4.20
*/

#define BOARD_DEPENDENT_SOURCE

#include "../mez88_47q.h"

// console input buffers
#define U3B_SIZE 128
unsigned char rx_buf[U3B_SIZE];	//UART Rx ring buffer
unsigned int rx_wp, rx_rp, rx_cnt;

// AUX: input buffers
#define U5B_SIZE 128
unsigned char ax_buf[U5B_SIZE];	//UART Rx ring buffer
unsigned int ax_wp, ax_rp, ax_cnt;
int nmi_flg;


//TIMER0 seconds counter
static union {
    unsigned int w; //16 bits Address
    struct {
        unsigned char l; //Address low
        unsigned char h; //Address high
    };
} adjCnt;

TPB tim_pb;			// TIME device parameter block

void uart5_init(void) {
	ax_wp = 0;
	ax_rp = 0;
	ax_cnt = 0;

	U5RXIE = 1;			// Receiver interrupt enable

}

//initialize TIMER0 & TIM device parameter block
void timer0_init(void) {
	adjCnt.w = TIMER0_INITC;	// set initial adjust timer counter
	tim_pb.TIM_DAYS = TIM20240101;
	tim_pb.TIM_MINS = 0;
	tim_pb.TIM_HRS = 0;
	tim_pb.TIM_SECS = 0;
	tim_pb.TIM_HSEC = 0;
}

//
// define interrupt
//
// Never called, logically
void __interrupt(irq(default),base(8)) Default_ISR(){}

////////////// TIMER0 vector interrupt ////////////////////////////
//TIMER0 interrupt
/////////////////////////////////////////////////////////////////
void __interrupt(irq(TMR0),base(8)) TIMER0_ISR(){

	union {
    	unsigned int w; //16 bits Address
    	struct {
        	unsigned char l; //Address low
        	unsigned char h; //Address high
    	};
	} tmpCnt;

	TMR0IF =0; // Clear timer0 interrupt flag

	// adjust timer conter
	tmpCnt.l = TMR0L;
	tmpCnt.h = TMR0H;
	tmpCnt.w = tmpCnt.w + adjCnt.w;

	TMR0L = tmpCnt.l;
	TMR0H = tmpCnt.h;

	if( ++tim_pb.TIM_SECS == 60 ) {
		tim_pb.TIM_SECS = 0;
		if ( ++tim_pb.TIM_MINS == 60 ) {
			tim_pb.TIM_MINS = 0;
			if ( ++tim_pb.TIM_HRS == 24 ) {
				tim_pb.TIM_HRS = 0;
				tim_pb.TIM_DAYS++;
			}
		}
	}
	tim_pb.TIM_HSEC = 0;
}

////////////// UART3 Receive interrupt ////////////////////////////
// UART3 Rx interrupt
// PIR9 (bit0:U3RXIF bit1:U3TXIF)
/////////////////////////////////////////////////////////////////
void __interrupt(irq(U3RX),base(8)) URT3Rx_ISR(){

	unsigned char rx_data;

	rx_data = U3RXB;			// get rx data

	if (rx_data == CTL_Q) {
		nmi_flg = 1;
	}
	else if (rx_cnt < U3B_SIZE) {
		rx_buf[rx_wp] = rx_data;
		rx_wp = (rx_wp + 1) & (U3B_SIZE - 1);
		rx_cnt++;
	}
}

// UART3 Transmit
void putch(char c) {
    while(!U3TXIF);             // Wait or Tx interrupt flag set
    U3TXB = c;                  // Write data
}

// UART3 Recive
int getch(void) {
	char c;

	while(!rx_cnt);             // Wait for Rx interrupt flag set
	GIE = 0;                // Disable interrupt
	c = rx_buf[rx_rp];
	rx_rp = (rx_rp + 1) & ( U3B_SIZE - 1);
	rx_cnt--;
	GIE = 1;                // enable interrupt
    return c;               // Read data
}

////////////// UART5 Receive interrupt ////////////////////////////
// UART5 Rx interrupt
// PIR13 (bit0:U5RXIF)
/////////////////////////////////////////////////////////////////
void __interrupt(irq(U5RX),base(8)) URT5Rx_ISR(){

	unsigned char ax_data;

	ax_data = U5RXB;			// get rx data

	if (ax_cnt < U5B_SIZE) {
		ax_buf[ax_wp] = ax_data;
		ax_wp = (ax_wp + 1) & (U5B_SIZE - 1);
		ax_cnt++;
	}
}

// UAR54 Transmit
void putax(char c) {
    while(!U5TXIF);             // Wait or Tx interrupt flag set
    U5TXB = c;                  // Write data
}

// UART5 Recive
int getax(void) {
	char c;

	while(!ax_cnt);			// Wait for Rx interrupt flag set
	GIE = 0;                // Disable interrupt

	c = ax_buf[ax_rp];
	ax_rp = (ax_rp + 1) & ( U5B_SIZE - 1);
	ax_cnt--;
	GIE = 1;                // enable interrupt

	return c;               // Read data
}

void devio_init(void) {
	rx_wp = 0;
	rx_rp = 0;
	rx_cnt = 0;
	nmi_flg = 0;
    U3RXIE = 1;          // Receiver interrupt enable
}

uint32_t get_physical_addr(uint16_t ah, uint16_t al)
{
// real 32 bit address
//	return (uint32_t)ah*0x1000 + (uint32_t)al;

// 8086 : segment:offset
	return (uint32_t)ah*0x10 + (uint32_t)al;
}


static void mez88_common_sys_init()
{
    // System initialize
    OSCFRQ = 0x08;      // 64MHz internal OSC

	// Disable analog function
    ANSELA = 0x00;
    ANSELB = 0x00;
    ANSELC = 0x00;
    ANSELD = 0x00;
    ANSELE0 = 0;
    ANSELE1 = 0;
    ANSELE2 = 0;

    // RESET output pin
	LAT(I88_RESET) = 1;        // Reset
    TRIS(I88_RESET) = 0;       // Set as output

	// HOLDA
	WPU(I88_HOLDA) = 0;     // disable week pull up
	LAT(I88_HOLDA) = 1;     // set HOLDA=0 for PIC controls ALE(RC5) dualing RESET period
	TRIS(I88_HOLDA) = 0;    // Set as output during RESET period

	// ALE
	WPU(I88_ALE) = 0;     // disable week pull up
	LAT(I88_ALE) = 0;
    TRIS(I88_ALE) = 0;    // Set as output for PIC R/W RAM

    // UART3 initialize
    U3BRG = 416;        // 9600bps @ 64MHz
    U3RXEN = 1;         // Receiver enable
    U3TXEN = 1;         // Transmitter enable

    // UART3 Receiver
    TRISA7 = 1;         // RX set as input
    U3RXPPS = 0x07;     // RA7->UART3:RXD;

    // UART3 Transmitter
    LATA6 = 1;          // Default level
    TRISA6 = 0;         // TX set as output
    RA6PPS = 0x26;      // UART3:TXD -> RA6;

    U3ON = 1;           // Serial port enable

	// Init address LATCH to 0
	// Address bus A7-A0 pin
    WPU(I88_ADBUS) = 0xff;       // Week pull up
    LAT(I88_ADBUS) = 0x00;
    TRIS(I88_ADBUS) = 0x00;      // Set as output

	// Address bus A15-A8 pin
    WPU(I88_ADR_H) = 0xff;       // Week pull up
    LAT(I88_ADR_H) = 0x00;
    TRIS(I88_ADR_H) = 0x00;      // Set as output

	WPU(I88_A16) = 1;     // A16 Week pull up
	LAT(I88_A16) = 1;     // init A16=0
    TRIS(I88_A16) = 0;    // Set as output

	WPU(I88_A17) = 1;     // A17 Week pull up
	LAT(I88_A17) = 1;     // init A17=0
    TRIS(I88_A17) = 0;    // Set as output

	WPU(I88_A18) = 1;     // A18 Week pull up
	LAT(I88_A18) = 1;     // init A18=0
    TRIS(I88_A18) = 0;    // Set as output

}

static void mez88_common_start_i88(void)
{
    // AD bus A7-A0 pin
    TRIS(I88_ADBUS) = 0xff;	// Set as input
    TRIS(I88_ADR_H) = 0xff;	// Set as input
    TRIS(I88_A16) = 1;    // Set as input
    TRIS(I88_A17) = 1;    // Set as input
    TRIS(I88_A18) = 1;    // Set as input

    TRIS(I88_RD) = 1;           // Set as input
    TRIS(I88_WR) = 1;           // Set as input
	TRIS(I88_IOM) = 1;			// Set as input
}

// Address Bus
//union address_bus_u {
//    uint32_t w;             // 32 bits Address
//    struct {
//        uint8_t ll;        // Address L low
//        uint8_t lh;        // Address L high
//        uint8_t hl;        // Address H low
//        uint8_t hh;        // Address H high
//    };
//};
void write_sram(uint32_t addr, uint8_t *buf, unsigned int len)
{
    union address_bus_u ab;
    unsigned int i;

	ab.w = addr;
	TRIS(I88_ADBUS) = 0x00;					// Set as output
	i = 0;

	while( i < len ) {

	    LAT(I88_ADBUS) = ab.ll;
		LAT(I88_ADR_H) = ab.lh;
		LAT(I88_A16) = ab.hl & 0x01;
		LAT(I88_A17) = (ab.hl & 0x02) >> 1;
		LAT(I88_A18) = (ab.hl & 0x04) >> 2;

		// Latch address A0 - A7 & A16-A13 to 74LS373
		LAT(I88_ALE) = 1;
		LAT(I88_ALE) = 0;

        LAT(I88_WR) = 0;					// activate /WE
        LAT(I88_ADBUS) = ((uint8_t*)buf)[i];
        LAT(I88_WR) = 1;					// deactivate /WE

		i++;
		ab.w++;
    }
	TRIS(I88_ADBUS) = 0xff;					// Set as input
}

void read_sram(uint32_t addr, uint8_t *buf, unsigned int len)
{
    union address_bus_u ab;
    unsigned int i;

	ab.w = addr;

	LAT(I88_RD) = 0;						// activate /OE
	i = 0;
	while( i < len ) {
	
		TRIS(I88_ADBUS) = 0x00;					// Set as output

		LAT(I88_ADBUS) = ab.ll;
		LAT(I88_ADR_H) = ab.lh;
		LAT(I88_A16) = ab.hl & 0x01;
		LAT(I88_A17) = (ab.hl & 0x02) >> 1;
		LAT(I88_A18) = (ab.hl & 0x04) >> 2;

		// Latch address A0 - A7 & A16-A13 to 74LS373
		LAT(I88_ALE) = 1;
		LAT(I88_ALE) = 0;

		TRIS(I88_ADBUS) = 0xff;					// Set as input
		ab.w++;									// Ensure bus data setup time from HiZ to valid data
		((uint8_t*)buf)[i] = PORT(I88_ADBUS);	// read data

		i++;
    }

	LAT(I88_RD) = 1;						// deactivate /OE
}

static void emu88_common_wait_for_programmer()
{
    //
    // Give a chance to use PRC (RB6) and PRD (RB7) to PIC programer.
    //
    printf("\n\r");
    printf("wait for programmer ...\r");
    __delay_ms(200);
    printf("                       \r");

    printf("\n\r");
}
