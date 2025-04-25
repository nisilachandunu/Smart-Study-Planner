import SwiftUI

struct TaskManagerView: View {
    @StateObject private var viewModel = TaskManagerViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemGray6)]),
                             startPoint: .top,
                             endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 0) {
                        // Add minimal top safe area spacing
                        Color.clear
                            .frame(height: 4)
                        
                        HStack {
                            Text("Task Manager")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Spacer()
                            Button(action: {
                                viewModel.showAddTask = true
                            }) {
                                Text("Add")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .clipShape(Capsule())
                                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                    }
                    .background(Color(.systemBackground))
                    
                    // Search Bar
                    TaskSearchBar(text: $viewModel.searchQuery)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background(Color(.systemBackground))
                    
                    // Task Filter Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            FilterButton(title: "All Tasks", isSelected: viewModel.selectedFilter == .all) {
                                viewModel.selectedFilter = .all
                                viewModel.applyFilter(.all)
                            }
                            FilterButton(title: "By Subject", isSelected: viewModel.selectedFilter == .bySubject) {
                                viewModel.selectedFilter = .bySubject
                                viewModel.applyFilter(.bySubject)
                            }
                            FilterButton(title: "By Due Date", isSelected: viewModel.selectedFilter == .byDueDate) {
                                viewModel.selectedFilter = .byDueDate
                                viewModel.applyFilter(.byDueDate)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 4)
                    .background(Color(.systemBackground))
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Pending Tasks Section
                            Text("Pending Tasks")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .padding(.horizontal)
                            
                            ForEach(viewModel.pendingTasks) { task in
                                NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                                    TaskCard(task: task)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Completed Tasks Section
                            HStack {
                                Text("Completed Tasks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                Spacer()
                                Button("See All") {
                                    viewModel.showAllCompleted = true
                                }
                                .foregroundColor(.blue)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            }
                            .padding(.horizontal)
                            
                            ForEach(viewModel.completedTasks.prefix(1)) { task in
                                NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                                    CompletedTaskCard(task: task)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Add padding at the bottom to prevent tab bar overlap
                            Spacer()
                                .frame(height: 90)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $viewModel.showAddTask) {
            AddTaskView(viewModel: viewModel)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            Color.clear
                        }
                    }
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}

struct TaskCard: View {
    let task: StudyTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(task.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(task.subject)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                PriorityBadge(priority: task.priority)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                    Text(task.deadline, style: .relative)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .padding(.horizontal)
    }
}

struct CompletedTaskCard: View {
    let task: StudyTask
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .strikethrough()
                    .foregroundColor(.gray)
                Text(task.subject)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button("Undo") {
                // Undo completion action
            }
            .foregroundColor(.blue)
            .font(.subheadline)
            .fontWeight(.medium)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct PriorityBadge: View {
    let priority: Int
    
    var priorityColor: Color {
        switch priority {
        case 3: return .red
        case 2: return .orange
        default: return .green
        }
    }
    
    var priorityText: String {
        switch priority {
        case 3: return "High Priority"
        case 2: return "Medium Priority"
        default: return "Low Priority"
        }
    }
    
    var body: some View {
        Text(priorityText)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(priorityColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(priorityColor.opacity(0.15))
            )
    }
}

// Add SearchBar view
struct TaskSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search tasks...", text: $text)
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
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 