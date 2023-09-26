//
//  Color+Extension.swift
//  EarBuds
//
//  Created by 매기 on 2023/07/04.
//

import Foundation
import SwiftUI

extension Color {
    static func randomColor() -> Color {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        
        let randomColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
        
        return Color(randomColor)
    }
}
