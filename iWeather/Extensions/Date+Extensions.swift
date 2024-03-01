import Foundation

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM EEE"
        formatter.timeZone = .current
        return formatter
    }()
    
    var formatted: String {
        return Date.formatter.string(from: self)
    }
}

extension String {
    func dateFromISO8601String() -> Date {
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            return date
        }
        return isoDateFormatter.date(from: self) ?? Date()
    }
}
