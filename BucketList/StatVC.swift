//
//  StatVC.swift
//  BucketList
//
//  Created by Zheng, Minghui on 10/31/21.
// ref: https://stackoverflow.com/questions/14822618/core-data-sum-of-all-instances-attribute

import UIKit
import CoreData

class StatVC: UIViewController{
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    //for localization
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var totalBudgetLabel: UILabel!
    @IBOutlet weak var totalVacationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //localization NSLocalizedString("string_title", comment: "")
        statLabel.text=NSLocalizedString("str_stat", comment: "")
        totalBudgetLabel.text=NSLocalizedString("str_total_budget", comment: "")
        totalVacationLabel.text=NSLocalizedString("str_total_days", comment: "")
        budgetLabel.text = NSLocalizedString("str_currency", comment: "")+sumbudget().description
        durationLabel.text = sumDuration().description
    }
    func sumbudget() -> Double {
       let context = AppDelegate.cdContext
       var budgetTotal : Double = 0

       let expression = NSExpressionDescription()
       expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "budget")])
       expression.name = "budgetTotal";
       expression.expressionResultType = NSAttributeType.doubleAttributeType

       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
       fetchRequest.propertiesToFetch = [expression]
       fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType

       do {
           let results = try context.fetch(fetchRequest)
           let resultMap = results[0] as! [String:Double]
           budgetTotal = resultMap["budgetTotal"]!
       } catch let error as NSError {
           NSLog("Error when summing budgets: \(error.localizedDescription)")
       }

       return budgetTotal
   }
func sumDuration() -> Double {
    let context = AppDelegate.cdContext

    var durationTotal : Double = 0

       let expression = NSExpressionDescription()
       expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "duration")])
       expression.name = "durationTotal";
       expression.expressionResultType = NSAttributeType.doubleAttributeType

       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
       fetchRequest.propertiesToFetch = [expression]
       fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType

       do {
           let results = try context.fetch(fetchRequest)
           let resultMap = results[0] as! [String:Double]
           durationTotal = resultMap["durationTotal"]!
       } catch let error as NSError {
           NSLog("Error when summing durations: \(error.localizedDescription)")
       }

       return durationTotal
    }
}
