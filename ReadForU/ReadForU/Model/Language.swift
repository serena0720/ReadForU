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
        if text == Self.korean.inKorean {
            self = .korean
        } else if text == Self.english.inKorean {
            self = .english
        } else if text == Self.japanese.inKorean {
            self = .japanese
        } else if text == Self.chinese.inKorean {
            self = .chinese
        } else {
            self = .traditionalChineseCharacters
        }
    }
}
