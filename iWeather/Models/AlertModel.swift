import Foundation

struct AlertModel {
    var title: String
    let message: String
    let firstButton: String
    let secondButton: String?
    let firstCompletion: () -> Void
    let secondCompletion: () -> Void?
}
