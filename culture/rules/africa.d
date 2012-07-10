module culture.rules.africa;

import chrono.month;
import culture.util;

class AfricaRules {
static:
public:
	class AlgeriaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 6, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 3, 24, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 24, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 3, 9, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 9, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 3, 1, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 1, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 2, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 10, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 3, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 6, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 9, 11, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, 11, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, Util.isFirst(1, 1, 1944, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 10, Util.isFirst(1, 1, 1945, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, Util.isFirst(1, 1, 1944, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, Util.isFirst(1, 1, 1945, 4), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 4, 25, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1971, 9, 25, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 5, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 3, 24, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 9, 24, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 4, 25, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 10, 25, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class EgyptRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1940) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 7, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 10, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 4, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 5, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1958, 10, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1958, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1958, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 5, 1, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 9, 1, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 5, 1, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 10, 1, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1982, 7, 25, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 10, 25, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 7, 12, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 10, 12, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1984, 5, 1, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 10, 1, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 5, 6, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 10, 6, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 5, 1, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 10, 1, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1995, 4, Util.isLast(5, 1995, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 9, Util.isLast(5, 2010, 4), 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1995, 4, Util.isLast(5, 1995, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 8, Util.isLast(5, 2010, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1995, 4, Util.isLast(5, 1995, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 9, Util.isLast(5, 2010, 4), 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 9, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 8, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 9, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 9, 10, 23, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class GhanaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1936) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 9, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 12, 1, 0, 0)) {
				return 1200;
			}
			
			return 0;
		}
	}
	
	class LibyaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1951) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 10, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1952, 1, 14, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1953, 10, 9, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 1, 9, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1955, 9, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1956, 1, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1982, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 4, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 10, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 4, 4, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 10, 4, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 10, 1, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MauritiusRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1982) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1982, 10, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1983, 3, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isLast(0, 2008, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 3, Util.isLast(0, 2008, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MoroccoRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1939) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 9, 12, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, 12, 0, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 6, 11, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 10, 11, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 6, 3, 12, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1967, 10, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 6, 24, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 9, 24, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 8, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 8, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2008, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 8, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 5, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 8, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2011, 4, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2011, 7, 3, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NamibiaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1994) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1994, 9, Util.isFirst(0, 1, 1994, 9), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 9), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SlRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1935) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1935, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 10, 1, 0, 0)) {
				return 2400;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1962, 9, 1, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1942) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 9, Util.isFirst(0, 15, 1942, 9), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 3, Util.isFirst(0, 15, 1943, 9), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SudanRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1970) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1970, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 10, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1972, 4, Util.isLast(0, 1972, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 10, Util.isLast(0, 1985, 4), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class TunisiaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1939) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 4, 15, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, 15, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 2, 25, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 10, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 3, 9, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 11, 9, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 3, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 4, 29, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 3, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 10, 29, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 4, 25, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 4, 25, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 4, 25, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 10, 25, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, Util.isFirst(1, 1, 1944, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 10, Util.isFirst(1, 1, 1945, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, Util.isFirst(1, 1, 1944, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, Util.isFirst(1, 1, 1945, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 3, 26, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 9, 26, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2005, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 9, 1, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 3, Util.isLast(0, 2006, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2008, 10, Util.isLast(0, 2008, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
}

