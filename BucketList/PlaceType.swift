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
            return NSLocalizedString("str_picker_friends", comment: "")
        case .family:
            return NSLocalizedString("str_picker_family", comment: "")
        case .significantOther:
            return NSLocalizedString("str_picker_love", comment: "")
        case .yourself:
            return NSLocalizedString("str_picker_self", comment: "")
        }
    }
}
