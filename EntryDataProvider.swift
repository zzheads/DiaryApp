//
//  EntryDataProvider.swift
//  DiaryApp
//
//  Created by Alexey Papin on 07.01.17.
//  Copyright © 2017 zzheads. All rights reserved.
//

import Foundation
import CoreData

protocol DataProviderDelegate: class {
    func processUpdates(updates: [DataProviderUpdate<Entry>])
    func providerFailedWithError(error: Error)
}

enum DataProviderUpdate<T> {
    case Insert(T)
    case Remove(IndexPath)
    case Change(T, IndexPath)
}

class EntryDataProvider {
    let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    let coordinator = CoreDataController.sharedInstance.persistentStoreCoordinator
    var updates = [DataProviderUpdate<Entry>]()
    
    private weak var delegate: DataProviderDelegate?
    
    init(delegate: DataProviderDelegate?) {
        self.delegate = delegate
    }
    
    func perform(request: NSFetchRequest<NSFetchRequestResult>) {
        do {
            print("Request!")
            let entries = try self.managedObjectContext.fetch(Entry.allEntriesRequest) as! [Entry]
            self.processResult(result: .Success(entries))
        } catch (let error) {
            let result = Result<Entry>.Failure(error)
            self.processResult(result: result)
        }
    }
    
    func save() {
        do {
            try self.managedObjectContext.save()
        } catch (let error) {
            let result = Result<Entry>.Failure(error)
            self.processResult(result: result)
        }
    }
    
    func delete(entry: Entry) {
        self.managedObjectContext.delete(entry)
    }
    
    private func processResult(result: Result<[Entry]>) {
        DispatchQueue.main.async {
            switch result {
            case .Success(let entries):
                self.updates = entries.map { DataProviderUpdate.Insert($0) }
                guard let delegate = self.delegate else {
                    return
                }
                delegate.processUpdates(updates: self.updates)
            case .Failure(let error):
                print("\(error)")
                guard let delegate = self.delegate else {
                    return
                }
                delegate.providerFailedWithError(error: error)
            }
        }
    }
    
    private func processResult(result: Result<Entry>) {
        DispatchQueue.main.async {
            switch result {
            case .Success(let entry):
                self.updates = [DataProviderUpdate.Insert(entry)]
                guard let delegate = self.delegate else {
                    return
                }
                delegate.processUpdates(updates: self.updates)
            case .Failure(let error):
                print("\(error)")
                guard let delegate = self.delegate else {
                    return
                }
                delegate.providerFailedWithError(error: error)
            }
        }
    }
}
