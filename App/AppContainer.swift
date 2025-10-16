import Foundation
import Moya

final class AppContainer {
    let tokenStore = TokenStore()

    #if DEBUG
    private let useStubs = true
    #else
    private let useStubs = false
    #endif

    private let logger = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))

    lazy var authProvider: MoyaProvider<AuthAPI> = {
        useStubs
        ? MoyaProvider<AuthAPI>(stubClosure: { _ in .delayed(seconds: 0.5) }, plugins: [logger])
        : MoyaProvider<AuthAPI>(plugins: [logger])
    }()

    lazy var profileProvider: MoyaProvider<ProfileAPI> = {
        useStubs
        ? MoyaProvider<ProfileAPI>(stubClosure: { _ in .delayed(seconds: 0.5) }, plugins: [logger])
        : MoyaProvider<ProfileAPI>(plugins: [
            AccessTokenPlugin { _ in self.tokenStore.accessToken ?? "" },
            logger
        ])
    }()

    // Сервисы
    lazy var authService: AuthService = AuthServiceMoya(
        provider: authProvider,
        tokenStore: tokenStore
    )

    lazy var authorizedAPI = AuthorizedAPI(
        tokenStore: tokenStore,
        authProvider: authProvider,
        profileProvider: profileProvider
    )

    lazy var profileService: ProfileService = ProfileServiceMoya(api: authorizedAPI)
}

