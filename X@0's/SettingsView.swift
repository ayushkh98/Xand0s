//
//  SettingsView.swift
//  X@0's
//
//  Created by Ayush Khanna on 22/06/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @State var selectedDifficulty: Diffculty
    @State var computerGoesFirst: Bool
    @Binding var isPresented: Bool
    
    var didChangeSettings: ((_ difficulty: Diffculty,
                            _ doesComputerGoFirst: Bool)->())?
    
    var body: some View {
        VStack(){
  
            HStack {
                Text("Game Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    
                
                Spacer()
                
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("cancel")
                        .accentColor(.black)
                })
            }.padding()
            
            Divider()
                .padding([.leading,.trailing])
            
            
            Text("Game Difficulty")
                .font(.headline)
                .foregroundColor(Color.black)
                .padding([.top,.leading])
            
            
            DifficultyPicker(selected: $selectedDifficulty)
                .padding()
            
            Toggle(isOn: $computerGoesFirst) {
                Text("Computer goes first?")
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                isPresented = false
                didChangeSettings?(selectedDifficulty, computerGoesFirst)
            }, label: {
                Text("Done!")
                    .accentColor(.white)
                    .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            })
            .background(Color.black)
            .cornerRadius(10)
            
        }
        
    }
}

struct DifficultyPicker: View {
    
    @Binding var selected: Diffculty
    
    var body: some View {
        VStack {
            Picker("Selected", selection: $selected, content: {
                ForEach(Diffculty.allCases, content: { diff in
                    Text(diff.rawValue.capitalized)
                })
            })
            
            .pickerStyle(SegmentedPickerStyle())
            
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var diff = Diffculty.easy
    @State static var first = false
    
    static var previews: some View {
        SettingsView(selectedDifficulty: diff, computerGoesFirst: first, isPresented: .constant(true
        ))
        
    }
}
