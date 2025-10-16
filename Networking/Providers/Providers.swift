import Moya

// Пока простой стор в памяти. Позже замени на Keychain.
final class TokenStore {
    var accessToken: String?
    var refreshToken: String?

    func save(access: String, refresh: String) {
        accessToken = access
        refreshToken = refresh
        // TODO: сохранить в Keychain
    }
    func clear() {
        accessToken = nil
        refreshToken = nil
        // TODO: удалить из Keychain
    }
}

let tokenStore = TokenStore()

let authProvider = MoyaProvider<AuthAPI>(
    plugins: [
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ]
)

let profileProvider = MoyaProvider<ProfileAPI>(
    plugins: [
        AccessTokenPlugin { _ in tokenStore.accessToken ?? "" }, // добавляет Authorization: Bearer
        NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ]
)

