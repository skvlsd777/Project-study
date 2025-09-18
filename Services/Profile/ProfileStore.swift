import Foundation

/// Простейшее локальное хранилище профилей в UserDefaults (JSON-словарём)
final class ProfileStore {
    private let key = "profiles.v1"
    private let defaults = UserDefaults.standard

    private func readAll() -> [String: AccountProfile] {
        guard let data = defaults.data(forKey: key) else { return [:] }
        return (try? JSONDecoder().decode([String: AccountProfile].self, from: data)) ?? [:]
    }

    @discardableResult
    private func writeAll(_ dict: [String: AccountProfile]) -> Bool {
        guard let data = try? JSONEncoder().encode(dict) else { return false }
        defaults.set(data, forKey: key)
        return true
    }

    // MARK: Public API

    @discardableResult
    func createProfile(username: String, email: String) -> Bool {
        var all = readAll()
        all[username] = AccountProfile(username: username, email: email, firstName: nil, lastName: nil)
        return writeAll(all)
    }

    func loadProfile(username: String) -> AccountProfile? {
        readAll()[username]
    }

    @discardableResult
    func updateProfile(_ profile: AccountProfile) -> Bool {
        var all = readAll()
        all[profile.username] = profile
        return writeAll(all)
    }

    /// На будущее, когда будем переименовывать логин
    @discardableResult
    func renameUsername(old: String, new: String) -> Bool {
        var all = readAll()
        guard let prof = all.removeValue(forKey: old) else { return false }
        all[new] = AccountProfile(username: new, email: prof.email, firstName: prof.firstName, lastName: prof.lastName)
        return writeAll(all)
    }

    func deleteProfile(username: String) {
        var all = readAll()
        all[username] = nil
        _ = writeAll(all)
    }
}


