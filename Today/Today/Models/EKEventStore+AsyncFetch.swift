//
//  EKEventStore+AsyncFetch.swift
//  Today
//
//  Created by Ashley Nygaard on 6/14/23.
//

import Foundation
import EventKit

extension EKEventStore {
  
  // async wrapper function
  func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
    try await withCheckedThrowingContinuation { continuation in
      fetchReminders(matching: predicate) { reminders in
        if let reminders {
          continuation.resume(returning: reminders)
        } else {
          continuation.resume(throwing: TodayError.failedReadingReminders)
        }
      }
    }
  }
  
}
