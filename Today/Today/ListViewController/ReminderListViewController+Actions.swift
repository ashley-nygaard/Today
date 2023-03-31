//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by Ashley Nygaard on 3/30/23.
//

import UIKit

extension ReminderListViewController {
    
    //@objc makes this method avaiable to objective c
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
}
