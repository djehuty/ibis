module culture.zones.america_pangnirtung;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaPangnirtungZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1921, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1995, 4, Util.isFirst(0, 1, 1995, 4),2,0)) {
			return NorthamericaRules.Nt_ykRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 10, 31,2,0)) {
			return NorthamericaRules.CanadaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 10, 29,2,0)) {
			return NorthamericaRules.CanadaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.CanadaRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1921, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1995, 4, Util.isFirst(0, 1, 1995, 4),2,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 10, 31,2,0)) {
			return -18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 10, 29,2,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -18000;
		}
		
		return 0;
	}
}

