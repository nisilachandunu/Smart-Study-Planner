import SwiftUI

struct TaskDetailView: View {
    let task: CDStudyTask
    @ObservedObject var viewModel: TaskManagerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header with gradient background
                VStack(alignment: .leading, spacing: 12) {
                    Text(task.title ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(task.subject ?? "")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                
                // Priority and Due Date Cards
                HStack(spacing: 16) {
                    // Priority Card
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Priority", systemImage: "flag.fill")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        PriorityBadge(priority: Int(task.priority))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    
                    // Due Date Card
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Due Date", systemImage: "calendar")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        if let deadline = task.deadline {
                            Text(deadline, style: .date)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                }
                .padding(.horizontal)
                
                // Notes Section
                if let notes = task.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(notes)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                }
                
                // Action Buttons
                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.toggleTaskCompletion(task)
                        dismiss()
                    }) {
                        Text(task.completed ? "Mark as Incomplete" : "Mark as Complete")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        viewModel.deleteTask(task)
                        dismiss()
                    }) {
                        Text("Delete Task")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
} 