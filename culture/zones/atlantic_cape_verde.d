module culture.zones.atlantic_cape_verde;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AtlanticCapeVerdeZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1907, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 9, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1975, 11, 25,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1907, 1, 1,0,0)) {
			return -5644;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 9, 1,0,0)) {
			return -7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 15,0,0)) {
			return -7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1975, 11, 25,2,0)) {
			return -7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -3600;
		}
		
		return 0;
	}
}

