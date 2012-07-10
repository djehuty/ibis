module culture.zones.america_goose_bay;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaGooseBayZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1884, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1918, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1919, 1, 1,0,0)) {
			return NorthamericaRules.CanadaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1935, 3, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1936, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 5, 11,0,0)) {
			return NorthamericaRules.StjohnsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return NorthamericaRules.CanadaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1966, 3, 15,2,0)) {
			return NorthamericaRules.StjohnsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.StjohnsRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1884, 1, 1,0,0)) {
			return -14500;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1918, 1, 1,0,0)) {
			return -12652;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1919, 1, 1,0,0)) {
			return -12652;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1935, 3, 30,0,0)) {
			return -12652;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1936, 1, 1,0,0)) {
			return -12600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 5, 11,0,0)) {
			return -12600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1946, 1, 1,0,0)) {
			return -12600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1966, 3, 15,2,0)) {
			return -12600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -14400;
		}
		
		return 0;
	}
}

