const fs = require('fs');
const path = require('path');

// Tạo thư mục logs nếu chưa tồn tại
const logsDir = path.join(process.cwd(), 'logs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

// Log levels
const LOG_LEVELS = {
  ERROR: 0,
  WARN: 1,
  INFO: 2,
  DEBUG: 3
};

// Colors cho console
const COLORS = {
  ERROR: '\x1b[31m', // Red
  WARN: '\x1b[33m',  // Yellow
  INFO: '\x1b[36m',  // Cyan
  DEBUG: '\x1b[37m', // White
  RESET: '\x1b[0m'   // Reset
};

class Logger {
  constructor(options = {}) {
    this.level = LOG_LEVELS[options.level?.toUpperCase()] ?? LOG_LEVELS.INFO;
    this.enableConsole = options.enableConsole ?? true;
    this.enableFile = options.enableFile ?? true;
    this.maxFileSize = options.maxFileSize ?? 10 * 1024 * 1024; // 10MB
    this.maxFiles = options.maxFiles ?? 5;
  }

  formatMessage(level, message, metadata = {}) {
    const timestamp = new Date().toISOString();
    const meta = Object.keys(metadata).length > 0 ? JSON.stringify(metadata) : '';
    
    return {
      timestamp,
      level,
      message,
      metadata,
      formatted: `[${timestamp}] [${level}] ${message} ${meta}`.trim()
    };
  }

  shouldLog(level) {
    return LOG_LEVELS[level] <= this.level;
  }

  writeToFile(level, formattedMessage) {
    if (!this.enableFile) return;

    const filename = path.join(logsDir, `${level.toLowerCase()}.log`);
    const logEntry = formattedMessage + '\n';

    try {
      // Kiểm tra kích thước file
      if (fs.existsSync(filename)) {
        const stats = fs.statSync(filename);
        if (stats.size > this.maxFileSize) {
          this.rotateLogFile(filename, level.toLowerCase());
        }
      }

      fs.appendFileSync(filename, logEntry);
    } catch (error) {
      console.error('Error writing to log file:', error);
    }
  }

  rotateLogFile(filename, level) {
    try {
      // Rotate existing files
      for (let i = this.maxFiles - 1; i > 0; i--) {
        const currentFile = `${filename}.${i}`;
        const nextFile = `${filename}.${i + 1}`;
        
        if (fs.existsSync(currentFile)) {
          if (i === this.maxFiles - 1) {
            fs.unlinkSync(currentFile); // Delete oldest
          } else {
            fs.renameSync(currentFile, nextFile);
          }
        }
      }

      // Move current file to .1
      if (fs.existsSync(filename)) {
        fs.renameSync(filename, `${filename}.1`);
      }
    } catch (error) {
      console.error('Error rotating log file:', error);
    }
  }

  writeToConsole(level, message, metadata) {
    if (!this.enableConsole) return;

    const color = COLORS[level] || COLORS.INFO;
    const timestamp = new Date().toISOString();
    const meta = Object.keys(metadata).length > 0 ? 
      `\n${JSON.stringify(metadata, null, 2)}` : '';

    console.log(`${color}[${timestamp}] [${level}] ${message}${COLORS.RESET}${meta}`);
  }

  log(level, message, metadata = {}) {
    if (!this.shouldLog(level)) return;

    const formatted = this.formatMessage(level, message, metadata);
    
    this.writeToConsole(level, message, metadata);
    this.writeToFile(level, formatted.formatted);
  }

  error(message, metadata = {}) {
    this.log('ERROR', message, metadata);
  }

  warn(message, metadata = {}) {
    this.log('WARN', message, metadata);
  }

  info(message, metadata = {}) {
    this.log('INFO', message, metadata);
  }

  debug(message, metadata = {}) {
    this.log('DEBUG', message, metadata);
  }

  // Log các hoạt động của API
  apiRequest(req) {
    this.info('API Request', {
      method: req.method,
      url: req.url,
      ip: req.ip || req.connection.remoteAddress,
      userAgent: req.get('User-Agent'),
      userId: req.userId || 'anonymous',
      body: this.sanitizeBody(req.body),
      query: req.query,
      params: req.params
    });
  }

  apiResponse(req, res, responseTime, statusCode) {
    const level = statusCode >= 400 ? 'WARN' : 'INFO';
    this.log(level, 'API Response', {
      method: req.method,
      url: req.url,
      statusCode,
      responseTime: `${responseTime}ms`,
      userId: req.userId || 'anonymous'
    });
  }

  apiError(req, error, statusCode = 500) {
    this.error('API Error', {
      method: req.method,
      url: req.url,
      statusCode,
      error: {
        name: error.name,
        message: error.message,
        stack: error.stack
      },
      userId: req.userId || 'anonymous',
      body: this.sanitizeBody(req.body),
      query: req.query,
      params: req.params
    });
  }

  // Database operations
  dbQuery(query, params = {}, duration) {
    this.debug('Database Query', {
      query: query.substring(0, 200) + (query.length > 200 ? '...' : ''),
      params,
      duration: duration ? `${duration}ms` : undefined
    });
  }

  dbError(query, error, params = {}) {
    this.error('Database Error', {
      query: query.substring(0, 200) + (query.length > 200 ? '...' : ''),
      params,
      error: {
        name: error.name,
        message: error.message,
        code: error.code
      }
    });
  }

  // Business logic logging
  businessOperation(operation, userId, details = {}) {
    this.info(`Business Operation: ${operation}`, {
      userId,
      operation,
      ...details
    });
  }

  sanitizeBody(body) {
    if (!body || typeof body !== 'object') return body;

    const sanitized = { ...body };
    
    // Ẩn các trường nhạy cảm
    const sensitiveFields = ['password', 'matKhau', 'token', 'secret'];
    sensitiveFields.forEach(field => {
      if (sanitized[field]) {
        sanitized[field] = '***';
      }
    });

    return sanitized;
  }

  // Cleanup old logs
  cleanup() {
    const maxAge = 30 * 24 * 60 * 60 * 1000; // 30 days
    const now = Date.now();

    try {
      const files = fs.readdirSync(logsDir);
      
      files.forEach(file => {
        const filePath = path.join(logsDir, file);
        const stats = fs.statSync(filePath);
        
        if (now - stats.mtime.getTime() > maxAge) {
          fs.unlinkSync(filePath);
          this.info(`Cleaned up old log file: ${file}`);
        }
      });
    } catch (error) {
      this.error('Error cleaning up logs', { error: error.message });
    }
  }
}

// Middleware để log requests
const requestLogger = (logger) => (req, res, next) => {
  const startTime = Date.now();
  
  // Log request
  logger.apiRequest(req);
  
  // Override res.json để log response
  const originalJson = res.json;
  res.json = function(data) {
    const responseTime = Date.now() - startTime;
    logger.apiResponse(req, res, responseTime, res.statusCode);
    return originalJson.call(this, data);
  };

  next();
};

// Create default logger instance
const defaultLogger = new Logger({
  level: process.env.LOG_LEVEL || 'INFO',
  enableConsole: process.env.NODE_ENV !== 'production',
  enableFile: true
});

// Export default instance and class
module.exports = {
  Logger,
  logger: defaultLogger,
  requestLogger,
  LOG_LEVELS
};