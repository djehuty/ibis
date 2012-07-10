module culture.zones.asia_jakarta;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaJakartaZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1867, 8, 10,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1923, 12, 31,23,47)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1932, 11, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 3, 23,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 23,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1948, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1950, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1964, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1867, 8, 10,0,0)) {
			return 25632;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1923, 12, 31,23,47)) {
			return 25632;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1932, 11, 1,0,0)) {
			return 26400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 3, 23,0,0)) {
			return 27000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 9, 23,0,0)) {
			return 32400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1948, 5, 1,0,0)) {
			return 27000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1950, 5, 1,0,0)) {
			return 28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1964, 1, 1,0,0)) {
			return 27000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 25200;
		}
		
		return 0;
	}
}

