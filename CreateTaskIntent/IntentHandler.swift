//
//  IntentHandler.swift
//  CreateTaskIntent
//
//  Created by Nisila on 2025-04-26.
//

import Intents
import CoreData

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        if intent is CreateTaskIntent {
            return CreateTaskIntentHandler()
        }
        return self
    }
}

class CreateTaskIntentHandler: NSObject, CreateTaskIntentHandling {
    func handle(intent: CreateTaskIntent, completion: @escaping (CreateTaskIntentResponse) -> Void) {
        // Set up Core Data with App Group
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.task.temp") else {
            let response = CreateTaskIntentResponse(code: .failure, userActivity: nil)
            completion(response)
            return
        }
        let storeURL = appGroupURL.appendingPathComponent("SmartStudyPlanner.sqlite")
        let container = NSPersistentContainer(name: "SmartStudyPlanner")
        let description = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading persistent stores: \(error)")
                let response = CreateTaskIntentResponse(code: .failure, userActivity: nil)
                completion(response)
                return
            }
            let context = container.viewContext
            let task = CDStudyTask(context: context)
            task.id = UUID()
            task.title = intent.title ?? "Untitled"
            task.subject = intent.subject ?? ""
            if let deadlineComponents = intent.deadline {
                let calendar = Calendar.current
                task.deadline = calendar.date(from: deadlineComponents)
            } else {
                task.deadline = Date() // Default to current date if not provided
            }
            task.priority = Int16(truncating: intent.priority ?? 0)
            task.notes = intent.notes ?? ""
            task.createdAt = Date()
            task.completed = false
            
            do {
                try context.save()
                let response = CreateTaskIntentResponse(code: .success, userActivity: nil)
                response.title = task.title
                completion(response)
            } catch {
                print("Error saving task: \(error)")
                let response = CreateTaskIntentResponse(code: .failure, userActivity: nil)
                completion(response)
            }
        }
    }
    
    func resolveTitle(for intent: CreateTaskIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let title = intent.title, !title.isEmpty {
            completion(.success(with: title))
        } else {
            completion(.needsValue())
        }
    }
    
    func resolveSubject(for intent: CreateTaskIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let subject = intent.subject, !subject.isEmpty {
            completion(.success(with: subject))
        } else {
            completion(.needsValue())
        }
    }
    
    func resolveDeadline(for intent: CreateTaskIntent, with completion: @escaping (INDateComponentsResolutionResult) -> Void) {
        if let deadline = intent.deadline {
            completion(.success(with: deadline))
        } else {
            completion(.needsValue())
        }
    }
    
    func resolvePriority(for intent: CreateTaskIntent, with completion: @escaping (CreateTaskPriorityResolutionResult) -> Void) {
        if let priority = intent.priority {
            if priority.intValue >= 0 {
                completion(.success(with: priority.intValue))
            } else {
                completion(.unsupported(forReason: .negativeNumbersNotSupported))
            }
        } else {
            completion(.needsValue())
        }
    }
    
    func resolveNotes(for intent: CreateTaskIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let notes = intent.notes {
            completion(.success(with: notes))
        } else {
            completion(.notRequired())
        }
    }
}
