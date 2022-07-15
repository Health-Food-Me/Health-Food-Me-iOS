//
//  ReviewDataModel.swift
//  HealthFoodMe
//
//  Created by 강윤서 on 2022/07/14.
//

import Foundation

struct ReviewDataModel {
    let reviewer: String
    let starLate: Float
    let tagList: [String]
    let reviewImageURLList: [String]?
    let reviewContents: String?
}

struct ReviewCellViewModel {
    var data: ReviewDataModel
    var foldRequired: Bool
}

extension ReviewDataModel {
    static let sampleData: [ReviewDataModel] = [
        ReviewDataModel(reviewer: "나는헬푸파미",
                        starLate: 4.0,
                        tagList: ["#맛 최고", "#약속 시 부담없는", "#든든한"],
                        reviewImageURLList: ["Image", "tempMuseum", "Image", "tempMuseum", "Image"],
                        reviewContents:
                       "블라블라 멍멍멍멍멍 만약에 이 내용이 너무 길어진다면 ..? 그게 고민이었는데 해결됐어요. 왜냐면 더보기를 누르면 되니까요! 제 뻘소리를 더 보고 싶으시다면 바로 옆에 곧 나올 더보기를 함 눌러볼까말까 에베베베ㅔ에ㅔ벱 눌러봐라~~~~~~ 엇 누르셨네요? 호호 제 뻘소리의 매력에 푹 빠지셨군뇨 하긴 제가 좀 매력이 흘러넘처긴 해요 근데 여기 리뷰가 총 최대 몇 글자까지인지를 모르겠네요? 괵팀에게 물어봐야.. 엇 500자로 정해졌어요 드디어 그럼 안녕 블라블라 맛 멋져요 멍멍 근데 누가 리뷰를 500자까지 쓰겠나요 그쵸? 안그래유? 진짜 500자까지 리뷰 쓰는 사람 정성 인정하긴 하는데욥 근데 안 썼으면 좋겠어요 왜냐면요 더보기를 눌렀을 때 이렇게 길어지면 뷰가 안 이뻐요 뿌엥 좀 적당히 짧게 써주시면 참 감사하겠어요 제발 부탁드려요~ 근데 저 샐러디 사진 제가 찍은 거예요 화질 기가막히게 잘 찍었죠 끄쵸 칭찬해주세오 아 지금 이렇게 데이터 채우기도 힘든데.. 누가.. 500자를.."
                       ),
        ReviewDataModel(reviewer: "나는헬푸파미",
                        starLate: 3.5,
                        tagList: ["#맛 최고", "#약속 시 부담없는", "#양 조절 쉬운", "#든든한"],
                        reviewImageURLList: [],
                        reviewContents:
                            "이거는 사진 없고 더보기도 없는 버즈어언 귀찮은 사람은 백퍼무조건 이렇게 리뷰 씀 ㅋㅋ 내가 보장함 ㅋㅋ"),
        ReviewDataModel(reviewer: "나는헬푸파미",
                        starLate: 2.0,
                        tagList: ["#맛 최고"],
                        reviewImageURLList: ["Image"],
                        reviewContents:
                            "블라블라 맛 멋져요 멍멍 만약에 이 내용이 너무 길어진다면 ..? 그게 고민이었는데 해결됐어요. 왜냐면 더보기를 누르면 되니까요! 제 뻘소리를 더 보고 싶으시다면 더보기를 함 눌러볼텨"),
        ReviewDataModel(reviewer: "나는헬푸파미",
                        starLate: 1.3,
                        tagList: ["#맛 최고", "#양 조절 쉬운"],
                        reviewImageURLList: ["Image", "Image", "Image"],
                        reviewContents: nil),
        ReviewDataModel(reviewer: "나는헬푸파미",
                        starLate: 4.5,
                        tagList: ["#맛 최고"],
                        reviewImageURLList: [],
                        reviewContents:
                            "블라블라 멍멍멍멍멍 만약에 이 내용이 너무 길어진다면 ..? 그게 고민이었는데 해결됐어요. 왜냐면 더보기를 누르면 되니까요! 제 뻘소리를 더 보고 싶으시다면 바로 옆에 곧 나올 더보기를 함 눌러볼까말까 에베베베ㅔ에ㅔ벱 눌러봐라~~~~~~ 엇 누르셨네요? 호호 제 뻘소리의 매력에 푹 빠지셨군뇨 하긴 제가 좀 매력이 흘러넘처긴 해요 근데 여기 리뷰가 총 최대 몇 글자까지인지를 모르겠네요? 괵팀에게 물어봐야.. 엇 500자로 정해졌어요 드디어 그럼 안녕 블라블라 맛 멋져요 멍멍 근데 누가 리뷰를 500자까지 쓰겠나요 그쵸? 안그래유? 진짜 500자까지 리뷰 쓰는 사람 정성 인정하긴 하는데욥 근데 안 썼으면 좋겠어요 왜냐면요 더보기를 눌렀을 때 이렇게 길어지면 뷰가 안 이뻐요 뿌엥 좀 적당히 짧게 써주시면 참 감사하겠어요 제발 부탁드려요~ 근데 저 샐러디 사진 제가 찍은 거예요 화질 기가막히게 잘 찍었죠 끄쵸 칭찬해주세오 아 지금 이렇게 데이터 채우기도 힘든데.. 누가.. 500자를.."),
        ReviewDataModel(reviewer: "나는헬푸파미야",
                        starLate: 5.0,
                        tagList: ["#맛 최고"],
                        reviewImageURLList: [],
                        reviewContents: nil)
    ]
}
