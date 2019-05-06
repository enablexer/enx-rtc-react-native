//
//  EnxStreamManager.swift
//  Enx
//
//  Created by Daljeet Singh on 04/04/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(EnxPlayerViewSwift)
class EnxStreamManager: RCTViewManager {
    override func view() -> UIView {
        return EnxStreamView();
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true;
    }
}
