import Foundation

class CourseListViewModel {
    var courseList = [GolfCourseData]()

    init() { }

    func loadViewModel(completion: @escaping (Bool) -> Void) {
        ServiceCalls.shared.readAllCourses { golfCourseData in
            guard let golfCourseData = golfCourseData else {
                self.courseList = []
                completion(false)
                return
            }
            self.courseList = golfCourseData.sorted { $0.name < $1.name }
            completion(true)
        }
    }
}
