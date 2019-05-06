//
//  EnxStreamView.swift
//  Enx
//
//  Created by Daljeet Singh on 04/04/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import EnxRTCiOS
@objc(EnxStreamView)
class EnxStreamView : UIView {
    @objc var streamId: NSString?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        if streamId != nil{
        let pp = EnxRN.sharedState.players[(streamId)! as String]
        let stream = EnxRN.sharedState.subscriberStreams[(streamId)! as String]
            
        if pp != nil{
            pp?.removeFromSuperview()
            self.addSubview(pp!)
            if(stream != nil){
                stream?.attachRenderer(pp!)
            }
        }
        else {
            let player = EnxPlayerView.init(frame: self.bounds)
            self.addSubview(player!)
            EnxRN.sharedState.players.updateValue(player!, forKey: streamId! as String)
            if(stream != nil){
                stream?.attachRenderer(player!)
            }
        }
      }
     }
    }


