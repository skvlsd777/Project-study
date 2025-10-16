import Foundation
import Moya

protocol AuthService {
    func register(_ r: RegisterRequest) async throws -> ProfileResponse
    func login(_ r: LoginRequest) async throws -> ProfileResponse
    func logout()
}

final class AuthServiceMoya: AuthService {
    private let provider: MoyaProvider<AuthAPI>
    private let tokenStore: TokenStore
    private(set) var currentUser: ProfileResponse?

    init(provider: MoyaProvider<AuthAPI>, tokenStore: TokenStore) {
        self.provider = provider
        self.tokenStore = tokenStore
    }

    // ⬇️ ВАЖНО: сигнатуры строго под протокол (DTO)
    func register(_ r: RegisterRequest) async throws -> ProfileResponse {
        let resp: AuthResponse = try await provider.requestDecodable(AuthAPI.register(r))
        tokenStore.save(access: resp.accessToken, refresh: resp.refreshToken)
        currentUser = resp.user
        return resp.user
    }

    func login(_ r: LoginRequest) async throws -> ProfileResponse {
        let resp: AuthResponse = try await provider.requestDecodable(AuthAPI.login(r))
        tokenStore.save(access: resp.accessToken, refresh: resp.refreshToken)
        currentUser = resp.user
        return resp.user
    }

    func logout() {
        tokenStore.clear()
        currentUser = nil
    }

    // Доп. свойства/геттеры можно оставить — они не мешают конформности,
    // просто их не будет видно с типом `any AuthService`.
    var rememberMe: Bool {
        get { UserDefaults.standard.bool(forKey: "rememberMe") }
        set { UserDefaults.standard.set(newValue, forKey: "rememberMe") }
    }
}

protocol ProfileService {
    func me() async throws -> ProfileResponse
    func update(_ r: ProfileUpdateRequest) async throws -> ProfileResponse
    func deleteMe() async throws
    func uploadAvatar(_ imageData: Data, filename: String, mime: String) async throws -> String
}

final class ProfileServiceMoya: ProfileService {
    private let api: AuthorizedAPI
    init(api: AuthorizedAPI) { self.api = api }

    func me() async throws -> ProfileResponse {
        try await api.call(.me)
    }

    func update(_ r: ProfileUpdateRequest) async throws -> ProfileResponse {
        try await api.call(.update(r))
    }

    func deleteMe() async throws {
        struct Empty: Decodable {}
        let _: Empty = try await api.call(.deleteMe)
    }

    func uploadAvatar(_ imageData: Data, filename: String, mime: String) async throws -> String {
        struct UploadResp: Decodable { let avatar: String }
        let resp: UploadResp = try await api.call(.uploadAvatar(data: imageData, filename: filename, mime: mime))
        return resp.avatar
    }
}

