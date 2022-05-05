//
//  ProfileProvider.swift
//  Suka Podcast
//
//  Created by yxgg on 05/05/22.
//

import Foundation
import UIKit
import CoreData

class ProfileProvider {
  static let shared: ProfileProvider = ProfileProvider()
  private init() { }
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Profile")
    container.loadPersistentStores { _, error in
      guard error == nil else {
        fatalError("Unresolved error \(error!)")
      }
    }
    container.viewContext.automaticallyMergesChangesFromParent = false
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.shouldDeleteInaccessibleFaults = true
    container.viewContext.undoManager = nil
    return container
  }()
  
  private func newTaskContext() -> NSManagedObjectContext {
    let taskContext = persistentContainer.newBackgroundContext()
    taskContext.undoManager = nil
    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return taskContext
  }
  
  func createProfile(
    _ id: Int,
    _ profileImage: Data,
    completion: @escaping() -> Void
  ) {
    let taskContext = newTaskContext()
    taskContext.performAndWait {
      if let entity = NSEntityDescription.entity(forEntityName: "ProfileData", in: taskContext) {
        let profile = NSManagedObject(entity: entity, insertInto: taskContext)
        profile.setValue(id, forKeyPath: "id")
        profile.setValue(profileImage, forKeyPath: "image")
        do {
          try taskContext.save()
          completion()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }
    }
  }
  
  func getProfile(completion: @escaping(_ profiles: ProfileDataModel) -> Void) {
    let taskContext = newTaskContext()
    taskContext.perform {
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileData")
      do {
        if let result = try taskContext.fetch(fetchRequest).first {
          let profile = ProfileDataModel(
            image: result.value(forKeyPath: "image") as? Data
          )
          completion(profile)
        }
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
  }
  
  func updateFavorite(
    _ id: Int,
    _ profileImage: Data,
    completion: @escaping() -> Void
  ) {
    let taskContext = newTaskContext()
    taskContext.perform {
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileData")
      fetchRequest.fetchLimit = 1
      fetchRequest.predicate = NSPredicate(format: "id == \(id)")
      if let result = try? taskContext.fetch(fetchRequest), let profile = result.first as? ProfileData {
        profile.setValue(profileImage, forKeyPath: "image")
        do {
          try taskContext.save()
          completion()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
      }
    }
  }
  
  func checkProfileData(_ id: Int, completion: @escaping(_ profiles: Bool) -> Void) {
    let taskContext = newTaskContext()
    taskContext.perform {
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProfileData")
      fetchRequest.fetchLimit = 1
      fetchRequest.predicate = NSPredicate(format: "id == \(id)")
      do {
        if let _ = try taskContext.fetch(fetchRequest).first {
          completion(true)
        } else {
          completion(false)
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
}
