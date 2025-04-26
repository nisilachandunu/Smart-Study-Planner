import SwiftUI

class AppTheme: ObservableObject {
    static let shared = AppTheme()
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "darkModeEnabled")
            updateAppearance()
        }
    }
    
    private init() {
        // Load saved preference or use system setting
        self.isDarkMode = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        updateAppearance()
    }
    
    func updateAppearance() {
        // Update the app's appearance based on the current setting
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
    
    func toggleDarkMode() {
        isDarkMode.toggle()
    }
} 