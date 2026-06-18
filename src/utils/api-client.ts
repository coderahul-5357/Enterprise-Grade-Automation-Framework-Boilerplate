import { APIRequestContext, APIResponse } from '@playwright/test';

export class ApiClient {
  private request: APIRequestContext;

  constructor(request: APIRequestContext) {
    this.request = request;
  }

  async post(endpoint: string, data: object, token?: string): Promise<APIResponse> {
    const headers: Record<string, string> = { 'Content-Type': 'application/json' };
    if (token) headers['Authorization'] = `Token ${token}`;
    return await this.request.post(endpoint, { data, headers });
  }

  async get(endpoint: string, token?: string): Promise<APIResponse> {
    const headers: Record<string, string> = token ? { 'Authorization': `Token ${token}` } : {};
    return await this.request.get(endpoint, { headers });
  }
}
