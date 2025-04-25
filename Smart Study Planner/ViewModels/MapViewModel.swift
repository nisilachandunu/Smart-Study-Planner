import Foundation
import MapKit

class MapViewModel: ObservableObject {
    @Published var studyLocations: [StudyLocation] = []
    
    init() {
        loadStudyLocations()
    }
    
    private func loadStudyLocations() {
        // Dummy data for study locations with widely spread coordinates
        studyLocations = [
            StudyLocation(
                locationID: "1",
                name: "University Main Library",
                latitude: 37.3346,
                longitude: -122.0090,
                rating: 4.8,
                notes: "24/7 access, quiet study rooms, group study areas, computer labs, and printing services. Best for late-night study sessions."
            ),
            StudyLocation(
                locationID: "2",
                name: "Student Union Study Center",
                latitude: 37.3346,
                longitude: -122.0070,
                rating: 4.2,
                notes: "Collaborative study space with cafes, comfortable seating, and whiteboards. Great for group projects."
            ),
            StudyLocation(
                locationID: "3",
                name: "Science Building Study Rooms",
                latitude: 37.3326,
                longitude: -122.0090,
                rating: 4.5,
                notes: "Modern study rooms with natural lighting, power outlets, and quiet atmosphere. Perfect for science majors."
            ),
            StudyLocation(
                locationID: "4",
                name: "Engineering Library",
                latitude: 37.3326,
                longitude: -122.0070,
                rating: 4.6,
                notes: "Specialized engineering resources, study pods, and technical equipment. Ideal for engineering students."
            ),
            StudyLocation(
                locationID: "5",
                name: "Campus Coffee Shop",
                latitude: 37.3306,
                longitude: -122.0090,
                rating: 4.0,
                notes: "Casual study space with coffee and snacks. Good for light study sessions and group meetings."
            ),
            StudyLocation(
                locationID: "6",
                name: "Outdoor Study Garden",
                latitude: 37.3306,
                longitude: -122.0070,
                rating: 4.3,
                notes: "Peaceful outdoor study area with WiFi and covered seating. Perfect for nice weather days."
            ),
            StudyLocation(
                locationID: "7",
                name: "Business School Library",
                latitude: 37.3286,
                longitude: -122.0090,
                rating: 4.7,
                notes: "Professional study environment with Bloomberg terminals and meeting rooms. Best for business students."
            ),
            StudyLocation(
                locationID: "8",
                name: "24/7 Study Hub",
                latitude: 37.3286,
                longitude: -122.0070,
                rating: 4.4,
                notes: "Always open study space with vending machines and security. Great for night owls."
            ),
            StudyLocation(
                locationID: "9",
                name: "Arts Center Study Room",
                latitude: 37.3266,
                longitude: -122.0090,
                rating: 4.1,
                notes: "Creative study space with art supplies and quiet corners. Perfect for creative projects."
            ),
            StudyLocation(
                locationID: "10",
                name: "Medical School Library",
                latitude: 37.3266,
                longitude: -122.0070,
                rating: 4.9,
                notes: "State-of-the-art medical resources, study rooms, and anatomy models. Ideal for medical students."
            )
        ]
    }
    
    func addStudyLocation(_ location: StudyLocation) {
        studyLocations.append(location)
        // TODO: Save to backend
    }
    
    func removeStudyLocation(_ location: StudyLocation) {
        studyLocations.removeAll { $0.locationID == location.locationID }
        // TODO: Remove from backend
    }
} 
