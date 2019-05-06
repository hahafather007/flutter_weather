//
//  FeedbackUtil.swift
//  Runner
//
//  Created by 活雷轰 on 2019/5/6.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

class FeedbackUtil {
    static func openQQ(qqNum: String, groupKey: String?) -> Bool {
        var url = ""
        if (groupKey == nil) {
            url = "mqq://im/chat?chat_type=wpa&uin=\(qqNum)&version=1&src_type=web"
        } else {
            url = "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=\(qqNum)&key=\(groupKey!)&card_type=group&source=external"
        }
        if let url = URL(string: url) {
            return UIApplication.shared.openURL(url)
        }
        
        return false
    }
    
    static func sendEmail(email: String) -> Bool {
        let url = URL(string: "mailto:\(email)")
        UIApplication.shared.openURL(url!)
        
        return true
    }
}
