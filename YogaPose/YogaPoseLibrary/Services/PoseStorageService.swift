//
//  PoseStorageService.swift
//  YogaPoseLibrary
//
//  Persists the pose library as JSON inside the app's Documents folder.
//

import Foundation

/// Abstraction over persistence so it can be swapped or mocked in tests.
protocol PoseStoring {
    /// Returns the stored poses, or `nil` if nothing has been saved yet.
    func load() throws -> [Pose]?
    func save(_ poses: [Pose]) throws
}

struct PoseStorageService: PoseStoring {
    private let fileURL: URL

    init(fileName: String = "poses.json") {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = directory.appendingPathComponent(fileName)
    }

    func load() throws -> [Pose]? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([Pose].self, from: data)
    }

    func save(_ poses: [Pose]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(poses)
        try data.write(to: fileURL, options: .atomic)
    }
}
