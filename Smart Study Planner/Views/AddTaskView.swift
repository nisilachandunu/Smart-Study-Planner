import SwiftUI

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskManagerViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var subject = ""
    @State private var deadline = Date()
    @State private var priority = 2
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Subject", text: $subject)
                }
                
                Section(header: Text("Deadline")) {
                    DatePicker("Due Date", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority Level", selection: $priority) {
                        Text("Low").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Additional Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add New Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveTask()
                }
                .disabled(title.isEmpty || subject.isEmpty)
            )
        }
    }
    
    private func saveTask() {
        let task = StudyTask(
            taskID: UUID().uuidString,
            userID: "user1", // In a real app, this would come from authentication
            title: title,
            subject: subject,
            deadline: deadline,
            priority: priority,
            status: "pending",
            notes: notes.isEmpty ? nil : notes
        )
        
        viewModel.addTask(task)
        dismiss()
    }
} 