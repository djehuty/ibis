module culture.zones.asia_vladivostok;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaVladivostokZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1922, 11, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 6, 21,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 3, 31,2,0)) {
			return EuropeRules.RussiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 1, 19,2,0)) {
			return EuropeRules.RussiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2011, 3, 27,2,0)) {
			return EuropeRules.RussiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1922, 11, 15,0,0)) {
			return 31664;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 6, 21,0,0)) {
			return 32400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 3, 31,2,0)) {
			return 36000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 1, 19,2,0)) {
			return 32400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2011, 3, 27,2,0)) {
			return 36000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 39600;
		}
		
		return 0;
	}
}

