module culture.zones.pacific_midway;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class PacificMidwayZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1956, 6, 3,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1956, 9, 2,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1967, 4, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 11, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return -42568;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1956, 6, 3,0,0)) {
			return -39600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1956, 9, 2,0,0)) {
			return -39600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1967, 4, 1,0,0)) {
			return -39600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 11, 30,0,0)) {
			return -39600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -39600;
		}
		
		return 0;
	}
}

