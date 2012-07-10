module culture.zones.europe_bucharest;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class EuropeBucharestZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1891, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 7, 24,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 3, 29,2,0)) {
			return EuropeRules.RomaniaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 1, 1,0,0)) {
			return EuropeRules.C_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1994, 1, 1,0,0)) {
			return EuropeRules.RomaniaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1997, 1, 1,0,0)) {
			return EuropeRules.E_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return EuropeRules.EuRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1891, 10, 1,0,0)) {
			return 6264;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 7, 24,0,0)) {
			return 6264;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1981, 3, 29,2,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1991, 1, 1,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1994, 1, 1,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1997, 1, 1,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 7200;
		}
		
		return 0;
	}
}

