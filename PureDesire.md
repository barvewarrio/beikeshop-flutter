目标地区：美国，越南，东南亚，加拿大，非洲
目标用户：100000人以上
行业分类：成人用品，保健品
主要语言：英语
英文名称：PureDesire

### 方案一：极简轻奢风 (最推荐，适合国际化)
**设计理念**：利用首字母 "P" 和 "D" 进行艺术化组合，线条流畅、高级，既显得专业（保健品）又有曲线美（成人用品）。
**适用场景**：APP 图标、产品包装、网站 Header。

> **Prompt:**
> Minimalist logo design for a brand named "PureDesire", monogram logo combining letters P and D, intertwining elegant lines, luxury and sleek style, modern serif typography, deep burgundy and rose gold color palette, vector graphics, white background, professional, high-end adult wellness brand --no shading --v 6.0

### 方案二：抽象符号风 (含蓄、意象化)
**设计理念**：使用抽象图形，融合“水滴/叶子”（代表 Pure/健康）与“火焰/心形”（代表 Desire/激情），传达一种自然的吸引力。
**适用场景**：品牌形象墙、社交媒体头像。

> **Prompt:**
> `Abstract logo symbol for "PureDesire", a fusion of a water droplet and a subtle flame shape, minimalist line art, flat design, balanced and symmetrical, soft gradient colors from teal to coral, conveying health and passion, sans-serif font underneath, clean white background, vector style --v 6.0`

### 方案三：现代文字标 (直观、年轻化)
**设计理念**：重点在于字体设计，使用圆润或带有特殊切角的无衬线字体，体现现代感和亲和力，适合电商平台。
**适用场景**：网站横幅、广告投放。

> **Prompt:**
> `Typographic logo for "PureDesire", custom modern sans-serif font, smooth curves, letters connected fluidly, minimalist, vibrant purple and clean white, tech-inspired but soft, isolated on white background, 2d vector, e-commerce branding style --v 6.0`

---

### 隐私与合规 (Privacy & Compliance)
**隐私政策 (Privacy Policy)**: http://mvpagent.cn/PureDesire

### 已完成 (Completed)
- [x] **年龄验证 (Age Verification)**: 已实现 APP 启动时的年龄确认弹窗 (Home Screen Modal)，使用 SharedPreferences 持久化状态。
- [x] **隐私政策 (Privacy Policy)**: 已更新 URL，并在设置页添加链接。
- [x] **保密发货 (Discrete Packaging)**: 已在结算页增加保密发货说明。
- [x] **界面优化 (UI Refinement)**:
  - 地址管理页 (Address Management): Temu 风格卡片 (圆角 8px, 阴影 blur 4, 默认标签位置优化)。
  - 订单列表页 (Order List): 修复 Product 模型属性引用错误 (name -> title)，修复本地化 item count 错误，统一 Temu 风格 UI。
- [x] **API 服务优化 (API Service)**:
  - 修复 `getOrders` 分页数据解析错误。
  - 完善 `Product` 和 `Order` 数据模型映射。
  - 验证订单商品总数计算逻辑 (Flutter端累加 items.quantity，后端 OrderRepo 预加载 orderProducts)。
- [x] **多货币支持 (Multi-currency)**: SettingsProvider 支持 12 种货币及汇率换算。
- [x] **支付接口 (Payment API)**:
  - 后端: `Api/PaymentController` 已完善，支持 COD (货到付款) 和 Stripe (作为默认回退选项) 的处理逻辑。
  - 前端: `ApiService` 集成支付接口，`CheckoutScreen` 动态加载支付方式。
- [x] **代码质量 (Code Quality)**:
  - Flutter 端全面修复 `avoid_print` linter 错误，统一使用 `debugPrint` 进行日志输出，提升生产环境性能。
  - 修复 `ApiService` 中 User 模型导入问题。
- [x] **评价系统 (Review System)**:
  - 后端: `ReviewController` (List, Create) 已实现并注册路由，`Review` 模型与迁移验证通过。
  - 前端: 实现 `ProductReviewsScreen` (查看全部评价) 和 `WriteReviewScreen` (提交评价)，商品详情页展示 Top 3 评价。
- [x] **心愿单 (Wishlist)**:
  - 后端: `WishlistController` (List, Add, Remove) 已实现并注册路由，`CustomerWishlist` 模型关联验证通过。
  - 前端: 商品详情页集成心愿单切换功能。
- [x] **搜索功能 (Search)**:
  - 前端: `SearchScreen` 集成后端关键词过滤接口 (`getProducts(keyword: ...)`)。
- [x] **优惠券 (Coupons)**:
  - 后端: `CouponController` (List, Apply, Remove) 已实现并注册路由。
  - 前端: `ApiService` 已集成优惠券接口。
- [x] **退款/售后 (RMA)**:
  - 后端: `RmaController` (List, Show, Create, Reasons) 已实现并注册路由。
  - 前端: `ApiService` 集成 RMA 接口，订单详情页增加 "Request Refund" 按钮。
- [x] **下载页 (Download Page)**:
  - 前端: `beikeshop-down` 项目实现 Temu 风格下载页，增加 "Spin to Win" 互动弹窗及移动端吸底引导 (Sticky Footer)。

### 补充建议 (Strategic Suggestions)
1. **合规性 (Compliance)**
   - **年龄验证 (Age Verification)**: (已完成) 针对成人用品行业，建议在进入 APP 或网站时增加严格的年龄验证弹窗，确保符合各地区法律法规。
   - **数据隐私**: 鉴于目标地区包含欧美，需严格遵守 GDPR (欧洲/加拿大) 和 CCPA (美国加州) 等隐私法规。

2. **用户信任与隐私 (Trust & Privacy)**
   - **保密发货 (Discrete Packaging)**: (已完成) 强调“无敏感字眼、无品牌标识”的包裹包装，保护用户隐私，作为核心服务卖点。
   - **匿名评价**: 允许用户匿名发布评价，鼓励真实反馈同时消除顾虑。

3. **本地化策略 (Localization Strategy)**
   - **支付方式**:
     - **越南**: 接入 MoMo, ZaloPay, ViettelPay。
     - **非洲**: 接入 M-Pesa (肯尼亚/东非), OPay (尼日利亚)。
     - **东南亚**: GrabPay, ShopeePay。
   - **多语言支持**: 确保覆盖目标地区的主要语言 (英语, 越南语, 法语等)。

### 后端接口与支付方式审查 (Backend API Audit & Payment Methods)

#### 1. 现有支付方式 (Detected Payment Methods)
根据后端代码库 (`beikeshop/beikeshop/public/image` 及 `plugins` 目录推断)，系统目前支持或预留了以下支付方式：
- **Alipay (支付宝)**: 国际版或国内版
- **WeChat Pay (微信支付)**
- **Stripe**: 适合欧美、加拿大市场 (信用卡/借记卡)
- **LianLian Pay (连连支付)**: 跨境支付
- **WinToPay**: 信用卡收款
- **PayPal**: (推测存在于 Composer 依赖 `srmklive/paypal`)
- **COD (货到付款)**: 基础插件功能

**重要提示 (Critical Note)**:
所有支付插件若要在移动端使用，**必须**实现 `service.payment.mobile_pay.data` 钩子 (Hook)，并填充 `params` 数据。否则 `PaymentService::mobilePay()` 将抛出异常。

#### 2. 接口开发状态 (API Development Status)

**已完成 (Completed)**
- [x] **用户认证 (Authentication)**: `AuthController` (Login, Register, Logout, Me, Refresh) - 已验证并集成真实 API (JWT Auth)。
- [x] **支付 (Payment)**: `PaymentController` (Methods, Pay) - 已实现 COD 和 Stripe 处理逻辑。
- [x] **路由 (Routes)**: `api.php` 已注册并验证 Auth, Payment, Cart, Order, Review, Wishlist, RMA, Coupon 所有核心路由。
- [x] **购物车 (Cart)**: `CartController` (List, Add, Update, Delete) - 已验证。
- [x] **地址管理 (Address)**: `AddressController` (List, Add, Update, Delete) - 已验证。
- [x] **订单管理 (Order)**: `OrderController` (List, Detail, Create, Cancel) - 已验证。
- [x] **基础数据**: `CategoryController`, `ProductController`, `CountryController`, `ZoneController` - 已验证。
- [x] **评价系统**: `ReviewController` (List, Create) - 已验证。
- [x] **心愿单**: `WishlistController` (List, Add, Remove) - 已验证。
- [x] **优惠券**: `CouponController` (List, Apply, Remove) - 已验证。
- [x] **退款/售后**: `RmaController` (List, Show, Create, Reasons) - 已验证。

### 待开发接口 (Missing Interfaces / To-Do)
- [ ] **物流追踪 (Order Tracking)**:
  - 前端: 订单详情页需展示物流信息。
  - 后端: 需实现 `GET /api/orders/{id}/tracking` 接口，对接物流商API。
- [ ] **支付回调**: Webhook/Callback for Stripe/Alipay/WeChat
- [ ] **物流追踪**: `ShippingController` (Track)

#### 3. 后端适配建议 (Backend Adaptation)
- **API 模式改造**: 已在 `Shop/Http/Controllers/Api` 命名空间下创建独立控制器，并配置 `api_customer` guard (JWT Auth)。
- **支付适配**: 需检查现有支付插件是否实现 mobile hook。
