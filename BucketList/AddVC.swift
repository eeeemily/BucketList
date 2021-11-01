//
//  AddVC.swift
//  BucketList
//
//  Created by Zheng, Minghui on 10/31/21.
//

import UIKit
import CoreData

class AddVC: UIViewController{
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var budgetField: UITextField!
    @IBOutlet weak var durationStepper: UIStepper!
    @IBOutlet weak var withPicker: UIPickerView!
    @IBOutlet weak var activityField: UITextField!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    var day = 0{
        willSet{
            durationLabel?.text = newValue.description
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        durationStepper?.value = 7
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func savePlace(name: String, budget: Int16, activity: String) {
        let context = AppDelegate.cdContext
        if let entity = NSEntityDescription.entity(forEntityName: "Place", in: context) {
            let place = NSManagedObject(entity: entity, insertInto: context)
            place.setValue(name, forKeyPath: "name")
            place.setValue(budget, forKeyPath: "budget")
            place.setValue(activity, forKeyPath: "activity")
            place.setValue(withPicker.selectedRow(inComponent: 0), forKeyPath: "with")
            place.setValue(Int(durationStepper.value), forKeyPath: "duration")
//
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save the place. \(error), \(error.userInfo)")
            }
        }
        
    }
    @IBAction func onDurationChanged(_ sender: UIStepper) {
        day = Int(sender.value)
    }
    @IBAction func onCancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    @IBAction func onAdd(_ sender: Any) {
        if let name = placeField?.text, let budget = Int16((budgetField?.text)!), let activity = activityField?.text{
            savePlace(name: name, budget: budget, activity: activity)
        }
        presentingViewController?.dismiss(animated: true)
    }
}

extension AddVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == withPicker ? 1:2
    }
    
  
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == withPicker ?"hi?":PlaceType(rawValue: row)?.with()
    }

}
