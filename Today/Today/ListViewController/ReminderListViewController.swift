//
//  ViewController.swift
//  Today
//
//  Created by Ashley Nygaard on 3/29/23.
//

import UIKit

class ReminderListViewController: UICollectionViewController {

    var dataSource: DataSource!
    var reminders : [Reminder] = Reminder.sampleData
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        // closure accepts the indexPath to the location of the cell in the collection view and an item identifier
        dataSource = DataSource(collectionView: collectionView){
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdenfifier: Reminder.ID) in
            //reuse cells allows better performace with vast number of items
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdenfifier)
        }
        updateSnapshot()
        collectionView.dataSource = dataSource
    }
    private func listLayout() -> UICollectionViewCompositionalLayout {
        // creates a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
    }
    
    // not showing the item user tapped as selected so return false. Will show details instead
    override func collectionView ( _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        // push new view controller onto navigation control stack
        navigationController?.pushViewController(viewController, animated: true)
    }
}

