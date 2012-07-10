module culture.zones.europe_rome;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class EuropeRomeZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1866, 9, 22,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1893, 11, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 11, 2,2,0)) {
			return EuropeRules.ItalyRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1944, 7, 1,0,0)) {
			return EuropeRules.C_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 1, 1,0,0)) {
			return EuropeRules.ItalyRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return EuropeRules.EuRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1866, 9, 22,0,0)) {
			return 2996;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1893, 11, 1,0,0)) {
			return 2996;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 11, 2,2,0)) {
			return 3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1944, 7, 1,0,0)) {
			return 3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 1, 1,0,0)) {
			return 3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 3600;
		}
		
		return 0;
	}
}

