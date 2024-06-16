//
//  AboutViewController.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 14/06/24.
//

import UIKit
import Haptica
import QuickLook
import MessageUI

enum FilesType: String {
    case attribution = "attribution"
    case conditions = "conditions"
    case dataCollection = "dataCollection"
    case politicy = "politicy"
}

final class AboutViewController: UIViewController, ViewSpecificController, AlertViewController {
    
    //MARK: - Root View
    typealias RootView = AboutView
    
    //MARK: - Services
    internal var coordinator: AboutCoordinator?
    
    //MARK: - Attributes
    private var fileType: FilesType? = .none
    
    //MARK: - Actions
    @IBAction func infoButtonActions(_ sender: UIButton) {
        Haptic.impact(.soft).generate()
        switch sender.tag {
        case 0,1:
            openURL(urlString: MainConstants.tgSupport.rawValue)
        case 2:
            openMail()
        case 3:
            coordinator?.pushLanguageVC(viewController: self)
        default:
            break
        }
    }
    
    @IBAction func licensesActions(_ sender: UIButton) {
        Haptic.impact(.soft).generate()
        switch sender.tag {
        case 0:
            fileType = .politicy
        case 1:
            fileType = .dataCollection
        case 2:
            fileType = .conditions
        case 3:
            fileType = .attribution
        default:
            break
        }
        guard let _  = fileType else { return }
        openFile()
    }
    
    //MARK: - Lifecycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

//MARK: - Other funcs
extension AboutViewController {
    private func appearanceSettings() {
        navigationController?.navigationBar.installBlurEffect()
    }
    
    private func openFile() {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true, completion: nil)
    }
}

//MARK: - QLPreviewControllerDataSource
extension AboutViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        guard let fileType = fileType,
              let fileURL = Bundle.main.url(forResource: fileType.rawValue, withExtension: "docx") else {
            fatalError("Could not find file: \(String(describing: fileType?.rawValue))")
        }
        return fileURL as QLPreviewItem
    }
}

//MARK: - MFMailComposeViewControllerDelegate
extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    internal func openMail() {
        let recipientEmail = "Support@rapiddevops.am"
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([recipientEmail])
            mailComposer.setSubject("Subject")
            mailComposer.setMessageBody("Message body", isHTML: false)
            present(mailComposer, animated: true, completion: nil)
        } else {
            print("Mail services are not available")
        }
    }
}

//MARK: - LanguageViewControllerDelegate
extension AboutViewController: LanguageViewControllerDelegate {
    func didSelect() {
        resetTabBarTransition()
    }
}
