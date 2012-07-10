module culture.zones.america_guyana;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaGuyanaZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1915, 3, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1966, 5, 26,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1975, 7, 31,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1915, 3, 1,0,0)) {
			return -13960;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1966, 5, 26,0,0)) {
			return -13500;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1975, 7, 31,0,0)) {
			return -13500;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 1, 1,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -14400;
		}
		
		return 0;
	}
}

