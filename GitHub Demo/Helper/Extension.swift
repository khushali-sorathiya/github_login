//
//  Extension.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import UIKit

extension String {
    
    func formatDate(date: String, dateFormate: String, formate: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormate
        guard let date = dateFormatter.date(from: date) else {
            return "Invalid Date"
        }
        
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: date)
    }
}
