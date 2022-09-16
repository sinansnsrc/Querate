import Foundation

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private var refreshingToken = false
    private var onRefreshBlocks = [((String) -> Void)]()
    
    private init() {}
    
    struct Constants {
        static let clientID = "bb85eed4667f43079d656ecb2a2b28f8"
        static let clientSecret = "26d28e3390ad4fb2a7b210d0636ca995"
        
        static let scopes = "user-read-private%20playlist-modify-private%20playlist-modify-public%20playlist-read-private%20user-library-modify%20user-library-read%20user-read-playback-state%20user-read-email%20user-read-playback-state%20user-read-currently-playing"
        static let redirectURI = "https://www.spotify.com/"
        
        static let tokenURI = "https://accounts.spotify.com/api/token"
    }
    
    var userIsSignedIn: Bool {
        return userAccessToken != nil
    }
    
    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize?response_type=code"
        let client = "&client_id=\(Constants.clientID)"
        let scope = "&scope=\(Constants.scopes)"
        let redirect = "&redirect_uri=\(Constants.redirectURI)"
        let dialog = "&show_dialog=TRUE"
        
        let url = base + client + scope + redirect + dialog
        
        return URL(string: url)
    }
    
    private var userAccessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var userRefreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    public var userTokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expires_in") as? Date
    }
    
    public var shouldRefreshToken: Bool {
        guard let expirationDate = userTokenExpirationDate else {
            return false
        }
                
        let currentDate = Date()
        
        return currentDate.addingTimeInterval(TimeInterval(300)) >= expirationDate
    }
    
    public func exchangeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenURI) else {
            return
        }
        
        let basicData = Constants.clientID + ":" + Constants.clientSecret
        let encodedData = basicData.data(using: .utf8)
        guard let base64Data = encodedData?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Data)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthenticationModel.self, from: data)
                print("* - Token exchange successful.")
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                print("* - Token exchange failed.")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    private func cacheToken(result: AuthenticationModel) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")
        
        APIManager.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    UserDefaults.standard.setValue(model.id, forKey: "user_id")
                case .failure(let model):
                    print("* - Failed to retreive user ID, database actions will fail.")
                }
            }
        }
    }
    
    public func refreshAccessToken(completion: ((Bool) -> Void)?) {
        print("* - Access token refresh necessary?: \(shouldRefreshToken)")
        print("* - Token expires at: \(String(describing: userTokenExpirationDate!))")
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion?(true)
            return
        }
        
        guard let refreshToken = self.userRefreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenURI) else {
            return
        }
        
        refreshingToken = true
        
        let basicData = Constants.clientID + ":" + Constants.clientSecret
        let encodedData = basicData.data(using: .utf8)
        guard let base64Data = encodedData?.base64EncodedString() else {
            completion?(false)
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded ", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Data)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthenticationModel.self, from: data)
                print("* - Token refresh successful.")
                self?.onRefreshBlocks.forEach { $0(result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)
            }
            catch {
                print("* - Token refresh failed.")
                completion?(false)
            }
        }
        
        task.resume()
    }
    
    public func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        
        if shouldRefreshToken {
            refreshAccessToken { [weak self] success in
                if let token = self?.userAccessToken, success {
                    completion(token)
                }
            }
        }
        else if let token = userAccessToken {
            completion(token)
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        UserDefaults.standard.setValue(nil, forKey: "user_id")
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        UserDefaults.standard.setValue(nil, forKey: "expires_in")
        print("* - User has signed out.")
        completion(true)
    }
}
