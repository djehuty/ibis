module culture.rules.australasia;

import chrono.month;
import culture.util;

class AustralasiaRules {
static:
public:
	class AusRule {
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
	
	class AwRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1974) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 10, Util.isLast(0, 1974, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 3, Util.isLast(0, 1974, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 10, Util.isLast(0, 1983, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1984, 3, Util.isLast(0, 1983, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 11, 17, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 3, 17, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 12, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 3, 3, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 10, Util.isLast(0, 2007, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2009, 3, Util.isLast(0, 2008, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AqRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1971) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 10, Util.isLast(0, 1971, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1972, 2, Util.isLast(0, 1971, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, Util.isLast(0, 1989, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 3, Util.isLast(0, 1991, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class HolidayRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1992) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 10, Util.isLast(0, 1992, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1994, 3, Util.isLast(0, 1993, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AsRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1971) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 10, Util.isLast(0, 1971, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 3, Util.isLast(0, 1985, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 10, 19, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 3, 19, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, Util.isLast(0, 1987, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, Util.isLast(0, 1987, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isFirst(0, 1, 2008, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AtRule {
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
	
	class AvRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1971) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 10, Util.isLast(0, 1971, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 3, Util.isLast(0, 1985, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 10, Util.isFirst(0, 15, 1986, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 3, Util.isFirst(0, 15, 1987, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 10, Util.isLast(0, 1988, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 3, Util.isLast(0, 1999, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 10, Util.isLast(0, 1988, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 1999, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 8, Util.isLast(0, 2000, 8), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 2000, 8), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isLast(0, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isLast(0, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isFirst(0, 1, 2008, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AnRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1971) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 10, Util.isLast(0, 1971, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 3, Util.isLast(0, 1985, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 10, 19, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, 19, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, Util.isLast(0, 1987, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isLast(0, 1999, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, Util.isLast(0, 1987, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 1999, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 8, Util.isLast(0, 2000, 8), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 2000, 8), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isLast(0, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isLast(0, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isFirst(0, 1, 2008, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class LhRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1981) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 10, Util.isLast(0, 1981, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 3, Util.isLast(0, 1984, 10), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 10, Util.isLast(0, 1985, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 3, Util.isLast(0, 1985, 10), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 10, 19, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, 19, 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, Util.isLast(0, 1987, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isLast(0, 1999, 10), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 10, Util.isLast(0, 1987, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 1999, 10), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 8, Util.isLast(0, 2000, 8), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 2000, 8), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isLast(0, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 10, Util.isLast(0, 2001, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isLast(0, 2007, 10), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 10, Util.isFirst(0, 1, 2008, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isFirst(0, 1, 3200000, 10), 2, 0)) {
				return 1800;
			}
			
			return 0;
		}
	}
	
	class CookRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1978) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 11, 12, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 3, 12, 0, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 10, Util.isLast(0, 1979, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 3, Util.isLast(0, 1990, 10), 0, 0)) {
				return 1800;
			}
			
			return 0;
		}
	}
	
	class FijiRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1998) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1998, 11, Util.isFirst(0, 1, 1998, 11), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 2, Util.isFirst(0, 1, 1999, 11), 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 11, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 3, 29, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2010, 10, 24, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2010, 3, 24, 3, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NcRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1977) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 12, Util.isFirst(0, 1, 1977, 12), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 2, Util.isFirst(0, 1, 1978, 12), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1996, 12, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 3, 1, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NzRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1927) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 11, 6, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 3, 6, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 10, Util.isFirst(0, 8, 1928, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 3, Util.isFirst(0, 8, 1933, 10), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 10, Util.isFirst(0, 8, 1928, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1933, 3, Util.isFirst(0, 8, 1933, 10), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1934, 9, Util.isLast(0, 1934, 9), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 4, Util.isLast(0, 1940, 9), 2, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 11, Util.isFirst(0, 1, 1974, 11), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 2, Util.isFirst(0, 1, 1974, 11), 2, 0)) {
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
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, Util.isFirst(0, 8, 1989, 10), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isFirst(0, 8, 1989, 10), 2, 0)) {
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
	
	class ChathamRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1974) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 11, Util.isFirst(0, 1, 1974, 11), 2, 45) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 2, Util.isFirst(0, 1, 1974, 11), 2, 45)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 10, Util.isLast(0, 1975, 10), 2, 45) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 2, Util.isLast(0, 1988, 10), 2, 45)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 10, Util.isLast(0, 1975, 10), 2, 45) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isLast(0, 1988, 10), 2, 45)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 10, Util.isFirst(0, 8, 1989, 10), 2, 45) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 3, Util.isFirst(0, 8, 1989, 10), 2, 45)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 10, Util.isFirst(0, 1, 1990, 10), 2, 45) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isFirst(0, 1, 2006, 10), 2, 45)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 9, Util.isLast(0, 2007, 9), 2, 45) &&
			         Util.isBefore(year, month, day, hour, minute, 2007, 3, Util.isLast(0, 3200000, 9), 2, 45)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 9, Util.isLast(0, 2007, 9), 2, 45) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 4, Util.isLast(0, 3200000, 9), 2, 45)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class TongaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1999) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1999, 10, 7, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 3, 7, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 11, Util.isFirst(0, 1, 2000, 11), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 3, Util.isFirst(0, 1, 2001, 11), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 11, Util.isFirst(0, 1, 2000, 11), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2002, 1, Util.isFirst(0, 1, 2001, 11), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class VanuatuRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1983) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 9, 25, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 3, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1984, 10, 23, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 3, 23, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 9, Util.isFirst(0, 23, 1985, 9), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 3, Util.isFirst(0, 23, 1991, 9), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1992, 10, Util.isFirst(0, 23, 1992, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 1, Util.isFirst(0, 23, 1992, 10), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
}

