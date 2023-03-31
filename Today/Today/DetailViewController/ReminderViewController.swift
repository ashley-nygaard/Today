//
//  ReminderViewController.swift
//  Today
//
//  Created by Ashley Nygaard on 3/30/23.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    // instances of int for the section number
    // instancs of Row for the list of rows
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>

    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Row>
    
    var reminder: Reminder
    private var dataSource: DataSource!
    

    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    // interface builder stores archives of view controllers. We need coder so system can use it
    // if controller can't decode it, initalize fails
    // if intilizaer fails use optional that contains nils
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    // register the cell with the collection view and create data source after view loads
    // superclass gets first chance to perform tasks, then custom tasks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // don't create cells that exist off screen, maintain a list of cells to reuse as they go off screen
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
       
        if #available(iOS 16, *) {
            navigationItem.style = .navigator

        }
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
       

        updateSnapshot()
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        
        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .todayPrimaryTint
        
    }
    
    func text(for row: Row ) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened )
        case .title: return reminder.title
        }
    }
    
    func updateSnapshot(){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems([Row.title, Row.date, Row.time, Row.notes], toSection: 0)
        dataSource.apply(snapshot)
    }
}
