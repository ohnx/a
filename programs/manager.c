#include "libBareMetal.h"
//I was too lazy to make newlib work, so I ended up having to write this...
int strlen(char *s) {
	char *curr;
	curr=s;
	while(*curr!='\0') {
		curr++;
	}
	return curr - s;
}
/*int strstr(char *f, char *s) {
	while (*f==*s) {
		if(*f=='\0') { //reached null without being equal
			return 1;
		}
		f++;
		s++;
	}
	return 0; //not equal
}*/
int main() {
	char cmd[129];
	int ti, i;
	unsigned long sleeptime;
	b_output("Console ready.\n");
	while (1) {
		b_output("term> ");
		b_input(cmd, 128);
		if(*cmd=='h') { //help
			b_output("Help for Console:\nCommands:\nhelp\tDisplay help\necho\techos text\nsleep\tdelays for <x> seconds\nexit\treturn to the boring BMOS shell\ncores\tget number of cores\n\twell, that's it.");
			continue;
		} else if(*cmd=='e') {
			if(*(cmd+1)=='x') {
				return 0;
			} else {
				b_output(cmd+5);
				continue;
			}
		} else if(*cmd=='s') {
			sleeptime=0;
			//A pretty horrible atoi
			ti = strlen(cmd+6);
			i=6;
			for(;ti>0;ti--) {
				sleeptime+=(*(cmd+i)-30)*(ti*10); //breaking this down: get the value of whatever character we're on, subtract 30 (numbers are from 30-39 ascii with 0 being 30 and 9 being 39), then multiply this by whatever amount needed to put it in the right place
				i++;
			}
			sleeptime *= 8;
			b_system_misc(DELAY, &sleeptime, 0x0);
			continue;
		} else if(*cmd=='c') {
			i=0;
			b_system_misc(SMP_NUMCORES, 0x0, &i);
			b_output("cores: TBI");
			//b_output();
			continue;
		}
	}
	return 1;
}