//
//  SettingsViewController.swift
//  ColorPaletteApp
//
//  Created by Михаил Мезенцев on 08.07.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var colorPaletteView: UIView!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTF: UITextField!
    @IBOutlet weak var greenTF: UITextField!
    @IBOutlet weak var blueTF: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var color: UIColor!
    var delegate: SettingsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redTF.delegate = self
        greenTF.delegate = self
        blueTF.delegate = self
        
        addGradientLayer()
        setColorPaletteAppearance()
        setValuesForSliders()
        setValuesForLabels()
        setValuesForTextFields()
        addDoneButtonOnKeyboard()
        
        registerForKeboardNotifications()
        addTapGestureRecognizer()
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        switch sender {
        case redSlider:
            redValueLabel.text = getValue(from: sender)
            redTF.text = getValue(from: sender)
        case greenSlider:
            greenValueLabel.text = getValue(from: sender)
            greenTF.text = getValue(from: sender)
        default:
            blueValueLabel.text = getValue(from: sender)
            blueTF.text = getValue(from: sender)
        }
        
        colorPaletteView.backgroundColor = setColor()
        color = setColor()
    }
    
    @IBAction func doneButtonPressed() {
        delegate.setColor(with: color)
        dismiss(animated: true)
    }
}

//MARK: - Private methods
extension SettingsViewController {
    
    private func setColorPaletteAppearance() {
        colorPaletteView.layer.cornerRadius = 15
        colorPaletteView.backgroundColor = color
        colorPaletteView.layer.borderWidth = 4
        colorPaletteView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func setValuesForLabels() {
        redValueLabel.text = getValue(from: redSlider)
        greenValueLabel.text = getValue(from: greenSlider)
        blueValueLabel.text = getValue(from: blueSlider)
    }
    
    private func setValuesForSliders() {
        redSlider.value = Float(color.cgColor.components?[0] ?? 0.5)
        greenSlider.value = Float(color.cgColor.components?[1] ?? 0.5)
        blueSlider.value = Float(color.cgColor.components?[2] ?? 0.5)
    }
    
    private func setValuesForTextFields() {
        redTF.text = getValue(from: redSlider)
        greenTF.text = getValue(from: greenSlider)
        blueTF.text = getValue(from: blueSlider)
    }
    
    private func getValue(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func setColor() -> UIColor {
        UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
}

//MARK: - Working with TextFields
extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case redTF:
            let redValue = getFloatFrom(textField)
            redSlider.setValue(redValue, animated: true)
            redValueLabel.text = getValue(from: redSlider)
            textField.text = getValue(from: redSlider)
        case greenTF:
            let greenValue = getFloatFrom(textField)
            greenSlider.setValue(greenValue, animated: true)
            greenValueLabel.text = getValue(from: greenSlider)
            textField.text = getValue(from: greenSlider)
        default:
            let blueValue = getFloatFrom(textField)
            blueSlider.setValue(blueValue, animated: true)
            blueValueLabel.text = getValue(from: blueSlider)
            textField.text = getValue(from: blueSlider)
        }
        
        colorPaletteView.backgroundColor = setColor()
        color = setColor()
    }
    
    private func getFloatFrom(_ textField: UITextField) -> Float {
        let stringValue = textField.text ?? "1.0"
        let formattedValue = stringValue.replacingOccurrences(of: ",", with: ".")
        return Float(formattedValue) ?? 1.0
    }
}
    
//MARK: - Working with keaboard
extension SettingsViewController {
    
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let keyboardInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        guard let keyboardSize = (keyboardInfo as? NSValue)?.cgRectValue else { return }
        
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardSize.height + 5,
            right: 0
        )
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func addDoneButtonOnKeyboard() {
        let toolBar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        )
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(endEditing)
        )
        
        let items = [flexSpace, doneButton]
        toolBar.items = items
        toolBar.sizeToFit()
        
        redTF.inputAccessoryView = toolBar
        greenTF.inputAccessoryView = toolBar
        blueTF.inputAccessoryView = toolBar
    }
    
    private func registerForKeboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(endEditing)
        )
        
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

//MARK: - Set gradient
extension SettingsViewController {
    
    private func addGradientLayer() {
        
        let colorOne = UIColor(
            red: 14 / 255,
            green: 217 / 255,
            blue: 120 / 255,
            alpha: 1
        )
        
        let colorTwo = UIColor(
            red: 10 / 255,
            green: 128 / 255,
            blue: 71 / 255,
            alpha: 1
        )
        
        let colorThree = UIColor(
            red: 3 / 255,
            green: 45 / 255,
            blue: 25 / 255,
            alpha: 1
        )
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.bounds
        gradient.colors = [
            colorOne.cgColor,
            colorTwo.cgColor,
            colorThree.cgColor
        ]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        //        gradient.locations = [0.0, 1.0]
        //        gradient.startPoint = CGPoint(x: 0, y: 0)
        //        gradient.endPoint = CGPoint(x: 0, y: 1)
    }
}

