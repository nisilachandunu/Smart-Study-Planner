import SwiftUI
import MapKit

struct StudyLocationMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3346, longitude: -122.0090),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedLocation: StudyLocation?
    
    var studyLocations: [StudyLocation]
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: studyLocations) { location in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .font(.title)
                    .onTapGesture {
                        selectedLocation = location
                    }
            }
        }
        .sheet(item: $selectedLocation) { location in
            LocationDetailView(location: location)
        }
    }
}

struct LocationDetailView: View {
    let location: StudyLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(location.name)
                .font(.title)
                .bold()
            
            if let notes = location.notes {
                Text(notes)
                    .font(.body)
            }
            
            if let rating = location.rating {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", rating))
                        .font(.subheadline)
                }
            }
            
            Button("Get Directions") {
                openMaps(for: location)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func openMaps(for location: StudyLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        mapItem.openInMaps()
    }
}

#Preview {
    StudyLocationMapView(studyLocations: [
        StudyLocation(
            locationID: "1",
            name: "University Library",
            latitude: 37.3346,
            longitude: -122.0090,
            rating: 4.5,
            notes: "Main study area with quiet zones"
        )
    ])
} 