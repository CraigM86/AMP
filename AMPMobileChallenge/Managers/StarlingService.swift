//
//  StarlingService.swift
//  AMPMobileChallenge
//
//  Created by Craig Martin on 26/3/2025.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum StarlingError: Error {
    case invalidResponse
    case serverError
    case requestError(String)
}

class StarlingService {
    private let session: URLSession
    private let baseUrl = URL(string: "https://api-sandbox.starlingbank.com")!
    private let token = "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty5KjMAz8lSnOoykC5nmb2_7AfoCwROIasCnbZHZqa_99TQwhpHKju_VoWeJvopxL2gQnBcSj-XAe7aD0uUP99SHNmLwnbu5CRE6ITZ4T1CRqEB3X0HBGkBUZ550o005wCOY_U9KeKpE1dSqa_D1R6CNRNyJdCJTSzNr_MgOx_a1ord31XQkViwZEURZQC5kBFmlFWYZFlmKo7c0X6z1DVl0NFaYCRJn1gHVWQ4ZV3hd9WsqKQkYY61NKdu4h61R2IFPKQeScQtOVOZzKopGyamRdNMvA0ky8PEp0CpebVdA4cmsZ6e1J8D_Tk6CItVe9YnvkB-X8gVkBkQ0mWybl7yAq3qO8jHyP3PG3VZ7fcPYXY5ULKwOlSV0VzTjE4A4H1HK1JtESSKO9NUNstDCrZnSv7IheGQ2mh37WtBqQs_Nm3ObgEdWaPaIm9NwSDxx8bPAWNrLHgLCVAS7ihm-ZE_4wb1IEa5EI9iBQI57XmlHbP8Fb1A7l4vlOw2BkmH6vHQkwyzM8s2uWNb0atlax94G6RVmWrCZ_AO4oxX04vIZVODib3ceBW0c9cLc6j0wcrg_P_qLELr6otYuxqLwwzQMThLH3M3LsfRhwnlY44XYm4f8PVxSOyVh6aH9kt75H9kU-mG995z0vBkC66zM1UR-px53eVvG85OTff8SkRzKyBAAA.RTLiY77FPGJBzpbjYy4Xk73g-8wiQq8f4GVkz-ejpjK7JfU95KklQsT6flb8N131PriMwptSdbZz9Uu86hFRYyxITM-5J_eL2cj4f1UXZi8yjQeCjr9Q-33Ua3N2u0dJ1EZCXc501aygY8e9KvtB9Pkmyb8PGCRCrOLbOCnVVzbPk_fX-U00ScG6Qt92H3O2SHEL1ZOD_7zg5mazqvI_JAHEP09H1LnxhgxpYr1llUC7Zq2lZnk-RNVrK4pni5mgOgwcHnMgfYzXhypwm2Xqvu1_WS5H-2DYAPqOTDwndSBOtmOtEGwgj0iq6hAO6PtexHYQsqaCZfAedn6pXMV3jNScVLd0ESiC3GW-9qRzsQYiVhvyatnLQLLp3z5ZfWrx1e1Dynwu5T5tmMWB37pcKQNEZT5LHGtokpQxABQ3zyEoiEZI2nZ0x1RcKEG6mQ0NGOr4Q4vdmx6eNS7QolxQlbGNbmfoeBm2V5hJX6UrvsOpgrwRuue3UsZS5rimJQF2-977zGPQDMdu40w_hVbCRRLi2S14jcdBnSFFMJkzFS_PDzPFVT-Vt2ymUG-SwEkPf96P-6oal042Iji4KUMYTcSoZpbIOg3P3yil4RN08NQ6iyWV2i-yRE798JmvyFfLtkNMDQxJXkGGt2TiZb8CeX74-TdmASN6ZyquDzAZW3c"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchAccounts() async throws -> AccountData {
        let path = "/api/v2/accounts"
        let url = try createURL(path: path, urlQueryItems: nil)
        let urlRequest = try createURLRequest(url: url, method: .get)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw StarlingError.serverError
        }
        let accountData = try JSONDecoder().decode(AccountData.self, from: data)
        return accountData
    }
    
    func fetchAccountBalance(for accountId: String) async throws -> AccountBalanceData {
        let path = "/api/v2/accounts/\(accountId)/balance"
        let url = try createURL(path: path, urlQueryItems: nil)
        let urlRequest = try createURLRequest(url: url, method: .get)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw StarlingError.serverError
        }
        let accountBalanceData = try JSONDecoder().decode(AccountBalanceData.self, from: data)
        return accountBalanceData
    }
    
    private func createURL(path: String, urlQueryItems: [URLQueryItem]? = nil) throws -> URL {
        guard var urlComponents = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            throw StarlingError.serverError
        }
        if let queryItems = urlQueryItems {
            urlComponents.queryItems = queryItems
        }
        guard let url = urlComponents.url else {
            throw StarlingError.requestError("Failed to construct URL")
        }
        
        return url
    }
    
    private func createURLRequest(url: URL, method: RequestMethod) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Note: Headers are the same for all the requests so will just leave them static
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Craig", forHTTPHeaderField: "User-Agent")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
