#include "wramp.h"

int counter = 0;

/**
 * Prints a character to SP2
 **/
void printChar(int c) {
	//Loop while the TDR bit is not set
	while(!(WrampSp2->Stat & 2));
	//Write the character to the Tx register
	WrampSp2->Tx = c;
}

void serial_main(){
	//Variables 
	int inputs = '1';
	int time;
	int number;
	while(1){
		if(WrampSp2->Stat & 1){
			if(WrampSp2->Rx == '1' || WrampSp2->Rx == '2' || WrampSp2->Rx == '3' || WrampSp2->Rx == 'q'){
				inputs = WrampSp2->Rx;
			}
		}
		printChar('\r');
		if(inputs == '1'){
			time = counter / 100;
			time /= 60;
			number = ((time / 10) % 10) + '0';
			printChar(number);
			number = (time % 10) + '0';
			printChar(number);
			printChar(':');
			time = counter / 100;
			time %= 60;
			number = (time / 10) + '0';
			printChar(number);
			number = (time % 10) + '0';
			printChar(number); 
			printChar(' '); 
			printChar(' '); 
		}
		else if(inputs == '2'){
			time = counter / 1000;
			number = ((time / 100) % 10) + '0';
			printChar(number);
			time %= 100;
			number = (time / 10) + '0'; 
			printChar(number);
			number = (time % 10) + '0';
			printChar(number);
			time = counter % 1000;
			number = (time / 100) + '0';
			printChar(number);
			printChar('.');
			time %= 100;
			number = (time / 10) + '0';
			printChar(number);
			number = (time % 10) + '0';
			printChar(number);			
		}
		else if(inputs == '3'){
			time = counter / 1000;
			number = ((time / 100) % 10) + '0';
			printChar(number);
			time %= 100;
			number = (time / 10) + '0'; 
			printChar(number);
			number = (time % 10) + '0';
			printChar(number);
			time = counter % 1000;
			number = (time / 100) + '0';
			printChar(number);
			time %= 100;
			number = (time / 10) + '0';
			printChar(number);
			number = (time % 10) + '0';
			printChar(number);
			printChar(' '); 
		}
		else if(inputs == 'q'){
			return;
		}
	}
}
