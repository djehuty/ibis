module culture.rules.asia;

import chrono.month;
import culture.util;

class AsiaRules {
static:
public:
	class EuasiaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1981) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isLast(0, 3200000, 3), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(0, 3200000, 3), 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class E_eurasiaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1981) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isLast(0, 3200000, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(0, 3200000, 3), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class RussiaasiaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1981) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1983, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 3, Util.isLast(0, 1985, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 9, Util.isLast(0, 1991, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 3, Util.isLast(6, 1992, 3), 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 9, Util.isLast(6, 1992, 3), 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 3, Util.isLast(0, 1993, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isLast(0, 3200000, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 3, Util.isLast(0, 1993, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(0, 3200000, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AzerRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1997) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1997, 3, Util.isLast(0, 1997, 3), 4, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(0, 3200000, 3), 5, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class DhakaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 2009) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 6, 19, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 12, 19, 23, 59)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ShangRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1940) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 6, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 10, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 3, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 10, 16, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PrcRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1986) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 5, 4, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 9, 4, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 10, 1987, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 9, Util.isFirst(0, 10, 1991, 4), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class HkRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1941) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 4, 1, 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, 1, 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, 20, 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 12, 20, 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, 13, 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1947, 12, 13, 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 5, 2, 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 10, 2, 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, Util.isFirst(0, 1, 1949, 4), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 10, Util.isFirst(0, 1, 1953, 4), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, Util.isFirst(0, 1, 1949, 4), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1953, 11, Util.isFirst(0, 1, 1953, 4), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1954, 3, Util.isFirst(0, 18, 1954, 3), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 10, Util.isFirst(0, 18, 1964, 3), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1954, 3, Util.isFirst(0, 18, 1954, 3), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 11, Util.isFirst(0, 18, 1964, 3), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 4, Util.isFirst(0, 16, 1965, 4), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, Util.isFirst(0, 16, 1976, 4), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 12, 30, 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 30, 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 5, Util.isFirst(0, 8, 1979, 5), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 10, Util.isFirst(0, 8, 1979, 5), 3, 30)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class TaiwanRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1945) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1952, 3, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1953, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1953, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1960, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 6, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 9, 30, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MacauRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1961) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1961, 3, Util.isFirst(0, 16, 1961, 3), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 11, Util.isFirst(0, 16, 1962, 3), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1963, 3, Util.isFirst(0, 16, 1963, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 11, Util.isFirst(0, 16, 1963, 3), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1964, 3, Util.isFirst(0, 16, 1964, 3), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 11, Util.isFirst(0, 16, 1964, 3), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 3, Util.isFirst(0, 16, 1965, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 10, Util.isFirst(0, 16, 1965, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 4, Util.isFirst(0, 16, 1966, 4), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1971, 10, Util.isFirst(0, 16, 1971, 4), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1972, 4, Util.isFirst(0, 15, 1972, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1973, 10, Util.isFirst(0, 15, 1974, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1972, 4, Util.isFirst(0, 15, 1972, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, Util.isFirst(0, 15, 1974, 4), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 4, Util.isFirst(0, 15, 1975, 4), 3, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, Util.isFirst(0, 15, 1977, 4), 3, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 4, Util.isFirst(0, 15, 1978, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 10, Util.isFirst(0, 15, 1980, 4), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class CyprusRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1975) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 4, 13, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 10, 13, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 5, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, Util.isFirst(0, 1, 1980, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 9, Util.isFirst(0, 1, 1980, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 9, Util.isLast(0, 1998, 3), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class IranRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1978) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 10, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 5, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1996, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1996, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1997, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1999, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2003, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2004, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2004, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2005, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2008, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2011, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2012, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2012, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2013, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2015, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2016, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2016, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2017, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2019, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2020, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2020, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2021, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2023, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2024, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2024, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2025, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2027, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2028, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2029, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2030, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2031, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2032, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2033, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2034, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2035, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2036, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2037, 9, 21, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class IraqRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1982) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1982, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1984, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 3, 31, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1984, 10, 31, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1984, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1984, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1984, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 9, 1, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 3, Util.isLast(0, 1986, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 9, Util.isLast(0, 1990, 3), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 4, 1, 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 10, 1, 3, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ZionRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1940) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 4, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 16, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, 16, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 11, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 5, 23, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 11, 23, 2, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 9, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 11, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 11, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 9, 16, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 11, 1, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1952, 4, 20, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1952, 10, 20, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1953, 4, 12, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1953, 9, 12, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1954, 6, 13, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, 13, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1955, 6, 11, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1955, 9, 11, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 6, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1956, 9, 3, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 4, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1957, 9, 29, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 7, 7, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 10, 7, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 4, 20, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 8, 20, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 4, 14, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 9, 14, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 5, 18, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 9, 18, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1987, 9, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 4, 9, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 9, 9, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 9, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 3, 25, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 8, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 3, 24, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 9, 24, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 3, 29, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 9, 29, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 4, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 9, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1994, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 8, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1995, 3, 31, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, 31, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1996, 3, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1996, 9, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1997, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1998, 3, 20, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1998, 9, 20, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 4, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1999, 9, 2, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 10, 14, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 4, 9, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2001, 9, 9, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 3, 29, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2002, 10, 29, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2003, 3, 28, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2003, 10, 28, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2004, 4, 7, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2004, 9, 7, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2005, 4, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 3, Util.isFirst(5, 26, 2006, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(5, 26, 2010, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 3, Util.isFirst(5, 26, 2006, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 9, Util.isFirst(5, 26, 2010, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2011, 4, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2011, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2012, 3, Util.isFirst(5, 26, 2012, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2012, 9, Util.isFirst(5, 26, 2015, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2012, 3, Util.isFirst(5, 26, 2012, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2015, 9, Util.isFirst(5, 26, 2015, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2016, 4, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2016, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2017, 3, Util.isFirst(5, 26, 2017, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2017, 9, Util.isFirst(5, 26, 2021, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2017, 3, Util.isFirst(5, 26, 2017, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2021, 9, Util.isFirst(5, 26, 2021, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2022, 4, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2022, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2023, 3, Util.isFirst(5, 26, 2023, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2023, 9, Util.isFirst(5, 26, 2032, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2023, 3, Util.isFirst(5, 26, 2023, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2032, 9, Util.isFirst(5, 26, 2032, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2033, 4, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2033, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2034, 3, Util.isFirst(5, 26, 2034, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2034, 9, Util.isFirst(5, 26, 2037, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2034, 3, Util.isFirst(5, 26, 2034, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2037, 9, Util.isFirst(5, 26, 2037, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class JapanRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1948) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 5, Util.isFirst(0, 1, 1948, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 9, Util.isFirst(0, 1, 1948, 5), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, Util.isFirst(0, 1, 1949, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 9, Util.isFirst(0, 1, 1949, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 5, Util.isFirst(0, 1, 1950, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 9, Util.isFirst(0, 1, 1951, 5), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class JordanRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1973) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 6, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 10, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 9, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 4, Util.isFirst(5, 1, 1986, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, Util.isFirst(5, 1, 1988, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 5, 8, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, 8, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 4, 27, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, 27, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 4, 17, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 9, 17, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 4, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 10, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 4, Util.isFirst(5, 1, 1993, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 10, Util.isFirst(5, 1, 1998, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 4, Util.isFirst(5, 1, 1993, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1998, 9, Util.isFirst(5, 1, 1998, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 7, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2002, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 3, Util.isLast(4, 2000, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2002, 9, Util.isLast(4, 2001, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 3, Util.isLast(4, 2002, 3), 24, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2002, 9, Util.isLast(4, 3200000, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 3, Util.isLast(4, 2002, 3), 24, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(4, 3200000, 3), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class KyrgyzRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1992) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 4, Util.isFirst(0, 7, 1992, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1996, 9, Util.isFirst(0, 7, 1996, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1997, 3, Util.isLast(0, 1997, 3), 2, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 2004, 10, Util.isLast(0, 2005, 3), 2, 30)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class RokRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1960) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1960, 5, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 9, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 5, Util.isFirst(0, 8, 1987, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 10, Util.isFirst(0, 8, 1988, 5), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class LebanonRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1920) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 3, 28, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 10, 28, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 4, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 3, 26, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 10, 26, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 4, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1923, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1972, 6, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 9, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1984, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 5, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 10, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 3, Util.isLast(0, 1993, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1998, 9, Util.isLast(0, 3200000, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 3, Util.isLast(0, 1993, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(0, 3200000, 3), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NborneoRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1935) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1935, 9, 14, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 12, 14, 0, 0)) {
				return 1200;
			}
			
			return 0;
		}
	}
	
	class MongolRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1983) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1983, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1998, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 3, Util.isLast(0, 1985, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1998, 9, Util.isLast(0, 1998, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 4, Util.isLast(6, 2001, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 9, Util.isLast(6, 2001, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 3, Util.isLast(6, 2002, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 9, Util.isLast(6, 2006, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PakistanRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 2002) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 4, Util.isFirst(0, 2, 2002, 4), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 2002, 10, Util.isFirst(0, 2, 2002, 4), 0, 1)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2008, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 4, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 11, 15, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class EgyptasiaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1957) {
				return 0;
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
			
			return 0;
		}
	}
	
	class PalestineRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1999) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 4, Util.isFirst(5, 15, 1999, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2003, 10, Util.isFirst(5, 15, 2005, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 4, Util.isFirst(5, 15, 1999, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, Util.isFirst(5, 15, 2005, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2008, 8, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 3, Util.isLast(5, 2009, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 9, Util.isLast(5, 2009, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 3, Util.isLast(6, 2010, 3), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 9, Util.isLast(6, 3200000, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 3, Util.isLast(6, 2010, 3), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 8, Util.isLast(6, 3200000, 3), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PhilRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1936) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 11, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1937, 2, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1954, 4, 12, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 7, 12, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 3, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 9, 22, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SyriaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1920) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 4, Util.isFirst(0, 15, 1920, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1923, 10, Util.isFirst(0, 15, 1923, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1962, 4, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1962, 10, 29, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1963, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1963, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1963, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 4, 24, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 24, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 4, 9, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1984, 10, 9, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 2, 16, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 10, 16, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 3, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 3, 15, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 10, 15, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 3, 31, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 10, 31, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 4, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 4, 8, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 10, 8, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 3, 26, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 9, 26, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1994, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1997, 3, Util.isLast(1, 1997, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, Util.isLast(1, 1998, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 3, Util.isLast(5, 2007, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 11, Util.isLast(5, 2007, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 4, Util.isFirst(5, 1, 2008, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2008, 11, Util.isFirst(5, 1, 2008, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 3, Util.isLast(5, 2009, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(5, 2009, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 4, Util.isFirst(5, 1, 2010, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isFirst(5, 1, 3200000, 4), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
}

