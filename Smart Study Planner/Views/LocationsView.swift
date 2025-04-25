import SwiftUI
import MapKit

struct LocationsView: View {
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
            StudyLocationMapView(studyLocations: mapViewModel.studyLocations)
                .navigationTitle("Study Locations")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    LocationsView()
} 