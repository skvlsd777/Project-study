import Foundation
import Moya

extension MoyaProvider {
    func requestDecodable<T: Decodable>(_ target: Target, decoder: JSONDecoder = .init()) async throws -> T {
        try await withCheckedThrowingContinuation { cont in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        guard (200..<300).contains(response.statusCode) else {
                            if let err = try? decoder.decode(ErrorResponse.self, from: response.data) {
                                cont.resume(throwing: err); return
                            }
                            cont.resume(throwing: MoyaError.statusCode(response)); return
                        }
                        cont.resume(returning: try decoder.decode(T.self, from: response.data))
                    } catch {
                        cont.resume(throwing: error)
                    }
                case .failure(let err):
                    cont.resume(throwing: err)
                }
            }
        }
    }
}

