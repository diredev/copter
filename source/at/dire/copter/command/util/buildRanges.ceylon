import ceylon.collection {
	ArrayList
}

"This convenience method will create ranges from a list of integers."
shared [Range<Integer>*] buildRanges({Integer*} values) {
	value sorted = sort(values);

	value firstOrNull = sorted.first;

	if(!exists firstOrNull) {
		return [];
	}

	value result = ArrayList<Range<Integer>>();

	// Automatically build ranges??
	variable Integer first = firstOrNull;
	variable Integer previous = firstOrNull;

	for(intValue in sorted.rest) {
		// Skipped a range?
		if(intValue > previous+1) {
			// Current value does not match group. Return.
			//TODO: simplify...
			/*if(first == previous) {
				result.add(first..first);
			} else {*/
				result.add(first..previous);
			first=intValue;
			//}
		}

		previous = intValue;
	}

	// Add remaining entry
	result.add(first..previous);

	return result.sequence();
}