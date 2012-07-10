module culture.zones.asia_novosibirsk;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaNovosibirskZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1919, 12, 14,6,0)) {
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
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1993, 5, 23,0,0)) {
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
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1919, 12, 14,6,0)) {
			return 19900;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 6, 21,0,0)) {
			return 21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 3, 31,2,0)) {
			return 25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 1, 19,2,0)) {
			return 21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1993, 5, 23,0,0)) {
			return 25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2011, 3, 27,2,0)) {
			return 21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 25200;
		}
		
		return 0;
	}
}

