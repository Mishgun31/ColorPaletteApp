//
//  MainViewController.swift
//  ColorPaletteApp
//
//  Created by Михаил Мезенцев on 07.08.2021.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setColor(with color: UIColor)
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 1, green: 0.5, blue: 0.3, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.color = view.backgroundColor
        settingsVC.delegate = self
    }
}

extension MainViewController: SettingsViewControllerDelegate {
    func setColor(with color: UIColor) {
        view.backgroundColor = color
    }
}
