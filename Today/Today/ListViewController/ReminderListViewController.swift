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
    var listStyle: ReminderListStyle = .today
    var filteredReminders: [Reminder] {
        return reminders.filter{listStyle.shouldInclude(date: $0.dueDate)}.sorted{$0.dueDate < $1.dueDate}
    }
    let listStyleSegmentedControl = UISegmentedControl(items:  [ ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name ] )
  
    
    
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
      
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibilty label")
        navigationItem.rightBarButtonItem = addButton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        
        if  #available(iOS 16, *) {
          navigationItem.style = .navigator
        }
        updateSnapshot()
        collectionView.dataSource = dataSource
    }
    private func listLayout() -> UICollectionViewCompositionalLayout {
        // creates a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
    }
    
    // not showing the item user tapped as selected so return false. Will show details instead
    override func collectionView ( _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredReminders[indexPath.item].id
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
  
    // custom swipe actions with a row in the list
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
      guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {
        return nil
      }
      // displays a button for each action in the configuration. Label for the button is the action's title
      let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
      // custom background if you do not want the desctrutive red background
      let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
        [weak self] _, _, completion in
        self?.deleteReminder(withId: id)
        self?.updateSnapshot()
        completion(false)
      }
      return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

