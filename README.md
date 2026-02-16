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
*   **状态管理**:
    *   使用 `provider` 进行高效的响应式状态更新。
    *   使用 `shared_preferences` 进行本地持久化。

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
