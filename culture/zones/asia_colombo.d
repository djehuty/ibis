module culture.zones.asia_colombo;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaColomboZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1880, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1906, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 1, 5,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 9, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 16,2,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 5, 25,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 10, 26,0,30)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2006, 4, 15,0,30)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1880, 1, 1,0,0)) {
			return 19164;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1906, 1, 1,0,0)) {
			return 19172;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 1, 5,0,0)) {
			return 19800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1942, 9, 1,0,0)) {
			return 19800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1945, 10, 16,2,0)) {
			return 19800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 5, 25,0,0)) {
			return 19800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 10, 26,0,30)) {
			return 23400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2006, 4, 15,0,30)) {
			return 21600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 19800;
		}
		
		return 0;
	}
}

