module culture.zones.pacific_pago_pago;

import chrono.month;
import culture.util;

import culture.rules.africa;
import culture.rules.antarctica;
import culture.rules.asia;
import culture.rules.australasia;
import culture.rules.europe;
import culture.rules.northamerica;
import culture.rules.southamerica;

class PacificPagoPagoZone {
static:
public:
	
	long savings(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1879, 7, 5,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1950, 1, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1967, 4, 1,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 11, 30,0,0)) {
			return 0;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return 0;
		}
		
		return 0;
	}
	
	long offset(long year, Month month, uint day, uint hour, uint minute) {
		if (Util.isStrictlyBefore(year, month, day, hour, minute, 1879, 7, 5,0,0)) {
			return 45432;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1911, 1, 1,0,0)) {
			return -40968;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1950, 1, 1,0,0)) {
			return -41400;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1967, 4, 1,0,0)) {
			return -39600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 1983, 11, 30,0,0)) {
			return -39600;
		}
		else if (Util.isStrictlyBefore(year, month, day, hour, minute, 3200000, 1, 1,0,0)) {
			return -39600;
		}
		
		return 0;
	}
}

