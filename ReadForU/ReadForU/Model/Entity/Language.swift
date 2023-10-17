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
    
    init(text: String) {
        switch text {
        case Self.korean.inKorean:
            self = .korean
        case Self.english.inKorean:
            self = .english
        case Self.japanese.inKorean:
            self = .japanese
        case Self.chinese.inKorean:
            self = .chinese
        case Self.traditionalChineseCharacters.inKorean:
            self = .traditionalChineseCharacters
        default:
            self = .korean
        }
    }
}
