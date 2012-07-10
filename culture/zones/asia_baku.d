module culture.zones.asia_baku;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaBakuZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1924, 5, 2,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1957, 3, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 3, 31,2,0)) {
			return AsiaRules.RussiaasiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 8, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 9, Util.isLast(6, 1992, 9),23,0)) {
			return AsiaRules.RussiaasiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1997, 1, 1,0,0)) {
			return AsiaRules.EuasiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return AsiaRules.AzerRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1924, 5, 2,0,0)) {
			return 11964;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1957, 3, 1,0,0)) {
			return 10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 3, 31,2,0)) {
			return 14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 8, 30,0,0)) {
			return 10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 9, Util.isLast(6, 1992, 9),23,0)) {
			return 10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 1, 1,0,0)) {
			return 14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1997, 1, 1,0,0)) {
			return 14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 14400;
		}
		
		return 0;
	}
}

