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
    @IBOutlet weak var daysLabel: UILabel!
    //for localization
    @IBOutlet weak var addingLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var withLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelBotton: UIButton!
    
    var day = 0{
        willSet{
            daysLabel?.text = newValue.description
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        durationStepper?.value = 0
        addingLabel.text=NSLocalizedString("str_adding_destination", comment: "")
        placeLabel.text=NSLocalizedString("str_place", comment: "")
        budgetLabel.text=NSLocalizedString("str_budget", comment: "")
        withLabel.text=NSLocalizedString("str_with", comment: "")
        durationLabel.text=NSLocalizedString("str_duration", comment: "")
        activityLabel.text=NSLocalizedString("str_activity", comment: "")
        addButton.setTitle(NSLocalizedString("str_add", comment: ""), for: .normal)
        cancelBotton.setTitle(NSLocalizedString("str_cancel", comment: ""), for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func convert(input: Int) -> String{
        switch input{
        case 0:
            return NSLocalizedString("str_picker_friends", comment: "")
        case 1:
            return NSLocalizedString("str_picker_family", comment: "")
        case 2:
            return NSLocalizedString("str_picker_love", comment: "")
        default:
            return NSLocalizedString("str_picker_self", comment: "")
        }
    }
    
    func savePlace(name: String, budget: Int16, activity: String) {
        let context = AppDelegate.cdContext
        if let entity = NSEntityDescription.entity(forEntityName: "Place", in: context) {
            let place = NSManagedObject(entity: entity, insertInto: context)
            place.setValue(name, forKeyPath: "name")
            place.setValue(budget, forKeyPath: "budget")
            place.setValue(activity, forKeyPath: "activity")
            place.setValue(convert(input: withPicker.selectedRow(inComponent: 0)), forKeyPath: "with")
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
        let alert = UIAlertController(title: NSLocalizedString("str_warning", comment: ""), message: NSLocalizedString("str_are_you_sure_cancel", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("str_ok", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)
//        presentingViewController?.dismiss(animated: true)
    }
    @IBAction func onAdd(_ sender: Any) {
        if let name = placeField?.text, let budget = Int16((budgetField?.text)!), let activity = activityField?.text{
            savePlace(name: name, budget: budget, activity: activity)
        }
        presentingViewController?.dismiss(animated: true)
    }
    
    
}

extension AddVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PlaceType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PlaceType(rawValue: row)?.with()
    }
}
