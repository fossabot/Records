import Foundation

enum CompletionResult<T> {
    case success(T), failure(Error)
}

extension CompletionResult {
    init(value: T?, error: Error?) {
        switch (value, error) {
        case (let value?, _):
            self = .success(value)
        case (nil, let error?):
            self = .failure(error)
        case (nil, nil):
            let error = NSError(domain: "ResultErrorDomain", code: 1, userInfo: [NSLocalizedFailureReasonErrorKey: "Invalid input: value and error were both nil."])
            self = .failure(error)
        }
    }
}
