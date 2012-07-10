module culture.zones.asia_phnom_penh;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaPhnomPenhZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1906, 6, 9,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 3, 11,0,1)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1912, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1906, 6, 9,0,0)) {
			return 25180;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 3, 11,0,1)) {
			return 25580;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1912, 5, 1,0,0)) {
			return 25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1931, 5, 1,0,0)) {
			return 28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 25200;
		}
		
		return 0;
	}
}

