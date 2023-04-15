struct UserData {
    let id: String
    let userInformation: UserInformation
    let scores: [UserScoreData] = []
    let handicap: String = "0.0"
}

struct UserInformation {
    let email: String
    let password: String
    let name: String?
}
