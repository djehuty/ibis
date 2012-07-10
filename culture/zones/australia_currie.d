module culture.zones.australia_currie;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AustraliaCurrieZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1895, 9, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1916, 10, 1,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1917, 2, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1971, 7, 1,0,0)) {
			return AustralasiaRules.AusRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return AustralasiaRules.AtRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1895, 9, 1,0,0)) {
			return 34528;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1916, 10, 1,2,0)) {
			return 36000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1917, 2, 1,0,0)) {
			return 36000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1971, 7, 1,0,0)) {
			return 36000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 36000;
		}
		
		return 0;
	}
}

