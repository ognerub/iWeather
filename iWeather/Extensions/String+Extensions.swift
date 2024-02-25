import Foundation

extension String {
    var isValidURL: Bool {
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) {
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                return match.range.length == self.utf16.count
            } else { return false }
        } else { return false }
    }
}
