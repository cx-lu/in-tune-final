//
//  ColorPickerViewController.swift
//  InTune
//
//  Created by Christina Lu on 12/5/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation
import UIKit
import iOS_Color_Picker

class ColorPickerViewController: UIViewController, FCColorPickerViewControllerDelegate {
    var color: UIColor?
    
    func colorPickerViewController(_ colorPicker: FCColorPickerViewController, didSelect color: UIColor) {
        self.color = color;
        dismiss(animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidCancel(_ colorPicker: FCColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
