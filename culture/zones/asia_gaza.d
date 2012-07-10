module culture.zones.asia_gaza;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AsiaGazaZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1900, 10, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1948, 5, 15,0,0)) {
			return AsiaRules.ZionRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1967, 6, 5,0,0)) {
			return AsiaRules.EgyptasiaRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 1, 1,0,0)) {
			return AsiaRules.ZionRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 1, 1,0,0)) {
			return AsiaRules.JordanRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return AsiaRules.PalestineRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1900, 10, 1,0,0)) {
			return 8272;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1948, 5, 15,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1967, 6, 5,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1996, 1, 1,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1999, 1, 1,0,0)) {
			return 7200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 7200;
		}
		
		return 0;
	}
}

