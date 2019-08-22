//
//  EnxRN.swift
//  Enx
//
//  Created by Daljeet Singh on 01/04/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import EnxRTCiOS
class EnxRN : NSObject {
   @objc static let sharedState = EnxRN()
   @objc var room: EnxRoom?
    var subscriberStreams = [String: EnxStream]()
    var publishStreams = [String: EnxStream]()
    @objc var players = [String: EnxPlayerView]()
    override init() {
        super.init()
    }
}
