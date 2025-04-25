import SwiftUI
import Combine
import CoreData

enum TaskFilter {
    case all
    case bySubject
    case byDueDate
    case map
}

class TaskManagerViewModel: ObservableObject {
    @Published var pendingTasks: [CDStudyTask] = []
    @Published var completedTasks: [CDStudyTask] = []
    @Published var selectedFilter: TaskFilter = .all
    @Published var showAddTask = false
    @Published var showAllCompleted = false
    @Published var searchQuery: String = ""
    @Published var isSearching: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadTasks()
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
    
    private func loadTasks() {
        pendingTasks = coreDataManager.fetchTasks(completed: false)
        completedTasks = coreDataManager.fetchTasks(completed: true)
    }
    
    private func performSearch(query: String) {
        isSearching = !query.isEmpty
        
        if query.isEmpty {
            loadTasks()
            return
        }
        
        let searchResults = coreDataManager.searchTasks(query: query)
        pendingTasks = searchResults.filter { !$0.completed }
        completedTasks = searchResults.filter { $0.completed }
    }
    
    func applyFilter(_ filter: TaskFilter) {
        selectedFilter = filter
        loadTasks()
    }
    
    func addTask(title: String, subject: String, deadline: Date, priority: Int, notes: String? = nil) {
        _ = coreDataManager.createTask(
            title: title,
            subject: subject,
            deadline: deadline,
            priority: Int16(priority),
            notes: notes
        )
        loadTasks()
    }
    
    func toggleTaskCompletion(_ task: CDStudyTask) {
        coreDataManager.toggleTaskCompletion(task)
        loadTasks()
    }
    
    func deleteTask(_ task: CDStudyTask) {
        coreDataManager.deleteTask(task)
        loadTasks()
    }
    
    func updateTask(_ task: CDStudyTask) {
        coreDataManager.updateTask(task)
        loadTasks()
    }
} 
