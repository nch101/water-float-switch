//Demo app to blink the red LED (LED1) on the TI Launchpad
//which is attached to P1.0
//The green LED(LED2) is connected to P1.6

#include <msp430g2553.h>
 
int main(void) {
  volatile int i;
 
  // stop watchdog timer
  WDTCTL = WDTPW | WDTHOLD;
  // set up bit 0 of P1 as output
  P1DIR = 0x01;
  // intialize bit 0 of P1 to 0
  P1OUT = 0x00;
 
  // loop forever
  for (;;) {
    // toggle bit 0 of P1
    P1OUT ^= 0x01;
    // delay for a while
    for (i = 0; i < 0x6000; i++);
  }
}