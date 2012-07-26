module culture.zones.asia_qyzylorda;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaQyzylordaZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1924, 5, 2,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 6, 21,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 4, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1982, 4, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 1, 1,0,0)) {
			return AsiaRules.RussiaasiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 12, 16,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 1, 19,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2005, 3, 15,0,0)) {
			return AsiaRules.RussiaasiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1924, 5, 2,0,0)) {
			return 15712;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 6, 21,0,0)) {
			return 14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 4, 1,0,0)) {
			return 18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 10, 1,0,0)) {
			return 18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1982, 4, 1,0,0)) {
			return 21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 1, 1,0,0)) {
			return 18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 12, 16,0,0)) {
			return 18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 1, 19,2,0)) {
			return 18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2005, 3, 15,0,0)) {
			return 21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 21600;
		}
		
		return 0;
	}
}
