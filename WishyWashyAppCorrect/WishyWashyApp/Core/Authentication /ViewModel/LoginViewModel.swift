import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @MainActor
    func login() async throws {
        try await AuthService.shared.login(email: email, password: password)
    }
    
}
