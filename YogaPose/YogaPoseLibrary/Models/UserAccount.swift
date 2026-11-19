//
//  UserAccount.swift
//  YogaPoseLibrary
//
//  A registered user. The password itself is NEVER stored – only a salted hash.
//

import Foundation

struct UserAccount: Identifiable, Codable, Equatable {
    let id: UUID
    var fullName: String
    var username: String
    var email: String
    var passwordHash: String
    var salt: String
    let createdAt: Date
}
