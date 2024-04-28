import Foundation

class SignUpModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var fullname: String = ""
    
    
  
    
    @MainActor
    func createUser () async throws{
        try await AuthService.shared.createUser(email: email, password: password, fullname: fullname)
        
    }
}
