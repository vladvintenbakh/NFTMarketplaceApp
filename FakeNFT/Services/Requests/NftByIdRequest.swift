import Foundation

struct NFTRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)\(id)")
    }
}
