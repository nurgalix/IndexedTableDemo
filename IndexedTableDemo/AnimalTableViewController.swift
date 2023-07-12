//
//  ViewController.swift
//  IndexedTableDemo
//
//  Created by Simon Ng on 28/1/2021.
//

import UIKit

class AnimalTableViewController: UITableViewController {

    let animals = ["Bear", "Black Swan", "Buffalo", "Camel", "Cockatoo", "Dog", "Donkey", "Emu", "Giraffe", "Greater Rhea", "Hippopotamus", "Horse", "Koala", "Lion", "Llama", "Manatus", "Meerkat", "Panda", "Peacock", "Pig", "Platypus", "Polar Bear", "Rhinoceros", "Seagull", "Tasmania Devil", "Whale", "Whale Shark", "Wombat"]
    
    lazy var dataSource = configureDataSource()
    var animalsDict = [String: [String]]()
    var animalSectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate data
        tableView.dataSource = dataSource
        
        updateSnapshot()
        createAnimalDict()
    }


}

extension AnimalTableViewController {
    
    func configureDataSource() -> UITableViewDiffableDataSource<String, String> {

         let dataSource = UITableViewDiffableDataSource<String, String>(tableView: tableView) { (tableView, indexPath, animalName) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            // Configure the cell...
            cell.textLabel?.text = animalName
            
            // Convert the animal name to lower case and
            // then replace all occurences of a space with an underscore
            let imageFileName = animalName.lowercased().replacingOccurrences(of: " ", with: "_")
            cell.imageView?.image = UIImage(named: imageFileName)
            
            
            return cell
        }

        return dataSource
    }
    
    func updateSnapshot(animatingChange: Bool = false) {

        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(animalSectionTitles)
        animalSectionTitles.forEach { (section) in
            if let animals = animalsDict[section] {
                snapshot.appendItems(animals, toSection: section)
            }
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createAnimalDict() {
        for animal in animals {
            let firstLetterIndex = animal.index(animal.startIndex, offsetBy: 1)
            let animalKey = String(animal[..<firstLetterIndex])
            
            if var animalValues = animalsDict[animalKey] {
                animalValues.append(animal)
                animalsDict[animalKey] = animalValues
            } else {
                animalsDict[animalKey] = [animal]
            }
        }
        
        animalSectionTitles = [String](animalsDict.keys)
        animalSectionTitles = animalSectionTitles.sorted(by: {$0 < $1 })
    }
}
