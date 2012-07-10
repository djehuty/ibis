module culture.zones.america_asuncion;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaAsuncionZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1890, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 10, 10,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1972, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1974, 4, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return SouthamericaRules.ParaRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1890, 1, 1,0,0)) {
			return -13840;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 10, 10,0,0)) {
			return -13840;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1972, 10, 1,0,0)) {
			return -14400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1974, 4, 1,0,0)) {
			return -10800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -14400;
		}
		
		return 0;
	}
}

