// Response utilities để chuẩn hóa format response

class ApiResponse {
  constructor(success, message, data = null, errors = null, statusCode = 200) {
    this.success = success;
    this.message = message;
    this.timestamp = new Date().toISOString();
    
    if (data !== null) {
      this.data = data;
    }
    
    if (errors !== null) {
      this.errors = errors;
    }
    
    this.statusCode = statusCode;
  }

  static success(res, message, data = null, statusCode = 200) {
    const response = new ApiResponse(true, message, data, null, statusCode);
    return res.status(statusCode).json(response);
  }

  static error(res, message, errors = null, statusCode = 500) {
    const response = new ApiResponse(false, message, null, errors, statusCode);
    return res.status(statusCode).json(response);
  }

  static created(res, message, data = null) {
    return ApiResponse.success(res, message, data, 201);
  }

  static badRequest(res, message, errors = null) {
    return ApiResponse.error(res, message, errors, 400);
  }

  static unauthorized(res, message = 'Không có quyền truy cập') {
    return ApiResponse.error(res, message, null, 401);
  }

  static forbidden(res, message = 'Bị cấm truy cập') {
    return ApiResponse.error(res, message, null, 403);
  }

  static notFound(res, message = 'Không tìm thấy') {
    return ApiResponse.error(res, message, null, 404);
  }

  static conflict(res, message = 'Dữ liệu đã tồn tại') {
    return ApiResponse.error(res, message, null, 409);
  }

  static validationError(res, errors) {
    return ApiResponse.error(res, 'Dữ liệu không hợp lệ', errors, 422);
  }

  static serverError(res, message = 'Lỗi máy chủ nội bộ') {
    return ApiResponse.error(res, message, null, 500);
  }

  static serviceUnavailable(res, message = 'Dịch vụ không khả dụng') {
    return ApiResponse.error(res, message, null, 503);
  }
}

// Paginated response
class PaginatedResponse extends ApiResponse {
  constructor(success, message, data, pagination, statusCode = 200) {
    super(success, message, data, null, statusCode);
    this.pagination = pagination;
  }

  static success(res, message, data, pagination, statusCode = 200) {
    const response = new PaginatedResponse(true, message, data, pagination, statusCode);
    return res.status(statusCode).json(response);
  }
}

// Pagination helper
const createPaginationInfo = (page, limit, total) => {
  const totalPages = Math.ceil(total / limit);
  const hasNextPage = page < totalPages;
  const hasPrevPage = page > 1;

  return {
    currentPage: parseInt(page),
    totalPages,
    totalItems: total,
    itemsPerPage: parseInt(limit),
    hasNextPage,
    hasPrevPage,
    nextPage: hasNextPage ? page + 1 : null,
    prevPage: hasPrevPage ? page - 1 : null
  };
};

// Response wrapper for controllers
const responseWrapper = {
  // Success responses
  success: (res, message, data = null) => {
    return ApiResponse.success(res, message, data);
  },

  created: (res, message, data = null) => {
    return ApiResponse.created(res, message, data);
  },

  // Error responses
  badRequest: (res, message, errors = null) => {
    return ApiResponse.badRequest(res, message, errors);
  },

  unauthorized: (res, message) => {
    return ApiResponse.unauthorized(res, message);
  },

  forbidden: (res, message) => {
    return ApiResponse.forbidden(res, message);
  },

  notFound: (res, message) => {
    return ApiResponse.notFound(res, message);
  },

  conflict: (res, message) => {
    return ApiResponse.conflict(res, message);
  },

  validationError: (res, errors) => {
    return ApiResponse.validationError(res, errors);
  },

  serverError: (res, message) => {
    return ApiResponse.serverError(res, message);
  },

  // Paginated response
  paginated: (res, message, data, pagination) => {
    return PaginatedResponse.success(res, message, data, pagination);
  }
};

// Middleware để thêm response helpers vào res object
const addResponseHelpers = (req, res, next) => {
  res.apiSuccess = (message, data = null) => responseWrapper.success(res, message, data);
  res.apiCreated = (message, data = null) => responseWrapper.created(res, message, data);
  res.apiBadRequest = (message, errors = null) => responseWrapper.badRequest(res, message, errors);
  res.apiUnauthorized = (message) => responseWrapper.unauthorized(res, message);
  res.apiForbidden = (message) => responseWrapper.forbidden(res, message);
  res.apiNotFound = (message) => responseWrapper.notFound(res, message);
  res.apiConflict = (message) => responseWrapper.conflict(res, message);
  res.apiValidationError = (errors) => responseWrapper.validationError(res, errors);
  res.apiServerError = (message) => responseWrapper.serverError(res, message);
  res.apiPaginated = (message, data, pagination) => responseWrapper.paginated(res, message, data, pagination);
  
  next();
};

// Helper để format dữ liệu trước khi trả về
const formatResponseData = (data) => {
  if (!data) return null;

  // Nếu là array
  if (Array.isArray(data)) {
    return data.map(item => formatSingleItem(item));
  }

  // Nếu là object
  return formatSingleItem(data);
};

const formatSingleItem = (item) => {
  if (!item || typeof item !== 'object') return item;

  const formatted = { ...item };

  // Format dates
  Object.keys(formatted).forEach(key => {
    if (formatted[key] instanceof Date) {
      formatted[key] = formatted[key].toISOString();
    }
    
    // Format nested objects
    if (formatted[key] && typeof formatted[key] === 'object' && !Array.isArray(formatted[key])) {
      formatted[key] = formatSingleItem(formatted[key]);
    }
  });

  return formatted;
};

// Constants cho messages
const MESSAGES = {
  // Success messages
  CREATED_SUCCESS: 'Tạo mới thành công',
  UPDATED_SUCCESS: 'Cập nhật thành công',
  DELETED_SUCCESS: 'Xóa thành công',
  RETRIEVED_SUCCESS: 'Lấy dữ liệu thành công',
  OPERATION_SUCCESS: 'Thao tác thành công',

  // Error messages
  VALIDATION_ERROR: 'Dữ liệu không hợp lệ',
  NOT_FOUND: 'Không tìm thấy dữ liệu',
  ALREADY_EXISTS: 'Dữ liệu đã tồn tại',
  UNAUTHORIZED: 'Không có quyền truy cập',
  FORBIDDEN: 'Bị cấm truy cập',
  SERVER_ERROR: 'Lỗi máy chủ nội bộ',
  DATABASE_ERROR: 'Lỗi cơ sở dữ liệu',

  // Specific messages
  LOGIN_SUCCESS: 'Đăng nhập thành công',
  LOGIN_FAILED: 'Tên đăng nhập hoặc mật khẩu không đúng',
  LOGOUT_SUCCESS: 'Đăng xuất thành công',
  PASSWORD_CHANGED: 'Đổi mật khẩu thành công',
  ACCOUNT_LOCKED: 'Tài khoản đã bị khóa',
  TOKEN_EXPIRED: 'Token đã hết hạn',
  TOKEN_INVALID: 'Token không hợp lệ'
};

module.exports = {
  ApiResponse,
  PaginatedResponse,
  responseWrapper,
  addResponseHelpers,
  createPaginationInfo,
  formatResponseData,
  MESSAGES
};