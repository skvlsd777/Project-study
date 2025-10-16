import Moya

final class AuthorizedAPI {
    private let tokenStore: TokenStore
    private let auth: MoyaProvider<AuthAPI>
    private let profile: MoyaProvider<ProfileAPI>

    init(tokenStore: TokenStore,
         authProvider: MoyaProvider<AuthAPI>,
         profileProvider: MoyaProvider<ProfileAPI>) {
        self.tokenStore = tokenStore
        self.auth = authProvider
        self.profile = profileProvider
    }

    func call<T: Decodable>(_ target: ProfileAPI) async throws -> T {
        do {
            return try await profile.requestDecodable(target)
        } catch let MoyaError.statusCode(resp) where resp.statusCode == 401 {
            guard let rt = tokenStore.refreshToken else { throw MoyaError.statusCode(resp) }
            let r: AuthResponse = try await auth.requestDecodable(AuthAPI.refresh(token: rt))
            tokenStore.save(access: r.accessToken, refresh: r.refreshToken)
            return try await profile.requestDecodable(target)
        }
    }
}

