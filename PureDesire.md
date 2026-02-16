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
- [x] **年龄验证 (Age Verification)**: 已实现 APP 启动时的年龄确认弹窗 (Home Screen Modal)。
- [x] **隐私政策 (Privacy Policy)**: 已更新 URL。
- [x] **保密发货 (Discrete Packaging)**: 已在结算页增加保密发货说明。

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

#### 2. 缺失接口列表 (Missing API Endpoints)
前端 `ApiService.dart` 目前仅实现了极少部分接口。以下为完整电商流程所需的缺失接口：

**用户认证 (Authentication)**
- [ ] `POST /login` (登录)
- [ ] `POST /register` (注册)
- [ ] `GET /logout` (登出)
- [ ] `POST /forgotten/send_code` & `password` (找回密码)
- [ ] `GET /auth/user` (获取用户信息)

**购物车 (Cart)**
- [ ] `GET /carts` (获取购物车列表)
- [ ] `POST /carts` (添加商品)
- [ ] `PUT /carts/{cart_id}` (更新数量)
- [ ] `DELETE /carts/{cart_id}` (删除商品)
- [ ] `POST /carts/select` & `unselect` (选中/取消选中)

**结算与订单 (Checkout & Order)**
- [ ] `GET /checkout` (获取结算页信息：地址、支付方式、配送方式)
- [ ] `PUT /checkout` (更新结算信息)
- [ ] `POST /checkout/confirm` (提交订单)
- [ ] `GET /account/orders` (订单列表)
- [ ] `GET /account/orders/{order_number}` (订单详情)
- [ ] `GET /orders/{order_number}/pay` (支付页面/参数)

**地址管理 (Address)**
- [ ] `GET /account/addresses` (地址列表)
- [ ] `POST /account/addresses` (新增地址)
- [ ] `PUT /account/addresses/{id}` (编辑地址)
- [ ] `DELETE /account/addresses/{id}` (删除地址)

#### 3. 后端适配建议 (Backend Adaptation)
- **API 模式改造**: BeikeShop 后端主要设计为返回 HTML 视图 (MVC)。
  - 需确认后端控制器是否支持 `Accept: application/json` 请求头自动返回 JSON。
  - 若不支持，需修改 `Shop/Http/Controllers` 下的控制器（如 `CheckoutController`），在检测到 API 请求时返回 `json_success($data)` 而非 `view(...)`。
