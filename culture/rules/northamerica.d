module culture.rules.northamerica;

import chrono.month;
import culture.util;

class NorthamericaRules {
static:
public:
	class UsRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 3, Util.isLast(0, 1918, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, Util.isLast(0, 1919, 3), 2, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 8, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 4, Util.isLast(0, 1967, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 1973, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 1, 6, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, 6, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 2, 23, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, 23, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 4, Util.isLast(0, 1976, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 1, 1987, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 3, Util.isFirst(0, 8, 2007, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 11, Util.isFirst(0, 8, 3200000, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NycRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1920) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 3, Util.isLast(0, 1920, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 10, Util.isLast(0, 1920, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 4, Util.isLast(0, 1921, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 4, Util.isLast(0, 1921, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1966, 10, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ChicagoRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1920) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 6, 13, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 13, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 3, Util.isLast(0, 1921, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, Util.isLast(0, 1921, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 4, Util.isLast(0, 1922, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 4, Util.isLast(0, 1922, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1966, 10, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class DenverRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1920) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 3, Util.isLast(0, 1920, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 10, Util.isLast(0, 1921, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 3, Util.isLast(0, 1920, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 5, Util.isLast(0, 1921, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 4, Util.isLast(0, 1965, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1966, 10, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class CaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1948) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 3, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 1, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, Util.isLast(0, 1950, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 9, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, Util.isLast(0, 1950, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1966, 10, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class IndianapolisRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1941) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 6, 22, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, 22, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, Util.isLast(0, 1954, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MarengoRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1951) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, Util.isLast(0, 1951, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 9, Util.isLast(0, 1951, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1954, 4, Util.isLast(0, 1954, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 9, Util.isLast(0, 1960, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class VincennesRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1946) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, Util.isLast(0, 1946, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1953, 4, Util.isLast(0, 1953, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, Util.isLast(0, 1954, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1955, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 4, Util.isLast(0, 1956, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, Util.isLast(0, 1963, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 4, Util.isLast(0, 1956, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1963, 10, Util.isLast(0, 1963, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PerryRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1946) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, Util.isLast(0, 1946, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1953, 4, Util.isLast(0, 1953, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, Util.isLast(0, 1954, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1955, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 4, Util.isLast(0, 1956, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, Util.isLast(0, 1963, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 4, Util.isLast(0, 1956, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1963, 10, Util.isLast(0, 1963, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PikeRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1955) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1955, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 4, Util.isLast(0, 1956, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 9, Util.isLast(0, 1964, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 4, Util.isLast(0, 1956, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 10, Util.isLast(0, 1964, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class StarkeRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1947) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isLast(0, 1947, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, Util.isLast(0, 1961, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isLast(0, 1947, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 10, Util.isLast(0, 1961, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PulaskiRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1946) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, Util.isLast(0, 1960, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 9, Util.isLast(0, 1960, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class LouisvilleRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1921) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 4, Util.isLast(0, 1941, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, Util.isLast(0, 1961, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class DetroitRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1948) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 4, Util.isLast(0, 1948, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 9, Util.isLast(0, 1948, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 6, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1967, 10, 14, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MenomineeRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1946) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, Util.isLast(0, 1946, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 4, Util.isLast(0, 1966, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1966, 10, Util.isLast(0, 1966, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class CanadaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 10, 14, 2, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 8, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 4, Util.isLast(0, 1974, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 1, 1987, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 3, Util.isFirst(0, 8, 2007, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 11, Util.isFirst(0, 8, 3200000, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class StjohnsRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1917) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 4, 8, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 9, 8, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 5, 5, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 8, 5, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 5, Util.isFirst(0, 1, 1920, 5), 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1935, 10, Util.isFirst(0, 1, 1935, 5), 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 5, Util.isFirst(1, 9, 1936, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 10, Util.isFirst(1, 9, 1941, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 5, Util.isFirst(0, 8, 1946, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 10, Util.isFirst(0, 8, 1950, 5), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, Util.isLast(0, 1951, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, Util.isLast(0, 1951, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1986, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 1, 1987, 4), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 1987, 4), 0, 1)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 4, Util.isFirst(0, 1, 1988, 4), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 1988, 4), 0, 1)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 4, Util.isFirst(0, 1, 1989, 4), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 4), 0, 1)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 3, Util.isFirst(0, 8, 2007, 3), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 11, Util.isFirst(0, 8, 3200000, 3), 0, 1)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class HalifaxRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 5, 9, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 8, 9, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 5, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 9, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 9, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 5, Util.isFirst(0, 1, 1923, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1923, 9, Util.isFirst(0, 1, 1925, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 5, Util.isFirst(0, 1, 1923, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1925, 9, Util.isFirst(0, 1, 1925, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1926, 5, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1926, 9, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1927, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 5, Util.isFirst(0, 8, 1928, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 9, Util.isFirst(0, 8, 1931, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 5, Util.isFirst(0, 8, 1928, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, Util.isFirst(0, 8, 1931, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1933, 10, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1934, 5, 20, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1934, 9, 20, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1935, 6, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1935, 9, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 5, Util.isFirst(0, 1, 1937, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, Util.isFirst(0, 1, 1938, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 5, 28, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, 28, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 5, Util.isFirst(0, 1, 1940, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, Util.isFirst(0, 1, 1941, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 9, Util.isLast(0, 1949, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, Util.isLast(0, 1951, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1954, 9, Util.isLast(0, 1954, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 4, Util.isLast(0, 1956, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 9, Util.isLast(0, 1959, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1962, 4, Util.isLast(0, 1962, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1973, 10, Util.isLast(0, 1973, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MonctonRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1933) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 6, Util.isFirst(0, 8, 1933, 6), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1935, 9, Util.isFirst(0, 8, 1935, 6), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 6, Util.isFirst(0, 1, 1936, 6), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 9, Util.isFirst(0, 1, 1938, 6), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 5, 27, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, 27, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 5, 19, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, 19, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 5, 4, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 9, 4, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1956, 9, Util.isLast(0, 1972, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1972, 10, Util.isLast(0, 1972, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 4, Util.isFirst(0, 1, 1993, 4), 0, 1) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 4), 0, 1)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MontRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1917) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 3, 25, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 4, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 3, 31, 2, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 31, 2, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 5, 2, 2, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 10, 2, 2, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 10, 1, 2, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 4, 30, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 10, 30, 2, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 5, 17, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1926, 9, 17, 2, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1925, 5, Util.isFirst(0, 1, 1925, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1926, 9, Util.isFirst(0, 1, 1926, 5), 2, 30)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, Util.isLast(0, 1928, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, Util.isLast(0, 1931, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 4, Util.isLast(0, 1933, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1933, 10, Util.isLast(0, 1940, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 9, Util.isLast(0, 1973, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1973, 10, Util.isLast(0, 1973, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class TorontoRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1919) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 3, 30, 23, 30) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 5, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 9, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 5, 15, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 9, 15, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 5, Util.isFirst(0, 8, 1922, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1926, 9, Util.isFirst(0, 8, 1923, 5), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 5, Util.isFirst(0, 1, 1924, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1926, 9, Util.isFirst(0, 1, 1927, 5), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 5, Util.isFirst(0, 1, 1924, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, Util.isFirst(0, 1, 1927, 5), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, Util.isLast(0, 1928, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, Util.isLast(0, 1931, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 4, Util.isLast(0, 1933, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1933, 10, Util.isLast(0, 1940, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, Util.isLast(0, 1946, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isLast(0, 1947, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 9, Util.isLast(0, 1949, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isLast(0, 1947, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 11, Util.isLast(0, 1949, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, Util.isLast(0, 1950, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 11, Util.isLast(0, 1973, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, Util.isLast(0, 1950, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1973, 10, Util.isLast(0, 1973, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class WinnRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 4, 23, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 9, 23, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 5, 16, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1937, 9, 16, 2, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 8, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 5, 12, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, 12, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isLast(0, 1947, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 9, Util.isLast(0, 1949, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, Util.isLast(0, 1951, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1958, 9, Util.isLast(0, 1960, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, Util.isLast(0, 1951, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 9, Util.isLast(0, 1960, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1963, 4, Util.isLast(0, 1963, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1963, 9, Util.isLast(0, 1963, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 4, Util.isLast(0, 1966, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 1, 1987, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, Util.isFirst(0, 1, 2005, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ReginaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1930, 5, Util.isFirst(0, 1, 1930, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1934, 10, Util.isFirst(0, 1, 1934, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 4, Util.isFirst(0, 8, 1937, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1937, 10, Util.isFirst(0, 8, 1941, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 4, Util.isFirst(0, 8, 1937, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 10, Util.isFirst(0, 8, 1941, 4), 0, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 8, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isFirst(0, 8, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isFirst(0, 8, 1946, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isLast(0, 1947, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1957, 9, Util.isLast(0, 1957, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 4, Util.isLast(0, 1959, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 10, Util.isLast(0, 1959, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SwiftRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1957) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 4, Util.isLast(0, 1957, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1957, 10, Util.isLast(0, 1957, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 4, Util.isLast(0, 1959, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1959, 10, Util.isLast(0, 1961, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 4, Util.isLast(0, 1959, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 9, Util.isLast(0, 1961, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class EdmRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, Util.isFirst(0, 8, 1918, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 10, Util.isFirst(0, 8, 1919, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, Util.isFirst(0, 8, 1918, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 5, Util.isFirst(0, 8, 1919, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 4, Util.isLast(0, 1920, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 10, Util.isLast(0, 1923, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 4, Util.isLast(0, 1920, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1923, 9, Util.isLast(0, 1923, 4), 2, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 8, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isLast(0, 1947, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1947, 9, Util.isLast(0, 1947, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 4, Util.isLast(0, 1967, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1967, 10, Util.isLast(0, 1967, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1969, 4, Util.isLast(0, 1969, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1969, 10, Util.isLast(0, 1969, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1972, 4, Util.isLast(0, 1972, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class VancRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 10, 14, 2, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 8, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isLast(0, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class Nt_ykRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 5, 25, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 11, 25, 0, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 8, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 4, Util.isLast(0, 1965, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 10, Util.isLast(0, 1965, 4), 2, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 4, Util.isLast(0, 1980, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 1, 1987, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ResoluteRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 3200000) {
				return 0;
			}
			
			
			return 0;
		}
	}
	
	class MexicoRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1939) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 2, 5, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 6, 5, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 12, 9, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 4, 9, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 12, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 5, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 2, 12, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 7, 12, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1996, 4, Util.isFirst(0, 1, 1996, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2000, 10, Util.isFirst(0, 1, 2000, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2001, 5, Util.isFirst(0, 1, 2001, 5), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2001, 9, Util.isFirst(0, 1, 2001, 5), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2002, 4, Util.isFirst(0, 1, 2002, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isFirst(0, 1, 3200000, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class BahamasRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1964) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1964, 4, Util.isLast(0, 1964, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 10, Util.isLast(0, 1975, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class BarbRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1977) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 6, 12, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 10, 12, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 4, Util.isFirst(0, 15, 1978, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 10, Util.isFirst(0, 15, 1980, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 4, Util.isFirst(0, 15, 1978, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, Util.isFirst(0, 15, 1980, 4), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class BelizeRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 10, Util.isFirst(0, 2, 1918, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 2, Util.isFirst(0, 2, 1942, 10), 0, 0)) {
				return 1800;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 12, 5, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 2, 5, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1982, 12, 18, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1983, 2, 18, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class CrRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1979) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 2, Util.isLast(0, 1979, 2), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 6, Util.isLast(0, 1980, 2), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 1, Util.isFirst(6, 15, 1991, 1), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 7, Util.isFirst(6, 15, 1992, 1), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 1, Util.isFirst(6, 15, 1991, 1), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 3, Util.isFirst(6, 15, 1992, 1), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class CubaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1928) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 6, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 10, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 6, Util.isFirst(0, 1, 1940, 6), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 9, Util.isFirst(0, 1, 1942, 6), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 6, Util.isFirst(0, 1, 1945, 6), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, Util.isFirst(0, 1, 1946, 6), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 5, 29, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1966, 10, 29, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1967, 4, 8, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 9, 8, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1968, 4, 14, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 9, 14, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1969, 4, Util.isLast(0, 1969, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1971, 10, Util.isLast(0, 1977, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1969, 4, Util.isLast(0, 1969, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, Util.isLast(0, 1977, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 5, 7, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, 7, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 3, Util.isFirst(0, 15, 1979, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, Util.isFirst(0, 15, 1980, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 5, Util.isFirst(0, 5, 1981, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, Util.isFirst(0, 5, 1985, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 3, Util.isFirst(0, 14, 1986, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, Util.isFirst(0, 14, 1989, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 4, Util.isFirst(0, 1, 1990, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 10, Util.isFirst(0, 1, 1997, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1990, 4, Util.isFirst(0, 1, 1990, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 10, Util.isFirst(0, 1, 1997, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1998, 3, Util.isLast(0, 1998, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2003, 10, Util.isLast(0, 1999, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2000, 4, Util.isFirst(0, 1, 2000, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2003, 10, Util.isFirst(0, 1, 2004, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 3, Util.isFirst(0, 8, 2007, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isFirst(0, 8, 2007, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2008, 3, Util.isFirst(0, 15, 2008, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isFirst(0, 15, 2008, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2009, 3, Util.isFirst(0, 8, 2009, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isFirst(0, 8, 2010, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2011, 3, Util.isFirst(0, 15, 2011, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isFirst(0, 15, 2011, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2012, 3, Util.isFirst(0, 8, 2012, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isFirst(0, 8, 3200000, 3), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class DrRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1966) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 10, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1967, 2, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1969, 10, Util.isLast(0, 1969, 10), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 1, Util.isLast(0, 1973, 10), 0, 0)) {
				return 1800;
			}
			
			return 0;
		}
	}
	
	class SalvRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1987) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 5, Util.isFirst(0, 1, 1987, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 9, Util.isFirst(0, 1, 1988, 5), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class GuatRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1973) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 11, 25, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 2, 25, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 5, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1983, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 3, 23, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1991, 9, 23, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 4, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, 30, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class HaitiRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1983) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 5, 8, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1987, 10, 8, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1984, 4, Util.isLast(0, 1984, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1987, 10, Util.isLast(0, 1987, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1988, 4, Util.isFirst(0, 1, 1988, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1997, 10, Util.isFirst(0, 1, 1997, 4), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2005, 4, Util.isFirst(0, 1, 2005, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 4), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class HondRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1987) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 5, Util.isFirst(0, 1, 1987, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1988, 9, Util.isFirst(0, 1, 1988, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 5, Util.isFirst(0, 1, 2006, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 8, Util.isFirst(0, 1, 2006, 5), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NicRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1979) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 3, Util.isFirst(0, 16, 1979, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 6, Util.isFirst(0, 16, 1980, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2005, 4, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2005, 10, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2006, 4, 30, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, 30, 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class TcRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1979) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 4, Util.isLast(0, 1979, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 1986, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1987, 4, Util.isFirst(0, 1, 1987, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isFirst(0, 1, 2006, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 2007, 3, Util.isFirst(0, 8, 2007, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 11, Util.isFirst(0, 8, 3200000, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
}

