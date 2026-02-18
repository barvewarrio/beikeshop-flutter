// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '贝壳商城';

  @override
  String get home => '首页';

  @override
  String get category => '分类';

  @override
  String get cart => '购物车';

  @override
  String get profile => '我的';

  @override
  String get search => '搜索';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get currency => '货币';

  @override
  String get myOrders => '我的订单';

  @override
  String get viewAll => '查看全部';

  @override
  String get unpaid => '待付款';

  @override
  String get processing => '处理中';

  @override
  String get shipped => '待收货';

  @override
  String get review => '待评价';

  @override
  String get returns => '退换/售后';

  @override
  String get myServices => '我的服务';

  @override
  String get messages => '消息';

  @override
  String get coupons => '优惠券';

  @override
  String get credit => '余额';

  @override
  String get address => '收货地址';

  @override
  String get history => '浏览足迹';

  @override
  String get wishlist => '心愿单';

  @override
  String get support => '官方客服';

  @override
  String get flashSale => '限时抢购';

  @override
  String get recommendedForYou => '为你推荐';

  @override
  String get seeAll => '查看全部';

  @override
  String get sold => '已售';

  @override
  String get pleaseLoginToViewProfile => '请登录以查看您的个人资料';

  @override
  String get loginRegister => '登录 / 注册';

  @override
  String get vipMember => 'VIP会员';

  @override
  String get searchCategories => '搜索分类';

  @override
  String topPicksIn(String category) {
    return '$category 精选';
  }

  @override
  String get viewCart => '查看购物车';

  @override
  String get writeReview => '写评价';

  @override
  String get requestRefund => '申请退款';

  @override
  String get shoppingCart => '购物车';

  @override
  String get clear => '清空';

  @override
  String get cartEmpty => '您的购物车是空的';

  @override
  String get shopNow => '去购物';

  @override
  String addMoreForFreeShipping(String amount) {
    return '再买 $amount 即可免运费';
  }

  @override
  String get all => '全选';

  @override
  String get total => '合计:';

  @override
  String get checkout => '结算';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get selectCurrency => '选择货币';

  @override
  String get trackOrder => '查看物流';

  @override
  String get payNow => '立即付款';

  @override
  String get buyAgain => '再次购买';

  @override
  String get returnRefund => '申请售后';

  @override
  String get orderDetails => '订单详情';

  @override
  String get orderStatus => '订单状态';

  @override
  String get statusPending => '待付款';

  @override
  String get statusProcessing => '处理中';

  @override
  String get statusShipped => '已发货';

  @override
  String get statusDelivered => '已送达';

  @override
  String get statusCancelled => '已取消';

  @override
  String get shippingAddress => '收货地址';

  @override
  String get paymentMethod => '支付方式';

  @override
  String get items => '商品';

  @override
  String itemCount(int count) {
    return '共 $count 件商品';
  }

  @override
  String get orderDate => '下单时间';

  @override
  String get orderId => '订单编号';

  @override
  String get myAddresses => '收货地址';

  @override
  String get addAddress => '添加新地址';

  @override
  String get editAddress => '编辑地址';

  @override
  String get deleteAddress => '删除地址';

  @override
  String get deleteAddressConfirm => '确定要删除这个地址吗？';

  @override
  String get fullName => '收货人姓名';

  @override
  String get phoneNumber => '手机号码';

  @override
  String get country => '国家/地区';

  @override
  String get provinceState => '省/州';

  @override
  String get city => '城市';

  @override
  String get zipCode => '邮政编码';

  @override
  String get noOrders => '暂无订单';

  @override
  String get startShopping => '去购物';

  @override
  String get buyerProtection => '买家保护';

  @override
  String get freeShipping => '免运费';

  @override
  String get enterCouponCode => '请输入优惠券码';

  @override
  String get viewAvailable => '查看可用优惠券';

  @override
  String get almostSoldOut => '库存紧张';

  @override
  String get priceDrop => '降价提醒';

  @override
  String get deliveryGuarantee => '发货保证';

  @override
  String get securePayment => '安全支付';

  @override
  String get defaultAddress => '默认地址';

  @override
  String get setDefault => '设为默认';

  @override
  String get shippingFee => '运费';

  @override
  String get setAsDefault => '设为默认地址';

  @override
  String get defaultLabel => '默认';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get noAddressesFound => '暂无收货地址';

  @override
  String get edit => '编辑';

  @override
  String get defaultTag => '默认';

  @override
  String get change => '修改';

  @override
  String get placeOrder => '提交订单';

  @override
  String get apply => '使用';

  @override
  String get remove => '移除';

  @override
  String get discount => '折扣';

  @override
  String get store => '店铺';

  @override
  String get chat => '客服';

  @override
  String get orderPlaced => '订单已提交';

  @override
  String get orderPlacedMessage => '您的订单已成功提交。';

  @override
  String get selectShippingAddress => '请选择收货地址';

  @override
  String errorPlacingOrder(String error) {
    return '提交订单失败: $error';
  }

  @override
  String get subtotal => '商品小计';

  @override
  String get shipping => '运费';

  @override
  String get creditCard => '信用卡';

  @override
  String get cancelOrder => '取消订单';

  @override
  String get discretePackaging => '私密发货';

  @override
  String get discretePackagingNote => '所有包裹均采用私密包装，不包含任何敏感信息。';

  @override
  String get paypal => 'PayPal';

  @override
  String get cod => '货到付款';

  @override
  String get searchHint => '搜索商品';

  @override
  String get recentSearches => '最近搜索';

  @override
  String get trending => '热门搜索';

  @override
  String get clearHistory => '清除历史';

  @override
  String get noResults => '未找到相关商品';

  @override
  String endsIn(String time) {
    return '距离结束 $time';
  }

  @override
  String get productNotFound => '未找到相关商品';

  @override
  String get ageVerificationTitle => '年龄确认';

  @override
  String get ageVerificationContent => '本应用包含成人内容。您必须年满18岁才能访问。';

  @override
  String get iAmOver18 => '我已满18岁';

  @override
  String get exitApp => '离开';

  @override
  String get copy => '复制';

  @override
  String get rmaReason => '退款原因';

  @override
  String get rmaStatus => '退款状态';

  @override
  String get rmaDetails => '退款详情';

  @override
  String get rmaPending => '审核中';

  @override
  String get rmaApproved => '已批准';

  @override
  String get rmaRejected => '已拒绝';

  @override
  String get submit => '提交';

  @override
  String get pleaseSelectReason => '请选择原因';

  @override
  String get description => '描述';

  @override
  String get optional => '可选';

  @override
  String get submitSuccess => '提交成功';

  @override
  String get cancelOrderConfirmation => '确定要取消此订单吗？';

  @override
  String get orderCancelled => '订单取消成功';

  @override
  String get confirm => '确认';

  @override
  String get error => '错误';

  @override
  String get addToCart => '加入购物车';

  @override
  String get addedToCart => '已加入购物车';

  @override
  String get buyNow => '立即购买';

  @override
  String get noCouponsAvailable => '暂无优惠券';

  @override
  String minSpend(String amount) {
    return '最低消费: $amount';
  }

  @override
  String expires(String date) {
    return '有效期至: $date';
  }

  @override
  String couponCode(String code) {
    return '券码: $code';
  }

  @override
  String get off => '优惠';

  @override
  String get addedToWishlist => '已加入心愿单';

  @override
  String get removedFromWishlist => '已从心愿单移除';

  @override
  String failedToUpdateWishlist(String error) {
    return '更新心愿单失败: $error';
  }

  @override
  String reviewsTitle(int count) {
    return '用户评价 ($count)';
  }

  @override
  String get noReviewsYet => '暂无评价，快来抢沙发吧！';

  @override
  String get anonymous => '匿名用户';

  @override
  String failedToLoadReviews(String error) {
    return '加载评价失败: $error';
  }

  @override
  String get loadMore => '加载更多';

  @override
  String get secureCheckout => '安全结算';

  @override
  String get orderSummary => '订单摘要';

  @override
  String get encryptedPayment => '256位 SSL 加密支付';

  @override
  String get paymentSecurity => '支付安全';

  @override
  String get moneyBackGuarantee => '退款保证';

  @override
  String get safePayment => '安全支付';

  @override
  String deliveryBy(String date) {
    return '预计 $date 送达';
  }

  @override
  String get freeReturns => '90天无理由退货';

  @override
  String lowStock(int count) {
    return '仅剩 $count 件库存！';
  }

  @override
  String soldCount(String count) {
    return '已售 $count';
  }

  @override
  String youSaved(String amount) {
    return '已省 $amount';
  }

  @override
  String get requiredField => '必填';

  @override
  String errorAddingToCart(String error) {
    return '加入购物车失败: $error';
  }
}
