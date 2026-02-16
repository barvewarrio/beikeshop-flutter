# BeikeShop Mobile (Flutter) - Product Requirement Document (PRD)

## 1. 产品概览 (Product Overview)
- **App Name**: BeikeShop Mobile
- **Tagline**: Shop Smarter, Live Better. (参考 Temu: Shop Like a Billionaire)
- **Target Audience**: 全球用户，注重性价比，追求发现式购物体验。
- **Design Philosophy**: **Discovery-Driven E-commerce**. 强调高信息密度、促销氛围与无限流浏览体验（参考 Temu/拼多多跨境版）。

## 2. 设计规范 (Design System - High Conversion Style)

### 核心美学 (Aesthetics)
- **视觉风格**: 
  - **Vibrant & Energetic**: 使用高饱和度色彩激发购买欲。
  - **Information Dense**: 首页采用双列瀑布流，最大化商品展示效率。
  - **Promotion Centric**: 强调折扣标签、倒计时、库存紧张提示。

### 色彩体系 (Color Palette)
- **Primary (Brand)**: **Temu Orange** (#FB7701) 或 **Hot Red** (#E02020) - 用于“购买”、“加入购物车”、“限时特价”等核心转化按钮。
- **Secondary**: **Deep Black** (#1A1A1A) - 用于标题、重要文字。
- **Background**: 
  - **App Background**: 浅灰 (#F5F5F5) 用于区分卡片。
  - **Surface**: 纯白 (#FFFFFF) 用于商品卡片背景。
- **Functional**:
  - **Success**: Green (#25A744) - 支付成功、包邮提示。
  - **Warning/Timer**: Red/Orange - 倒计时、仅剩库存。

### 排版 (Typography)
- **Font**: System Default (San Francisco / Roboto) 或 Poppins (用于价格/数字)。
- **Hierarchy**:
  - **Price**: 字重最大，字号最大，颜色最醒目。
  - **Discount Tag**: 醒目的背景色+反白文字。
  - **Product Title**: 紧凑，允许 2 行显示。

### 交互与动效 (Interaction & Motion)
- **Infinite Scroll**: 首页与推荐页无限加载，丝滑流畅。
- **Micro-interactions**: 
  - "Add to Cart" 抛物线动画。
  - 倒计时跳动效果。
- **Popups**: 优惠券领取弹窗、新人红包动效（Gamification）。

## 3. 核心功能 (Core Features)

### 1. Home (首页 - 发现流)
- **Header**: 搜索栏 (含拍照搜索/扫码)、消息入口、分类快捷入口。
- **Banner**: 轮播图，展示大促活动。
- **Feature Icons**: 8-10 个圆形图标 (新品、热销、限时秒杀、优惠券中心等)。
- **Flash Sale**: 横向滚动区域，展示倒计时和进度条。
- **Feed**: 双列瀑布流推荐商品 (Just For You)。
  - 卡片元素：大图、价格 (高亮)、原价 (划线)、销量 (Sold 10k+)、加入购物车按钮。

### 2. Categories (分类)
- **左侧导航**: 一级分类列表 (Men, Women, Home, Electronics...)。
- **右侧内容**: 二级/三级分类 + 推荐图片。
- **布局**: 类似 Temu/京东的侧边栏联动布局。

### 3. Product Detail (商品详情)
- **Gallery**: 顶部大图轮播/视频。
- **Info Section**: 价格区间、Flash Sale 倒计时、标题、销量、评价星级。
- **Marketing**: "Free Shipping on all orders", "Free Returns within 90 days".
- **SKU Selection**: 颜色/尺码选择器 (底部弹窗)。
- **Reviews**: 带图评价预览。
- **Recommendation**: "You may also like" 瀑布流。
- **Bottom Bar**: 店铺/客服、收藏、加入购物车、立即购买。

### 4. Cart & Checkout (购物车与结算)
- **Cart**:
  - 店铺/仓库分组。
  - **Upsell**: "Add $5.00 more to get Free Shipping" (凑单进度条)。
  - 数量调整、删除、移入收藏。
- **Checkout**:
  - 地址管理 (智能补全)。
  - 支付方式 (Credit Card, PayPal, Apple/Google Pay)。
  - 优惠券/积分抵扣。
  - 费用明细 (Subtotal, Shipping, Tax, Total)。

### 5. Me (个人中心)
- **Header**: 用户头像、名称、会员等级。
- **Order Status**: 待付款、待发货、待收货、待评价、退换货 (图标栏)。
- **Services**: 优惠券、积分、浏览历史、地址管理、设置。
- **Gamification Entry**: 玩游戏领奖品/现金 (Temu 特色)。

## 4. 页面结构 (Information Architecture)

- **Bottom Navigation**:
  1.  **Home** (首页) - [Completed]
  2.  **Categories** (分类) - [Completed]
  3.  **You** (个人中心) - [Completed]
  4.  **Cart** (购物车 - 徽标显示数量) - [Completed]

## 5. 技术栈 (Tech Stack)

- **Framework**: Flutter (Stable Channel)
- **State Management**: Provider 或 Riverpod
- **Networking**: Dio (拦截器处理 Token、统一错误处理)
- **Storage**: Hive (本地缓存、搜索历史、Token) / shared_preferences
- **UI Libraries**: 
  - `flutter_staggered_grid_view` (瀑布流)
  - `cached_network_image` (图片缓存优化)
  - `carousel_slider` (轮播图)
  - `font_awesome_flutter` (图标库)
  - `pull_to_refresh` (下拉刷新/上拉加载)

## 6. 启动与打包 (开发者指南)

### 环境准备
- Flutter SDK >= 3.0
- Dart SDK >= 2.17
- Android Studio / VS Code

### 本地运行
```bash
# 获取依赖
flutter pub get

# 生成代码 (如果有使用 build_runner, 如 Hive/JsonSerializable)
flutter pub run build_runner build --delete-conflicting-outputs

# 运行 (Chrome 或 模拟器)
flutter run
```

### 目录结构
```
lib/
├── api/            # API 接口定义
├── theme/          # 全局主题、颜色、字体
├── models/         # 数据模型 (JsonSerializable)
├── screens/        # 页面
│   ├── home/       # 首页
│   ├── category/   # 分类页
│   ├── cart/       # 购物车页
│   └── profile/    # 个人中心页
├── widgets/        # 通用组件 (product_card, bottom_nav, etc.)
└── main.dart       # 入口
```

## 7. 商业化与合规
- **Monetization**: 
  - 实物电商销售。
  - 会员订阅 (BeikeShop Pro?)。
- **Compliance**:
  - GDPR 隐私弹窗 (首次启动)。
  - 账号注销功能。
  - 服务条款与隐私政策链接。

## 8. 待办事项 (Roadmap)
- [x] 搭建基础脚手架与路由配置
- [x] 封装 Dio 网络请求层
- [x] 实现首页瀑布流布局
- [x] 实现分类页面的左右联动效果
- [x] 实现购物车基础 UI
- [x] 实现个人中心基础 UI
- [ ] 集成 BeikeShop 后端 API (Product Detail, Login, etc.)
- [ ] 购物车逻辑 (本地 + 云端同步)
- [ ] 支付网关接入 (Stripe/PayPal)
