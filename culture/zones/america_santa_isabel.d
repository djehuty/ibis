module culture.zones.america_santa_isabel;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaSantaIsabelZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1922, 1, 1,0,20)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1924, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1927, 6, 10,23,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 11, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 4, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 9, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 4, 24,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 8, 14,23,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 11, 12,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1948, 4, 5,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1949, 1, 14,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1954, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1961, 1, 1,0,0)) {
			return NorthamericaRules.CaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1976, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2001, 1, 1,0,0)) {
			return NorthamericaRules.MexicoRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2002, 2, 20,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.MexicoRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1922, 1, 1,0,20)) {
			return -27568;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1924, 1, 1,0,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1927, 6, 10,23,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1930, 11, 15,0,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 4, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 9, 30,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 4, 24,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 8, 14,23,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 11, 12,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1948, 4, 5,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1949, 1, 14,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1954, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1961, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1976, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2001, 1, 1,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2002, 2, 20,0,0)) {
			return -28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -28800;
		}
		
		return 0;
	}
}

