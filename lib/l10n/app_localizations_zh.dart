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
  String get writeReview => '写评价';

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
  String get items => '商品明细';

  @override
  String get orderDate => '下单时间';

  @override
  String get orderId => '订单编号';
}
