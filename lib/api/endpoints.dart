class ApiEndpoints {
  // Base URL (Replace with your actual backend URL)
  // Use 10.0.2.2 for Android Emulator, localhost for iOS Simulator
  // Use your machine's local IP for real device testing
  static const String baseUrl =
      'http://192.168.0.107:8000/api'; // Added /api prefix

  // Public Routes
  static const String home = '/';

  // Brands
  static const String brands = '/brands';
  static String brandDetail(String id) => '/brands/$id';

  // Categories
  static const String categories = '/categories';
  static String categoryDetail(String id) => '/categories/$id';

  // Products
  static const String products = '/products';
  static String productDetail(String id) => '/products/$id';
  static const String productSearch = '/products/search';

  // Cart
  static const String cart = '/carts';
  static const String cartMini = '/carts/mini';
  static String cartItem(String id) => '/carts/$id';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String user = '/auth/user';

  // Orders
  static const String orders = '/orders';
  static String orderDetail(String id) => '/orders/$id';
  static String cancelOrder(String id) => '/orders/$id/cancel';

  // Payment
  static const String paymentMethods = '/payment/methods';
  static const String paymentPay = '/payment/pay';

  // Addresses
  static const String addresses = '/addresses';
  static String addressDetail(String id) => '/addresses/$id';
  static const String countries = '/countries';
  static String countryZones(int countryId) => '/countries/$countryId/zones';

  // Reviews
  static const String reviews = '/reviews';

  // Wishlist
  static const String wishlist = '/wishlist';

  // Coupons
  static const String coupons = '/coupons';
  static const String cartCoupon = '/cart/coupon';

  // RMA
  static const String rmaReasons = '/rmas/reasons';
  static const String rmas = '/rmas';
  static String rmaDetail(String id) => '/rmas/$id';
}
