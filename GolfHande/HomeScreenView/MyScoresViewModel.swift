import FirebaseDatabase

enum ViewModelStatus: String {
    case success
    case error
    case empty
}

class MyScoresViewModel {

    private let database = Database.database().reference()

    var userScoreArray = [UserScoreData]()
    var golfCourseArray = [GolfCourseData]()

    /**
     Loads the viewModel. Need to be called when after being initialized.
     - Parameter completion: [() -> Void] The closure function that will execute after viewModel has been populated.
     */
    func loadViewModel(completion: @escaping (ViewModelStatus) -> Void) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        ServiceCalls.readScores { [weak self] userScores in
            defer { dispatchGroup.leave() }
            guard let userScores = userScores else {
                return
            }
            self?.userScoreArray = userScores.sorted(by: { $0.dateAdded > $1.dateAdded })
            return
        }

        dispatchGroup.enter()
        ServiceCalls.readAllCourses { [weak self] golfCourses in
            defer { dispatchGroup.leave() }
            guard let golfCourseArray = golfCourses else { return }
            self?.golfCourseArray = golfCourseArray
            return
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success)
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

    func getUsersHandicap() -> String {
        let usersHandicapString = userScoreArray.map { $0.handicap }
        let usersHandicap = usersHandicapString.compactMap(Double.init)

        switch usersHandicap.count {
        case let count where count == 0:
            return "No Scores"
        case let count where count <= 3:
            print("Less than 3 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 1, forArray: usersHandicap)
            let handicap = (lowestNumbers[0] - 2.0)
            return String(round(handicap * 10) / 10)
        case let count where count <= 4:
            print("Less than 4 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 1, forArray: usersHandicap)
            let handicap = lowestNumbers[0] - 1.0
            return String(round(handicap * 10) / 10)
        case let count where count <= 5:
            print("less than 5 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 1, forArray: usersHandicap)
            let handicap = lowestNumbers[0]
            return String(round(handicap * 10) / 10)
        case let count where count <= 6:
            print("Less than 6 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 2, forArray: usersHandicap)
            let handicap = getDoubleAverage(for: lowestNumbers) - 1.0
            return String(handicap)
        case let count where count <= 8:
            print("Less than 8 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 2, forArray: usersHandicap)
            let handicap = getDoubleAverage(for: lowestNumbers)
            return String(handicap)
        case let count where count <= 11:
            print("Less than 11 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 3, forArray: usersHandicap)
            let handicap = getDoubleAverage(for: lowestNumbers)
            return String(handicap)
        case let count where count <= 14:
            print("Less than 14 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 4, forArray: usersHandicap)
            let handicap = getDoubleAverage(for: lowestNumbers)
            return String(handicap)
        case let count where count <= 16:
            print("Less than 16 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 5, forArray: usersHandicap)
            let handicap = getDoubleAverage(for: lowestNumbers)
            return String(handicap)
        case let count where count <= 18:
            print("Less than 18 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 6, forArray: usersHandicap)
            let handicap = getDoubleAverage(for: lowestNumbers)
            return String(handicap)
        case let count where count <= 19:
            print("Less than 19 rounds")
            let lowestNumbers = getLowestNumbers(forHowMany: 7, forArray: usersHandicap)
            let handicap = getDoubleAverage(for: lowestNumbers)
            return String(handicap)
        case let count where count >= 20:
            print("Greater than 20 rounds")
            let lastTwentyRounds = Array(usersHandicap.prefix(20))
            let lowestNumbers = getLowestNumbers(forHowMany: 8, forArray: lastTwentyRounds)
            let handicap = getDoubleAverage(for: lowestNumbers)
            return String(handicap)
        default:
            print("hm...")
            return ""
        }
    }

    private func getLowestNumbers(forHowMany: Int,
                                  forArray: [Double]) -> [Double] {
        let lowestNumbers = Array(forArray.sorted().prefix(forHowMany))
        return lowestNumbers
    }

    private func getDoubleAverage(for userScores: [Double]) -> Double {
        let sum = userScores.reduce(0, +)
        let average = sum / Double(userScores.count)
        return round(average * 10) / 10
    }
}
