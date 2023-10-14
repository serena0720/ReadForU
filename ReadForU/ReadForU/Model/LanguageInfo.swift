//
//  LanguageInfo.swift
//  ReadForU
//
//  Created by Serena on 2023/10/15.
//

class LanguageInfo {
    static let shared = LanguageInfo()
    
    var source: Language = Language.korean
    var target: Language = Language.english
}