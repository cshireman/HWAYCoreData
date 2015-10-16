//
//  HWAYSyncCoordinator.swift
//  Pods
//
//  Created by Chris Shireman on 10/14/15.
//
//

import Foundation
import CoreData

public final class HWAYSyncCoordinator {

    var mainManagedObjectContext: NSManagedObjectContext
    var syncManagedObjectContext: NSManagedObjectContext

    public init(mainManagedObjectContext mainContext:NSManagedObjectContext){
        mainManagedObjectContext = mainContext
        syncManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        syncManagedObjectContext.persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator

        self.setupContextNotificationObserving()
    }

    private func setupContextNotificationObserving() {
        mainManagedObjectContext.addContextDidSaveNotificationObserver({ [weak self] notification in
            self?.mainContextDidSave(notification)
        })
        syncManagedObjectContext.addContextDidSaveNotificationObserver({ [weak self] notification in
            self?.syncContextDidSave(notification)
            })
    }

    private func mainContextDidSave(notification: NSNotification) {
        syncManagedObjectContext.performMergeChangesFromContextDidSaveNotification(notification)
    }

    private func syncContextDidSave(notification: NSNotification) {
        mainManagedObjectContext.performMergeChangesFromContextDidSaveNotification(notification)
    }
}
