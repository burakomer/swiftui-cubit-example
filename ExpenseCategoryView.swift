//
//  ExpenseCategoryView.swift
//  Kuma
//
//  Created by Burak Omer on 29.08.2021.
//

import Foundation
import SwiftUI

struct ExpenseCategoryView: View {
    typealias M = ExpenseCategory
    @Environment(\.presentationMode) var presentation
//    let cubit: ExpenseCategoryCubit = locate(ExpenseCategoryCubit.self)
    @EnvironmentObject var cubit: ExpenseCategoryCubit
    
    //@State var selection: Int64? = 0
    
    let pickerMode: Bool
    
    init(pickerMode: Bool = false) {
        self.pickerMode = pickerMode
    }
    
    var body: some View {
        if pickerMode {
            buildBody()
        } else {
            buildBody()
                .navigationTitle("Expense Categories")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(
                            destination: ExpenseCategoryDetailView(item: ExpenseCategory.create())
                        ) {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func buildBody() -> some View {
        switch cubit.state {
        case .notReady:
            ProgressView()
                .execute {
                    Task{
                        await cubit.load()
                    }
                }
        case let .ready(expenses, _):
            if pickerMode {
                ForEach(expenses) { expense in
                    buildListItem(expense)
                }
            } else {
                List(expenses) { expense in
                    NavigationLink(
                        destination: ExpenseCategoryDetailView(item: expense),
//                        tag: expense.id,
//                        selection: $selection,
                        label: {
                            buildListItem(expense)
                        }
                    )
                }
                .listStyle(.insetGrouped)
            }
        case .loading:
            Text("NotReady")
        case let .error(message):
            Text("Error: \(message)")
        }
    }
    
    @ViewBuilder
    func buildListItem(_ item: ExpenseCategory) -> some View {
        Label("\(item.name)", systemImage: item.icon.getSystemImage())
            .tag(item)
            .foregroundColor(item.icon.getColor())
    }
}

struct ExpenseCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCategoryView()
            .environmentObject(ExpenseCubit(MainRepository(backend: RemoteBackend(url: AppEnvironment.backendUrl))))
    }
}

