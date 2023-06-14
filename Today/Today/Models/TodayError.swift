//
//  TodayError.swift
//  Today
//
//  Created by Ashley Nygaard on 6/14/23.
//

import Foundation

enum TodayError: LocalizedError {
  
  case accessDenied
  case accessRestricted
  case failedReadingReminders
  case reminderHasNoDueDate
  case unknown
  
  var errorDescription: String?{
    switch self {
    case .accessDenied:
      return NSLocalizedString("The app doesn't have permission to read reminders", comment: "access denied error description")
    case .accessRestricted:
      return NSLocalizedString("The device doesn't allow access to read reminders", comment: "access restricted error description")
    case .failedReadingReminders:
      return NSLocalizedString("Failed to read reminders", comment: "failed reading reminders error description")
    case .reminderHasNoDueDate:
      return NSLocalizedString("A reminder has no due date", comment: "reminder has no due date error description")
    case .unknown:
      return NSLocalizedString("A unknown error occurred", comment: "unknown error description")
  }
  
    
    
  }
}
