//
//  Difference.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/12.
//

import UIKit

extension UIColor {
    
    public enum ColorDifferenceResult: Comparable {
        
        /// There is no difference between the two colors.
        case indentical(CGFloat)
        
        /// The difference between the two colors is not perceptible by human eye.
        case similar(CGFloat)
        
        /// The difference between the two colors is perceptible through close observation.
        case close(CGFloat)
        
        /// The difference between the two colors is perceptible at a glance.
        case near(CGFloat)
        
        /// The two colors are different, but not opposite.
        case different(CGFloat)
        
        /// The two colors are more opposite than similar.
        case far(CGFloat)
        
        init(value: CGFloat) {
            if value == 0 {
                self = .indentical(value)
            } else if value <= 1.0 {
                self = .similar(value)
            } else if value <= 2.0 {
                self = .close(value)
            } else if value <= 10.0 {
                self = .near(value)
            } else if value <= 50.0 {
                self = .different(value)
            } else {
                self = .far(value)
            }
        }
        
        var associatedValue: CGFloat {
            switch self {
            case .indentical(let value),
                 .similar(let value),
                 .close(let value),
                 .near(let value),
                 .different(let value),
                 .far(let value):
                 return value
            }
        }
        
        public static func < (lhs: UIColor.ColorDifferenceResult, rhs: UIColor.ColorDifferenceResult) -> Bool {
            return lhs.associatedValue < rhs.associatedValue
        }
                
    }
    
    /// The different algorithms for comparing colors.
    /// @see https://en.wikipedia.org/wiki/Color_difference
    public enum DeltaEFormula {
        /// The euclidean algorithm is the simplest and fastest one, but will yield results that are unexpected to the human eye. Especially in the green range.
        /// It simply calculates the euclidean distance in the RGB color space.
        case euclidean
        
        /// The `CIE76`algorithm is fast and yields acceptable results in most scenario.
        case CIE76
        
        /// The `CIE94` algorithm is an improvement to the `CIE76`, especially for the saturated regions. It's marginally slower than `CIE76`.
        case CIE94
        
        /// The `CIEDE2000` algorithm is the most precise algorithm to compare colors.
        /// It is considerably slower than its predecessors.
        case CIEDE2000
    }
    
    /// Computes the difference between the passed in `UIColor` instance.
    ///
    /// - Parameters:
    ///   - color: The color to compare this instance to.
    ///   - formula: The algorithm to use to make the comparaison.
    /// - Returns: The different between the passed in `UIColor` instance and this instance.
    public func difference(from color: UIColor, using formula: DeltaEFormula = .CIE94) -> ColorDifferenceResult {
        switch formula {
        case .euclidean:
            let differenceValue = sqrt(pow(self.red255 - color.red255, 2) + pow(self.green255 - color.green255, 2) + pow(self.blue255 - color.blue255, 2))
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        case .CIE76:
            let differenceValue = sqrt(pow(color.L - self.L, 2) + pow(color.a - self.a, 2) + pow(color.b - self.b, 2))
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        case .CIE94:
            let differenceValue = UIColor.deltaECIE94(lhs: self, rhs: color)
            let roundedDifferenceValue = differenceValue.rounded(.toNearestOrEven, precision: 100)
            return ColorDifferenceResult(value: roundedDifferenceValue)
        default:
            return ColorDifferenceResult(value: -1)
        }
    }
    
    private static func deltaECIE94(lhs: UIColor, rhs: UIColor) -> CGFloat {
        let kL: CGFloat = 1.0
        let kC: CGFloat = 1.0
        let kH: CGFloat = 1.0
        let k1: CGFloat = 0.045
        let k2: CGFloat = 0.015
        let sL: CGFloat = 1.0
        
        let c1 = sqrt(pow(lhs.a, 2) + pow(lhs.b, 2))
        let sC = 1 + k1 * c1
        let sH = 1 + k2 * c1
        
        let deltaL = lhs.L - rhs.L
        let deltaA = lhs.a - rhs.a
        let deltaB = lhs.b - rhs.b
                
        let c2 = sqrt(pow(rhs.a, 2) + pow(rhs.b, 2))
        let deltaCab = c1 - c2

        let deltaHab = sqrt(pow(deltaA, 2) + pow(deltaB, 2) - pow(deltaCab, 2))
        
        let p1 = pow(deltaL / (kL * sL), 2)
        let p2 = pow(deltaCab / (kC * sC), 2)
        let p3 = pow(deltaHab / (kH * sH), 2)
        
        let deltaE = sqrt(p1 + p2 + p3)
        
        return deltaE;
    }
    
}
private func +=<UIColor, String> (lhs: [UIColor: String], rhs: [UIColor: String]) -> [UIColor: String] {
    let summedUpDictionay = lhs.reduce(into: rhs) { (result, colorNamePair) in
        result[colorNamePair.key] = colorNamePair.value
    }
    return summedUpDictionay
}

struct Lab {
    let L: CGFloat
    let a: CGFloat
    let b: CGFloat
}

struct LabCalculator {
    static func convert(RGB: RGB) -> Lab {
        let XYZ = XYZCalculator.convert(rgb: RGB)
        let Lab = LabCalculator.convert(XYZ: XYZ)
        return Lab
    }
    
    static let referenceX: CGFloat = 95.047
    static let referenceY: CGFloat = 100.0
    static let referenceZ: CGFloat = 108.883
    
    static func convert(XYZ: XYZ) -> Lab {
        func transform(value: CGFloat) -> CGFloat {
            if value > 0.008856 {
                return pow(value, 1 / 3)
            } else {
                return (7.787 * value) + (16 / 116)
            }
        }
        
        let X = transform(value: XYZ.X / referenceX)
        let Y = transform(value: XYZ.Y / referenceY)
        let Z = transform(value: XYZ.Z / referenceZ)
        
        let L = ((116.0 * Y) - 16.0).rounded(.toNearestOrEven, precision: 100)
        let a = (500.0 * (X - Y)).rounded(.toNearestOrEven, precision: 100)
        let b = (200.0 * (Y - Z)).rounded(.toNearestOrEven, precision: 100)
        
        return Lab(L: L, a: a, b: b)
    }
}

extension UIColor {
    
    /// The L* value of the CIELAB color space.
    /// L* represents the lightness of the color from 0 (black) to 100 (white).
    public var L: CGFloat {
        let Lab = LabCalculator.convert(RGB: self.rgb)
        return Lab.L
    }
    
    /// The a* value of the CIELAB color space.
    /// a* represents colors from green to red.
    public var a: CGFloat {
        let Lab = LabCalculator.convert(RGB: self.rgb)
        return Lab.a
    }
    
    /// The b* value of the CIELAB color space.
    /// b* represents colors from blue to yellow.
    public var b: CGFloat {
        let Lab = LabCalculator.convert(RGB: self.rgb)
        return Lab.b
    }
    
}
