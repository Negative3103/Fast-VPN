//
//  UpdateViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 31/07/24.
//

import UIKit
import Haptica

final class UpdateViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = UpdateView
    
    //MARK: - Services
    internal var coordinator: VPNCoordinator?
    
    //MARK: - Actions
    @IBAction func acceptAction(_ sender: UIButton) {
        dismiss(animated: true) {
            Haptic.impact(.soft).generate()
            UserDefaults.standard.updateIsShowed(update: true)
        }
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.updateIsShowed(update: true)
    }
    
}
