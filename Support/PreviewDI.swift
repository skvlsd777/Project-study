#if DEBUG
import Moya

enum PreviewDI {
    static let tokenStore = TokenStore()

    // Провайдеры Moya, которые не ходят в сеть — отдают sampleData
    static let authProvider    = MoyaProvider<AuthAPI>(stubClosure: { _ in .immediate })
    static let profileProvider = MoyaProvider<ProfileAPI>(stubClosure: { _ in .immediate })

    // Сервисы поверх этих провайдеров
    static let authService: AuthService = AuthServiceMoya(
        provider: authProvider,
        tokenStore: tokenStore
    )

    static let authorizedAPI = AuthorizedAPI(
        tokenStore: tokenStore,
        authProvider: authProvider,
        profileProvider: profileProvider
    )
    static let profileService: ProfileService = ProfileServiceMoya(api: authorizedAPI)
}
#endif

 
