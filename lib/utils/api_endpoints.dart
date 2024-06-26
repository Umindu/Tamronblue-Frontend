class ApiEndpoints {
  // static const String baseUrl = 'http://127.0.0.1:8000/';
  // static const String baseUrl = 'http://10.0.2.2:8000/';
  
  static const String baseUrl = 'http://192.168.217.129:8000/';

  static _AuthEndpoints authEndPoints = _AuthEndpoints();
  static _ProfileEndpoints profileEndpoints = _ProfileEndpoints();
  static _CustomerEndpoints customerEndpoints = _CustomerEndpoints();
  static _LandEndpoints landEndpoints = _LandEndpoints();
  static _PlantEndpoints plantEndpoints = _PlantEndpoints();
  static _VarietyEndpoints varietyEndpoints = _VarietyEndpoints();
  static _LandPlantEndpoints landPlantEndpoints = _LandPlantEndpoints();
  static _OrderEndpoints orderEndpoints = _OrderEndpoints();

}

class _AuthEndpoints {
  final String register = 'api/auth/users/';
  final String login = 'api/auth/jwt/create/';
  final String forgotPassword = '${ApiEndpoints.baseUrl}api/auth/users/reset_password/';
  final String resetPassword = '${ApiEndpoints.baseUrl}api/auth/users/set_password/';
  final String verifyEmail = '${ApiEndpoints.baseUrl}api/auth/users/activation/';
  final String resendEmailVerification = '${ApiEndpoints.baseUrl}api/auth/users/resend_activation/';
  final String verifyToken = '${ApiEndpoints.baseUrl}api/auth/jwt/verify/';
  final String myDetails = '${ApiEndpoints.baseUrl}api/auth/users/me/';
  final String logout = '${ApiEndpoints.baseUrl}api/logout';
}

class _ProfileEndpoints {
  final String getMyProfile = '${ApiEndpoints.baseUrl}api/profile/';
  final String addMyProfile = '${ApiEndpoints.baseUrl}api/profile/create/';
  final String updateProfile = '${ApiEndpoints.baseUrl}api/profile/update/';
}

class _CustomerEndpoints {
  final String getCustomers = '${ApiEndpoints.baseUrl}api/customers/agent/';
  final String getCustomerById = '${ApiEndpoints.baseUrl}api/customer/';
  final String createCustomer = '${ApiEndpoints.baseUrl}api/customer/create/';
}

class _LandEndpoints {
  // final String getLands = '${ApiEndpoints.baseUrl}api/lands/';
  final String getLandById = '${ApiEndpoints.baseUrl}api/land/';
  final String getCustomerLands = '${ApiEndpoints.baseUrl}api/lands/customer/';
  final String getAgentLands = '${ApiEndpoints.baseUrl}api/lands/agent/';
  final String createLand = '${ApiEndpoints.baseUrl}api/land/create/';
}

class _PlantEndpoints {
  final String getAllPlants = '${ApiEndpoints.baseUrl}api/plants/';
}

class _VarietyEndpoints {
  final String getAllVarieties = '${ApiEndpoints.baseUrl}api/varieties/';
  final String getVarietiesByPlantId = '${ApiEndpoints.baseUrl}api/varieties/plant/';
}

class _LandPlantEndpoints {
  final String createLandPlant = '${ApiEndpoints.baseUrl}api/land-plant/create/';
  final String getPlantsInLandByLandId = '${ApiEndpoints.baseUrl}api/land-plant-by-land/';
}

class _OrderEndpoints {
  final String getOrderById = '${ApiEndpoints.baseUrl}api/order/';
  final String getMyOrders = '${ApiEndpoints.baseUrl}api/orders/agent/';
  final String createOrder = '${ApiEndpoints.baseUrl}api/order/create/';

  final String addOrderItem = '${ApiEndpoints.baseUrl}api/orderitem/create/';
}