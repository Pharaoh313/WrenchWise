import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("WrenchWise")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Find trusted mechanics through\ncommunity reviews")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                    
                    // Form
                    VStack(spacing: 20) {
                        if isSignUp {
                            CustomTextField(
                                placeholder: "Full Name",
                                text: $name,
                                icon: "person.fill"
                            )
                        }
                        
                        CustomTextField(
                            placeholder: "Email",
                            text: $email,
                            icon: "envelope.fill",
                            keyboardType: .emailAddress
                        )
                        
                        CustomSecureField(
                            placeholder: "Password",
                            text: $password,
                            icon: "lock.fill"
                        )
                        
                        if isSignUp {
                            CustomSecureField(
                                placeholder: "Confirm Password",
                                text: $confirmPassword,
                                icon: "lock.fill"
                            )
                        }
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.horizontal)
                        }
                        
                        // Main Action Button
                        Button(action: handleAuthentication) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text(isSignUp ? "Create Account" : "Sign In")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(isFormValid ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(!isFormValid || isLoading)
                        
                        // Toggle Auth Mode
                        Button(action: { 
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isSignUp.toggle()
                                clearForm()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                    .foregroundColor(.secondary)
                                Text(isSignUp ? "Sign In" : "Sign Up")
                                    .foregroundColor(.blue)
                                    .fontWeight(.semibold)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer(minLength: 40)
                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty && 
                   !password.isEmpty && 
                   !name.isEmpty && 
                   password == confirmPassword &&
                   password.count >= 6
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
    
    private func handleAuthentication() {
        errorMessage = ""
        isLoading = true
        
        Task {
            do {
                if isSignUp {
                    if password != confirmPassword {
                        errorMessage = "Passwords don't match"
                        isLoading = false
                        return
                    }
                    await authManager.signUp(email: email, password: password)
                } else {
                    await authManager.signIn(email: email, password: password)
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    private func clearForm() {
        email = ""
        password = ""
        confirmPassword = ""
        name = ""
        errorMessage = ""
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
}