//
//  PlaceType.swift
//  BucketList
//
//  Created by Zheng, Minghui on 11/1/21.
//

import Foundation
import UIKit

enum PlaceType: Int, CaseIterable{
    case friends, family, significantOther, yourself
    func with() ->String{
        switch self{
        case .friends:
            return "Friends"
        case .family:
            return "Family"
        case .significantOther:
            return "Significant other"
        case .yourself:
            return "Yourself"
        }
    }
}
