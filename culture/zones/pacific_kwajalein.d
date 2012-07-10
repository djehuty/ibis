module culture.zones.pacific_kwajalein;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class PacificKwajaleinZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1993, 8, 20,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return 40160;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 10, 1,0,0)) {
			return 39600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1993, 8, 20,0,0)) {
			return -43200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 43200;
		}
		
		return 0;
	}
}

