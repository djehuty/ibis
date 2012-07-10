module culture.rules.europe;

import chrono.month;
import culture.util;

class EuropeRules {
static:
public:
	class Gb_eireRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 5, 21, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 10, 21, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 4, 8, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 9, 8, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 3, 24, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 9, 24, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 3, 30, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 9, 30, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 3, 28, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 10, 28, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 4, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 3, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 3, 26, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 10, 26, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 4, Util.isFirst(0, 16, 1923, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1924, 9, Util.isFirst(0, 16, 1923, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 4, Util.isFirst(0, 9, 1924, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1924, 9, Util.isFirst(0, 9, 1924, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1925, 4, Util.isFirst(0, 16, 1925, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 16, 1926, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 4, Util.isFirst(0, 9, 1927, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 9, 1927, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, Util.isFirst(0, 16, 1928, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 16, 1929, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1930, 4, Util.isFirst(0, 9, 1930, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 9, 1930, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1931, 4, Util.isFirst(0, 16, 1931, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 16, 1932, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 4, Util.isFirst(0, 9, 1933, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 9, 1933, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1934, 4, Util.isFirst(0, 16, 1934, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 16, 1934, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1935, 4, Util.isFirst(0, 9, 1935, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 9, 1935, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 4, Util.isFirst(0, 16, 1936, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 16, 1937, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 4, Util.isFirst(0, 9, 1938, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, Util.isFirst(0, 9, 1938, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 4, Util.isFirst(0, 16, 1939, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, Util.isFirst(0, 16, 1939, 4), 2, 0)) {
				return 3600;
			}
			
			
			
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 4, Util.isFirst(0, 2, 1942, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isFirst(0, 2, 1944, 4), 2, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 9, Util.isFirst(0, 16, 1944, 9), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isFirst(0, 16, 1944, 9), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, Util.isFirst(1, 2, 1945, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isFirst(1, 2, 1945, 4), 2, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 7, Util.isFirst(0, 9, 1945, 7), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isFirst(0, 9, 1945, 7), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isFirst(0, 9, 1946, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isFirst(0, 9, 1946, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 3, 16, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1947, 11, 16, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, 13, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1947, 11, 13, 2, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 8, 10, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1947, 11, 10, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 3, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 3, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, Util.isFirst(0, 14, 1950, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1952, 10, Util.isFirst(0, 14, 1952, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1953, 4, Util.isFirst(0, 16, 1953, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 10, Util.isFirst(0, 16, 1953, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1954, 4, Util.isFirst(0, 9, 1954, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 10, Util.isFirst(0, 9, 1954, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1955, 4, Util.isFirst(0, 16, 1955, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 10, Util.isFirst(0, 16, 1956, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 4, Util.isFirst(0, 9, 1957, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 10, Util.isFirst(0, 9, 1957, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1958, 4, Util.isFirst(0, 16, 1958, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 10, Util.isFirst(0, 16, 1959, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1960, 4, Util.isFirst(0, 9, 1960, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1960, 10, Util.isFirst(0, 9, 1960, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1961, 3, Util.isLast(0, 1961, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 10, Util.isLast(0, 1963, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1964, 3, Util.isFirst(0, 19, 1964, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 10, Util.isFirst(0, 19, 1967, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1968, 2, 18, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1968, 10, 18, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1972, 3, Util.isFirst(0, 16, 1972, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 10, Util.isFirst(0, 16, 1980, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1989, 10, Util.isLast(0, 1995, 3), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 10, Util.isLast(0, 1995, 3), 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class EuRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1977) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, Util.isFirst(0, 1, 1980, 4), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isFirst(0, 1, 1980, 4), 1, 0)) {
				return 3600;
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
	
	class W_eurRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1977) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, Util.isFirst(0, 1, 1980, 4), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isFirst(0, 1, 1980, 4), 1, 0)) {
				return 3600;
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
	
	class C_eurRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 4, 30, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 10, 30, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 4, Util.isFirst(1, 15, 1917, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 9, Util.isFirst(1, 15, 1918, 4), 2, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 3, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 10, 29, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, Util.isFirst(1, 1, 1944, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 10, Util.isFirst(1, 1, 1945, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, Util.isFirst(1, 1, 1944, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, Util.isFirst(1, 1, 1945, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, Util.isFirst(0, 1, 1980, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isFirst(0, 1, 1980, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isLast(0, 3200000, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 3200000, 10, Util.isLast(0, 3200000, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class E_eurRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1977) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, Util.isFirst(0, 1, 1980, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isFirst(0, 1, 1980, 4), 0, 0)) {
				return 3600;
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
	
	class RussiaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1917) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 7, 1, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 12, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 5, 31, 22, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 8, 31, 0, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 9, 16, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 8, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 5, 31, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 8, 31, 0, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 7, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 8, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 2, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 14, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 3, 20, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 20, 0, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 9, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 1, 0, 0)) {
				return 3600;
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
	
	class AlbaniaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1940) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 3, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 4, 29, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 5, 4, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 10, 4, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 5, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 5, 8, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, 8, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 5, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 10, 6, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 5, 5, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 9, 5, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 5, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 10, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 4, 26, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1981, 9, 26, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1982, 5, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1982, 10, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 4, 18, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1983, 10, 18, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class AustriaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1920) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 4, 5, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 9, 5, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, 6, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 10, 6, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 4, 18, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 10, 18, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 4, 6, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, 6, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class BelgiumRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 3, 9, 0, 0) &&
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
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 3, 25, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1927, 10, 25, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 4, 21, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1927, 10, 21, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 3, 29, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1927, 10, 29, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1925, 4, 4, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1927, 10, 4, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1926, 4, 17, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1927, 10, 17, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 4, 9, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1927, 10, 9, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1929, 4, 21, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 21, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1930, 4, 13, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 13, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1931, 4, 19, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 19, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 4, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 3, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 3, 26, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 26, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1934, 4, 8, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 8, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1935, 3, 31, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 31, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 4, 19, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 19, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 4, 4, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 4, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 3, 27, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 27, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 4, 16, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, 16, 2, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 2, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 5, 19, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, 19, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class BulgRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1979) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 3, 31, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 10, 31, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 4, Util.isFirst(6, 1, 1980, 4), 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, Util.isFirst(6, 1, 1982, 4), 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class CzechRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1945) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 8, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 8, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 5, 6, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 6, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, 20, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 20, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 4, 18, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 18, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, 9, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 9, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class DenmarkRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 5, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 9, 14, 23, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 8, 2, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 5, 1, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 5, 4, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1947, 8, 4, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 5, 9, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 8, 9, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ThuleRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1991) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 3, Util.isLast(0, 1991, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1992, 9, Util.isLast(0, 1992, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1993, 4, Util.isFirst(0, 1, 1993, 4), 2, 0) &&
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
	
	class FinlandRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1942) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 4, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 10, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1982, 9, Util.isLast(0, 1982, 3), 3, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class FranceRule {
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
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 3, 25, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 25, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 5, 26, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 26, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 3, 29, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 29, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1925, 4, 4, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 4, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1926, 4, 17, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 17, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 4, 9, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 9, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1929, 4, 20, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 20, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1930, 4, 12, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 12, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1931, 4, 18, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 18, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 4, 2, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 2, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 3, 25, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 25, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1934, 4, 7, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 7, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1935, 3, 30, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 30, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 4, 18, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 18, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 4, 3, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 3, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 3, 26, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 26, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 4, 15, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, 15, 23, 0)) {
				return 3600;
			}
			
			
			
			
			
			
			
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 3, 3, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 10, 8, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 8, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 2, 3, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 3, 28, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 9, 28, 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class GermanyRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1946) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, 14, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, 6, 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 6, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 5, 11, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 11, 2, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 6, 29, 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 29, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 4, 18, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 18, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, 10, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 10, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SovietzoneRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1945) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 5, 24, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 24, 2, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 9, 24, 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 24, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class GreeceRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1932) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 7, 7, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 9, 7, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 4, 7, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 11, 7, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 3, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1943, 10, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1952, 7, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1952, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 4, 12, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 11, 12, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 4, 11, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 11, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, Util.isFirst(0, 1, 1978, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 9, Util.isFirst(0, 1, 1978, 4), 4, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 4, 1, 9, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 9, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, 1, 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class HungaryRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1918) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, 1, 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 9, 1, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 4, 15, 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 9, 15, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 4, 5, 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 9, 5, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 5, 1, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 3, 31, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 31, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isFirst(0, 4, 1947, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, Util.isFirst(0, 4, 1949, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, 17, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 10, 17, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1954, 5, 23, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1955, 10, 23, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1956, 6, Util.isFirst(0, 1, 1956, 6), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1956, 9, Util.isFirst(0, 1, 1956, 6), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 6, Util.isFirst(0, 1, 1957, 6), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1957, 9, Util.isFirst(0, 1, 1957, 6), 3, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class IcelandRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1917) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 2, 19, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 10, 19, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 2, 19, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 11, 19, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 4, 29, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, 29, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 2, 25, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 11, 25, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 3, 2, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 11, 2, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 3, 8, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 10, 8, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 3, Util.isFirst(0, 1, 1943, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 10, Util.isFirst(0, 1, 1946, 3), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isFirst(0, 1, 1947, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 10, Util.isFirst(0, 1, 1967, 4), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isFirst(0, 1, 1947, 4), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1967, 10, Util.isFirst(0, 1, 1967, 4), 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class ItalyRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 6, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 10, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 3, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 3, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 3, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 9, 21, 0, 0)) {
				return 3600;
			}
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 3, 17, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, 17, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 3, 16, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1947, 10, 16, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 2, 29, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1948, 10, 29, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1966, 5, Util.isFirst(0, 22, 1966, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1969, 9, Util.isFirst(0, 22, 1968, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1969, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1969, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1970, 5, 31, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1970, 9, 31, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 5, Util.isFirst(0, 22, 1971, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1971, 9, Util.isFirst(0, 22, 1972, 5), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1971, 5, Util.isFirst(0, 22, 1971, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1972, 10, Util.isFirst(0, 22, 1972, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 6, 3, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 9, 3, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 5, 26, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 9, 26, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 5, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 5, Util.isFirst(0, 22, 1977, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, Util.isFirst(0, 22, 1979, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 5, Util.isFirst(0, 22, 1977, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 9, Util.isFirst(0, 22, 1979, 5), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class LatviaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1989) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1989, 3, Util.isLast(0, 1989, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1996, 9, Util.isLast(0, 1996, 3), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class LuxRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 5, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 10, 14, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 4, 28, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 9, 28, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, Util.isFirst(1, 15, 1918, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1918, 9, Util.isFirst(1, 15, 1918, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 3, 1, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 1, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 2, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1920, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 3, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 3, 25, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1922, 10, 25, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 4, 21, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1923, 10, 21, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 3, 29, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 10, 29, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1925, 4, 5, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 10, 5, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1926, 4, 17, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 10, 17, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 4, 9, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 10, 9, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1928, 10, 14, 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class MaltaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1973) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 3, 31, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1973, 9, 31, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 4, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 9, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 4, Util.isFirst(0, 15, 1975, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, Util.isFirst(0, 15, 1979, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 3, 31, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, 31, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NethRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 4, 16, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1917, 9, 16, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, Util.isFirst(1, 1, 1918, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 9, Util.isFirst(1, 1, 1921, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1922, 3, Util.isLast(0, 1922, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 10, Util.isLast(0, 1922, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1923, 6, Util.isFirst(5, 1, 1923, 6), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 10, Util.isFirst(5, 1, 1923, 6), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 3, Util.isLast(0, 1924, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 10, Util.isLast(0, 1924, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1925, 6, Util.isFirst(5, 1, 1925, 6), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 10, Util.isFirst(5, 1, 1925, 6), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1926, 5, 15, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 10, 15, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 5, 22, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 10, 22, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 5, 15, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1936, 10, 15, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 5, 22, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, 22, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 7, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, 1, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 5, 15, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, 15, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 9, 2, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class NorwayRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 5, 22, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 9, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 2, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, 2, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 3, Util.isFirst(0, 15, 1959, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 9, Util.isFirst(0, 15, 1964, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1965, 4, 25, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 9, 25, 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PolandRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1919) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 4, 15, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 9, 15, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, 3, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1944, 10, 3, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 29, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 11, 29, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, 14, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, 14, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 5, 4, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 4, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1948, 4, 18, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 18, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, 10, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, 10, 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1957, 6, 2, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1958, 9, 2, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1958, 3, 30, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1958, 9, 30, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1959, 5, 31, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 10, 31, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1960, 4, 3, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 10, 3, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1961, 5, Util.isLast(0, 1961, 5), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1961, 10, Util.isLast(0, 1964, 5), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1961, 5, Util.isLast(0, 1961, 5), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 9, Util.isLast(0, 1964, 5), 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class PortRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 6, 17, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 11, 17, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 2, 28, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 28, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 3, 1, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 1, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 2, 28, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 28, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1920, 2, 29, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 29, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1921, 2, 28, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1921, 10, 28, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 4, 16, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1924, 10, 16, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1926, 4, 17, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 17, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 4, 9, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 9, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1929, 4, 20, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 20, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1931, 4, 18, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 10, 18, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 4, 2, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1932, 10, 2, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1934, 4, 7, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 7, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1935, 3, 30, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 30, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1936, 4, 18, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 18, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 4, 3, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 3, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 3, 26, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1938, 10, 26, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 4, 15, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 11, 15, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 2, 24, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 10, 24, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 4, 5, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1941, 10, 5, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 3, Util.isFirst(6, 8, 1942, 3), 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, Util.isFirst(6, 8, 1945, 3), 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 4, 25, 22, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, 25, 23, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 8, 15, 22, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, 15, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 4, 17, 22, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, 17, 23, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 8, Util.isFirst(6, 25, 1943, 8), 22, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, Util.isFirst(6, 25, 1945, 8), 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1944, 4, Util.isFirst(6, 21, 1944, 4), 22, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, Util.isFirst(6, 21, 1945, 4), 23, 0)) {
				return 7200;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 4, Util.isFirst(6, 1, 1946, 4), 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, Util.isFirst(6, 1, 1946, 4), 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isFirst(0, 1, 1947, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 10, Util.isFirst(0, 1, 1949, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, Util.isFirst(0, 1, 1951, 4), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1965, 10, Util.isFirst(0, 1, 1965, 4), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 3, 27, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, 27, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 4, Util.isFirst(0, 1, 1978, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 10, Util.isFirst(0, 1, 1979, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1978, 4, Util.isFirst(0, 1, 1978, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1982, 9, Util.isFirst(0, 1, 1979, 4), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 3, Util.isLast(0, 1980, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1982, 9, Util.isLast(0, 1980, 3), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1982, 9, Util.isLast(0, 1982, 3), 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class RomaniaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1932) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1932, 5, 21, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, 21, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1933, 4, Util.isFirst(0, 2, 1933, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, Util.isFirst(0, 2, 1939, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 5, 27, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1979, 9, 27, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1980, 4, 5, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1980, 9, 5, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 3, Util.isLast(0, 1991, 3), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1993, 9, Util.isLast(0, 1993, 3), 0, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SpainRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1917) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1917, 5, 5, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 5, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1918, 4, 15, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 15, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1919, 4, 5, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1919, 10, 5, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 4, 16, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1924, 10, 16, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1926, 4, 17, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 17, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1927, 4, 9, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 9, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1928, 4, 14, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 14, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1929, 4, 20, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1929, 10, 20, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1937, 5, 22, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, 22, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1938, 3, 22, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, 22, 23, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1939, 4, 15, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1939, 10, 15, 23, 0)) {
				return 3600;
			}
			
			
			
			else if (Util.isAfter(year, month, day, hour, minute, 1943, 4, Util.isFirst(6, 13, 1943, 4), 22, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, Util.isFirst(6, 13, 1946, 4), 0, 0)) {
				return 7200;
			}
			
			
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 9, 30, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 9, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, 30, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1949, 9, 30, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 4, Util.isFirst(6, 13, 1974, 4), 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1975, 10, Util.isFirst(6, 13, 1975, 4), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 3, 27, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, 27, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, 2, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 9, 2, 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, 2, 23, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1978, 10, 2, 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class SpainafricaRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1967) {
				return 0;
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
			
			return 0;
		}
	}
	
	class SwissRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1941) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1941, 5, Util.isFirst(1, 1, 1941, 5), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 10, Util.isFirst(1, 1, 1942, 5), 2, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
	
	class TurkeyRule {
static:
public:
		
		long savings(long year, Month month, uint day, uint hour, uint minute) {
			if (year < 1916) {
				return 0;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1916, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1916, 10, 1, 0, 0)) {
				return 3600;
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
			else if (Util.isAfter(year, month, day, hour, minute, 1924, 5, 13, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1925, 10, 13, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1925, 5, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1925, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 6, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 10, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1940, 12, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1940, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1942, 4, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1942, 11, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1945, 4, 2, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1945, 10, 2, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1946, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1946, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1947, 4, Util.isFirst(0, 16, 1947, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 10, Util.isFirst(0, 16, 1948, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1949, 4, 10, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 10, 10, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1950, 4, 19, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1950, 10, 19, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1951, 4, 22, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1951, 10, 22, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1962, 7, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1962, 10, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1964, 5, 15, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1964, 10, 15, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1970, 5, Util.isFirst(0, 2, 1970, 5), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1972, 10, Util.isFirst(0, 2, 1972, 5), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1973, 6, 3, 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1973, 11, 3, 3, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1974, 3, 31, 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1974, 11, 31, 5, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1975, 3, 30, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 30, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1976, 6, 1, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1976, 10, 1, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1977, 4, Util.isFirst(0, 1, 1977, 4), 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1977, 10, Util.isFirst(0, 1, 1978, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1979, 4, Util.isFirst(0, 1, 1979, 4), 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1982, 10, Util.isFirst(0, 1, 1980, 4), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1981, 3, Util.isLast(0, 1981, 3), 3, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1982, 10, Util.isLast(0, 1982, 3), 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1983, 7, 31, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1983, 10, 31, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1985, 4, 20, 0, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1985, 9, 20, 0, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1986, 3, Util.isLast(0, 1986, 3), 2, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1990, 9, Util.isLast(0, 1990, 3), 2, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 3, Util.isLast(0, 1991, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 1995, 9, Util.isLast(0, 2006, 3), 1, 0)) {
				return 3600;
			}
			else if (Util.isAfter(year, month, day, hour, minute, 1991, 3, Util.isLast(0, 1991, 3), 1, 0) &&
			         Util.isBefore(year, month, day, hour, minute, 2006, 10, Util.isLast(0, 2006, 3), 1, 0)) {
				return 3600;
			}
			
			return 0;
		}
	}
}

