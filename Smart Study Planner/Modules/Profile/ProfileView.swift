import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var appTheme: AppTheme
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                             startPoint: .top,
                             endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Profile Image
                            Image(systemName: viewModel.profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                )
                            
                            // User Info
                            VStack(spacing: 4) {
                                Text(viewModel.userName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(viewModel.userEmail)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            // Edit Profile Button
                            Button(action: {
                                // Handle edit profile action
                            }) {
                                Text("Edit Profile")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                        
                        // Settings Section
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Settings")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                            
                            // Notifications Toggle
                            SettingsRow(
                                icon: "bell.fill",
                                title: "Notifications",
                                color: .blue
                            ) {
                                Toggle("", isOn: $viewModel.notificationsEnabled)
                                    .onChange(of: viewModel.notificationsEnabled) { newValue in
                                        viewModel.updateNotificationSettings(enabled: newValue)
                                    }
                            }
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Dark Mode Toggle
                            SettingsRow(
                                icon: "moon.fill",
                                title: "Dark Mode",
                                color: .purple
                            ) {
                                Toggle("", isOn: $viewModel.darkModeEnabled)
                                    .onChange(of: viewModel.darkModeEnabled) { newValue in
                                        viewModel.updateThemeSettings(enabled: newValue)
                                    }
                            }
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Default Study Duration
                            SettingsRow(
                                icon: "clock.fill",
                                title: "Default Study Duration",
                                color: .orange
                            ) {
                                Picker("", selection: $viewModel.defaultStudyDuration) {
                                    Text("15 min").tag(15)
                                    Text("30 min").tag(30)
                                    Text("45 min").tag(45)
                                    Text("60 min").tag(60)
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onChange(of: viewModel.defaultStudyDuration) { newValue in
                                    viewModel.updateDefaultStudyDuration(duration: newValue)
                                }
                            }
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Help & Support
                            NavigationLink(destination: Text("Help & Support")) {
                                SettingsRow(
                                    icon: "questionmark.circle.fill",
                                    title: "Help & Support",
                                    color: .green
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Privacy Policy
                            NavigationLink(destination: Text("Privacy Policy")) {
                                SettingsRow(
                                    icon: "lock.fill",
                                    title: "Privacy Policy",
                                    color: .red
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Terms of Service
                            NavigationLink(destination: Text("Terms of Service")) {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Terms of Service",
                                    color: .indigo
                                ) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                        
                        // Logout Button
                        Button(action: {
                            viewModel.logout()
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square.fill")
                                Text("Log Out")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(15)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
            .background(
                NavigationLink(destination: LoginView(), isActive: $viewModel.isLoggedOut) { EmptyView() }
            )
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let color: Color
    let content: () -> Content
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            content()
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppTheme.shared)
} 