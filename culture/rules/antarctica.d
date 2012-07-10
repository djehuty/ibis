module culture.rules.antarctica;

import chrono.month;
import culture.util;

class AntarcticaRules {
static:
public:
	class ArgaqRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1964) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1964, 10, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1966, 3, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 10, Util.isFirst(0, 1, 1967, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1967, 4, Util.isFirst(0, 1, 1968, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 10, Util.isFirst(0, 1, 1967, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1969, 4, Util.isFirst(0, 1, 1968, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 1, 23, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 5, 23, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ChileaqRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1974) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 10, Util.isFirst(0, 9, 1974, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 3, Util.isFirst(0, 9, 1987, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 10, Util.isFirst(0, 9, 1974, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 9, 1987, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 10, Util.isFirst(0, 1, 1988, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isFirst(0, 1, 1988, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, Util.isFirst(0, 9, 1989, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isFirst(0, 9, 1989, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 9, 16, 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 3, 16, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 10, Util.isFirst(0, 9, 1991, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1996, 3, Util.isFirst(0, 9, 1997, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 10, Util.isFirst(0, 9, 1991, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 3, Util.isFirst(0, 9, 1997, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1998, 9, 27, 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1998, 3, 27, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 10, Util.isFirst(0, 9, 1999, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1999, 4, Util.isFirst(0, 9, 3200000, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 10, Util.isFirst(0, 9, 1999, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 3, Util.isFirst(0, 9, 3200000, 10), 3, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AusaqRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1917) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 1, 1, 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 3, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 1, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 3, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 9, 27, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 3, 27, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 10, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 3, 3, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AtaqRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1967) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 10, Util.isFirst(0, 1, 1967, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 3, Util.isFirst(0, 1, 1967, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1968, 10, Util.isLast(0, 1968, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 3, Util.isLast(0, 1985, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1968, 10, Util.isLast(0, 1968, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 3, Util.isLast(0, 1985, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 10, Util.isFirst(0, 15, 1986, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 3, Util.isFirst(0, 15, 1986, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, Util.isFirst(0, 22, 1987, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 3, Util.isFirst(0, 22, 1987, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 10, Util.isLast(0, 1988, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 3, Util.isLast(0, 1990, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 10, Util.isFirst(0, 1, 1991, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isFirst(0, 1, 1999, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 8, Util.isLast(0, 2000, 8), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 2000, 8), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isFirst(0, 1, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isFirst(0, 1, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NzaqRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1974) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 11, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 2, 3, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 10, Util.isLast(0, 1975, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 2, Util.isLast(0, 1988, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 10, Util.isLast(0, 1975, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isLast(0, 1988, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, 8, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, 8, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 10, Util.isFirst(0, 1, 1990, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isFirst(0, 1, 2006, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 9, Util.isLast(0, 2007, 9), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isLast(0, 3200000, 9), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 9, Util.isLast(0, 2007, 9), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isLast(0, 3200000, 9), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
}

