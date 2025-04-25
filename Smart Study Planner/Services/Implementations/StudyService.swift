import Foundation
import Combine

class StudyService: StudyServiceProtocol {
    private let baseURL = "https://api.smartstudyplanner.com/v1"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getNextSession() -> AnyPublisher<StudySession?, Error> {
        guard let url = URL(string: "\(baseURL)/sessions/next") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: StudySession?.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getWeeklyProgress() -> AnyPublisher<[(day: String, hours: Double)], Error> {
        guard let url = URL(string: "\(baseURL)/progress/weekly") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [WeeklyProgressData].self, decoder: JSONDecoder())
            .map { progress in
                progress.map { ($0.day, $0.hours) }
            }
            .eraseToAnyPublisher()
    }
    
    func startSession(taskId: String, duration: TimeInterval) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/sessions/start") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "task_id": taskId,
            "duration": duration
        ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return session.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func endCurrentSession() -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/sessions/current/end") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return session.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func searchTasks(query: String) -> AnyPublisher<[StudyTask], Error> {
        guard let url = URL(string: "\(baseURL)/tasks/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [StudyTask].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

// Helper model for decoding weekly progress
private struct WeeklyProgressData: Codable {
    let day: String
    let hours: Double
} 