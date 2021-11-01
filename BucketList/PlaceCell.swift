//
//  PlaceCell.swift
//  BucketList
//
//  Created by Zheng, Minghui on 11/1/21.
//

import UIKit

class PlaceCell: UITableViewCell{
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var withLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with place: Place) {

        if let name = place.value(forKey: "name") as? String,
            let with = place.value(forKey: "with") as? String,
            let budget = place.value(forKey: "budget") as? Int16,
            let activity = place.value(forKey: "activity") as? String,
            let duration = place.value(forKey: "duration") as? Int16 {

            nameLabel?.text = name
            budgetLabel?.text = budget.description
            withLabel?.text = with.description


//            if let mediaType = MediaType(rawValue: type) {
//                typeImageView.image = mediaType.image()
//            }
        }
    }
}
