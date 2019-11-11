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
    @objc var isLocal: NSString?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        if streamId != nil{
        let player = EnxRN.sharedState.players[(streamId)! as String]
        var stream = EnxRN.sharedState.subscriberStreams[(streamId)! as String]
        if stream == nil {
              stream = EnxRN.sharedState.publishStreams[(streamId)! as String]
        }
        if player != nil{
            player?.frame = self.bounds
            player?.removeFromSuperview()
           // player?.contentMode = UIView.ContentMode.scaleAspectFill
            self.addSubview(player!)
            if(stream != nil){
                stream?.attachRenderer(player!)
            }
        }
        else {
            if(isLocal == "local"){
                let player = EnxPlayerView.init(localView: self.bounds)
                self.addSubview(player)
                //  player?.contentMode = UIView.ContentMode.scaleAspectFill
                EnxRN.sharedState.players.updateValue(player, forKey: streamId! as String)
                if(stream != nil){
                    stream?.attachRenderer(player)
                }
            }
            else {
                let player =  EnxPlayerView.init(remoteView: self.bounds)
                self.addSubview(player)
                // player?.contentMode = UIView.ContentMode.scaleAspectFill
                EnxRN.sharedState.players.updateValue(player, forKey: streamId! as String)
                if(stream != nil){
                    stream?.attachRenderer(player)
                }
            }
        }
      }
     }
    }


