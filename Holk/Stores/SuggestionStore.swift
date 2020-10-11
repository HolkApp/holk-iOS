//
//  SuggestionStore.swift
//  Holk
//
//  Created by 张梦皓 on 2020-06-11.
//  Copyright © 2020 Holk. All rights reserved.
//

import Foundation
import Combine

final class SuggestionStore {
    // MARK: Public variables
    @Published var gaps: [GapSuggestion] = []
    @Published var thinkOfs: [ThinkOfSuggestion] = []

    // MARK: - Private variables
    private let user: User
    private let suggestionService: SuggestionService
    private var cancellables = Set<AnyCancellable>()

    init(queue: DispatchQueue, user: User) {
        self.user = user
        suggestionService = SuggestionService(client: APIClient(queue: queue), user: user)
    }

    func fetchAllSuggestions(completion: @escaping (Result<SuggestionsListResponse, APIError>) -> Void = { _ in }) {
        suggestionService.fetchAllSuggestions()
            .sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .finished:
                break
            }
        }) { [weak self] suggestionsListResponse in
            self?.gaps = suggestionsListResponse.gaps
            self?.thinkOfs = suggestionsListResponse.thinkOfs
            completion(.success(suggestionsListResponse))
        }.store(in: &cancellables)
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
    }
}

extension SuggestionStore {
    func thinkOfs(_ subInsurance: Insurance.SubInsurance) -> [ThinkOfSuggestion] {
        return thinkOfs.filter {
            return $0.tags.contains { tag in
                tag.key == .subInsurance && tag.value == subInsurance.kind.rawValue
            }
        }
    }
}
