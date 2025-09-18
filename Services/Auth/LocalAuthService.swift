import Foundation
import SwiftUI
import CryptoKit
import Security

private struct CredRecord: Codable { let salt: Data; let hash: Data }

final class LocalAuthService: AuthService, ObservableObject {
    @AppStorage(AppStorageKeys.rememberMe)     var rememberMe: Bool = true
    @AppStorage(AppStorageKeys.storedUsername) private var storedUsername = ""
    @AppStorage(AppStorageKeys.isLoggedIn)     private var isLoggedInFlag = false

    private let service = "ProjectStudy.LocalAuth"

    var currentUser: AuthAccount? {
        guard isLoggedInFlag, !storedUsername.isEmpty else { return nil }
        return AuthAccount(username: storedUsername)
    }

    init() {
        // автологин при запуске, если включено «Запомнить меня»
        if rememberMe, !storedUsername.isEmpty {
            isLoggedInFlag = true
        }
    }

    // MARK: - Public API
    func register(username: String, password: String) -> Result<AuthAccount, AuthError> {
        guard !exists(username: username) else { return .failure(.userExists) }
        guard save(username: username, password: password) else { return .failure(.storageFailure) }
        storedUsername = username
        isLoggedInFlag = true
        return .success(AuthAccount(username: username))
    }

    func login(username: String, password: String) -> Result<AuthAccount, AuthError> {
        guard let rec = load(username: username) else { return .failure(.userNotFound) }
        guard verify(password: password, with: rec) else { return .failure(.badCredentials) }
        storedUsername = username
        isLoggedInFlag = true
        return .success(AuthAccount(username: username))
    }

    func logout() {
        isLoggedInFlag = false
        // По желанию: если rememberMe=false, очищай сохранённый логин:
        // if !rememberMe { storedUsername = "" }
    }

    // MARK: - Keychain + crypto
    private func key(username: String) -> [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service,
         kSecAttrAccount as String: username]
    }

    private func exists(username: String) -> Bool {
        var q = key(username: username)
        q[kSecMatchLimit as String] = kSecMatchLimitOne
        return SecItemCopyMatching(q as CFDictionary, nil) == errSecSuccess
    }

    private func makeSalt(_ n: Int = 16) -> Data {
        var d = Data(count: n)
        _ = d.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, n, $0.baseAddress!)
        }
        return d
    }

    private func hash(password: String, salt: Data) -> Data {
        var combo = Data()
        combo.append(salt)
        combo.append(password.data(using: .utf8)!)
        return Data(SHA256.hash(data: combo))
    }

    private func save(username: String, password: String) -> Bool {
        let salt = makeSalt()
        let h = hash(password: password, salt: salt)
        let rec = CredRecord(salt: salt, hash: h)
        guard let data = try? JSONEncoder().encode(rec) else { return false }

        SecItemDelete(key(username: username) as CFDictionary)
        var q = key(username: username)
        q[kSecValueData as String] = data
        return SecItemAdd(q as CFDictionary, nil) == errSecSuccess
    }

    private func load(username: String) -> CredRecord? {
        var q = key(username: username)
        q[kSecReturnData as String] = true
        q[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        guard SecItemCopyMatching(q as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data else { return nil }
        return try? JSONDecoder().decode(CredRecord.self, from: data)
    }

    private func verify(password: String, with rec: CredRecord) -> Bool {
        hash(password: password, salt: rec.salt) == rec.hash
    }
}

