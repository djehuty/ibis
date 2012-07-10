module culture.zones.europe_paris;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class EuropeParisZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1891, 3, 15,0,1)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 3, 11,0,1)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1940, 6, 14,23,0)) {
			return EuropeRules.FranceRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1944, 8, 25,0,0)) {
			return EuropeRules.C_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 16,3,0)) {
			return EuropeRules.FranceRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1977, 1, 1,0,0)) {
			return EuropeRules.FranceRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return EuropeRules.EuRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1891, 3, 15,0,1)) {
			return 561;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 3, 11,0,1)) {
			return 561;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1940, 6, 14,23,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1944, 8, 25,0,0)) {
			return 3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 16,3,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1977, 1, 1,0,0)) {
			return 3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 3600;
		}
		
		return 0;
	}
}

