//
//  APIRequests.swift
//  MinistryOfElectricity
//
//  Created by Esslam Emad on 2/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation
import Moya

enum APIRequests {
    
    
    case login(email: String, password: String)
    case sendForm(form: Form)
    case upload(image: UIImage)
    case aboutUS
    
    
}


extension APIRequests: TargetType{
    var baseURL: URL{
        
        return URL(string: "https://sh.alyomhost.net/electricity/ar/mobile")!
        
        
    }
    
    var path: String{
        switch self{
       
        case .login:
            return "login"
        case .sendForm:
            return "fillForm"
        case .upload:
            return "upload"
        case .aboutUS:
            return "pages/1"
       
        }
    }
    
    
    var method: Moya.Method{
        switch self{
        case .login, .sendForm, .upload:
            return .post
        default:
            return .get
        }
    }
    
    
    
    var task: Task{
        switch self{
            
       
        case .login(email: let email, password: let password):
            return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
        case .sendForm(form: let form):
            return .requestJSONEncodable(form)
        case.upload(image: let image):
            let data = image.jpegData(compressionQuality: 0.75)!
            let imageData = MultipartFormData(provider: .data(data), name: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            let multipartData = [imageData]
            return .uploadMultipart(multipartData)
        default:
            return .requestPlain
            
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json",
                "client": "64fa3cdf119727f5a8d66827f3c2a94eba49b1e2",
                "secret": "d78a4825ff52332ed76bc4d6dbb04404f6e6f38a"]
    }
}
