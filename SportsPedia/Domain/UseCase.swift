//
//  UseCase.swift
//  SportsPedia
//

import Combine

/// A reusable domain contract shared by every feature module.
/// Associated types keep each use case strongly typed without `Any`.
protocol UseCase: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable

    func execute(_ input: Input) -> AnyPublisher<Output, Error>
}

/// Use this as a typed input for a use case that needs no argument.
struct NoInput: Sendable {
    init() {}
}

extension UseCase where Input == NoInput {
    func execute() -> AnyPublisher<Output, Error> {
        execute(NoInput())
    }
}
