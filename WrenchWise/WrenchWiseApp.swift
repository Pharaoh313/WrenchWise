import SwiftUI

@main
struct WrenchWiseApp: App {
    @StateObject private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    init() {
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        // Check if user is logged in via Supabase
        // This will be implemented with actual Supabase integration
        isAuthenticated = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func signIn(email: String, password: String) async {
        // Implement Supabase authentication
        // For now, simulate login
        DispatchQueue.main.async {
            self.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    func signUp(email: String, password: String) async {
        // Implement Supabase registration
        DispatchQueue.main.async {
            self.isAuthenticated = true
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}