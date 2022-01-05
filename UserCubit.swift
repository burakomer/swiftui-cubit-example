//
//  UserCubit.swift
//  Kuma
//
//  Created by Burak Omer on 24.12.21.
//

import Foundation

class UserCubit: ModelCubit<User, UserFilter>, ObservableObject {
    @Published var state: UserState = .notReady
    
    override func emit(_ state: ModelState<User>, filter: UserFilter? = nil) {
        super.emit(state, filter: filter)
        self.state = UserState.from(state)
    }
}

enum UserState {
    case notReady
    case ready(User)
    case loading
    case error(String)
    
    static func from(_ state: ModelState<User>) -> UserState {
        switch state {
        case .notReady:
            return .notReady
        case let .ready(models, _):
            return .ready(models[0])
        case .loading:
            return .loading
        case let .error(message):
            return .error(message)
        }
    }
}
