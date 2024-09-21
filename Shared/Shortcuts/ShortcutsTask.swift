//
//  ShortcutsTask.swift
//  FastVPN
//
//  Created by Lev Vlasov on 18.09.2024.
//

import AppIntents
import Foundation

@available(iOS 16.0, *)
struct ShortcutButtonVPN: AppIntent {
    
    // title button
    static var title: LocalizedStringResource = "VPN Button"
    
    // description for Siri
    static var description = IntentDescription("Connect to VPN using VPN Button")
   
    
    func perform() async throws -> some IntentResult {
        print("vpn.connectVpn() Start")
    
        let vpn = await VPNViewController.shared
        
        await vpn.connectVpn()
        
        return .result()
    }
    
    // This Intent can be used in Siri
    static var parameterSummary: some ParameterSummary {
        Summary("Connect to Fast VPN")
    }
}

