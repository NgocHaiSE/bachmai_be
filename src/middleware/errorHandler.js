// Error handler middleware

// Xử lý lỗi Prisma
const handlePrismaError = (error) => {
  let message = 'Lỗi cơ sở dữ liệu';
  let statusCode = 500;

  switch (error.code) {
    case 'P2002':
      message = 'Dữ liệu đã tồn tại (trùng lặp)';
      statusCode = 409;
      break;
    case 'P2025':
      message = 'Không tìm thấy bản ghi';
      statusCode = 404;
      break;
    case 'P2003':
      message = 'Khóa ngoại không hợp lệ';
      statusCode = 400;
      break;
    case 'P2014':
      message = 'Dữ liệu vi phạm ràng buộc';
      statusCode = 400;
      break;
    default:
      message = error.message || 'Lỗi cơ sở dữ liệu';
      break;
  }

  return { message, statusCode };
};

// Xử lý lỗi SQL Server
const handleSqlServerError = (error) => {
  let message = 'Lỗi SQL Server';
  let statusCode = 500;

  // Lỗi từ stored procedures
  if (error.message.includes('THROW')) {
    // Lấy message từ THROW statement
    const throwMatch = error.message.match(/Msg \d+.*?'([^']+)'/);
    if (throwMatch) {
      message = throwMatch[1];
      statusCode = 400;
    }
  }

  // Lỗi constraint
  if (error.message.includes('FOREIGN KEY constraint')) {
    message = 'Khóa ngoại không hợp lệ';
    statusCode = 400;
  }

  if (error.message.includes('PRIMARY KEY constraint')) {
    message = 'Khóa chính đã tồn tại';
    statusCode = 409;
  }

  if (error.message.includes('UNIQUE constraint')) {
    message = 'Dữ liệu đã tồn tại';
    statusCode = 409;
  }

  // Lỗi kết nối
  if (error.message.includes('Connection')) {
    message = 'Lỗi kết nối cơ sở dữ liệu';
    statusCode = 503;
  }

  return { message, statusCode };
};

// Xử lý lỗi validation
const handleValidationError = (error) => {
  return {
    message: 'Dữ liệu không hợp lệ',
    statusCode: 400,
    details: error.errors || []
  };
};

// Main error handler middleware
const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;

  // Log lỗi
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    body: req.body,
    query: req.query,
    params: req.params,
    timestamp: new Date().toISOString()
  });

  let response = {
    success: false,
    message: 'Có lỗi xảy ra trên server',
    timestamp: new Date().toISOString()
  };

  let statusCode = 500;

  // Xử lý các loại lỗi khác nhau
  if (err.name === 'PrismaClientKnownRequestError') {
    const { message, statusCode: code } = handlePrismaError(err);
    response.message = message;
    statusCode = code;
  } else if (err.name === 'PrismaClientValidationError') {
    response.message = 'Dữ liệu không hợp lệ';
    statusCode = 400;
  } else if (err.message && err.message.includes('MSSQL')) {
    const { message, statusCode: code } = handleSqlServerError(err);
    response.message = message;
    statusCode = code;
  } else if (err.name === 'ValidationError') {
    const { message, statusCode: code, details } = handleValidationError(err);
    response.message = message;
    response.errors = details;
    statusCode = code;
  } else if (err.name === 'CastError') {
    response.message = 'Định dạng ID không hợp lệ';
    statusCode = 400;
  } else if (err.name === 'JsonWebTokenError') {
    response.message = 'Token không hợp lệ';
    statusCode = 401;
  } else if (err.name === 'TokenExpiredError') {
    response.message = 'Token đã hết hạn';
    statusCode = 401;
  } else if (err.statusCode) {
    // Lỗi đã được định nghĩa status code
    statusCode = err.statusCode;
    response.message = err.message;
  }

  // Thêm thông tin debug trong development
  if (process.env.NODE_ENV === 'development') {
    response.error = {
      name: err.name,
      message: err.message,
      stack: err.stack
    };
  }

  res.status(statusCode).json(response);
};

// Async error handler wrapper
const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};

// 404 handler
const notFound = (req, res, next) => {
  const error = new Error(`Không tìm thấy endpoint: ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
};

// Rate limiting error
const rateLimitHandler = (req, res) => {
  res.status(429).json({
    success: false,
    message: 'Quá nhiều yêu cầu, vui lòng thử lại sau',
    retryAfter: req.rateLimit?.resetTime
  });
};

module.exports = {
  errorHandler,
  asyncHandler,
  notFound,
  rateLimitHandler,
  handlePrismaError,
  handleSqlServerError,
  handleValidationError
};