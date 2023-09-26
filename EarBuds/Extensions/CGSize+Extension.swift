//
//  CGSize+Extension.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/12.
//

import CoreGraphics

extension CGSize {
    
    /// The area of the size.
    var area: CGFloat {
        return width * height
    }
    
    /// Returns a new size of the target area, keeping the same aspect ratio.
    func transformToFit(in targetArea: CGFloat) -> CGSize {
        let ratio = area / targetArea
        let targetSize = CGSize(width: width / sqrt(ratio), height: height / sqrt(ratio))
        
        return targetSize
    }
    
}
