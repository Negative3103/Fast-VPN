//
//  AboutViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit

final class AboutViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = AboutView
    
    //MARK: - Services
    internal var coordinator: AboutCoordinator?
}
