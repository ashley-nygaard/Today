//
//  CAGradientLayter+ListStyle.swift
//  Today
//
//  Created by Ashley Nygaard on 4/26/23.
//

import UIKit

extension CAGradientLayer {
    // Self refters to CAGradientLayer type
    static func gradientLayer(for style: ReminderListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
        
    }
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
        case .all:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        case .future:
            beginColor = .todayGradientFutureBegin
            endColor = .todayGradientFutureEnd
        case .today:
            beginColor = .todayGradientTodayBegin
            endColor = .todayGradientTodayEnd
    
        }
        return [beginColor.cgColor, endColor.cgColor]
    }
    
}
