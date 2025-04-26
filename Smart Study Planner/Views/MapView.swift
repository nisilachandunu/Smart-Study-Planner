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
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with location name and close button
            HStack {
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Rating section
                    if let rating = location.rating {
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(rating) ? "star.fill" : 
                                    (index < Int(rating + 0.5) ? "star.leadinghalf.filled" : "star"))
                                    .foregroundColor(.yellow)
                            }
                            Text(String(format: "%.1f", rating))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 8)
                    }
                    
                    // Notes section
                    if let notes = location.notes {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About this location")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text(notes)
                                .font(.body)
                                .lineSpacing(4)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Get Directions button
                    Button(action: { openMaps(for: location) }) {
                        HStack {
                            Image(systemName: "map.fill")
                            Text("Get Directions")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
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