//
//  DateExtension.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-18.
//

extension String {
    func monthDayOnly() -> String {
        let parts = self.split(separator: "-")
        if parts.count == 3 {
            return "\(parts[1])-\(parts[2])" 
        }
        return self
    }
}
