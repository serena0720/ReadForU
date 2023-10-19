# ReadForU 💬

## 📖 목차

1. [소개](#소개)
2. [팀원](#팀원)
3. [실행 화면](#실행-화면)
4. [트러블 슈팅](#트러블-슈팅)

<br>

<a id="소개"></a>

## 1. 📢 소개

5가지 언어 중 원하는 언어를 선택해주세요! <br>
카메라를 켜고 실시간으로 번역을 사용해보세요 <br>
번역된 내용을 선택, 복사하여 기본 번역에서 추가 번역을 해보세요

> 5가지 `Source Language`, `Target Language` 선택 및 전환 버튼 뷰 <br>
> 언어 선택 뷰를 별도의 `LanguageChangeButtonView`로 만들어 뷰를 재사용 <br>
> `DataScannerViewController`를 사용하여 실시간 번역 구현 <br>
> 실시간 번역 내용 선택 시 클립보드 복사 <br>
> 1초당 자동 번역 갱신되는 기본 번역 화면 구현

<br>

<a id="팀원"></a>

## 2. 👤 팀원

| [Serena 🐷](https://github.com/serena0720) |
| :--------: | 
| <Img src = "https://i.imgur.com/q0XdY1F.jpg" width="350"/>| 

<a id="실행-화면"></a>
## 3. 📲 실행 화면
| 로딩 화면 | 언어 선택 |
| :--------: | :--------: |
| <Img src = "https://media.discordapp.net/attachments/1110540681493090344/1164498581194014720/5.gif?ex=65436ed1&is=6530f9d1&hm=214bc9d6fe14195d491efac135f6993196a3fce8b49bfdb4fc6b65a095c45844&=&width=616&height=1332" width="350"/>| <img width="350" src="https://media.discordapp.net/attachments/1110540681493090344/1164497693356326982/1.gif?ex=65436dfd&is=6530f8fd&hm=db4481339a9cc1da12fa34d32366d7178a613cbd6cd8ae74c4f2f72bf8bd82cb&=&width=616&height=1332">|
| 실시간 번역 | 기본 번역 |
| <Img src = "https://media.discordapp.net/attachments/1110540681493090344/1164497692995633193/2.gif?ex=65436dfd&is=6530f8fd&hm=19e74d7a7de3f913c4695a869a87e0ba1863ea7f1c5a301756dc4416cb0b2666&=&width=616&height=1332" width="350"/>| <img width="350" src="https://media.discordapp.net/attachments/1110540681493090344/1164500524725440542/3.gif?ex=654370a0&is=6530fba0&hm=a662f5a8ee4905a086dc12c6cd982fb5f1cc239994361b94b06c5a1af7fbb1de&=&width=616&height=1332">|
| 카메라 접근 권한 | 카메라 미지원 시 |
| <Img src = "https://media.discordapp.net/attachments/1110540681493090344/1164498055857446994/4.gif?ex=65436e53&is=6530f953&hm=9b504765fdac014c0bdaf4becd09090c04958b3d6d37f34dc5d488dee5ef1445&=&width=616&height=1332" width="350"/>| <img width="350" src="https://media.discordapp.net/attachments/1147011195086307399/1164385232292683857/Oct-19-2023_11-10-54.gif?width=652&height=1332">|



<br>

<a id="트러블-슈팅"></a>
## 4. 🛎️ 트러블 슈팅

### 🔥 LoadingView를 gif로 띄우기
- 앱을 설치 후 처음 앱 구동 시 `gif LoadingView`를 띄우고자 하였습니다. 이때, 외부라이브러리를 사용하여도 `LaunchScreen`에선 `gif`를 사용할 수 없다는 것을 알게되었습니다.
- 이를 해결하기 위해 `LaunchScreen`에서 `gif`의 첫 시작 사진을 넣고, `LaunchScreen`이후 바로 `gif LoadingView`를 띄워주었습니다.
    [🔗 참고링크 ](https://www.amerhukic.com/animating-launch-screen-using-gif)

<br>

### 🔥 DataScanner Constraints 오류
- `DataScannerViewController`의 `isGuidanceEnabled=true`로 주게되는 경우 하기와 같은 에러가 발생하였습니다.
```swift
"<NSLayoutConstraint:0x282c22e40 H:|-(10)-[UILabel:0x12f3152e0](LTR) (active, names: '|':VKKeyboardCameraGuidanceView:0x12f3148a0 )>",
"<NSLayoutConstraint:0x282c22ee0 H:[UILabel:0x12f3152e0]-(10)-|(LTR) (active, names: '|':VKKeyboardCameraGuidanceView:0x12f3148a0 )>",
"<NSLayoutConstraint:0x282c22f30 VKKeyboardCameraGuidanceView:0x12f3148a0.width <= 0.666667*VKAVCapturePreviewView:0x12f313be0.width (active)>",
"<NSLayoutConstraint:0x282c39cc0 'UIView-Encapsulated-Layout-Width' VKAVCapturePreviewView:0x12f313be0.width == 0 (active)>"
```
- 이는 `VKAVCapturePreviewView`의 가로폭사이즈가 지정되지 않으면서 생긴 문제라 생각되어, `DataScannerViewController`의 View사이즈를 지정해줌으로 해결하였습니다.
```swift
dataScanner.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dataScanner.view.leadingAnchor.constraint(equalTo: realTimeView.scannerView.leadingAnchor),
            dataScanner.view.trailingAnchor.constraint(equalTo: realTimeView.scannerView.trailingAnchor),
            dataScanner.view.topAnchor.constraint(equalTo: realTimeView.scannerView.topAnchor),
            dataScanner.view.bottomAnchor.constraint(equalTo: realTimeView.scannerView.bottomAnchor)
        ])
```
    
<br>

### 🔥 StackView안의 View 사이즈 결정 시기
- `DataScannerViewController`의 `view`의 사이즈를 `RealTimeTranslateViewController`의 `realTimeView`의 사이즈에 맞추고자 하였습니다. 이때 `realTimeView`의 사이즈가 `viewDidLoad`에서 결정되지 않아 이 시점에서 `DataScannerViewController`의 `view`사이즈를 정할 수 없는 문제가 생겼습니다.
- 하여 `StackView`안에 있는 `realTimeView`의 사이즈가 결정된 시점인 `viewDidAppear`에서 `DataScannerViewController`의 `view` 사이즈를 지정하였습니다.
```swift
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if scannerAvailable {
            startDataScanner()
        } else {
            refuseAdmission()
        }
    }
    
    private func startDataScanner() {
        dataScanner.view.frame = realTimeView.scannerView.bounds
        try? dataScanner.startScanning()
    }
```

<br>

### 🔥 Image위에 Text 배치 시 가독성 문제를 UIVisualEffect로 해결
- 실시간 번역 시 인식되는 텍스트 박스 위에 불투명한 `Button`을 배치하고자 하였습니다. 이때, 단순히 `color`의 `alpha`값을 조정하여 사용하게 되면 오히려 텍스트의 가독성이 떨어졌습니다.
- 이를 해결하고자 `UIVisualEffect`를 사용하여 배경을 `blur`처리하고 그 위에 `text`가 배치될 수 있도록 하였습니다.

    [🔗 참고링크](https://zeddios.tistory.com/1140)


<br>

### 🔥 ViewController 순환참조 문제
- `API`를 실시간으로 호출하기 위해 `Timer`를 사용하여 지정 시간마다 반복적으로 `API`호출을 하도록 구현하였습니다. 이때 각 `ViewController`의 `RC`가 `0`로 바뀌지 않는 문제가 생겼습니다.
- `Timer`의 인스턴스가 유지되고 있다는 것을 발견하여 `ViewController`가 `viewWillDisappear` 시 `Timer`를 삭제하였습니다.
```swift
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
```

<br>

### 🔥 AlertController 반복 호출
- `API`를 자동 반복 호출하기 때문에, `API`호출 에러시 뜨는 `AlerController`의 창이 중복으로 호출된다는 문제가 생겼습니다.
- `AlertController`는 `UIViewController`를 상속하기 떄문에 `UIViewController`의 `presentedViewController`프로퍼티를 사용하여 `present`로 호출된 `ViewController`가 있을 시 `AlertController`를 추가 호출하지 않도록 하였습니다.

    [🔗 참고링크](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621407-presentedviewcontroller)
