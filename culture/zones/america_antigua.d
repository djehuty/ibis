module culture.zones.america_antigua;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaAntiguaZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1912, 3, 2,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1951, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1912, 3, 2,0,0)) {
			return -14832;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1951, 1, 1,0,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -14400;
		}
		
		return 0;
	}
}

