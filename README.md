# BeikeShop Flutter 应用

基于 Flutter 构建的现代跨平台电商移动应用。

## 功能特性

*   **用户认证**:
    *   用户登录与注册（含表单验证）。
    *   安全的令牌管理和会话持久化。
    *   个人资料管理。
*   **商品浏览**:
    *   动态主页，包含促销横幅和精选商品。
    *   分类导航。
    *   详细的商品页面，包含图片库和描述。
*   **购物车**:
    *   添加/移除商品。
    *   调整数量。
    *   实时总价计算。
    *   跨应用重启的持久化购物车状态。
*   **地址管理**:
    *   创建、读取、更新、删除 (CRUD) 收货地址。
    *   设置默认地址。
    *   结账时选择地址。
*   **订单系统**:
    *   简化的结账流程。
    *   支付方式选择（信用卡、PayPal、货到付款）。
    *   订单提交和历史记录追踪。
    *   订单详情查看及状态更新。
*   **设置与本地化**:
    *   多货币支持 (USD, CNY, EUR)。
    *   语言切换 (English, 中文)。
    *   持久化用户偏好设置。
*   **Temu 风格 UI 增强**:
    *   限时抢购倒计时和横幅。
    *   折扣徽章和原价删除线。
    *   "为您推荐" 版块。
    *   商品标签（例如：免运费、热销）。
    *   高转化率配色方案（橙色/红色）。
    *   **用户中心**: 渐变头部背景、VIP 徽章、订单状态行和服务宫格。
    *   **分类导航**: 侧边栏布局配合子分类网格。
    *   **地址与结账优化**: Temu 风格地址卡片设计，全流程中文本地化（结账页、弹窗、提示信息）。
    *   **订单管理优化**: 订单列表多状态选项卡切换，底部操作栏（支付、追踪、评价），商品缩略图横向滚动展示。
    *   **搜索功能**: 关键词搜索，历史记录保存，热门搜索推荐，搜索结果瀑布流展示。
*   **状态管理**:
    *   使用 `provider` 进行高效的响应式状态更新。
    *   使用 `shared_preferences` 进行本地持久化。

## 待优化功能 (Pending Optimizations)

以下功能目前处于开发阶段或需要进一步完善：

1.  **支付集成**: 目前使用模拟支付流程，需接入真实支付网关（如 Stripe, PayPal, 微信支付, 支付宝）。
2.  **推送通知**: 需集成 Firebase Cloud Messaging (FCM) 以支持订单状态更新和促销推送。
3.  **高级数据分析**: 需集成 Google Analytics 或其他分析工具以追踪用户行为。
4.  **社交登录**: 需支持 Google, Facebook, Apple 等第三方登录方式。
5.  **深色模式**: 目前仅部分支持，需全面适配深色主题。
6.  **性能优化**: 图片加载策略和列表滚动性能仍有提升空间。
7.  **错误处理**: 需增强网络异常和服务器错误的全局处理机制。

## 项目结构

```
lib/
├── api/          # API 服务和端点
├── models/       # 数据模型 (Product, Cart, Order, User, Address)
├── providers/    # 状态管理 (Auth, Cart, Order, Address)
├── screens/      # UI 页面 (Auth, Home, Product, Cart, Checkout, Order, Profile)
├── theme/        # 应用主题和样式
├── widgets/      # 可复用 UI 组件
└── main.dart     # 应用入口点
```

## 快速开始

1.  克隆仓库:
    ```bash
    git clone https://github.com/yourusername/beikeshop-flutter.git
    ```
2.  安装依赖:
    ```bash
    flutter pub get
    ```
3.  运行应用:
    ```bash
    flutter run
    ```

## 使用的技术

*   **Flutter**: UI 工具包
*   **Provider**: 状态管理
*   **Shared Preferences**: 本地存储
*   **Cached Network Image**: 高效图片加载
*   **Intl**: 日期格式化
*   **Font Awesome**: 图标库

## 启动图生成提示词 (Midjourney / Stable Diffusion)

以下是用于生成高质量 App 启动图的提示词参考：

**风格 1：极简时尚 (Minimalist Fashion)**
> A high-end fashion app splash screen, minimalist design, elegant model wearing couture, white background with soft shadows, "PureDesire" typography in gold serif font, clean layout, 8k resolution, photorealistic, cinematic lighting --ar 9:16

**风格 2：活力电商 (Vibrant E-commerce)**
> A vibrant shopping app launch screen, colorful abstract 3d shapes, floating shopping bags and gift boxes, orange and red color palette (Temu style), energetic atmosphere, "PureDesire" bold modern logo in center, high quality 3d render, octane render --ar 9:16

**风格 3：生活方式 (Lifestyle)**
> A lifestyle photography shot for a fashion app, young woman smiling and holding shopping bags in a modern city street, blurred background, natural sunlight, lens flare, "PureDesire" logo overlay at top, welcoming and warm vibe, 4k, high detail --ar 9:16
