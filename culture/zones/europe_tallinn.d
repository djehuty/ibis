module culture.zones.europe_tallinn;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class EuropeTallinnZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1880, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1918, 2, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1919, 7, 1,0,0)) {
			return EuropeRules.C_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1921, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1940, 8, 6,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1941, 9, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1944, 9, 22,0,0)) {
			return EuropeRules.C_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1989, 3, 26,2,0)) {
			return EuropeRules.RussiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1989, 9, 24,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1998, 9, 22,0,0)) {
			return EuropeRules.C_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 11, 1,0,0)) {
			return EuropeRules.EuRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2002, 2, 21,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return EuropeRules.EuRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1880, 1, 1,0,0)) {
			return 5940;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1918, 2, 1,0,0)) {
			return 5940;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1919, 7, 1,0,0)) {
			return 3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1921, 5, 1,0,0)) {
			return 5940;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1940, 8, 6,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1941, 9, 15,0,0)) {
			return 10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1944, 9, 22,0,0)) {
			return 3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1989, 3, 26,2,0)) {
			return 10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1989, 9, 24,2,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1998, 9, 22,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 11, 1,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2002, 2, 21,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 7200;
		}
		
		return 0;
	}
}

