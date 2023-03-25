//
//  SliderUtils.swift
//  HomeApp
//
//  Created by Pavel on 24.03.23.
//

import Foundation

enum TouchType {
    case began
    case moved
    case ended
}

protocol SolidSliderDelegate {
    func solidSliderBegan(value: Double)
    func solidSliderMoved(value: Double)
    func solidSliderEnded(value: Double)
}

protocol ReversedSliderDelegate {
    func reversedSliderBegan(value: Double)
    func reversedSliderMoved(value: Double)
    func reversedSliderEnded(value: Double)
}

protocol GradientSliderDelegate {
    func gradientSliderBegan(value: Double)
    func gradientSliderMoved(value: Double)
    func gradientSliderEnded(value: Double)
}
