import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Back button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .imageScale(.large)
                }
                .padding(.leading)
                Spacer()
            }
            
            // Title
            Text("Create Account")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
                .padding(.bottom)
            
            // Form fields
            VStack(spacing: 20) {
                // Full Name
                CustomTextField(
                    text: $viewModel.fullName,
                    placeholder: "Enter your full name",
                    icon: "person",
                    title: "Full Name"
                )
                
                // Email
                CustomTextField(
                    text: $viewModel.email,
                    placeholder: "Enter your email",
                    icon: "envelope",
                    title: "Email Address"
                )
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                
                // Password
                CustomSecureField(
                    text: $viewModel.password,
                    placeholder: "Create password",
                    title: "Password"
                )
                
                // Confirm Password
                CustomSecureField(
                    text: $viewModel.confirmPassword,
                    placeholder: "Confirm password",
                    title: "Confirm Password"
                )
                
                // Terms and Privacy
                HStack {
                    Text("I agree to the")
                        .foregroundColor(.gray)
                    Button("Terms of Service") {
                        // Handle terms action
                    }
                    .foregroundColor(.blue)
                    Text("and")
                        .foregroundColor(.gray)
                    Button("Privacy Policy") {
                        // Handle privacy action
                    }
                    .foregroundColor(.blue)
                }
                .font(.footnote)
                
                // Create Account Button
                Button(action: {
                    Task {
                        await viewModel.register()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Create Account")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(viewModel.isLoading)
                
                // Login Link
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Button("Log in") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
                .font(.subheadline)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Footer
            HStack(spacing: 20) {
                Button("Help & Support") {
                    // Handle help action
                }
                Text("•")
                Button("Privacy Policy") {
                    // Handle privacy action
                }
                Text("•")
                Button("Terms") {
                    // Handle terms action
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.bottom)
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// Custom TextField Component
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.purple)
                .fontWeight(.medium)
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                TextField(placeholder, text: $text)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

// Custom Secure Field Component
struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    let title: String
    @State private var isSecured: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.purple)
                .fontWeight(.medium)
            
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                
                if isSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
                
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

#Preview {
    RegisterView()
} 