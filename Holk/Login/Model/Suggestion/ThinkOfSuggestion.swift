import Foundation

struct ThinkOfSuggestion: Codable, Hashable {
    struct Details: Codable, Hashable {
        let header: String
        let description: String
        let paragraphs: [Paragraph]
    }

    let coverPhoto: URL
    let title: String
    let header: String
    let details: Details
    let tags: [SuggestionTag]
}

extension ThinkOfSuggestion {
    func relatedSubInsurances(OfInsurances insurances: [Insurance]) -> [Insurance.SubInsurance] {
        guard let subInsuranceTag = tags.first(where: { $0.key == .subInsurance }),
              let subInsuranceKind = Insurance.SubInsurance.Kind(rawValue: subInsuranceTag.value) else {
            return []
        }
        return insurances.flatMap { insurnace in
            insurnace.subInsurances.filter({ subInsurance in
                subInsurance.kind == subInsuranceKind
            })
        }
    }
}
