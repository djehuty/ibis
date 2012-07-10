module culture.zones.america_recife;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaRecifeZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1914, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1990, 9, 17,0,0)) {
			return SouthamericaRules.BrazilRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 9, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 10, 15,0,0)) {
			return SouthamericaRules.BrazilRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2001, 9, 13,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2002, 10, 1,0,0)) {
			return SouthamericaRules.BrazilRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1914, 1, 1,0,0)) {
			return -8376;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1990, 9, 17,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 9, 30,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 10, 15,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2001, 9, 13,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2002, 10, 1,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -10800;
		}
		
		return 0;
	}
}

