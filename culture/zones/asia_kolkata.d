module culture.zones.asia_kolkata;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaKolkataZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1880, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1941, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 5, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 9, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 15,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1880, 1, 1,0,0)) {
			return 21208;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1941, 10, 1,0,0)) {
			return 21200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 5, 15,0,0)) {
			return 23400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 9, 1,0,0)) {
			return 19800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 15,0,0)) {
			return 19800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 19800;
		}
		
		return 0;
	}
}

