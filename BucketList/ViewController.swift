//
//  ViewController.swift
//  BucketList
//
//  Created by Zheng, Minghui on 10/31/21.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var places: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        readData()
    }
    
    func deletionAlert(name: String, completion: @escaping (UIAlertAction) -> Void) {
        let alertMsg = "Are you sure you want to delete \(name)?"
        let alert = UIAlertController(title: "Warning", message: alertMsg, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as? PlaceCell else {
            fatalError("Expected PlaceCell")
        }
        
        if let place = places[indexPath.row] as? Place {
            cell.update(with: place)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let place = places[indexPath.row] as? Place, let name = place.name {
                deletionAlert(name: name, completion: { _ in
                    self.deletePlace(place: place)
                })
            }
        }
    }
    
    // MARK: - CoreData
    
    func readData() {
        let context = AppDelegate.cdContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Place")
        do {
            places = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested place. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func deletePlace(place: Place) {
        let context = AppDelegate.cdContext
        if let _ = places.firstIndex(of: place)  {
            context.delete(place)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not delete the place. \(error), \(error.userInfo)")
            }
        }
        readData()
    }
    
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        readData()
        tableView.reloadData()
    }
}
