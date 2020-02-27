//
//  Endpoints.swift
//  Hiromant
//
//  Created by Yerassyl Zhassuzakhov on 4/8/19.
//  Copyright © 2019 Nursultan. All rights reserved.
//

import Alamofire

enum Endpoints: EndPointType {
    
    case login(parameters : Parameters)
    case registration(parameters: Parameters)
    
    
    case getNews(parameters : Parameters)
    
    case forgotPassword(params : Parameters)
    case subscribeToCorrection(token : String, params : Parameters)
    case getCorrectionContent(token : String, params : Parameters)
    case getUser(token: String)
    
    // Main
    case getBannerPlaylists(token : String)
    case getBeginPlaylists(token: String)
    case getPopularPlaylists(token: String)
    
    // Programs
    case getPrograms(token: String)
    case getSearchTrends(token: String)
    case getSearchPlaylists(token: String, params : Parameters)
    case getSearchTracks(token: String, params : Parameters)
    
    // Favorite
    case getLikedPlaylists(token: String)
    case getLikedTracks(token: String)
    
    
    // Programs
    case getOneProgramTracks(token: String, params: Parameters)
    case patchLikeProgram(token: String, params: Parameters)
    case patchUnlikeProgram(token: String, params: Parameters)
    
    // Backround Tracks
    case getBackroundTracks(token: String)
    case patchlikeUnlikeTrack(token: String, params: Parameters)
    
    
    // Profile
    case changeAboutMe(token : String, params : Parameters)
    
    case postShowTrack(token: String, parameters: Parameters)
    case getNumericalInformations(token: String, params : Parameters)
    case getAkilOiOlshemi(token: String)
    case getOneWeek(token: String)
    case getEndOne(token: String, params: Parameters)
    
    // payment
    case getPaymentType(token: String)
    case postPayboxPay(token: String, params: Parameters)
    
    case resetPassword(parameters: Parameters)
    case editProfile(token: String, data: Data, parameters: Parameters)
    case getCorrections(token : String)
    case getInteresting(token : String)
    case postDirectConsultation(token : String, params : Parameters)
    case postRemoteConsultation(token : String, params : Parameters, data : Any)
    case getInfoAboutMe
    case getStraightInfo
    case getRemoteInfo
    
    var baseURL: String {
        return "http://185.22.67.88/api/"
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login(_):
            return .post
        case    .registration(_):
            return  .post
        case .resetPassword(_):
            return .post
        case .editProfile(_, _, _):
            return .patch
        case    .postDirectConsultation(_, _):
            return  .post
        case    .changeAboutMe(_, _):
            return  .patch
        case    .forgotPassword(_):
            return  .post
        case    .patchLikeProgram(_, _), .patchUnlikeProgram(_, _):
            return .patch
        case    .patchlikeUnlikeTrack(_, _):
             return .patch
        case    .postShowTrack(_, _):
            return .post
        case .postPayboxPay(_, _):
            return .post
        default:
            return  .get
        }
    }
    
    var httpTask: HTTPTask {
        switch self {
            
        case .login(let parameters):
            return .requestWithParameters(parameters: parameters)
        case    .registration(let params):
            return .requestWithParameters(parameters: params)
        case .resetPassword(let parameters):
            return .requestWithParameters(parameters: parameters)
        case let .editProfile(_, data, parameters):
            return .requestWithMultipartData(data: data, parameters: parameters, dataParameterName: "avatar")
        case   .postDirectConsultation(_, let params):
            return .requestWithParameters(parameters: params)
        case    .postRemoteConsultation(_, let params, let data):
            return .requestWithMultipartData(data: data, parameters: params, dataParameterName: "image")
        case    .getNews(let params):
            return .requestWithParameters(parameters: params)
        case    .subscribeToCorrection(_, let params):
            return .requestWithParameters(parameters: params)
        case    .getCorrectionContent(_, let params):
            return .requestWithParameters(parameters: params)
        case    .changeAboutMe(_, let params):
            return .requestWithParameters(parameters: params)
        case    .forgotPassword(let params):
            return .requestWithParameters(parameters: params)
        case    .postShowTrack(_, let parameters):
            return .requestWithParameters(parameters: parameters)
        case    .postPayboxPay(_, let params):
            return .requestWithParameters(parameters: params)
        case    .getNumericalInformations(_, let params):
            return .requestWithParameters(parameters: params)
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getUser(let token):
            return ["Authorization": "JWT \(token)"]
        case .editProfile(let token, _, _):
            return ["Authorization": "JWT \(token)"]
        case .postDirectConsultation(let token, _):
            return  ["Authorization" : token]
        case .postRemoteConsultation(let token, _, _):
            return  ["Authorization" : token]
        case .getCorrections(let token):
            return  ["Authorization" : token]
        case .getInteresting(let token):
            return  ["Authorization" : token]
        case .getBannerPlaylists(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getBeginPlaylists(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getPopularPlaylists(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getPrograms(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getSearchTrends(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getSearchPlaylists(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .getSearchTracks(let token, _):
        return ["Authorization" : "JWT \(token)"]
        case .getLikedPlaylists(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getLikedTracks(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getOneProgramTracks(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .patchLikeProgram(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .patchUnlikeProgram(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .getBackroundTracks(let token):
            return ["Authorization" : "JWT \(token)"]
        case .patchlikeUnlikeTrack(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .postShowTrack(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .getNumericalInformations(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .getAkilOiOlshemi(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getOneWeek(let token):
            return ["Authorization" : "JWT \(token)"]
        case .getEndOne(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .subscribeToCorrection(let token, _):
            return ["Authorization" : token]
        case .getCorrectionContent(let token, _):
            return ["Authorization" : token]
        case .changeAboutMe(let token, _):
            return ["Authorization" : "JWT \(token)"]
        case .getPaymentType(let token):
            return ["Authorization" : "JWT \(token)"]
        case .postPayboxPay(let token, _):
            return ["Authorization" : "JWT \(token)"]
        default:
            return [:]
        }
    }
    
    var path: String {
        switch self {
        case                             .login(_): return "core/login/"
        case                             .registration(_): return "core/register/"
        case                             .getUser(_): return "core/profile/"
        case                       .resetPassword(_): return "forgotPassword"
        case                   .editProfile(_, _, _): return "core/profile/"
        case                                .postRemoteConsultation(_, _, _) : return "makeRemoteOrder"
        case                                .getInfoAboutMe : return "getBiography"
        case                                .postDirectConsultation(_, _) :
            return "makeStraightOrder"
        case                                .getInteresting(_) : return "getInterestCorrections"
        case                                .getCorrections(_) : return "getCorrections"
        case                                .getNews(let params) : return "getNews?page=\(params["page"]!)"
        case                                .getBannerPlaylists(_) : return "/music/banner-playlists/"
        case .getBeginPlaylists(_):
            return "/music/begin-playlists/"
        case                                .getPopularPlaylists(_): return "/music/popular-playlists/"
        case                                .getPrograms(_): return "music/programs/"
        case                                .getSearchTrends(_): return "music/search/trends/?limit=10"
        case                                .getSearchPlaylists(_, let params): return "music/search/playlists/\(params["search_str"]!)/"
        case                                .getSearchTracks(_,let params): return "music/search/tracks/\(params["search_str"]!)/"
        case                                .getLikedPlaylists(_): return "music/liked-playlists/?limit=10"
        case                                .getLikedTracks(_): return "music/liked-tracks/?limit=10"
        case                                .getOneProgramTracks(_, let params): return "music/playlists/\(params["value"]!)/"
        case                                .patchLikeProgram(_, let params):
            return "music/playlists/\(params["value"]!)/like/"
        case                                .patchUnlikeProgram(_, let params):
            return "music/playlists/\(params["value"]!)/unlike/"
        case                                .getBackroundTracks(_): return "music/background-tracks/"
        case                                .patchlikeUnlikeTrack(_, let params):
            return "music/tracks/\(params["value"]!)/\(params["type"]!)/"
        case                                .postShowTrack(_, _): return "statistics/tracks/"
        case                                .getNumericalInformations(_, _):
            return "statistics/common/"
        case                                .getAkilOiOlshemi(_):
                   return "statistics/week-overall/"
        case                                .getOneWeek(_):
                          return "statistics/week-minutes/"
        case                                .getEndOne(_, let params):
            return "music/tracks/\(params["value"]!)/finished/"
        case                                .getPaymentType(_):
            return "core/subscription-types/"
        case                                .postPayboxPay(_, _):
            return "paybox/pay/"
        case                                .subscribeToCorrection(_, let params) : return "setSubscription?correction_id=\(params["correction_id"]!)"
        case                                .getCorrectionContent(_, let params):
            return "getContents?page=\(params["page"]!)&correction_id=\(params["correction_id"]!)"
        case                                .changeAboutMe(_, _):
            return "core/profile/"
        case                                .forgotPassword(_):
            return "forgotPassword"
        case                                .getStraightInfo: return "getStraightPrice"
        case                                .getRemoteInfo: return "getRemotePrice"
        
        }
    }
}
