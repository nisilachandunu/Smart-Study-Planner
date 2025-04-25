import SwiftUI
import Combine

enum TaskFilter {
    case all
    case bySubject
    case byDueDate
}

class TaskManagerViewModel: ObservableObject {
    @Published var pendingTasks: [StudyTask] = []
    @Published var completedTasks: [StudyTask] = []
    @Published var selectedFilter: TaskFilter = .all
    @Published var showAddTask = false
    @Published var showAllCompleted = false
    @Published var searchQuery: String = ""
    @Published var isSearching: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadDummyData()
        setupSearchBinding()
    }
    
    private func setupSearchBinding() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) {
        isSearching = !query.isEmpty
        
        if query.isEmpty {
            // Reset to original filter
            applyFilter(selectedFilter)
            return
        }
        
        // Filter tasks based on search query
        let filteredPending = pendingTasks.filter { task in
            task.title.localizedCaseInsensitiveContains(query) ||
            task.subject.localizedCaseInsensitiveContains(query)
        }
        
        let filteredCompleted = completedTasks.filter { task in
            task.title.localizedCaseInsensitiveContains(query) ||
            task.subject.localizedCaseInsensitiveContains(query)
        }
        
        pendingTasks = filteredPending
        completedTasks = filteredCompleted
    }
    
    private func loadDummyData() {
        // Sample pending tasks
        pendingTasks = [
            StudyTask(
                taskID: "1",
                userID: "user1",
                title: "Mathematics Assignment",
                subject: "Calculus Chapter 5 Problems",
                deadline: Date(),
                priority: 3,
                status: "pending"
            ),
            StudyTask(
                taskID: "2",
                userID: "user1",
                title: "Physics Review",
                subject: "Quantum Mechanics Notes",
                deadline: Date().addingTimeInterval(86400),
                priority: 2,
                status: "pending"
            ),
            StudyTask(
                taskID: "4",
                userID: "user1",
                title: "Chemistry Lab",
                subject: "Organic Chemistry",
                deadline: Date().addingTimeInterval(172800),
                priority: 3,
                status: "pending"
            )
        ]
        
        // Sample completed task
        completedTasks = [
            StudyTask(
                taskID: "3",
                userID: "user1",
                title: "Biology Research",
                subject: "Cell Structure Analysis",
                deadline: Date().addingTimeInterval(-86400),
                priority: 1,
                status: "completed"
            )
        ]
    }
    
    func applyFilter(_ filter: TaskFilter) {
        switch filter {
        case .all:
            // Reset to original order by deadline
            pendingTasks.sort { $0.deadline < $1.deadline }
            completedTasks.sort { $0.deadline < $1.deadline }
        case .bySubject:
            pendingTasks.sort { $0.subject < $1.subject }
            completedTasks.sort { $0.subject < $1.subject }
        case .byDueDate:
            pendingTasks.sort { $0.deadline < $1.deadline }
            completedTasks.sort { $0.deadline < $1.deadline }
        }
        
        // Trigger UI update
        objectWillChange.send()
    }
    
    func addTask(_ task: StudyTask) {
        pendingTasks.append(task)
        applyFilter(selectedFilter)
    }
    
    func completeTask(_ task: StudyTask) {
        if let index = pendingTasks.firstIndex(where: { $0.taskID == task.taskID }) {
            var completedTask = pendingTasks.remove(at: index)
            completedTask.status = "completed"
            completedTasks.insert(completedTask, at: 0)
            applyFilter(selectedFilter)
        }
    }
    
    func undoTaskCompletion(_ task: StudyTask) {
        if let index = completedTasks.firstIndex(where: { $0.taskID == task.taskID }) {
            var pendingTask = completedTasks.remove(at: index)
            pendingTask.status = "pending"
            pendingTasks.append(pendingTask)
            applyFilter(selectedFilter)
        }
    }
} 