#include "wramp.h"

void parallel_main(){
	int switches;
	int buttons = 0x1;
	int value;
	int number;
	
	while(1) {
		switches = WrampParallel->Switches;
		if(WrampParallel->Buttons != 0){
			buttons = WrampParallel->Buttons;
		}
		if(buttons == 0x1){
			WrampParallel->LowerRightSSD = switches;
			switches >>= 4;
			WrampParallel->LowerLeftSSD = switches;
			switches >>= 4;
			WrampParallel->UpperRightSSD = switches;
			switches >>= 4;
			WrampParallel->UpperLeftSSD = switches;
		}
		else if(buttons == 0x2){
			value = switches % 10000;
			number = value / 1000;
			value = value % 1000;
			WrampParallel->UpperLeftSSD = number;
			number = value / 100;
			value = value % 100;
			WrampParallel->UpperRightSSD = number;
			number = value / 10;
			value = value % 10;
			WrampParallel->LowerLeftSSD = number;
			WrampParallel->LowerRightSSD = value;
		}
		else if(buttons == 0x4){
			return;
		}
	}
}
