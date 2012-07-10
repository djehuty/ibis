module culture.zones.pacific_saipan;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class PacificSaipanZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1844, 12, 31,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 12, 23,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1844, 12, 31,0,0)) {
			return -51420;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return 34980;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 10, 1,0,0)) {
			return 32400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 12, 23,0,0)) {
			return 36000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 36000;
		}
		
		return 0;
	}
}

