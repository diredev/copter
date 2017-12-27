import ceylon.language.meta.model {
	Type,
	UnionType
}

"Split the given union type into it's case types if they match the chosen type."
shared {Type<MatchType>*} getCaseTypesOf<MatchType>(UnionType<MatchType> forType) {
	return { for (caseType in forType.caseTypes) if (is Type<MatchType> caseType) caseType };
}
