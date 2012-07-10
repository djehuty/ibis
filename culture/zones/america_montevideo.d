module culture.zones.america_montevideo;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaMontevideoZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1898, 6, 28,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1920, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 12, 14,0,0)) {
			return SouthamericaRules.UruguayRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return SouthamericaRules.UruguayRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1898, 6, 28,0,0)) {
			return -13484;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1920, 5, 1,0,0)) {
			return -13484;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 12, 14,0,0)) {
			return -12600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -10800;
		}
		
		return 0;
	}
}

