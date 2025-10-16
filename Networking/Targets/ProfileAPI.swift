import Foundation
import Moya

enum ProfileAPI {
    case me
    case update(ProfileUpdateRequest)
    case deleteMe
    case uploadAvatar(data: Data, filename: String, mime: String) // multipart
}

extension ProfileAPI: TargetType {
    var baseURL: URL { APIConfig.baseURL }

    var path: String {
        switch self {
        case .me, .update, .deleteMe: return "/me"
        case .uploadAvatar:           return "/me/avatar"
        }
    }

    var method: Moya.Method {
        switch self {
        case .me:           return .get
        case .update:       return .patch
        case .deleteMe:     return .delete
        case .uploadAvatar: return .put // или .post — как у вас
        }
    }

    var task: Task {
        switch self {
        case .me, .deleteMe:
            return .requestPlain

        case .update(let body):
            return .requestJSONEncodable(body)

        case .uploadAvatar(let data, let filename, let mime):
            // Не ставь вручную multipart headers — Moya сам всё проставит
            let part = MultipartFormData(provider: .data(data),
                                         name: "file",
                                         fileName: filename,
                                         mimeType: mime)
            return .uploadMultipart([part])
        }
    }

    var headers: [String : String]? {
        switch self {
        case .uploadAvatar: return nil // boundary проставит Moya
        default:            return ["Content-Type": "application/json"]
        }
    }

    var sampleData: Data {
        switch self {
        case .me, .update:
            return Data(#"{"id":1,"username":"demo","email":"demo@ex.com","firstName":"Gor","lastName":"Illa","city":"Almaty","avatar":null}"#.utf8)
        case .deleteMe:
            return Data(#"{"status":"ok"}"#.utf8)
        case .uploadAvatar:
            return Data(#"{"avatar":"https://cdn.example.com/u/1.jpg"}"#.utf8)
        }
    }
}

// Пометка для AccessTokenPlugin — этот таргет требует Bearer токен
extension ProfileAPI: AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? { .bearer }
}

