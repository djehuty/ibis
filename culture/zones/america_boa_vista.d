module culture.zones.america_boa_vista;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaBoaVistaZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1914, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1988, 9, 12,0,0)) {
			return SouthamericaRules.BrazilRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 9, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 10, 15,0,0)) {
			return SouthamericaRules.BrazilRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1914, 1, 1,0,0)) {
			return -14560;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1988, 9, 12,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 9, 30,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2000, 10, 15,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -14400;
		}
		
		return 0;
	}
}

