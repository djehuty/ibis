module culture.zones.australia_perth;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AustraliaPerthZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1895, 12, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1943, 7, 1,0,0)) {
			return AustralasiaRules.AusRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return AustralasiaRules.AwRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1895, 12, 1,0,0)) {
			return 27804;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1943, 7, 1,0,0)) {
			return 28800;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 28800;
		}
		
		return 0;
	}
}

