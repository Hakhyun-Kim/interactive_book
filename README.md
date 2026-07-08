# 국제학교를 선택한다는 건 — 인터랙티브 에세이 북 (Expo)

학부모이자 교직원의 시선으로 담아낸 국제학교 선택에 대한 사색과 성찰을,
종이책 같은 감성과 가벼운 인터랙션과 함께 읽을 수 있는 모바일 전자책 프로토타입입니다.

**Expo (React Native)** 기반으로, 한 코드베이스로 iOS / Android / 웹에서 모두 실행됩니다.

---

## 처음이어도 3분 만에 실행하기

### 준비물
- [Node.js](https://nodejs.org/) LTS 버전 (설치 후 터미널에서 `node --version`으로 확인)
- 스마트폰에 **Expo Go** 앱 설치
  - [Android — Play 스토어](https://play.google.com/store/apps/details?id=host.exp.exponent)
  - [iOS — App Store](https://apps.apple.com/app/expo-go/id982107779)

### 1단계: 의존성 설치
프로젝트 폴더에서 터미널을 열고 한 번만 실행합니다.

```bash
npm install
```

### 2단계: 개발 서버 켜기

```bash
npx expo start
```

### 3단계: 내 폰에서 열기
터미널에 큼직한 **QR 코드**가 나타납니다.
- **Android**: Expo Go 앱을 열고 *Scan QR code*로 스캔
- **iOS**: 기본 카메라 앱으로 QR을 비추면 Expo Go로 연결

⚠️ 폰과 컴퓨터가 **같은 Wi-Fi**에 연결되어 있어야 합니다.

### (선택) 브라우저로 바로 보기
폰 없이 컴퓨터에서 확인하려면:

```bash
npm run web
```

---

## 이 프로토타입에서 볼 수 있는 것

- 📖 **표지 화면** — 구름이 떠다니는 감성 커버, 읽기 시작 버튼
- 👆 **좌우 스와이프**로 페이지 넘기기 + 상단 진행 바
- ✦ **본문을 탭**하면 그 자리에서 반짝임이 피어납니다
- 🖋 **저자의 노트** 카드를 탭하면 숨은 주석이 펼쳐집니다
- 🔗 **함께 보기** 카드를 탭하면 참고 자료 링크가 열립니다

## 프로젝트 구조

```
├── App.tsx                  # 진입점: 폰트 로드, 표지 ↔ 리더 전환
├── data/
│   └── book_data.json       # 책 본문 데이터 (글은 전부 여기!)
└── src/
    ├── theme.ts             # 색상·서체 팔레트
    ├── types.ts             # 책 데이터 타입 + 마크다운 파서
    └── components/
        ├── CoverScreen.tsx          # 표지 화면
        ├── ReaderScreen.tsx         # 페이지 리더 (스와이프, 진행 바)
        ├── BookPageView.tsx         # 한 페이지 렌더링 + 탭 반짝임
        └── InteractiveElementCard.tsx  # 노트/링크 카드
```

## 글 수정하는 법

[data/book_data.json](data/book_data.json)만 고치면 됩니다.
- `content`: 페이지 본문. `# 제목`, `### 소제목`, 빈 줄로 구분한 문단, `"..."` 인용을 지원합니다.
- `interactiveElements`: 페이지 하단 카드. `type: "note"`(펼치는 주석) 또는 `type: "link"`(외부 링크 + `actionUrl`).

파일을 저장하면 실행 중인 앱이 자동으로 새로고침됩니다.
