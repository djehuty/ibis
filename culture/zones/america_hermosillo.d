module culture.zones.america_hermosillo;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaHermosilloZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1921, 12, 31,23,36)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1927, 6, 10,23,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 11, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 5, 1,23,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1932, 4, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 4, 24,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1949, 1, 14,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1970, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 1, 1,0,0)) {
			return NorthamericaRules.MexicoRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1921, 12, 31,23,36)) {
			return -26632;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1927, 6, 10,23,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 11, 15,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 5, 1,23,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 10, 1,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1932, 4, 1,0,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 4, 24,0,0)) {
			return -21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1949, 1, 14,0,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1970, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 1, 1,0,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -25200;
		}
		
		return 0;
	}
}

