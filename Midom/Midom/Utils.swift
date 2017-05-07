//
//  Utils.swift
//  Midom
//
//  Created by Eugen Druzin on 30/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation

class Utils {
    
    static func getDateFromDouble(date: UInt64?) -> String {
        if let date = date {
            let dateFormat = Date(timeIntervalSince1970: TimeInterval(date / 1000))
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: dateFormat)
            
            let year =  components.year?.description ?? ""
            let month = components.month?.description ?? ""
            let day = components.day?.description ?? ""
            return "\(day).\(month).\(year)."
        } else {
            return ""
        }
    }
    
    static func getCreationDateLabel(date: UInt64?) -> String {
        let dateString = getDateFromDouble(date: date)
        return "Creation date: \(dateString)"
    }
    
    static func getStudyNameLabel(name: String?) -> String {
        let studyName = name ?? ""
        return "Name study: \(studyName)"
    }
    
    static func getSpecialistNameLabel(account: AccountDetails?) -> String {
        let name = account?.getFullName() ?? ""
        return "Study specialist: \(name))"
    }
    
    static func getSpecialistComment(messages: [ConsultationRequestMessage]) -> String {
        var comment = "Specialist comment: "
        for message in messages {
            let messageComment = message.comment ?? ""
            comment.append("\(messageComment) \n")
        }
        return comment
    }
}
