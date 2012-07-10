module culture.zones.asia_kashgar;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaKashgarZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1928, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1940, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 5, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return AsiaRules.PrcRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1928, 1, 1,0,0)) {
			return 18236;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1940, 1, 1,0,0)) {
			return 19800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1980, 5, 1,0,0)) {
			return 18000;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 28800;
		}
		
		return 0;
	}
}

