import { Page } from '@playwright/test';

export abstract class BasePage {
  protected page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  async navigateTo(path: string): Promise<void> {
    await this.page.goto(path, { waitUntil: 'domcontentloaded' });
  }

  async logAction(message: string): Promise<void> {
    console.log(`[UI ACTION] - ${message}`);
  }
}
