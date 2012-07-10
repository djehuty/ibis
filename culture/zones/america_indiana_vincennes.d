module culture.zones.america_indiana_vincennes;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaIndianaVincennesZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1883, 11, 18,12,9)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1964, 4, 26,2,0)) {
			return NorthamericaRules.VincennesRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1971, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2006, 4, 2,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2007, 11, 4,2,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1883, 11, 18,12,9)) {
			return -21007;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1964, 4, 26,2,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 1, 1,0,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1971, 1, 1,0,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2006, 4, 2,2,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2007, 11, 4,2,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -18000;
		}
		
		return 0;
	}
}

