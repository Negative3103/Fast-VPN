//
//  VPNViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

final class VPNViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = VPNView
    
    //MARK: - Services
    internal var coordinator: VPNCoordinator?
}

