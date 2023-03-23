import Foundation

class CourseListViewModel {
    var courseList = [GolfCourseData]()

    init() { }

    func loadViewModel(completion: @escaping (Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        ServiceCalls.readAllCourses { golfCourseData in
            defer { dispatchGroup.leave() }
            guard let golfCourseData = golfCourseData else {
                completion(false)
                return
            }
            self.courseList = golfCourseData
        }
        dispatchGroup.notify(queue: .main) {
            completion(true)
        }
    }
}
