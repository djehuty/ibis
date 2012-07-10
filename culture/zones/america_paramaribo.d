module culture.zones.america_paramaribo;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaParamariboZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1935, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1975, 11, 20,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1984, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 1, 1,0,0)) {
			return -13240;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1935, 1, 1,0,0)) {
			return -13252;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 1,0,0)) {
			return -13236;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1975, 11, 20,0,0)) {
			return -12600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1984, 10, 1,0,0)) {
			return -12600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -10800;
		}
		
		return 0;
	}
}

