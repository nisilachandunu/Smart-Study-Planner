import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userName: String = "John Doe"
    @Published var userEmail: String = "john.doe@example.com"
    @Published var profileImage: String = "person.circle.fill"
    @Published var notificationsEnabled: Bool = true
    @Published var darkModeEnabled: Bool = false
    @Published var defaultStudyDuration: Int = 30
    @Published var isLoggedOut: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        loadUserData()
    }
    
    private func loadUserData() {
        // In a real app, this would fetch from the API
        // For now, we'll use dummy data
        userName = UserDefaults.standard.string(forKey: "userName") ?? "John Doe"
        userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "john.doe@example.com"
        notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        defaultStudyDuration = UserDefaults.standard.integer(forKey: "defaultStudyDuration")
    }
    
    func updateNotificationSettings(enabled: Bool) {
        notificationsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
        
        // In a real app, this would update the server
        userService.updateUserPreferences(notificationsEnabled: enabled, theme: darkModeEnabled ? "dark" : "light")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to update notification settings: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                print("Notification settings updated successfully")
            })
            .store(in: &cancellables)
    }
    
    func updateThemeSettings(enabled: Bool) {
        darkModeEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "darkModeEnabled")
        
        // In a real app, this would update the server
        userService.updateUserPreferences(notificationsEnabled: notificationsEnabled, theme: enabled ? "dark" : "light")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to update theme settings: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                print("Theme settings updated successfully")
            })
            .store(in: &cancellables)
    }
    
    func updateDefaultStudyDuration(duration: Int) {
        defaultStudyDuration = duration
        UserDefaults.standard.set(duration, forKey: "defaultStudyDuration")
    }
    
    func logout() {
        // Clear user data
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        KeychainService.shared.deleteCredentials()
        
        // Set logged out state
        isLoggedOut = true
    }
} 