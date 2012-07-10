module culture.zones.atlantic_azores;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AtlanticAzoresZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1884, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 5, 24,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1966, 4, 3,2,0)) {
			return EuropeRules.PortRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 9, 25,1,0)) {
			return EuropeRules.PortRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 9, 27,1,0)) {
			return EuropeRules.W_eurRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1993, 3, 28,1,0)) {
			return EuropeRules.EuRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return EuropeRules.EuRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1884, 1, 1,0,0)) {
			return -6160;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 5, 24,0,0)) {
			return -6872;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1966, 4, 3,2,0)) {
			return -7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 9, 25,1,0)) {
			return -3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1992, 9, 27,1,0)) {
			return -3600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1993, 3, 28,1,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -3600;
		}
		
		return 0;
	}
}

