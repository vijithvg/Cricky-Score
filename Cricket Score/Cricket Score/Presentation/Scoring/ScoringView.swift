//
//  ScoringView.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import SwiftUI

struct ScoringView: View {
    @State var viewModel: ScoringViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Live Scoreboard
            VStack(spacing: 8) {
                Text("\(viewModel.totalRuns) / \(viewModel.wickets)")
                    .font(.system(size: 72, weight: .black, design: .monospaced))
                
                Text("Overs: \(viewModel.overNumber).\(viewModel.ballNumber)")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)
            
            // Error Display
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
            
            // Control Pad Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(0...6, id: \.self) { runs in
                    Button {
                        Task { await viewModel.logDelivery(runsOffBat: runs) }
                    } label: {
                        Text("\(runs)")
                            .font(.title)
                            .frame(maxWidth: .infinity, minHeight: 60)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                
                // Extras Action
                Button {
                    Task { await viewModel.logDelivery(runsOffBat: 0, extras: .wide) }
                } label: {
                    Text("Wide")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                // Wicket Action
                Button {
                    let wicket = WicketEvent(type: .bowled, dismissedPlayerId: viewModel.strikerId, fielderId: nil)
                    Task { await viewModel.logDelivery(runsOffBat: 0, wicket: wicket) }
                } label: {
                    Text("W")
                        .font(.title2)
                        .frame(maxWidth: .infinity, minHeight: 60)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
    }
}
