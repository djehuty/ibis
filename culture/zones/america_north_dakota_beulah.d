module culture.zones.america_north_dakota_beulah;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class AmericaNorthDakotaBeulahZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1883, 11, 18,12,12)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2010, 11, 7,2,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return NorthamericaRules.UsRule.savings(year, month, day, hour, minute);
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1883, 11, 18,12,12)) {
			return -24427;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 2010, 11, 7,2,0)) {
			return -25200;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -21600;
		}
		
		return 0;
	}
}
