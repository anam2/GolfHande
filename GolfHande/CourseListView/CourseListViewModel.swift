import Foundation

class CourseListViewModel {
    var courseList = [GolfCourseData]()

    init() { }

    func loadViewModel(completion: @escaping (Bool) -> Void) {
        ServiceCalls.readAllCourses { golfCourseData in
            guard let golfCourseData = golfCourseData else {
                completion(false)
                return
            }
            self.courseList = golfCourseData
            completion(true)
        }
    }
}
