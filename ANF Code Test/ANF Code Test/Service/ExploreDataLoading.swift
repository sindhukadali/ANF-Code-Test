//
//  ExploreDataLoading.swift
//  ANF Code Test
//
//  Created by Sindhu, K on 14/11/25.
//

import Foundation

// MARK: - Protocol

protocol ExploreDataLoading {
    func load(completion: @escaping (Result<[ANFExploreData], Error>) -> Void)
}

// MARK: - ExploreDataLoader

final class ExploreDataLoader: ExploreDataLoading {

    private let localFileName: String?

    init(localFileName: String? = nil) {
        self.localFileName = localFileName
    }

    func load(completion: @escaping (Result<[ANFExploreData], Error>) -> Void) {
         if let fileName = localFileName {
            loadFromLocal(fileName, completion: completion)
        } else {
            completion(.failure(NSError(domain: "ExploreDataLoader", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data source provided"])))
        }
    }
}

// MARK: - Local JSON Loader

private extension ExploreDataLoader {

    func loadFromLocal(_ fileName: String,
                       completion: @escaping (Result<[ANFExploreData], Error>) -> Void) {

        DispatchQueue.global(qos: .background).async {
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
                completion(.failure(
                    NSError(domain: "ExploreDataLoader",
                            code: -2,
                            userInfo: [NSLocalizedDescriptionKey: "Local JSON file not found: \(fileName).json"])
                ))
                return
            }

            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoded = try JSONDecoder().decode([ANFExploreData].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
