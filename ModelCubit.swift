//
//  ModelCubit.swift
//  Kuma
//
//  Created by Burak Omer on 28.08.2021.
//

import Foundation

@MainActor
public class ModelCubit<Model: BaseModel, Filter> where Model.F == Filter {
    typealias State = ModelState<Model>
    
    let repository: Repository
    
    var listeners: [String: (ModelState<Model>) -> Void]
    var filter: Filter = Filter.empty()
    
    init(_ repository: Repository) {
        self.repository = repository
        self.listeners = [:]
    }
    
    internal func emit(_ state: State, filter: Filter? = nil) {
        //self.state = state
        self.filter = filter ?? self.filter
        for (_, listener) in listeners {
            listener(state)
        }
    }
    
    func listen(_ key: String, listener: @escaping (ModelState<Model>) -> Void) {
        listeners[key] = listener
    }
    
    func unlisten(_ key: String) {
        listeners.removeValue(forKey: key)
    }
    
    func load(filter: Filter? = nil) async {
        let filter = filter ?? self.filter
        
        do {
            let modelList = try await repository.loadModels(Model.self, filter: filter)
            emit(.ready(modelList))
        } catch {
            emit(.error(error.localizedDescription))
        }
    }
    
    func save(_ model: Model) async {
        do {
            let savedModel = try await repository.saveModel(model: model)
            let modelList = try await repository.loadModels(Model.self, filter: filter)
            emit(.ready(modelList, savedModel.id))
        } catch {
            emit(.error(error.localizedDescription))
        }
    }
    
    func reset() {
        emit(.notReady, filter: Filter.empty())
    }
}

enum ModelState<Model: BaseModel> {
    case notReady
    case ready([Model], Int64 = -1)
    case loading
    case error(String)
}
