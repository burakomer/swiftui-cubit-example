//
//  ExpenseCategoryBloc.swift
//  Kuma
//
//  Created by Burak Omer on 28.08.2021.
//

import Foundation

class ExpenseCategoryCubit: ModelCubit<ExpenseCategory, ExpenseCategoryFilter>, ObservableObject {
    @Published var state: ExpenseCategoryState = .notReady
    
    override func emit(_ state: ModelState<ExpenseCategory>, filter: ExpenseCategoryFilter? = nil) {
        super.emit(state, filter: filter)
        self.state = ExpenseCategoryState.from(state)
    }
}

enum ExpenseCategoryState {
    case notReady
    case ready([ExpenseCategory], Int64 = -1)
    case loading
    case error(String)
    
    static func from(_ state: ModelState<ExpenseCategory>) -> ExpenseCategoryState {
        switch state {
        case .notReady:
            return .notReady
        case let .ready(models, lastRowId):
            return .ready(models, lastRowId)
        case .loading:
            return .loading
        case let .error(message):
            return .error(message)
        }
    }
}
