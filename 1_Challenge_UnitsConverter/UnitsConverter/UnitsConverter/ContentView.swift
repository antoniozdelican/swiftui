//
//  ContentView.swift
//  UnitsConverter
//
//  Created by Antonio Zdelican on 09.09.21.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Temperature properties
    @State private var temperatureInputValue = ""
    @State private var temperatureInputUnit: UnitTemperature = .celsius
    @State private var temperatureOutputUnit: UnitTemperature = .celsius
    let temperatureUnits: [UnitTemperature] = [.celsius, .fahrenheit, .kelvin]
    var temperatureOutputValue: Double {
        guard let temperatureInputValue = Double(temperatureInputValue) else { return 0 }
        return Measurement(value: temperatureInputValue, unit: temperatureInputUnit).converted(to: temperatureOutputUnit).value
    }
    
    // MARK: - Length properties
    @State private var lengthInputValue = ""
    @State private var lengthInputUnit: UnitLength = .meters
    @State private var lengthOutputUnit: UnitLength = .meters
    let lengthUnits: [UnitLength] = [.meters, .kilometers, .feet, .yards, .miles]
    var lengthOutputValue: Double {
        guard let lengthInputValue = Double(lengthInputValue) else { return 0 }
        return Measurement(value: lengthInputValue, unit: lengthInputUnit).converted(to: lengthOutputUnit).value
    }
    
    // MARK: - Time properties
    @State private var timeInputValue = ""
    @State private var timeInputUnit: UnitDuration = .seconds
    @State private var timeOutputUnit: UnitDuration = .seconds
    let timeUnits: [UnitDuration] = [.seconds, .minutes, .hours]
    var timeOutputValue: Double {
        guard let timeInputValue = Double(timeInputValue) else { return 0 }
        return Measurement(value: timeInputValue, unit: timeInputUnit).converted(to: timeOutputUnit).value
    }
    
    // MARK: - Volume properties
    @State private var volumeInputValue = ""
    @State private var volumeInputUnit: UnitVolume = .milliliters
    @State private var volumeOutputUnit: UnitVolume = .milliliters
    let volumeUnits: [UnitVolume] = [.milliliters, .liters, .cups, .pints, .gallons]
    var volumeOutputValue: Double {
        guard let volumeInputValue = Double(volumeInputValue) else { return 0 }
        return Measurement(value: volumeInputValue, unit: volumeInputUnit).converted(to: volumeOutputUnit).value
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Temperature converter")) {
                    TextField("Temperature", text: $temperatureInputValue)
                        .keyboardType(.decimalPad)
                    
                    Picker("Input unit", selection: $temperatureInputUnit) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Picker("Output unit", selection: $temperatureOutputUnit) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Text("\(temperatureOutputValue, specifier: "%.2f")")
                }
                
                Section(header: Text("Length converter")) {
                    TextField("Length", text: $lengthInputValue)
                        .keyboardType(.decimalPad)
                    
                    Picker("Input unit", selection: $lengthInputUnit) {
                        ForEach(lengthUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Picker("Output unit", selection: $lengthOutputUnit) {
                        ForEach(lengthUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Text("\(lengthOutputValue, specifier: "%.2f")")
                }
                
                Section(header: Text("Time converter")) {
                    TextField("Time", text: $timeInputValue)
                        .keyboardType(.numberPad)
                    
                    Picker("Input unit", selection: $timeInputUnit) {
                        ForEach(timeUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Picker("Output unit", selection: $timeOutputUnit) {
                        ForEach(timeUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Text("\(timeOutputValue, specifier: "%.2f")")
                }
                
                Section(header: Text("Volume converter")) {
                    TextField("Volume", text: $volumeInputValue)
                        .keyboardType(.numberPad)
                    
                    Picker("Input unit", selection: $volumeInputUnit) {
                        ForEach(volumeUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Picker("Output unit", selection: $volumeOutputUnit) {
                        ForEach(volumeUnits, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                    
                    Text("\(volumeOutputValue, specifier: "%.2f")")
                }
            }
            .navigationTitle(Text("Units Converter"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
