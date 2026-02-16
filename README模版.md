# SimpleNote - Product Requirement Document (PRD)

## 1. 产品概览 (Product Overview)
- **App Name**: SimpleNote
- **Tagline**: Simple habit tracker, keep your streaks forever.
- **Target Audience**: Global users seeking a distraction-free, high-efficiency habit tracking experience.
- **Design Philosophy**: **Linear-style Minimalism**. Focus on content, precision, and speed.

## 2. 设计规范 (Design System - Linear Style)

### 核心美学 (Aesthetics)
- **视觉风格**: 极致简约，强调微小的细节和质感。
- **色彩体系 (Color Palette)**:
  - **Background**: 纯黑 (Dark Mode) 或 纯白 (Light Mode)，避免复杂的渐变背景。
  - **Surface**: 低对比度的灰色背景用于卡片 (e.g., #F4F4F5 in light, #18181B in dark).
  - **Borders**: 极细的边框 (1px)，颜色微弱 (e.g., rgba(0,0,0,0.08)).
  - **Accents**: 单一主色调（推荐 **Electric Blue** 或 **Violet**），仅用于强调操作（如 Check-in 按钮）。
  - **Text**: 高对比度主标题，次级信息使用透明度调整 (60% opacity)。
- **排版 (Typography)**:
  - 使用系统默认无衬线字体 (San Francisco / Roboto) 或 Inter。
  - 强调字重对比 (Bold Headings vs Regular Body)。
- **交互与动效 (Interaction & Motion)**:
  - **Snappy**: 响应迅速，无延迟。
  - **Micro-interactions**: 点击按钮时的轻微缩放，打卡成功时的细微震动反馈 (Haptic Feedback)。
  - **Transitions**: 页面切换使用平滑的 Slide 或 Fade 效果。

## 3. 核心功能 (Core Features)

### 1. Add Habit (添加习惯) [已完成]
- **交互**: 
  - 首页顶部或底部常驻 "+" 按钮。
  - 模态弹窗 (Modal) 或 底部抽屉 (Bottom Sheet) 形式。
- **输入项**:
  - **Name**: 习惯名称 (e.g., Running, Reading)。
  - **Icon**: 提供一套线性风格 (Outline style) 的图标库。
  - **Color**: 6-8 种低饱和度莫兰迪色系供选择。
  - **Frequency**: 每日 / 每周特定几天。

### 2. Check-in Daily (每日打卡) [已完成]
- **列表页 (Home)**:
  - 采用 **List View** 布局，每个习惯为一个独立的 Card。
  - Card 左侧为习惯名称和连续天数 (Streak)，右侧为打卡按钮。
  - **打卡交互**: 点击按钮 -> 按钮填色 + 图标变为对勾 -> 伴随轻微震动 -> Streak 数字 +1 动画跳动。
  - **撤销**: 长按已打卡的按钮可撤销。

### 3. Stats & History (统计与历史) [基础版已完成]
- 打卡热力图（过去一年，按天聚合）
- 趋势折线图（近 30 天完成次数）
- 习惯筛选（全部或单个习惯）
- 概览卡片：总习惯数、总打卡数
- **可视化**:
  - **Heatmap**: 类似 GitHub Contribution 的热力图，展示过去一年的坚持情况。
  - **Streak Curve**: 简单的折线图展示完成率趋势。
- **极简展示**: 只展示最关键的数据，避免过度设计。

## 4. 页面结构 (Information Architecture)

### 1. Home (首页) [已完成]
- **Header**: 当前日期，简单的问候语 (e.g., "Good Morning")。
- **Body**: 习惯列表。
  - 状态区分：未打卡 (高亮/靠前) vs 已打卡 (变灰/沉底)。
- **Empty State**: 极简插画，引导添加第一个习惯。

### 2. Add Habit (新建页) [已完成]
- 极简表单，自动聚焦输入框。
- 键盘上方提供快速图标/颜色选择器。

### 3. Stats (统计页) [待开发]
- Tab 切换或下拉选择查看不同习惯的统计。
- 核心指标：Current Streak, Best Streak, Total Completions。

### 4. Settings (设置页) [已完成]
- **Pro Banner**: 优雅的卡片展示付费权益。
- **Appearance**: 切换深色/浅色模式 (Dark/Light/System)。
- **Data**: 导出 CSV 功能。
- **About**: 版本号，隐私政策链接。

## 5. 商业化策略 (Monetization)

### 内购项目 (In-App Purchase) [待接入]
- **Habit Pro**: 
  - $4.99 (Lifetime)
  - $1.99 / Week
  - $4.99 / Month

### Pro 权益 [部分完成]
- **Unlimited Habits**: 免费版限制 3 个习惯。
- **Dark Mode**: 已支持主题切换，后续可做为 Pro 强化项。
- **Data Export**: 导出数据。
- **Custom Icons**: 解锁更多高级线性图标。
- **No Ads**: 移除所有广告。

## 6. 上架文案 (App Store Metadata)

**Title**: Daily Habit Streak Tracker - Simple
**Subtitle**: Build routines, keep streaks.

**Description**:
Master your daily routine with the most elegant habit tracker. 
Inspired by the "Linear" design philosophy, we focus on what matters: your habits and your progress. No clutter, no distractions.

**Key Features**:
- **Design First**: A beautiful, minimal interface that makes habit tracking a joy.
- **Streak Tracking**: Visualize your consistency with intuitive streak counters.
- **Privacy Focused**: Your data stays on your device.
- **Haptic Feedback**: Satisfying interactions for every check-in.
- **Insightful Stats**: Simple charts to understand your progress.

**Keywords**: 
habit tracker, daily routine, streak, minimal, productivity, self care, planner, agenda, check in.

## 7. 合规与技术 (Compliance & Tech)
- **Privacy Policy**: 仅本地存储，无服务器交互。
- **Permissions**: Notifications (用于提醒打卡)。
- **Tech Stack**: Flutter (Cross-platform, High performance).

---

## 8. 启动与打包（开发者指南）

### 本地运行（开发调试）
- Chrome（推荐调试，支持热重载）：
  ```bash
  flutter run -d chrome
  ```
- Web Server（局域网预览，建议 Release 模式，避免调试 WS 报错）：
  ```bash
  # 绑定 0.0.0.0 以供手机访问
  flutter run -d web-server --web-hostname=0.0.0.0 --web-port=61535 --release
  # 打开浏览器访问（将 IP 替换为你的内网 IP）
  # http://<你的内网IP>:61535/
  ```

### Android 打包 [已完成]
- Release APK（动态图标使用了运行时 IconData，需关闭 icons 树摇）：
  ```bash
  # 使用 JDK 17 构建（一次性）
  JAVA_HOME=$(/usr/libexec/java_home -v 17) flutter build apk --release --no-tree-shake-icons
  # 输出：
  # build/app/outputs/flutter-apk/app-release.apk
  ```

#### 单次构建（指定 JDK 17）
```bash
JAVA_HOME=$(/usr/libexec/java_home -v 17) flutter build apk --release --no-tree-shake-icons
```

#### 覆盖广告位 ID（可选）
- 覆盖 Banner：
```bash
flutter build apk --release --no-tree-shake-icons \
  --dart-define=ADMOB_BANNER_ID_ANDROID=ca-app-pub-xxx/yyy
```
- 覆盖插屏（Interstitial）：
```bash
flutter build apk --release --no-tree-shake-icons \
  --dart-define=ADMOB_INTERSTITIAL_ID_ANDROID=ca-app-pub-xxx/zzz
```
- 覆盖激励视频（Rewarded）：
```bash
flutter build apk --release --no-tree-shake-icons \
  --dart-define=ADMOB_REWARDED_ID_ANDROID=ca-app-pub-xxx/rrr
```
- 覆盖 App Open（冷启动/回前台展示）：
```bash
flutter build apk --release --no-tree-shake-icons \
  --dart-define=ADMOB_APP_OPEN_ID_ANDROID=ca-app-pub-xxx/ooo
```

### 包名与签名（Android/iOS）

#### 包名（已设置）
- Android Application ID：`com.simplenote.dailyhabit`  
  位置：[android/app/build.gradle.kts](file:///Volumes/macbak/codeaiapp/daily_habit_tracker/android/app/build.gradle.kts#L23-L41)
- iOS Bundle Identifier：`com.simplenote.dailyhabit`  
  位置：[ios/Runner.xcodeproj/project.pbxproj](file:///Volumes/macbak/codeaiapp/daily_habit_tracker/ios/Runner.xcodeproj/project.pbxproj#L554-L577)

#### Android Release 签名（本地环境变量方式）
- Gradle 已内置两种方式：1) 本地 `keystore/signing.properties`；2) 环境变量；否则回退到 debug 签名  
  位置：[build.gradle.kts](file:///Volumes/macbak/codeaiapp/daily_habit_tracker/android/app/build.gradle.kts#L1-L20)
- 方式 1：项目本地 keystore（推荐，已在 .gitignore 中忽略）
  - 路径：`daily_habit_tracker/keystore/`
  - 创建文件：`daily_habit_tracker/keystore/signing.properties`
  - 示例内容：
```properties
storeFile=release.jks
storePassword=********
keyAlias=simplenote_release
keyPassword=********
```
  - 将 keystore 放在 `daily_habit_tracker/keystore/release.jks`
- 方式 2：使用环境变量（CI 或本机）
  - 在本机设置以下变量（示例，注意替换占位）：
```bash
export ANDROID_KEYSTORE=/absolute/path/to/release.jks
export ANDROID_KEYSTORE_PASSWORD=********
export ANDROID_KEY_ALIAS=simplenote_release
export ANDROID_KEY_PASSWORD=********
```
- 生成 keystore（示例命令，按需更改别名/机构信息）：
```bash
keytool -genkeypair -v \
  -keystore /absolute/path/to/release.jks \
  -alias simplenote_release \
  -keyalg RSA -keysize 2048 -validity 36500 \
  -dname "CN=SimpleNote, OU=Dev, O=SimpleNote, L=, S=, C=US"
```
- 计算指纹（用于 Play 控台或 API 校验）：
```bash
keytool -list -v -keystore /absolute/path/to/release.jks -alias simplenote_release
```
- 备注：签名文件与口令均为敏感信息，请勿提交到仓库

#### iOS 签名（Xcode 自动签名推荐）
- Bundle Identifier 已设为 `com.simplenote.dailyhabit`
- Xcode → Targets → Runner → Signing & Capabilities  
  使用 Apple Distribution 证书与 App Store Provisioning Profile（或启用自动签名）

### 上架自动化（可选）
- 建议使用 Fastlane
  - Google Play：`supply`（上传 AAB/APK、元数据、截图）
  - App Store：`deliver`（上传 IPA、元数据、截图）
- 所需凭据（不入库）
  - Play Console 服务账号 JSON（具有发布权限）
  - App Store Connect API Key（Key ID / Issuer ID / 私钥）
- 典型流程
  - 本地或 CI 导出凭据到安全路径
  - CI 中配置环境变量与密钥（GitHub Actions/其他）
  - 执行 lane：构建 → 上传 → 提交审核/测试
- 多应用共享建议
  - 在每个 app 子目录放置 `Fastfile`，定义统一的 lane 名称（如 build_android、upload_play、build_ios、upload_appstore）
  - 在仓库根目录定义一个通用 CI Workflow（如 `.github/workflows/release.yml`），通过矩阵传入 app 路径、包名/Bundle ID、渠道（internal/beta/production）等参数
  - 共享的 Ruby Gemfile/Plugin 与脚本放在根目录，减少重复
  - 密钥依然通过 CI Secrets 注入（Google JSON / ASC API Key / 签名口令）
  - 我可以按以上方式生成最小化模板（不包含任何密钥），便于你在多个 app 间共用

### 内网 APK 下载页（真机安装） [已完成]
- 目录：根目录 `share/` 包含 `index.html` 与 `app-release.apk`
- 启动下载服务（任意目录执行以下命令）：
  ```bash
  python3 /Volumes/macbak/codeaiapp/share/serve.py
  # 服务地址：http://0.0.0.0:8000/
  # 手机访问： http://<你的内网IP>:8000/
  ```
- 页面支持：
  - 一键下载 APK
  - 显示当前内网地址与 Web 预览地址
  - 二维码快速下载

---

## 9. 设置与 Pro（去广告）说明

### 设置页（Settings） [已完成]
- 入口：主页右上角齿轮按钮，或路由 `/settings`
- 功能：
  - 主题模式：跟随系统 / 浅色 / 深色（保存到本地设置）
  - 数据导出：导出习惯数据为 CSV（保存于 App Documents 目录）
  - Pro Banner：非 Pro 用户显示升级入口

### Pro（去广告与高级功能） [进行中]
- 当前实现：本地模拟“升级为 Pro”，用于展示 UI 与逻辑结构
  - 按下“升级 Pro”后，将本地 `isPro` 标记为 true，并立即生效
  - 后续可无缝接入 `in_app_purchase` 或第三方支付 SDK
- 去广告逻辑：
  - 已集成移动广告（采用 Google 测试 ID），当 `isPro = true` 时隐藏广告
  - Android Manifest/ iOS Info.plist 已配置测试 App ID；上线前请替换为自己的正式 ID 与广告位

#### 广告接入（替换为正式 ID）
- Android：
  - Application ID：`android/app/src/main/AndroidManifest.xml` 中 `com.google.android.gms.ads.APPLICATION_ID`
  - Banner 广告位 ID：`lib/ads/ad_helper.dart` 中的 Android 单元 ID（支持 --dart-define 覆盖）
    - `--dart-define=ADMOB_BANNER_ID_ANDROID=ca-app-pub-xxx/yyy`
- iOS：
  - Application ID：`ios/Runner/Info.plist` 中 `GADApplicationIdentifier`
  - Banner 广告位 ID：`lib/ads/ad_helper.dart` 中的 iOS 单元 ID（支持 --dart-define 覆盖）
    - `--dart-define=ADMOB_BANNER_ID_IOS=ca-app-pub-aaa/bbb`
    
示例：
```bash
flutter build apk --release \
  --dart-define=ADMOB_BANNER_ID_ANDROID=ca-app-pub-xxx/yyy
flutter build ios --release \
  --dart-define=ADMOB_BANNER_ID_IOS=ca-app-pub-aaa/bbb
```
  
注意：请遵循平台隐私与合规（如 GDPR 同意），并在正式发布时切换至自己的广告位。

---

## 14. 内购（Pro）配置与测试

### 当前实现 [基础流已接入]
- 使用 in_app_purchase 接入非消耗型商品 `habit_pro`
- 设置页提供“购买 Pro / 恢复购买”按钮；如商店未配置，回退为本地解锁便于演示
- 购买或恢复成功后，自动将本地 `isPro` 设为 true 并隐藏广告

### 配置步骤（上架前）
- Google Play Console / App Store Connect 创建非消耗型商品：
  - Product ID：`habit_pro`
  - 价格与展示信息根据实际设置
- 在真机测试账号下进行测试购买：
  - Android 使用内部测试轨道、加入测试者，设备登录相同账号
  - iOS 使用 Sandbox Tester
- 注意事项：
  - 正式环境删除“本地解锁”回退，确保仅通过真实购买置为 Pro
  - 对接收据校验与服务器验证（可选，后续扩展）

### 相关代码
- Provider：`lib/providers/purchase_provider.dart`
- 设置页按钮：`lib/screens/settings_screen.dart`

---

## 10. 生成代码（Hive Adapter） [已完成]
- 如果新增/修改了带有 `@HiveType` 的模型：
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

---

## 11. 常见问题
- Web Server 调试日志提示 WebSocket 连接失败：
  - 原因：web-server 设备需要调试扩展，且在局域网/非 Chrome 设备下容易出现
  - 解决：使用 `--release` 模式运行 web-server 供手机预览，或直接使用 `-d chrome` 本机调试
- APK 下载 BrokenPipeError：
  - 原因：移动端在下载过程中中断连接
  - 处理：`share/serve.py` 已捕获并抑制该异常，不影响下载成功

---

## 12. 品牌与图标（SimpleNote）

- 名称：SimpleNote
- Logo 文件：`/Volumes/macbak/codeaiapp/logo/SimpleNote.jpeg`

### 应用名称设置 [已完成]
- Android：
  - 修改 `android/app/src/main/AndroidManifest.xml` 中 `<application android:label="SimpleNote" ...>`
- iOS：
  - 修改 `ios/Runner/Info.plist` 中 `CFBundleName`/`CFBundleDisplayName` 为 `SimpleNote`
- Web：
  - 修改 `web/index.html` 中 `<title>SimpleNote</title>`

### 应用图标设置（可选） [已完成（Android/iOS）、Web favicon 已接入]
- 手动替换：
  - Android 图标路径：`android/app/src/main/res/mipmap-*/ic_launcher.png`
  - iOS 图标路径：`ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - Web 图标：`web/icons/` 及 `web/favicon.png`
- 或使用图标生成工具：
  - 已使用 `flutter_launcher_icons` 生成 Android/iOS 启动图标  
    - 配置位置：`pubspec.yaml` -> `flutter_launcher_icons`  
    - 源图：`assets/branding/app_icon.jpg`（来源于 `/logo/SimpleNote.jpeg`）  
    - 生成命令：
      ```bash
      flutter pub get
      flutter pub run flutter_launcher_icons
      ```

---

## 13. 路线图（Roadmap）
- [已完成] 项目初始化、Hive 模型与 Provider、Home/Add UI、Linear 风格主题
- [已完成] 设置页（主题、导出 CSV、Pro Banner）、内网 Web/下载服务、APK 打包
- [进行中] Pro 逻辑（内购接入、去广告策略）
- [已完成] 统计页基础版（热力图、近30天趋势、筛选）
- [进行中] UMP/合规同意接入
- [已完成] 每日提醒（本地通知）
- [待开发] 更多图标与配色、数据备份/恢复

---

## 15. 隐私与同意

### 应用内同意管理 [已完成]
- 入口：设置 → 隐私与同意（路由 `/privacy`）
- 开关项：个性化广告、匿名分析
- 效果：关闭个性化时使用非个性化广告请求；Pro 隐藏广告；未选择同意前不发起广告请求
- 首次启动同意横幅：在首页顶部展示选择（同意个性化 / 仅必要），一经选择可在设置中修改

### 平台 UMP/GDPR（上架前接入）
- 广告同意请接入平台 UMP SDK 并在展示广告前请求同意
- 当前实现为应用内简化版，便于开发与测试
- 建议：在生产构建中用 UMP 结果回写到 `personalizedAds`，从而与广告请求保持一致
 
#### 调试
- 设置 → 隐私与同意 → 开发者设置（UMP 调试）
  - 强制 EEA 地理位置（调试）
  - 设置测试设备 ID（从日志复制 hashed id）
  - 重置 UMP SDK 状态（模拟首次安装，重启后生效）

---

## 16. 每日提醒（本地通知）

### 功能 [已完成]
- 设置页开启“每日提醒”，选择提醒时间（默认 20:00）
- 每天固定时间触发通知：“该打卡了，打开 SimpleNote 记录今天的习惯进度”

### 配置
- 依赖：`flutter_local_notifications` + `timezone`
- 初始化：非 Web 平台在启动时完成（见 `lib/main.dart`）
- 代码：`lib/services/notification_service.dart`、设置页开关与时间选择（`lib/screens/settings_screen.dart`）

### 注意
- 真机首次运行需授予通知权限
- 不同厂商/系统的后台限制可能影响准时性，必要时提醒用户为 App 解除省电限制

---

## 17. 账号与上架配置清单（请提供）

为推进上架与生产配置，请按以下清单准备并反馈信息（敏感文件如签名证书请勿直接提交到仓库，可线下安全传递）。

### Google（Android）
- Google Play Console
  - 最终包名（Application ID）：将替换 [android/app/build.gradle.kts](file:///Volumes/macbak/codeaiapp/daily_habit_tracker/android/app/build.gradle.kts#L23-L31) 中的 `applicationId`（当前为 `com.example.daily_habit_tracker`）
  - 应用名称、类别、内容分级、隐私政策 URL
  - 内测轨道/封闭测试名单（测试账号邮箱）
- 应用签名（Release）
  - 上传密钥 keystore（线下提供），alias、storePassword、keyPassword
  - SHA-1 / SHA-256 指纹（可由我方从 keystore 计算）
- AdMob（广告）
  - App ID（Android）
  - 广告位 ID（Banner / Interstitial / Rewarded / App Open）
  - 测试设备 ID（可选，用于调试）
  - UMP 消息配置（如已在 AdMob 关联）
- Google Play Billing（内购）
  - 非消耗型商品：`habit_pro`（已在代码与 UI 体现）
  - 价格与地区上架配置、测试账户

落地到项目的位置：
- AdMob App ID：`android/app/src/main/AndroidManifest.xml` 中 `com.google.android.gms.ads.APPLICATION_ID`
- 广告位 ID：通过构建参数覆盖  
  `--dart-define=ADMOB_BANNER_ID_ANDROID=...`、`ADMOB_INTERSTITIAL_ID_ANDROID=...`、`ADMOB_REWARDED_ID_ANDROID=...`、`ADMOB_APP_OPEN_ID_ANDROID=...`  
  或在 [ad_helper.dart](file:///Volumes/macbak/codeaiapp/daily_habit_tracker/lib/ads/ad_helper.dart) 中替换默认值
- 包名与签名：见 [build.gradle.kts](file:///Volumes/macbak/codeaiapp/daily_habit_tracker/android/app/build.gradle.kts#L23-L41)，上架前需添加 release 签名配置

### Apple（iOS）
- App Store Connect
  - Bundle Identifier（与 Xcode 配置一致）
  - 应用名称、副标题、类别、隐私政策 URL
  - 测试账号（Sandbox Tester）、TestFlight 配置
- 签名与证书
  - Team ID、Apple Distribution 证书（不提交到仓库）
  - Provisioning Profile（App Store），建议 Xcode 自动签名
- AdMob（广告）
  - App ID（iOS）
  - 广告位 ID（Banner / Interstitial / Rewarded / App Open）
  - 测试设备 ID（可选）
- StoreKit（内购）
  - 非消耗型商品：`habit_pro`（价格与上架配置）

落地到项目的位置：
- AdMob App ID：`ios/Runner/Info.plist` 中 `GADApplicationIdentifier`
- 广告位 ID：通过构建参数覆盖  
  `--dart-define=ADMOB_BANNER_ID_IOS=...`（其他同理）或在 [ad_helper.dart](file:///Volumes/macbak/codeaiapp/daily_habit_tracker/lib/ads/ad_helper.dart) 中替换默认值
- Bundle Identifier 与签名：Xcode → Targets → Runner → Signing & Capabilities

### 通用与合规
- 隐私政策 URL（Android/iOS 商店均需）
- 应用截图、图标、关键词、支持网址（如有）
- UMP/GDPR 合规：已在代码中集成 UMP，同意结果影响广告请求；上架前请确认 AdMob 后台已开启消息

### 交付与测试说明
- 构建参数（示例）：
  - Android：  
    `JAVA_HOME=$(/usr/libexec/java_home -v 17) flutter build apk --release --no-tree-shake-icons --dart-define=ADMOB_BANNER_ID_ANDROID=ca-app-pub-xxx/yyy`
  - iOS：  
    `flutter build ios --release --dart-define=ADMOB_BANNER_ID_IOS=ca-app-pub-aaa/bbb`
- 真机下载与验证：启动根目录下载服务  
  `python3 /Volumes/macbak/codeaiapp/share/serve.py` → 使用控制台打印的 LAN 地址在手机浏览器访问
