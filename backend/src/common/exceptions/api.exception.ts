// Custom exception for API errors
export class ApiException extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public errors?: any,
  ) {
    super(message);
    this.name = 'ApiException';
  }
}

export class ValidationException extends ApiException {
  constructor(errors: any) {
    super(400, 'Validation failed', errors);
    this.name = 'ValidationException';
  }
}

export class BadRequestException extends ApiException {
  constructor(message: string = 'Bad request') {
    super(400, message);
    this.name = 'BadRequestException';
  }
}

export class UnauthorizedException extends ApiException {
  constructor(message: string = 'Unauthorized') {
    super(401, message);
    this.name = 'UnauthorizedException';
  }
}

export class ForbiddenException extends ApiException {
  constructor(message: string = 'Forbidden') {
    super(403, message);
    this.name = 'ForbiddenException';
  }
}

export class NotFoundException extends ApiException {
  constructor(entity: string) {
    super(404, `${entity} not found`);
    this.name = 'NotFoundException';
  }
}

export class ConflictException extends ApiException {
  constructor(message: string) {
    super(409, message);
    this.name = 'ConflictException';
  }
}

export class InternalServerException extends ApiException {
  constructor(message: string = 'Internal server error') {
    super(500, message);
    this.name = 'InternalServerException';
  }
}
