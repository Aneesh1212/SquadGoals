//
//  Goal.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation
import SwiftUI

struct Goal : Hashable {
    
    var title : String
    var reason : String
    var category : String
    var currTargets : Array<Target>
    var momentumScore : Int
    var positiveMomentum : Int
    var negativeMomentum : Int
    var crossedOff : Bool
    var key : String
    var pastTargets : Dictionary<Date, Array<Target>>
    var brags : Array<Brag>
    
    init(title: String, reason : String, category : String, currTargets : Array<Target>, momentumScore : Int, positiveMomentum : Int, negativeMomentum : Int, crossedOff: Bool, key: String = "", pastTargets: Dictionary<Date, Array<Target>> = [:], brags: Array<Brag> = []) {
        self.title = title
        self.reason = reason
        self.category = category
        self.currTargets = currTargets
        self.momentumScore = momentumScore
        self.positiveMomentum = positiveMomentum
        self.negativeMomentum = negativeMomentum
        self.crossedOff = crossedOff
        self.key = key
        self.pastTargets = pastTargets
        self.brags = brags
    }
}
