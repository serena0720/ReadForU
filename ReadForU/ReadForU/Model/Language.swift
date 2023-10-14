//
//  LanguageCode.swift
//  ReadForU
//
//  Created by Serena on 2023/10/14.
//

enum Language: String {
    case korean
    case english
    case japanese
    case chinese
    case traditionalChineseCharacters
    
    var inKorean: String {
        switch self {
        case .korean:
            "한국어"
        case .english:
            "영어"
        case .japanese:
            "일본어"
        case .chinese:
            "중국어 간체"
        case .traditionalChineseCharacters:
            "중국어 번체"
        }
    }
    
    var code: String {
        switch self {
        case .korean:
            "ko"
        case .english:
            "en"
        case .japanese:
            "ja"
        case .chinese:
            "zh-CN"
        case .traditionalChineseCharacters:
            "zh-TW"
        }
    }
}
