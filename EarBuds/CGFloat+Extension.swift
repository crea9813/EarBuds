//
//  CGFloat+Extension.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/12.
//

import CoreGraphics

extension CGFloat {
    
    func rounded(_ rule: FloatingPointRoundingRule, precision: Int) -> CGFloat {
        return (self * CGFloat(precision)).rounded(rule) / CGFloat(precision)
    }
    
}
