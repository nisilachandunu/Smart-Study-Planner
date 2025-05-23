import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var isFocusModeEnabled = false
    @EnvironmentObject private var appTheme: AppTheme
    
    var body: some View {
        TabView {
            NavigationView {
                VStack(spacing: 0) {
                    // Search Bar - Always visible at the top
                    DashboardSearchBar(text: $viewModel.searchQuery)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Welcome Section with Profile Image
                            HStack {
                                HStack(spacing: 16) {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .foregroundColor(.blue)
                                        .background(Circle().fill(Color.blue.opacity(0.1)))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Welcome back,")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(viewModel.userName)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                }
                                Spacer()
                                NotificationBellView(count: viewModel.unreadNotifications)
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                            
                            // Search Results or Main Content
                            if viewModel.isSearching {
                                SearchResultsView(results: viewModel.searchResults)
                                    .padding(.horizontal)
                            } else {
                                // Next Study Session Card
                                NextSessionCard(session: viewModel.nextSession)
                                    .padding(.horizontal)
                                
                                // Weekly Progress
                                WeeklyProgressCard(progressData: viewModel.weeklyProgress)
                                    .padding(.horizontal)
                                
                                // Focus Mode Toggle
                                FocusModeCard(isEnabled: $viewModel.isFocusModeEnabled,
                                            estimatedTime: viewModel.estimatedFocusTime,
                                            isDNDEnabled: viewModel.isDNDEnabled,
                                            onToggle: viewModel.toggleFocusMode)
                                    .padding(.horizontal)
                                
                                // Current Session
                                if viewModel.hasActiveSession {
                                    CurrentSessionCard(
                                        remainingTime: viewModel.currentSessionRemainingTime,
                                        onEnd: viewModel.endCurrentSession
                                    )
                                    .padding(.horizontal)
                                }
                                
                                // Notifications
                                NotificationsCard(notifications: viewModel.recentNotifications)
                                    .padding(.horizontal)
                                    .padding(.bottom, 20)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(.systemBackground))
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            TaskManagerView()
                .tabItem {
                    Label("Tasks", systemImage: "list.bullet")
                }
            
            Text("Progress")
                .tabItem {
                    Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            LocationsView()
                .tabItem {
                    Label("Locations", systemImage: "mappin.and.ellipse")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tint(.blue)
    }
}

// Add SearchBar view for Dashboard
struct DashboardSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search tasks or subjects...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Search Results View
struct SearchResultsView: View {
    let results: [SearchResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Search Results")
                .font(.headline)
            
            if results.isEmpty {
                Text("No results found")
                    .foregroundColor(.gray)
                    .padding(.vertical, 12)
            } else {
                ForEach(results) { result in
                    SearchResultRow(result: result)
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct SearchResultRow: View {
    let result: SearchResult
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(result.priority.color)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(result.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack {
                    Text(result.subject)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(result.dueDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Supporting Views
struct NextSessionCard: View {
    let session: StudySession?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Next Study Session")
                .font(.headline)
            
            if let session = session {
                HStack(spacing: 20) {
                    Image(systemName: "book.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Mathematics")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("\(session.startTime.formatted(date: .omitted, time: .shortened)) - \(session.endTime.formatted(date: .omitted, time: .shortened))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Text("No upcoming sessions")
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct WeeklyProgressCard: View {
    let progressData: [(day: String, hours: Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Weekly Progress")
                    .font(.headline)
                Spacer()
                Button("View Details") {
                    // Handle view details action
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            Chart(progressData, id: \.day) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Hours", item.hours)
                )
                .foregroundStyle(Color.blue.gradient)
            }
            .frame(height: 200)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct FocusModeCard: View {
    @Binding var isEnabled: Bool
    let estimatedTime: TimeInterval
    let isDNDEnabled: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Focus Mode")
                .font(.headline)
            
            HStack {
                Text("Estimated: \(Int(estimatedTime/60))m")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Toggle("", isOn: Binding(
                    get: { isEnabled },
                    set: { _ in onToggle() }
                ))
                .tint(.blue)
            }
            
            if isDNDEnabled {
                HStack(spacing: 8) {
                    Image(systemName: "moon.fill")
                        .foregroundColor(.blue)
                    Text("Do Not Disturb is active")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct CurrentSessionCard: View {
    let remainingTime: TimeInterval
    let onEnd: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Current Session")
                    .font(.headline)
                Text("\(Int(remainingTime/60)):\(Int(remainingTime.truncatingRemainder(dividingBy: 60))) remaining")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button("End") {
                onEnd()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(24)
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct NotificationsCard: View {
    let notifications: [NotificationItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Notifications")
                    .font(.headline)
                Spacer()
                Button("View All") {
                    // Handle view all action
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            ForEach(notifications) { notification in
                NotificationRow(notification: notification)
                    .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(notification.isRead ? Color.gray.opacity(0.3) : Color.blue)
                .frame(width: 10, height: 10)
            
            Text(notification.message)
                .font(.subheadline)
                .foregroundColor(notification.isRead ? .gray : .primary)
            
            Spacer()
            
            Text(notification.timeAgo)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct NotificationBellView: View {
    let count: Int
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(systemName: "bell.fill")
                .font(.title3)
                .foregroundColor(.primary)
            
            if count > 0 {
                Text("\(count)")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 8, y: -8)
            }
        }
    }
} 
