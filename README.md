# CloneAppStore

#### 1. 소개

2018 네이버 캠퍼스 핵데이 프로젝트로 05.17~18 이틀 동안 진행하였다. 프로젝트 주제는 ''애플 앱스토어 앱 UI 만들기''로, 제공된 plist 파일을 json으로 변환하여 UI에 적용하는 것이다.

#### 2. 요구 사항 및 구현 내용 

- 오픈소스는 사용하지 않는다.
- UI 구현 하기.
  - 스토리 보드를 사용하지 않고 직접 UI를 코드로 구현하고 오토레이아웃은 필수로 적용 (규모가 큰 프로젝트에서 스토리 보드를 사용할 경우, 협업 중에 깃 충돌이 일어날 확률이 높으며 해결하기가 어렵다. 따라서 UI를 코드로 구현하도록 변경됨)
  - TabBarController를 window의 루트 뷰 컨트롤러로 설정
  - TabBarController는 한 개의 앱 탭을 가지고 있으며,  앱 탭에 구현해야 할 섹션은 추천 앱, 새롭게 추천하는 앱, 유료 순위, 무료 순위, 인기 카테고리 이다.


- 데이터 불러오기
  - ApiCener: 제공된 plist 파일을 JSON으로 변환하는 모듈로, 각 인터페이스는 api 통신하는 형태로 제공되어야 한다.
  - ApiCenter에서 파싱된 데이터(App, AppTabConfiguration, Category, InstalledApp)를 조합하여 각 섹션의 셀에 알맞는 데이터(recommendedCellData, newRecommendedCellData, paidRankedCellData, freeRankedCellData, favoriteCategoryInfo)를 생성한다. 
- Unit test
  - 생성된 모듈에 대하여 단위테스트를 한다.