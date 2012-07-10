module culture.zones.america_juneau;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaJuneauZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1867, 10, 18,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1900, 8, 20,12,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 4, 27,2,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 10, 26,2,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 10, 30,2,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 11, 30,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1867, 10, 18,0,0)) {
			return 54139;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1900, 8, 20,12,0)) {
			return -32261;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1969, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 4, 27,2,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 10, 26,2,0)) {
			return -32400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 10, 30,2,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 11, 30,0,0)) {
			return -32400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -32400;
		}
		
		return 0;
	}
}

