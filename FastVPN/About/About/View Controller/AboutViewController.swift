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
    private let viewModel = VPNViewModel()
    internal var coordinator: AboutCoordinator?
    internal let customSpinnerView = CustomSpinnerView()
    
    //MARK: - Attributes
    private var fileType: FilesType? = .none
    
    //MARK: - Actions
    @IBAction func infoButtonActions(_ sender: UIButton) {
        Haptic.impact(.soft).generate()
        switch sender.tag {
        case 0:
            openURL(urlString: MainConstants.tgSupport.rawValue)
        case 1:
            sender.showAnimation()
            Haptic.impact(.soft).generate()
            showAlertDestructive(message: "deleteCurrentUrl".localized, buttonTitle: "delete".localized) {
                Notification.Name.deleteUrl.post()
                Haptic.impact(.soft).generate()
                self.view().dateView.isHidden = true
                self.showSuccessAlert()
            }
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
    
    @objc private func presentAddView() {
        coordinator?.presentAddView(viewController: self)
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceSettings()
        viewModel.getServerInfo()
    }

}

//MARK: - AddKeyPopUpViewControllerDelegate
extension AboutViewController: AddKeyViewControllerDelegate {
    func didFinishKey() {
        Notification.Name.connectKey.post()
    }
}

//MARK: - Networking
extension AboutViewController: VPNViewModelProtocol {
    func didFinishFetchRegistration(server: ServerModel?, endDate: String?, serverName: String?, message: String?) {
        if let endDate = endDate {
            view().dateView.isHidden = false
            view().dateLabel.text = "tariffEndDate".localized + Symbols.space.rawValue + endDate.changeTimeFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS", to: "yyyy.MM.dd HH:mm")
        } else {
            view().dateView.isHidden = true
        }
    }
    
    func didFinishFetch(server: ServerModel?, endDate: String?, serverName: String?, message: String?) {
        if let endDate = endDate {
            view().dateView.isHidden = false
            view().dateLabel.text = "tariffEndDate".localized + Symbols.space.rawValue + endDate.changeTimeFormat(from: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS", to: "yyyy.MM.dd HH:mm")
        } else {
            view().dateView.isHidden = true
        }
    }
}


//MARK: - Other funcs
extension AboutViewController {
    private func appearanceSettings() {
        viewModel.delegate = self
        navigationItem.title = "information".localized
        navigationController?.navigationBar.installBlurEffect()
        
        Notification.Name.getData.onPost { [weak self] _ in self?.viewModel.getServerInfo() }
        Notification.Name.universalLink.onPost { [weak self] clientID in
            guard let clientID = clientID.object as? String else { return }
            self?.viewModel.registration(clientId: clientID)
        }

        guard UserDefaults.standard.isFromRestrictedCountry() else { return }
        view().addButton.addTarget(self, action: #selector(presentAddView), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view().addButton)
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
        let recipientEmail = "support@rapiddevops.am"
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
