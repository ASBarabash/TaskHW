//
//  StorageManager.swift
//  TaskHW
//
//  Created by Alexandr Barabash on 20.04.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskHW")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func save(_ taskTitle: String? = nil) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return nil}
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return nil}
        
        task.title = taskTitle
        
        saveContext()
        return task
    }
    
    func edit(_ task: Task, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
}
