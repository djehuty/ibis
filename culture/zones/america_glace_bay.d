module culture.zones.america_glace_bay;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaGlaceBayZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1902, 6, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1953, 1, 1,0,0)) {
			return NorthamericaRules.CanadaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1954, 1, 1,0,0)) {
			return NorthamericaRules.HalifaxRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1972, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1974, 1, 1,0,0)) {
			return NorthamericaRules.HalifaxRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.CanadaRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1902, 6, 15,0,0)) {
			return -14388;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1953, 1, 1,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1954, 1, 1,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1972, 1, 1,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1974, 1, 1,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -14400;
		}
		
		return 0;
	}
}

