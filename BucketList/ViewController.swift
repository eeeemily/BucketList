//
//  ViewController.swift
//  BucketList
// ref: https://developer.apple.com/documentation/uikit/views_and_controls/table_views/configuring_the_cells_for_your_table
//  Created by Zheng, Minghui on 10/31/21.


import UIKit
import CoreData

class ViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //for localization
    var albumImg: UIImage = UIImage(named: "road")!
    let pc = PlaceCell()
    //    @IBOutlet weak var statButton: UIBarButtonItem!
    @IBOutlet weak var displayImg: UIImageView!
    var places: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("str_stat", comment: ""))
        self.title = NSLocalizedString("string_title", comment: "")
        readData()
        pc.changeImg(img: albumImg)

    }
    
    func deletionAlert(name: String, completion: @escaping (UIAlertAction) -> Void) {
        let alertMsg = NSLocalizedString("are_you_sure_delete", comment: "")+name
        let alert = UIAlertController(title: NSLocalizedString("str_warning", comment: ""), message: alertMsg, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("str_delete", comment: ""), style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: NSLocalizedString("str_cancel", comment: ""), style: .cancel)
        
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
        cell.imageView?.image = albumImg
//        pc.changeImg(img: albumImg)

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
    // MARK: - Brownie Point

    @IBAction func onPhotoBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage  {
            print("image changed!!!::")
            print(image)
//            pc.placeImageView?.image = image
            pc.changeImg(img: image)
            albumImg = image
            readData()

            tableView.reloadData()

        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        readData()
        tableView.reloadData()
    }
}
