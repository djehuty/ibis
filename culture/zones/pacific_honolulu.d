module culture.zones.pacific_honolulu;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class PacificHonoluluZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1896, 1, 13,12,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1933, 4, 30,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1933, 5, 21,12,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 2, 9,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 30,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1947, 6, 8,2,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1896, 1, 13,12,0)) {
			return -37886;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1933, 4, 30,2,0)) {
			return -37800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1933, 5, 21,12,0)) {
			return -37800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 2, 9,2,0)) {
			return -37800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 30,2,0)) {
			return -37800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1947, 6, 8,2,0)) {
			return -37800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -36000;
		}
		
		return 0;
	}
}

