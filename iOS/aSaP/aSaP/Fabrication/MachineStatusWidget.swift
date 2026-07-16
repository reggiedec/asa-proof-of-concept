//
//  MachineStatusWidget.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/15/26.
//

import SwiftUI

struct StatusItem: Identifiable {
    var id: UUID = UUID()
    var machineCode: String
    var jobName: String
    var currentTons: Double
    var targetTons: Double
    var plannedCurrent: Double
    var plannedTarget: Double
    var state: StatusState
    var downReason: String?
    
    enum StatusState: CaseIterable {
        case active
        case downtime
        case error
        
        var title: String {
            switch self {
            case .active:
                return "Active"
            case .downtime:
                return "Idle"
            case .error:
                return "Down" // changed from downtime to down
            }
        }
        
        var fontColor: Color {
            return self == .downtime ? .charcoalBlack: .white
        }
        
        var backgroundColor: LinearGradient {
            switch self {
            case .active:
                return LinearGradient(
                    colors: [
                        .blueGradient.opacity(0.7),
                        .blueGradient,
                        .blueGradient
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            case .downtime:
                return LinearGradient(
                    colors: [
                        .backgroundBlack,
                        .backgroundBlack,
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            case .error:
                return LinearGradient(
                    colors: [
                        .gradientRedStart,
                        .gradientRedEnd,
                        .gradientRedEnd
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
    }
}

struct StatusItemView: View {
    @State private var showDropdown: Bool = false
    var status: StatusItem
    private let tonnageDecimals: Int = 0
    
    private func dropdownButton() -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                showDropdown.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Text(status.state.title)
                    .font(.semiBoldSubheader)
                    .foregroundStyle(status.state.fontColor)
                if let _ = status.downReason {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 12, height: 6)
                }
            }
            .padding(.horizontal, 6)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(status.state == .error ? .white.opacity(0.3) : .backgroundBlack)
            }
        }
        .buttonStyle(.plain)
        .fixedSize()
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: -2) {
                VStack(alignment: .leading) {
                    // Main Code
                    Text(status.machineCode)
                        .font(.headingThree)
                    // Job + Dropdown button
                    HStack {
                        Text(status.jobName)
                            .font(.semiBoldSubheader)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // MARK: Tons item and button
                HStack (alignment: .bottom){
                    dropdownButton()
                    Spacer()
                    // MARK: Tonnage Items
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Day")
                                .font(.subHeader)
                            
                            HStack(spacing: 0) {
                                Text(status.currentTons, format: .number.precision(.fractionLength(tonnageDecimals)))
                                    .font(.semiBoldSubheader)
                                Text("/\(status.targetTons, format: .number.precision(.fractionLength(tonnageDecimals)))T")
                                    .font(.semiBoldSubheader)
                            }
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 0) {
                            Text(" Week")
                                .font(.subHeader)
                            
                            HStack(spacing: 0) {
                                Text(status.plannedCurrent, format: .number.precision(.fractionLength(tonnageDecimals)))
                                    .font(.semiBoldSubheader)
                                Text("/\(status.plannedTarget, format: .number.precision(.fractionLength(tonnageDecimals)))T")
                                    .font(.semiBoldSubheader)
                            }
                        }
                    }
                    .containerRelativeFrame(.horizontal, count: 2, span: 1, spacing: 0)
                }
                .frame(maxWidth:.infinity)
            }
            // MARK: Dropdown section
            if showDropdown, let reason = status.downReason {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Reason")
                            .font(.semiBoldSubheader)
                            .padding(.bottom, 4)
                        Text(reason)
                            .font(.alertBodySmaller)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 15)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(status.state == .error ? .white.opacity(0.3) : .backgroundBlack)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .foregroundStyle(status.state.fontColor)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(status.state.backgroundColor)
        }
    }
}

struct MachineStatusWidget: WidgetProtocol {
    static func == (lhs: MachineStatusWidget, rhs: MachineStatusWidget) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    let name: String = "Machine Statuses"
    var isFavorite: Bool = false
    var statuses: [StatusItem]
    
    var body: some View {
        ForEach(statuses) { status in
                StatusItemView(status: status)
        }
    }
}


#Preview {
    @Previewable @State var appState = AppState()
    
    MachineStatusPreviewContainer()
        .environment(appState)
}

struct MachineStatusPreviewContainer: View {
    @State private var widgets = WidgetList(items: [
        MachineStatusWidget(id: UUID(), statuses: [
        .init(machineCode: "CC-2045", jobName: "JOB-2241", currentTons: 3, targetTons: 10, plannedCurrent: 31, plannedTarget: 50, state: .downtime, downReason: "Nothing scheduled"),
        .init(machineCode: "CC-2045", jobName: "JOB-2241", currentTons: 32.9, targetTons: 100, plannedCurrent: 1450, plannedTarget: 2000, state: .error, downReason: "BLEW UP!! ITS GONE!! WHOLE THING IS GONE"),
        .init(machineCode: "CC-2045", jobName: "JOB-2241", currentTons: 13.5, targetTons: 25, plannedCurrent: 53.78, plannedTarget: 150, state: .active),
    ])
    ])
    
    var body: some View {
        ReorderableList(widgets: widgets)
    }
}
