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
    private let token = "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty5KjMAz8lSnOoykeBgK3ue0P7AcIWSSuAZuyTWantvbf18QQQio3uluPliX-Jsq5pE1wUiB5NB_Oox2UPneovz7IjMl74uYuRBQSsSkKCScpTiA6PkHDuYS8zLnoRJV2gkMw_5mSNqtFkZV1XWTviUIfibTOioVAIjNr_8sMku1vJdfaXd9VULNoQJRVCSdBOWCZ1jLPscxTDLW9-WIdM0RTiEr2AtI070FQsBSYDAhLorIsTpWgkBHG-iRi5_Y-lFUdUCoLEAWn0HRVAVlVNkR1Q6eyWQYmM_HyKNEpXG5WQePIrWWUb0-C_5meBCVZe9Urtkd-UM4fmBVIaYPJlqXydxAV75EuI98jd_xtlec3nP3FWOXCykBpqa5KzjjE4A4H1LRaI7QSyGhvzRAbLcyqGd0rO6JXRoPpoZ-1XA3Q7LwZtzl4RLVmj6glem4lDxx8bPAWNrLHgLClABdxw7fMCX-YNymCtUgEexCoEc9rzajtn-Ataoe0eL7TMBgK0--1IwFmeYZnds2yplfD1ir2PlC3KMvEavIH4I5S3IfDa1iFg7PZfRy4ddQDd6vzyMTh-vDsL0rs4otauxiL0oXlPLCEMPZ-Ro69DwPO0won3M4k_P_hisIxGSsf2h_Zre-RfZEP5lvfec-LASB3faYm2Ufqcae3VTwvOfn3Hxp1z3yyBAAA.cVQSs1tnfrlKWwje-W4bp2oSB0M72LnBA9IPVjZPMUQ_1mFk0KACcih4fkrfqNZq8BewkAV2cYgif5BsbE72uRAxx4GnlBiQgbTZNZ9hAz_sGUjMU_y86LGlg3P_tKb9EcrosYvU8G-4L23Xls7ymF2Ckx8bFA58KUFehePg6ZXur-jNzBTBTzE71YkWc_pCh6QuBk9ftkVq0Q6K9ddE5PnmkB5piGg-Of8a7JPrh6nofljHIHxx8JhUustoYNjwliD9u0B3QSeDzy7OLVUP9TzmcA_swlCwFTGvV4hvhWdGzaIMn-ZF-Ak43j2-RFJZ-jpQD9yDzq0V0j09jlazl5kL4k-a1-E_v4cD9IEgwkoHaIOQuyJyOZzBPmdGlLaeY0AQaPTsWn6MFUvdhVqwoJi-Z_-4PpuHszSb_-YIwhCSk_mD0udIrmyl5nrFlObahMB31uxq3WKSVvHnT6p_W0NioFCZ62GNnUQ4OZbxFP1nzQZC2KzAh5efXhxovngk342KNmM6WwKZ_EWZ3BfcJjpvxL3qddlm60LVDBhis8Mdl2fD9MWmDMYOSGODWmhdfb7UfWELiiQG0PtRuflt6_0PS3aCDoPLG9H38-Jxg0N_RwhlO1zp_BBNSo9qqH9cXY8jNKWR41cKuxN6u4QlQQNXINJIPtb9QVms6kTVYP4"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: Accounts
    
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
    
    // MARK: Transactions
    
    func fetchTransactions(for accountId: String, categoryId: String, since dateISO: String?) async throws -> TransactionData {
        let path = "/api/v2/feed/account/\(accountId)/category/\(categoryId)"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "changesSince", value: "2020-01-01T12:34:56.000Z")
        ]
        let url = try createURL(path: path, urlQueryItems: queryItems)
        let urlRequest = try createURLRequest(url: url, method: .get)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw StarlingError.serverError
        }
        let transactionData = try JSONDecoder().decode(TransactionData.self, from: data)
        return transactionData
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
