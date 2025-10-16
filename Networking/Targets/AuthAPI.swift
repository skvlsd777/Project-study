import Foundation
import Moya

enum AuthAPI {
    case register(RegisterRequest)
    case login(LoginRequest)
    case refresh(token: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL { APIConfig.baseURL }

    var path: String {
        switch self {
        case .register: return "/auth/register"
        case .login:    return "/auth/login"
        case .refresh:  return "/auth/refresh"
        }
    }

    var method: Moya.Method { .post }

    var task: Task {
        switch self {
        case .register(let body): return .requestJSONEncodable(body)
        case .login(let body):    return .requestJSONEncodable(body)
        case .refresh(let token): return .requestJSONEncodable(["refreshToken": token])
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    // Заглушки для .immediatelyStub (удобно пока бэк не готов)
    var sampleData: Data {
        switch self {
        case .register, .login:
            return Data(#"{"user":{"id":1,"username":"demo","email":"demo@ex.com"},"accessToken":"A","refreshToken":"R","expiresIn":3600}"#.utf8)
        case .refresh:
            return Data(#"{"accessToken":"A2","refreshToken":"R2","expiresIn":3600}"#.utf8)
        }
    }
}

