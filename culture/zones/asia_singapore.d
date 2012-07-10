module culture.zones.asia_singapore;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaSingaporeZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1905, 6, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1933, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1936, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1941, 9, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 2, 16,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 12,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1965, 8, 9,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1982, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1901, 1, 1,0,0)) {
			return 24925;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1905, 6, 1,0,0)) {
			return 24925;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1933, 1, 1,0,0)) {
			return 25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1936, 1, 1,0,0)) {
			return 25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1941, 9, 1,0,0)) {
			return 26400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 2, 16,0,0)) {
			return 27000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 12,0,0)) {
			return 32400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1965, 8, 9,0,0)) {
			return 27000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1982, 1, 1,0,0)) {
			return 27000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 28800;
		}
		
		return 0;
	}
}

