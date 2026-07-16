//
//  LocationSelector.swift
//  aSaP
//
//  Created by Dalton Fitzsimmons on 7/9/26.
//

import SwiftUI

struct FabLocation: Identifiable {
    let id: UUID = UUID()
    let name: String
    let location: String
    let region: Region?
    
    init(name: String, location: String, region: Region? = nil) {
        self.name = name
        self.location = location
        self.region = region
    }
}

struct Region: Identifiable, Hashable, Comparable {
    let id: UUID = UUID()
    let name: String
    
    static func < (lhs: Region, rhs: Region) -> Bool {
        lhs.name < rhs.name
    }
}

struct LocationSelector: View {
    @Environment(AppState.self) private var appState
    @State private var expandedRegions: Set<Region> = []
    @Binding var showLocations: Bool
    private(set) var locations: [FabLocation]
    private(set) var groupedRegions: [Region: [FabLocation]]
    private let noRegionKey: Region = .init(name: "No Region")
    
    init(locations: [FabLocation], showLocations: Binding<Bool>) {
        self.locations = locations
        self._showLocations = showLocations
        
        // Group by region, ignoring nil
        let locationsByRegion = Dictionary(grouping: locations.compactMap { loc in
            loc.region != nil ? loc : nil
        }, by: { $0.region! })
        let noRegionLocations = locations.filter { $0.region == nil }
        
        self.groupedRegions = locationsByRegion.merging([noRegionKey: noRegionLocations]) { $1 }
        
        // Default to all regions expanded initially
        _expandedRegions = State(initialValue: Set(self.groupedRegions.keys))
    }
    
    private func locationRow(fabLoc: FabLocation) -> some View {
        let selected = appState.selectedLocationIDs.contains(fabLoc.name)
        let mapPinSelected: CGFloat = 32
        let mapPinDefault: CGFloat = 21
        let mapPinDefaultCircle: CGFloat = 32
        
        return HStack {
            // map pin
            HStack {
                if selected {
                    Image(systemName: "mappin.and.ellipse.circle.fill")
                        .resizable()
                        .frame(width: mapPinSelected, height: mapPinSelected)
                        .foregroundStyle(.blueGradient)
                } else {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: mapPinDefault, height: mapPinDefault, alignment: .center)
                        .foregroundStyle(.charcoalBlack)
                        .background {
                            Circle()
                                .foregroundStyle(.grayBars.opacity(0.3))
                                .frame(width: mapPinDefaultCircle, height: mapPinDefaultCircle)
                        }
                }
            }
            .frame(width: mapPinSelected) // replace with whatever image size is largest to ensure uniformitty
            
            // Text
            VStack(spacing: 2) {
                Text(fabLoc.name)
                    .fontWeight(.medium)
                    .foregroundStyle(selected ? .blueGradient : .charcoalBlack)
                Text(fabLoc.location)
                    .font(.subheadline)
                    .foregroundStyle(.lightBlack)
            }
            
            Spacer()
            
            // select/ check mark
            if selected {
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundStyle(.blueGradient)
                    .frame(width: 16, height: 12)
            } else {
                Text("Select")
                    .font(.thinSubheader)
                    .foregroundStyle(.greyText)
            }
           
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(selected ? .backgroundBlue : .superLightGray)
        }
        .overlay { // Some reason need to have both for the border and background
            RoundedRectangle(cornerRadius: 12)
                .stroke(selected ? .backgroundBlue : Color.clear, lineWidth: selected ? 2 : 0)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func selectorButton(region: Region, action: (() -> Void)? = nil) -> some View {
        var regionLocations = groupedRegions[region] ?? []
        // check if all
        if region.name == "All" {
            regionLocations = locations
        }
        let amountSelected = regionLocations.filter { appState.selectedLocationIDs.contains($0.name) }.count
        let selectedString = amountSelected == regionLocations.count ? "All" : "\(amountSelected)"
        
        
         let buttonImage = {
             if selectedString == "All" {
                 // Full
                 return Group {
                     Image(systemName: "checkmark.circle.fill").foregroundStyle(.blueGradient)
                 }
             } else if amountSelected == 0 {
                 // Empty
                 return Group {
                     Image(systemName: "circle").foregroundStyle(.grayBars)
                 }
             } else {
                 // parital
                 return Group {
                     Image(systemName: "minus.circle").foregroundStyle(.blueGradient)
                 }
             }
         }
        
        return Button {
            if let action {
                action()
            } else {
                if amountSelected != regionLocations.count {
                    // add all items
                    for location in regionLocations {
                        appState.selectedLocationIDs.insert(location.name)
                    }
                } else {
                    // remove all items from appState
                    for location in regionLocations {
                        appState.selectedLocationIDs.remove(location.name)
                    }
                }
            }
        } label: {
            HStack {
                buttonImage()
                Text(region.name)
                    .font(.headingThree)
                    .foregroundStyle(.charcoalBlack)
                Text("\(selectedString) of \(regionLocations.count)")
                    .font(.thinSubheader)
                    .foregroundStyle(.charcoalBlack)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func regionHeader(region: Region) -> some View {
        
       
        
        return HStack {
            // Selector Button
            selectorButton(region: region)

            Spacer()

            // Dropdown button
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if expandedRegions.contains(region) {
                        expandedRegions.remove(region)
                    } else {
                        expandedRegions.insert(region)
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .rotationEffect(expandedRegions.contains(region) ? .degrees(90) : .degrees(0))
                    .foregroundStyle(.charcoalBlack.opacity(0.4))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 11)
    }
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 8) {
                // Section Header
                HStack {
                    Text("Select Location")
                        .font(.headingTwo)
                    Spacer()
                    
                    Button {
                        showLocations = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundStyle(.charcoalBlack)
                            .background {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.backgroundBlack)
                            }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 16)
                
                selectorButton(region: .init(name: "All"), action: {
                    if (locations.allSatisfy({appState.selectedLocationIDs.contains($0.name)})) {
                        // all selected
                        appState.selectedLocationIDs.removeAll()
                    } else {
                        appState.selectedLocationIDs.formUnion(locations.map(\.name))
                    }
                })
                Divider()
                    .padding(.vertical, 6)
                
                // Regions
                ForEach(groupedRegions.keys.sorted(), id: \.self) { region in
                    Section {
                        if expandedRegions.contains(region) {
                            ForEach(groupedRegions[region] ?? []) { fabLoc in
                                Button {
                                    let selected = appState.selectedLocationIDs.contains(fabLoc.name)
                                    
                                    if selected {
                                        appState.selectedLocationIDs.remove(fabLoc.name)
                                    } else {
                                        appState.selectedLocationIDs.insert(fabLoc.name)
                                    }
                                } label: {
                                    locationRow(fabLoc: fabLoc)
                                }
                            }
                        }
                    } header: {
                        regionHeader(region: region)
                    }
                    Divider()
                        .padding(.vertical, 6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 32)
        }
    }
}

#Preview {
    @Previewable @State var appState = AppState()
    let midwest = Region(name: "Midwest")
    let locations: [FabLocation] = [
        .init(name: "Austin Plant", location: "Austin, TX"),
        .init(name: "Phoenix Plant", location: "Phoenix, AZ"),
        .init(name: "Denver Plant", location: "Denver, CO"),
        .init(name: "Detroit Plant", location: "Detroit, MI", region: midwest),
        .init(name: "Chicago Plant", location: "Chicago, IL", region: midwest),
        .init(name: "St. Louis Plant", location: "St. Louis, MO", region: midwest),
    ]
    
//    appState.selectedLocationIDs.insert(locations[2].name)
    
    LocationSelector(locations: locations, showLocations: Binding<Bool>.constant(true))
        .environment(appState)
        .onAppear {
            appState.selectedLocationIDs.insert(locations[2].name)
            appState.selectedLocationIDs.insert(locations[5].name)
        }
}

