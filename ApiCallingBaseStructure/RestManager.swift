//
//  RestManager.swift
//  ApiCallingBaseStructure
//
//  Created by Sharandeep Singh on 01/09/24.
//

import Foundation

enum HttpMethods: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ApiEndPoints: String {
    
    case verifyPhone = "auth/verifyPhone"
    case initialSwapProfileToken = "auth/initialSwapProfileToken"
}

let debugExtraLogging = true

final class RestManager<T: Codable> {
    
    let baseURL = "https://qa.allballapp.com/api/v7/"
    
    func makeRequest(on endPoint: ApiEndPoints,
                     ofType httpMethod: HttpMethods,
                     withQueryParams queryParams: [String: String]? = nil,
                     and httpBody: [String: Any]? = nil,
                     completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = baseURL + endPoint.rawValue
        
        /// Let's make URL Components object
        guard var urlComponents = URLComponents(string: urlString) else { return } // Return error in else block
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        /// Let's create URL from components object
        guard let url = urlComponents.url else { return } // Return error in else block
        
        /// Let's make Request
        var request = prepareHttpRequest(of: url, httpMethod: httpMethod, httpBody: httpBody)
        
        /// Let's make URLSession data task
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return                                        // Handle error case
            } else {
                let parsedData: T? = Parser.parse(data: data)
                if let data = parsedData {
                    completion(.success(data))
                }
            }
        }
        dataTask.resume()
    }
    
    private func prepareHttpRequest(of url: URL, httpMethod: HttpMethods, httpBody: [String: Any]?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        /// Let's set required heders
        var headers = [
            "Content-Type": "application/json",
            "aVer": getAppVersion(),
            "timezone": TimeZone.current.identifier,
            "offSet": getTimeZoneOffset()
        ]
        
        if let token = UserDefaultsManager.authToken {
            headers["Authorization"] = token
        }
        
        for (header, value) in headers {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        
        switch httpMethod {
            
        case .post, .put, .delete:
            if let httpBody = httpBody {
                let jsonBody = try? JSONSerialization.data(withJSONObject: httpBody)
                
                request.httpBody = jsonBody
            }
            return request
        default:
            return request
        }
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        return "iOS - \(version ?? "")"
    }
    
    private func getTimeZoneOffset() -> String {
        let timeZone = TimeZone.current
        let secondsFromGMT = timeZone.secondsFromGMT()
        let hours = secondsFromGMT / (60 * 60)
        let minutes = abs(secondsFromGMT / 60 % 60)
        
        return String(format: "GMT%+02d:%02d", hours, minutes)
    }
}

class Parser {
    
    // TODO: - We can improve this method, we can use custom error types or some more good
    static func parse<T: Codable>(data: Data?) -> T? {
        if let data = data {
            do {
                /// Parsed Data is basically swift object
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                
                /// Encoding parsed data to json to print pretty formatted json in console
                let jsonData = try JSONSerialization.jsonObject(with: data)
                let prettyJson = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                let prettyJsonString = String(data: prettyJson, encoding: .utf8)
                
                if let json = prettyJsonString, debugExtraLogging {
                    print("==========================================================================\n\n")
                    print(json)
                    print("\n\n==========================================================================")
                }
                
                return parsedData
            } catch {
                print("Unable to parse data")
                return nil
            }
        }
        
        return nil
    }
}
