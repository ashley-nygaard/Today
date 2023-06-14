//
//  EKReminder+Reminder.swift
//  Today
//
//  Created by Ashley Nygaard on 6/14/23.
//

import Foundation
import EventKit

extension EKReminder {
  func update(using reminder: Reminder, in store: EKEventStore) {
    title = reminder.title
    notes = reminder.notes
    isCompleted = reminder.isComplete
    
    calendar = store.defaultCalendarForNewReminders()
    // iterate through alarms, remove any that doesn't match due date
    alarms?.forEach{ alarm in
      guard let absoluteDate = alarm.absoluteDate else { return }
      let comparison = Locale.current.calendar.compare(reminder.dueDate, to: absoluteDate, toGranularity: .minute)
      if comparison != .orderedSame {
        removeAlarm(alarm)
      }
    }
    if !hasAlarms {
      addAlarm(EKAlarm(absoluteDate: reminder.dueDate))
    }
  }
}
