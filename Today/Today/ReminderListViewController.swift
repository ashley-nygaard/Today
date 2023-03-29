//
//  ViewController.swift
//  Today
//
//  Created by Ashley Nygaard on 3/29/23.
//

import UIKit

class ReminderListViewController: UICollectionViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var dataSource: DataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        let cellRegistration = UICollectionView.CellRegistration {
            // specify how to configure the content and appearance of a cell
            (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
            let reminder = Reminder.sampleData[indexPath.item]
            //get cell's default content configs
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminder.title
            cell.contentConfiguration = contentConfiguration
            
        }
        // closure accepts the indexPath to the location of the cell in the collection view and an item identifier
        dataSource = DataSource(collectionView: collectionView){
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdenfifier: String) in
            //reuse cells allows better performace with vast number of items
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdenfifier)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
//        var reminderTitles = [String]()
//        for reminder in Reminder.sampleData {
//            reminderTitles.append(reminder.title)
//        }
//        snapshot.appendItems(reminderTitles)
//        The above shorted to
        snapshot.appendItems(Reminder.sampleData.map { $0.title })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
    private func listLayout() -> UICollectionViewCompositionalLayout {
        // creates a section in a list layout
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        
        
    }
}

