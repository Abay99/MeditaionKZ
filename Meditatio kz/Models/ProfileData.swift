//
//  ProfileData.swift
//  Meditatio kz
//
//  Created by Abai Kalikov on 11/6/19.
//  Copyright © 2019 Nazhmeddin Babakhanov. All rights reserved.
//
 
 
struct ProfileData: Decodable {
    let firstName: String?
    let avatar: String?
    let allowNotifications: Bool
    let subscribed: Bool
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case avatar
        case allowNotifications = "allow_notifications"
        case subscribed
    }
}
