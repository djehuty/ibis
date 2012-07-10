module culture.zones.america_indiana_indianapolis;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaIndianaIndianapolisZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1883, 11, 18,12,15)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1920, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 1, 1,0,0)) {
			return NorthamericaRules.IndianapolisRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1955, 4, 24,2,0)) {
			return NorthamericaRules.IndianapolisRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1957, 9, 29,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1958, 4, 27,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1971, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2006, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1883, 11, 18,12,15)) {
			return -20678;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1920, 1, 1,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 1, 1,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1955, 4, 24,2,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1957, 9, 29,2,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1958, 4, 27,2,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 1, 1,0,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1971, 1, 1,0,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2006, 1, 1,0,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -18000;
		}
		
		return 0;
	}
}

