# BeikeShop App 开发计划

## 第一阶段：准备工作与 API 分析
- **目标**: 建立连接并理解数据流向。
- **任务**:
    - [x] 查阅 `api_list.md` 将 App 界面映射到对应的 API 端点 (已更新 `api_list.md`)。
    - [x] 搭建测试环境 (Flutter 项目已初始化: `beikeshop-flutter`)。
    - [ ] 为核心 API (登录, 商品列表, 购物车) 创建 Postman 集合或编写 API 封装代码 (Flutter 端 `lib/api/endpoints.dart` 已创建)。
    - [x] 确定 App 技术栈 (Flutter)。

## 第二阶段：核心功能 (MVP)
- **目标**: 实现商品浏览和用户认证。
- **功能**:
    - **首页**: 轮播图, 精选分类, 热门商品。
        - *API*: `shop.home.index` (`GET /`)
    - **分类与搜索**: 分类树形展示, 关键词搜索。
        - *API*: `shop.categories.index` (`GET /categories`), `shop.products.search` (`GET /products/search`)
    - **商品详情**: 图片, 价格, 描述, 规格选择 (SKU)。
        - *API*: `shop.products.show` (`GET /products/{product}`)
    - **用户认证**: 登录, 注册, 忘记密码。
        - *API*: `shop.login.store` (`POST /login`), `shop.register.store` (`POST /register`)

## 第三阶段：购物与结账
- **目标**: 完成购买流程。
- **功能**:
    - **购物车管理**: 添加/移除商品, 更新数量。
        - *API*: `shop.carts.index` (`GET /carts`), `shop.carts.store` (`POST /carts`), `shop.carts.update` (`PUT /carts/{cart}`)
    - **结账流程**: 选择地址, 配送方式, 支付方式。
        - *API*: `shop.checkout.index` (`GET /checkout`)
    - **订单创建**: 确认订单并发起支付。
        - *API*: `shop.checkout.confirm` (`POST /checkout/confirm`), `shop.orders.pay` (`GET /orders/{number}/pay`)

## 第三阶段：用户中心
- **目标**: 管理用户数据和订单。
- **功能**:
    - **订单历史**: 历史订单列表及详情。
        - *API*: `shop.account.order.index` (`GET /account/orders`)
    - **地址管理**: 收货地址的增删改查 (CRUD)。
        - *API*: `shop.account.addresses.*` (Resource: `/account/addresses`)
    - **个人资料**: 编辑资料, 修改密码。
        - *API*: `shop.account.edit.update` (`PUT /account/edit`), `shop.account.password.update` (`POST /account/password`)

## 第五阶段：测试与发布
- **目标**: 确保稳定性和性能。
- **任务**:
    - [ ] 功能测试 (手动与自动化)。
    - [ ] UI/UX 优化。
    - [ ] 性能测试 (API 延迟)。
    - [ ] 提交至 App Store / Play Store。

## API 参考
请参阅 `api_list.md` 获取详细的可用端点列表。
