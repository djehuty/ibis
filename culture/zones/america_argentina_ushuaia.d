module culture.zones.america_argentina_ushuaia;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaArgentinaUshuaiaZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1894, 10, 31,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1920, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 12, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 10, 5,0,0)) {
			return SouthamericaRules.ArgRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 10, 3,0,0)) {
			return SouthamericaRules.ArgRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 3, 3,0,0)) {
			return SouthamericaRules.ArgRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2004, 5, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2004, 6, 20,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2008, 10, 18,0,0)) {
			return SouthamericaRules.ArgRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1894, 10, 31,0,0)) {
			return -16392;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1920, 5, 1,0,0)) {
			return -15408;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 12, 1,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 10, 5,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 10, 3,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 3, 3,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2004, 5, 30,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2004, 6, 20,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2008, 10, 18,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -10800;
		}
		
		return 0;
	}
}

