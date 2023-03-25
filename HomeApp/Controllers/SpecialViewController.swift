//
//  SpecialViewController.swift
//  HomeApp
//
//  Created by Pavel on 25.03.23.
//

import UIKit

class SpecialViewController: UIViewController {

    @IBOutlet weak var specialSlider: GradientSlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderLabel.text = "\(specialSlider.currentValue)"
        specialSlider.delegate = self
    }
}

extension SpecialViewController: GradientSliderDelegate {
    func gradientSliderBegan(value: Double) {
        sliderLabel.text = "Begin \(specialSlider.currentValue)"
    }
    
    func gradientSliderMoved(value: Double) {
        sliderLabel.text = "Moving \(specialSlider.currentValue)"
    }
    
    func gradientSliderEnded(value: Double) {
        sliderLabel.text = "End \(specialSlider.currentValue)"
    }
    
    
}
