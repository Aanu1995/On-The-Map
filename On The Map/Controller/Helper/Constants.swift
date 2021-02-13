//
//  Constants.swift
//  On The Map
//
//  Created by user on 10/02/2021.
//

import Foundation

struct Constants {
    
    struct UdacityApi {
        static let BaseUrl = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let UserBaseUrl = "https://onthemap-api.udacity.com/v1/users/"
        static let SessionUrl = "https://onthemap-api.udacity.com/v1/session"
        static let SignUpUrl = "https://auth.udacity.com/sign-up"
    }
    
    struct Notification {
        static let FetchNotifierIdentifier = "fetchStudentInformation"
    }
    
    struct SegueIdentifier {
        static let InfoPostingScreen = "InfoPostingScreen"
    }
}
