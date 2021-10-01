//
//  AddView.swift
//  iExpense
//
//  Created by Antonio Zdelican on 01.10.21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save") {
                guard let actualAmount = Int(self.amount) else {
                    alertTitle = "Wrong amount"
                    alertTitle = "Please input a valid amount"
                    showingAlert = true
                    return
                }
                guard !self.name.isEmpty else {
                    alertTitle = "Empty name"
                    alertTitle = "Please input a name"
                    showingAlert = true
                    return
                }
                
                guard self.name != "Laptop" else {
                    alertTitle = "Wrong item"
                    alertTitle = "Sorry, but no laptops on this list :("
                    showingAlert = true
                    return
                }
                let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                self.expenses.items.append(item)
                self.presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
