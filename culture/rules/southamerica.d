module culture.rules.southamerica;

import chrono.month;
import culture.util;

class SouthamericaRules {
static:
public:
	class ArgRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1930) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1930, 12, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1931, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1931, 10, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1931, 4, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 11, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 7, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 10, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 6, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 10, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 8, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1963, 12, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1963, 10, 15, 0, 0)) {
				return 3600;
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
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 12, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, Util.isFirst(0, 15, 1989, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 3, Util.isFirst(0, 15, 1992, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 10, Util.isFirst(0, 1, 1999, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 3, Util.isFirst(0, 1, 1999, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 12, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 3, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isFirst(0, 15, 2008, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 3, Util.isFirst(0, 15, 2008, 10), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SanluisRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 2007) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 10, Util.isFirst(0, 8, 2007, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 3, Util.isFirst(0, 8, 2009, 10), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class BrazilRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1931) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1931, 10, 3, 11, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1933, 4, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 10, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1933, 4, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 12, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1952, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1963, 12, 9, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 3, 9, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 1, 31, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 3, 31, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 12, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 11, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 11, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 3, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 10, 25, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 3, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, 25, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1987, 2, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 10, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 2, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 1, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 10, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 2, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 10, 20, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 2, 20, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 10, 25, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 2, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 10, Util.isFirst(0, 11, 1993, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 1, Util.isFirst(0, 11, 1995, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 10, Util.isFirst(0, 11, 1993, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 2, Util.isFirst(0, 11, 1995, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1996, 10, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1996, 2, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1997, 10, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 2, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1998, 10, 11, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1998, 3, 11, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 10, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1999, 2, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 10, Util.isFirst(0, 8, 2000, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 2, Util.isFirst(0, 8, 2001, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 10, Util.isFirst(0, 8, 2000, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 2, Util.isFirst(0, 8, 2001, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 11, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 2, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2003, 10, 19, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 2, 19, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2004, 11, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 2, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2005, 10, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 2, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 11, 5, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 2, 5, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 10, Util.isFirst(0, 8, 2007, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 2, Util.isFirst(0, 8, 2007, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isFirst(0, 15, 2008, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2011, 2, Util.isFirst(0, 15, 3200000, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isFirst(0, 15, 2008, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 2, Util.isFirst(0, 15, 3200000, 10), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ChileRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1927) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 9, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 8, 1, 5, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 6, 1, 4, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 7, 15, 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, 15, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1968, 11, 3, 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1969, 3, 3, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1969, 11, 23, 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1969, 3, 23, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1970, 10, Util.isFirst(0, 9, 1970, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1970, 3, Util.isFirst(0, 9, 1972, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1970, 10, Util.isFirst(0, 9, 1970, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 3, Util.isFirst(0, 9, 1972, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 9, 30, 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 3, 30, 3, 0)) {
				return 3600;
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
			         Util.isBefore(year, month, day, hour, minute, 1999, 4, Util.isFirst(0, 9, 2010, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 10, Util.isFirst(0, 9, 1999, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 4, Util.isFirst(0, 9, 2010, 10), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2011, 8, Util.isFirst(0, 16, 2011, 8), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2011, 5, Util.isFirst(0, 16, 2011, 8), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2012, 10, Util.isFirst(0, 9, 2012, 10), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 3, Util.isFirst(0, 9, 3200000, 10), 3, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class CoRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1992) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 5, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 4, 3, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class FalkRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1937) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 9, Util.isLast(0, 1937, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 3, Util.isLast(0, 1938, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 9, Util.isLast(0, 1940, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 3, Util.isLast(0, 1942, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 9, Util.isLast(0, 1983, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 4, Util.isLast(0, 1983, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1984, 9, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 4, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 9, Util.isFirst(0, 9, 1985, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 4, Util.isFirst(0, 9, 2000, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 9, Util.isFirst(0, 9, 1985, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 4, Util.isFirst(0, 9, 2000, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 9, Util.isFirst(0, 1, 2001, 9), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 4, Util.isFirst(0, 1, 3200000, 9), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 9, Util.isFirst(0, 1, 2001, 9), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 9), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ParaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1975) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 4, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 10, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 4, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 10, 5, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 3, 5, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 3, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 2, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1996, 10, Util.isFirst(0, 1, 1996, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1996, 3, Util.isFirst(0, 1, 2001, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1996, 10, Util.isFirst(0, 1, 1996, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2001, 3, Util.isFirst(0, 1, 2001, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 9, Util.isFirst(0, 1, 2002, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2004, 4, Util.isFirst(0, 1, 2003, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2004, 10, Util.isFirst(0, 15, 2004, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2004, 4, Util.isFirst(0, 15, 2009, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2004, 10, Util.isFirst(0, 15, 2004, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 3, Util.isFirst(0, 15, 2009, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 10, Util.isFirst(0, 1, 2010, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 10), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PeruRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1938) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 1, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 9, Util.isLast(0, 1938, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 4, Util.isLast(0, 1939, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 9, Util.isLast(0, 1938, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 3, Util.isLast(0, 1939, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 1, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1987, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 1, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 4, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1994, 1, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 4, 1, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class UruguayRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1923) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 10, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1926, 4, 2, 0, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1926, 4, 1, 0, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 10, Util.isLast(0, 1933, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 3, Util.isLast(0, 1935, 10), 23, 30)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 11, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 3, 1, 23, 30)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 10, Util.isLast(0, 1937, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 3, Util.isLast(0, 1940, 10), 0, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 8, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 3, 1, 0, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 12, 14, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 1, 14, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 5, 24, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 11, 24, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1960, 1, 17, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 3, 17, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 4, Util.isFirst(0, 1, 1965, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 9, Util.isFirst(0, 1, 1967, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 4, Util.isFirst(0, 1, 1965, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1967, 10, Util.isFirst(0, 1, 1967, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1968, 5, 27, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1970, 12, 27, 0, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1972, 4, 24, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1972, 8, 24, 0, 0)) {
				return 3600;
			}
			
			
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 12, 4, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 4, 4, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 10, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 5, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 12, 14, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 3, 14, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 12, 11, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 3, 11, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, 29, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, 29, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 10, Util.isFirst(0, 21, 1990, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 3, Util.isFirst(0, 21, 1991, 10), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 10, 18, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 3, 18, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2004, 9, 19, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, 19, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2005, 10, 9, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, 9, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 3, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 3, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
}

