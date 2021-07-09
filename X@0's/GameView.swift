//
//  ContentView.swift
//  X@0's
//
//  Created by Ayush Khanna on 17/06/2021.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack{
                
                Text("TIC TAC TOE").font(.custom("Bold", fixedSize: 40))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.top, .bottom], 10.0)
                
                Text("Difficulty: \(viewModel.difficulty.rawValue.capitalized) ")
                    .font(.title2)
                    .font(.title)
                    .padding(.bottom,10)
                
                Text(viewModel.computerGoesFirst ? "Computer goes first!" : "You go first!")
                    .font(.title2)
                    .font(.title)
                
                Spacer()
                
                GameGridView(viewModel: viewModel, geometry: geometry)
                
                Spacer()
                
                Button("Settings") {
                    viewModel.showSettings = true
                }
                .padding()
                .background(Color.black)
                .accentColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                .cornerRadius(10)
                .sheet(isPresented: $viewModel.showSettings,
                       content: {
                        SettingsView(selectedDifficulty: viewModel.difficulty, computerGoesFirst: viewModel.computerGoesFirst, isPresented: $viewModel.showSettings) {difficulty, doesCompGoFirst in
                            
                            self.viewModel.difficulty = difficulty
                            self.viewModel.computerGoesFirst = doesCompGoFirst
                            viewModel.resetGame()
                        }
                       })
            }.disabled(viewModel.isGameBoardDsiabled)
            .padding()
            .alert(item: $viewModel.alertItem) { item in
                Alert(title: item.title,
                      message: item.message,
                      dismissButton: .default(
                        item.buttonTitle,
                        action: { viewModel.resetGame() }))
            }
            
        }.onAppear(perform: {
            if viewModel.computerGoesFirst {
                viewModel.playCompFirstMove()
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameView()
            GameView()
        }
    }
}

struct GameGridView: View {
    
    @StateObject var viewModel: GameViewModel
    var geometry: GeometryProxy
    
    var body: some View {
        
        LazyVGrid(columns: viewModel.colums, content: {
            ForEach(0..<9){ i in
                GameGridCell(viewModel: viewModel, geometry: geometry, gridPosition: i)
            }
        }).background(Color.black)
    }
}

struct GameGridCell: View {
    
    @StateObject var viewModel: GameViewModel
    var geometry: GeometryProxy
    var gridPosition: Int
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundColor(.white)
                .frame(width: geometry.size.width/3 - 15, height: geometry.size.width/3 - 10, alignment: .center)
                .cornerRadius(0)
            
            Image(systemName: viewModel.moves[gridPosition]?.image ?? "")
                .resizable()
                .frame(width: geometry.size.width/3 - 100,
                       height: geometry.size.width/3 - 100,
                       alignment: .center)
                .foregroundColor(viewModel.moves[gridPosition]?.player == .human ? .green : .red)
            
        }.onTapGesture {
            viewModel.processPlayerMove(for: gridPosition)
        }
    }
}
