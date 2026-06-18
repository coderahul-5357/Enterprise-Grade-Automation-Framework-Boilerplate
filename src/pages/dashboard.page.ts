import { Page, Locator } from '@playwright/test';
import { BasePage } from './base.page';

export class DashboardPage extends BasePage {
  readonly globalFeedTab: Locator;
  readonly articlePreview: Locator;

  constructor(page: Page) {
    super(page);
    this.globalFeedTab = page.getByRole('button', { name: 'Global Feed' });
    this.articlePreview = page.locator('.article-preview');
  }

  async loadGlobalFeed() {
    await this.logAction('Clicking on the Global Feed Tab.');
    await this.globalFeedTab.click();
  }
}
