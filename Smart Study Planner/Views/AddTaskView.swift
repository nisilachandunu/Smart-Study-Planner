import SwiftUI
import Speech

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskManagerViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var subject = ""
    @State private var deadline = Date()
    @State private var priority = 2
    @State private var notes = ""
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecordingTitle = false
    @State private var isRecordingNotes = false
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    HStack {
                        TextField("Title", text: $title)
                        Button(action: {
                            if isRecordingTitle {
                                speechRecognizer.stopRecording()
                                isRecordingTitle = false
                            } else {
                                speechRecognizer.startRecording()
                                isRecordingTitle = true
                            }
                        }) {
                            Image(systemName: isRecordingTitle ? "stop.circle.fill" : "mic.circle")
                                .foregroundColor(isRecordingTitle ? .red : .blue)
                                .font(.title2)
                        }
                    }
                    
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
                    VStack(alignment: .leading) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                if isRecordingNotes {
                                    speechRecognizer.stopRecording()
                                    isRecordingNotes = false
                                } else {
                                    speechRecognizer.startRecording()
                                    isRecordingNotes = true
                                }
                            }) {
                                HStack {
                                    Image(systemName: isRecordingNotes ? "stop.circle.fill" : "mic.circle")
                                        .foregroundColor(isRecordingNotes ? .red : .blue)
                                    Text(isRecordingNotes ? "Stop Recording" : "Record Notes")
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 8)
                    }
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
            .onChange(of: speechRecognizer.transcribedText) { newValue in
                if isRecordingTitle {
                    title = newValue
                } else if isRecordingNotes {
                    notes = newValue
                }
            }
            .onChange(of: speechRecognizer.errorMessage) { newValue in
                if newValue != nil {
                    showingPermissionAlert = true
                }
            }
            .alert(isPresented: $showingPermissionAlert) {
                Alert(
                    title: Text("Speech Recognition Error"),
                    message: Text(speechRecognizer.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func saveTask() {
        viewModel.addTask(
            title: title,
            subject: subject,
            deadline: deadline,
            priority: priority,
            notes: notes.isEmpty ? nil : notes
        )
        dismiss()
    }
} 