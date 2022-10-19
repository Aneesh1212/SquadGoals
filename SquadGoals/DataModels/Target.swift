//
//  Target.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation

struct Target : Hashable {
    
    var title : String
    var frequency : Int
    var original : Int
    var key : String
    var creationDate : Date
    
    init(title : String, frequency : Int, original : Int, key : String, creationDate : Date = Calendar(identifier: .gregorian).startOfDay(for: Date())) {
        self.title = title
        self.frequency = frequency
        self.original = original
        self.key = key
        self.creationDate = creationDate
    }
}
