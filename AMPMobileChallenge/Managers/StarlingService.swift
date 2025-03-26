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
    private let token = "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty3KkMAz8lRTnKMXwZm657Q_sBwhJZFwBm7JNsqmt_fc1GIYwlRvdrUfLEn8T5VxyTXBSwDKaF-fRDkq_dajfX8iMyXPi5i5E5IzY5jlDw0UDRScNtJIxZGUmeVdUaVdICJY_U3K91EWeVk1aN8-JQr8SWdtcqoVAIjNr_8sMLPa34q1213cV1FK0UJRVCU1BGWCZ1pxlWGYphtrevIuOGUVeSlaRQEpSQ5EXCE3PFXCaUZbXXYGyuAljvRKJc0cfulQdUMp5yJIU2q7K4VKVLVHdUlO2y8BkJlkeJTqF22oVNI5ytYL89CD4r-lBUCzaq16JPfODcv7EbIDZBpNXYeXvICreI91GuUce-NMqL084-5uxyoWVgdKsPhTPOMTgDgfUtFkjtAxktLdmiI0WZtOM7pUd0SujwfTQz5o3AzQ7b8Z9DhlRbdkjakYvV5ZBgo8drmGjeAwIrxTgIu54zZzwS2SXItiKRHAEgRrxbasZteMTvEXtkBbPdxoGQ2H6o3YkwCzP8MhuWdb0athbxd4nao2yQqImfwLuLMV9OPwIq3DwZg4fJ24b9cStdb4zcbg-PPsPJQ7xh1qHGIvSTXgehCGMfZyRE-_DgPO0wQn3Mwn_f7iicEzG8rf2Z3bve2Z_yAfzqe-8l8UAkPt4pCbuI_V9p-sqHpec_PsPYeDn9LIEAAA.xbVVZBnv_e8tc2U4RgoDKmVmV7kDRf2FoMffCLlgQvJ6u23LDUNJ0h1cyJYOxcc0IcDSooVH9rqlJdXgDL6caxkZfSk8ed8xznhK3Ta3mOCs_33O9MtdUBSYxV5iUG9nGWu7tud1tVq_2eC5uybxqymCUdwCno4VFb1RyGQ8AMfCm_eP2uA3JHnvOx2UnLyKBTxFsCajlQPTPzXHMOP_PBk_QHEkSkF6h7gCbUGOSQHWfoh8dYOzz2ojRlJRisxovEYTq1-WZjnGho6YYvovRTxo-xkkIiygmPnSk-yxXXMXkXcXLMV-7Vjn-HOfmv14QnFQDQBwFcWcdjfvW6m_OSlnI-URG8Omo6FB-hyNhJ2-jWz5a9qjSFNZirKSTGG48A_AliEvTmIaD7ecRF9hqroqyKguuitCrRQ5MtkPYy-dgwv3MWY5-O-a1SEYdSR3wmbJtaOp9PfHNZUK4_CrnmrDK-2JG77cAzl2gLe7qSG5VnUtuPfLG81uYucuwzIZTc8j4p12nyUfuvkniI4KGVTfpoAXIrOAK88aLjCfeJRfw1FzeCFH1RjUkhoV0UdosRbZL3XLtZoLAy1VedhFEjSbaan_N-_wKEMNt3aRN7VIanLBDJ14VLmYI6sLGUaFqIyxLb_ggNmmPPHKhtMf_d9aCIXdjKLq6S6nsimtZzM"
    
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
