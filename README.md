
# Member [iOS]
| <img src="https://avatars.githubusercontent.com/u/78294459?v=4" width=120px alt="황채웅"/>  | <img src="https://avatars.githubusercontent.com/u/89966409?v=4" width=120px alt="신호연"/>  | 
| :-----: | :-----: |
| [황채웅](https://github.com/woongaaaa) | [신호연](https://github.com/fnfn0901)  | 

# Directory Structure
```
.
└── walkmong_front/
    ├── walkmong.xcodeproj
    ├── walkmong.xcworkspace
    ├── walkmong/
    │   ├── Application/
    │   │   ├── AppDelegate.swift
    │   │   ├── Info.plist
    │   │   └── SceneDeleagate.swift
    │   ├── Global/
    │   │   ├── Components
    │   │   ├── Constants
    │   │   ├── Extensions
    │   │   └── Resources
    │   ├── Network/
    │   │   ├── API
    │   │   ├── Foundation
    │   │   ├── Manager
    │   │   ├── Response
    │   │   └── Service
    │   └── Presentation/
    │       ├── Example_2/
    │       │   ├── Models
    │       │   ├── Views
    │       │   └── Controller
    │       └── Example_2/
    │           ├── Models
    │           ├── Views
    │           └── Controller
    ├── Podfile
    └── Podfile.lock
```

# Stacks
| For       | Stack                                | Description       |
|-----------------|-------------------------------------|------------|
| UI     | `UIKit`      | iOS의 UI 프레임워크입니다.       |
| AutoLayout     | `SnapKit`      | UI 컴포넌트의 제약 조건을 손쉽게 설정하기 위한 라이브러리입니다.       |
| Architecture     | `MVC(Model-View-Controller)`      | 각 계층의 명확한 책임 분리와 유지보수성 향상을 위해 MVC 패턴을 사용하였습니다.       |
| Concurrency     | `Swift Concurrency`      | 비동기 API 호출과 UI 반영을 효율적으로 처리하기 위해 `Task`와 `async/await`를 활용했습니다. |
| Data Storage     | `UserDefaults`, `Keychain`          | `UserDefaults`를 사용해 사용자 경험을 개선하기 위한 자동완성 데이터를 저장하고, `Keychain`을 사용해 액세스 토큰과 같은 민감한 데이터를 안전하게 저장했습니다. |
| Network     | `Moya`, `StompClientLib`       | 네트워크 레이어를 효율적으로 관리하기 위해 `Moya`를, STOMP 프로토콜 기반의 채팅을 구현하기 위해 `StompClientLib`을 사용하였습니다.    |
| Image     | `KingFisher`       | 이미지 렌더링을 위한 라이브러리입니다.     |
| Dependency     | `cocoapods`, `Swift Package Manager`       | 라이브러리 종속성 관리 도구입니다.    |

# Project Overview
![2025](https://github.com/user-attachments/assets/25806b43-6767-417d-8531-cdf72f5bc239)
![25](https://github.com/user-attachments/assets/ae4e35ad-afab-4841-9502-0565ee2d3af6)

![26](https://github.com/user-attachments/assets/7391e24c-877a-4f21-8a32-b9cb1b86ffa7)

![27](https://github.com/user-attachments/assets/a060aea6-2d15-4a93-bdb7-9d4afa3928f8)

![28](https://github.com/user-attachments/assets/ebf876da-9803-4a99-8215-95014c49d0c5)

![29](https://github.com/user-attachments/assets/70163258-370f-4ece-affc-498de4603160)

![32](https://github.com/user-attachments/assets/25f2e2ad-2e3e-4237-adca-8ba14519590c)
![33](https://github.com/user-attachments/assets/714dcdd4-669c-4093-b7e0-1018d06ba1c2)
