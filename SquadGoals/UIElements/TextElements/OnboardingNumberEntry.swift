//
//  OnboardingNumberEntry.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 10/16/22.
//

import Foundation
import SwiftUI

struct OnboardingNumberEntry : View {
    
    var placeholder : String
    var number: Binding<Int>
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = .init(integerLiteral: 1)
        formatter.maximum = .init(integerLiteral: Int.max)
        formatter.generatesDecimalNumbers = false
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body : some View {
        TextField(
            placeholder,
            value: number,
            formatter: numberFormatter
        )
            .font(.system(size: 16))
            .frame(height: 42, alignment: .center)
            .padding(.leading, 15)
            .background(.white)
            .cornerRadius(Styling.smallUnit)
            .foregroundColor(.black)
            .onChange(of: number, perform: { _ in })
    }
}

func format(phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex // numbers iterator

    // iterate over the mask characters until the iterator of numbers ends
    for ch in "XXX-XXX-XXXX" where index < numbers.endIndex {
        if ch == "X" {
            // mask requires a number in this place, so take the next one
            result.append(numbers[index])

            // move numbers iterator to the next index
            index = numbers.index(after: index)

        } else {
            result.append(ch) // just append a mask character
        }
    }
    return result
}
