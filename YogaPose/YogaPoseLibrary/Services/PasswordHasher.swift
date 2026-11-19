//
//  PasswordHasher.swift
//  YogaPoseLibrary
//
//  Salted, repeated SHA-256 hashing so passwords are never stored as plain text.
//

import Foundation
import CryptoKit
import Security

enum PasswordHasher {

    private static let rounds = 10_000

    /// Creates a random salt (16 random bytes, Base64 encoded).
    static func makeSalt() -> String {
        var bytes = [UInt8](repeating: 0, count: 16)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status != errSecSuccess {
            bytes = (0..<16).map { _ in UInt8.random(in: 0...255) }
        }
        return Data(bytes).base64EncodedString()
    }

    /// Hashes the password together with the salt.
    static func hash(password: String, salt: String) -> String {
        let saltData = Data(salt.utf8)
        var digest = Data(SHA256.hash(data: saltData + Data(password.utf8)))
        for _ in 1..<rounds {
            digest = Data(SHA256.hash(data: digest + saltData))
        }
        return digest.base64EncodedString()
    }
}
