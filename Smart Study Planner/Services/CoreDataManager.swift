import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmartStudyPlanner")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Task Operations
    
    func createTask(title: String, subject: String, deadline: Date, priority: Int16, notes: String? = nil) -> CDStudyTask {
        let task = CDStudyTask(context: viewContext)
        task.id = UUID()
        task.title = title
        task.subject = subject
        task.deadline = deadline
        task.priority = priority
        task.notes = notes
        task.createdAt = Date()
        task.completed = false
        
        saveContext()
        return task
    }
    
    func fetchTasks(completed: Bool? = nil) -> [CDStudyTask] {
        let request: NSFetchRequest<CDStudyTask> = CDStudyTask.fetchRequest()
        
        if let completed = completed {
            request.predicate = NSPredicate(format: "completed == %@", NSNumber(value: completed))
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDStudyTask.deadline, ascending: true)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }
    
    func updateTask(_ task: CDStudyTask) {
        saveContext()
    }
    
    func deleteTask(_ task: CDStudyTask) {
        viewContext.delete(task)
        saveContext()
    }
    
    func toggleTaskCompletion(_ task: CDStudyTask) {
        task.completed.toggle()
        saveContext()
    }
    
    func searchTasks(query: String) -> [CDStudyTask] {
        let request: NSFetchRequest<CDStudyTask> = CDStudyTask.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR subject CONTAINS[cd] %@", query, query)
        request.predicate = predicate
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error searching tasks: \(error)")
            return []
        }
    }
} 