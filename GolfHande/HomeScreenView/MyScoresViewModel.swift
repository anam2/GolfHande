import FirebaseDatabase

class MyScoresViewModel {

    private let database = Database.database().reference()

    var userScoreArray = [UserScoreData]()
    var golfCourseArray = [GolfCourseData]()

    /**
     Loads the viewModel. Need to be called when after being initialized.
     - Parameter completion: [() -> Void] The closure function that will execute after viewModel has been populated.
     */
    func loadViewModel(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        ServiceCalls.readScores { [weak self] userScores in
            defer { dispatchGroup.leave() }
            guard let userScores = userScores else { return }
            self?.userScoreArray = userScores
        }

        dispatchGroup.enter()
        ServiceCalls.readAllCourses { [weak self] golfCourses in
            defer { dispatchGroup.leave() }
            guard let golfCourseArray = golfCourses else { return }
            self?.golfCourseArray = golfCourseArray
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    // MARK: TEXT GETTERS

    func getCourseID(for indexPathRow: Int) -> String? {
        guard userScoreArray.count > 0 else {
            NSLog("UserScoreArray is empty.")
            return nil
        }
        return userScoreArray[indexPathRow].courseID
    }

    func getCourseInfo(for courseID: String) -> GolfCourseData? {
        guard let golfCourse = golfCourseArray.first(where: { $0.id == courseID }) else { return nil }
        return golfCourse
    }
}
