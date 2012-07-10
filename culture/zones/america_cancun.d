module culture.zones.america_cancun;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaCancunZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1922, 1, 1,0,12)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 12, 23,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1998, 8, 2,2,0)) {
			return NorthamericaRules.MexicoRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.MexicoRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1922, 1, 1,0,12)) {
			return -20824;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 12, 23,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1998, 8, 2,2,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -21600;
		}
		
		return 0;
	}
}

