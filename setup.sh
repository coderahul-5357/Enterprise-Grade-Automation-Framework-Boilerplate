#!/bin/bash

echo "🚀 Starting Enterprise Playwright Framework Boilerplate Setup..."

# 1. Initialize Directories
echo "📂 Creating directory architecture..."
mkdir -p .github/workflows
mkdir -p src/fixtures
mkdir -p src/pages
mkdir -p src/specs/auth
mkdir -p src/specs/e2e
mkdir -p src/utils
mkdir -p .auth

# 2. Write package.json
echo "📦 Generating package.json..."
cat << 'EOF' > package.json
{
  "name": "playwright-enterprise-boilerplate",
  "version": "1.0.0",
  "description": "Enterprise-grade automation framework using Playwright and TypeScript",
  "main": "index.js",
  "scripts": {
    "test": "playwright test",
    "test:ui": "playwright test --ui",
    "test:chromium": "playwright test --project=chromium"
  },
  "devDependencies": {
    "@playwright/test": "^1.49.0",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0"
  }
}
EOF

# 3. Write tsconfig.json
echo "⚙️ Generating tsconfig.json..."
cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "CommonJS",
    "moduleResolution": "node",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist"
  },
  "include": ["src/**/*", "playwright.config.ts"]
}
EOF

# 4. Write .gitignore
echo "🙈 Generating .gitignore..."
cat << 'EOF' > .gitignore
node_modules/
test-results/
playwright-report/
blob-report/
playwright/.local-browsers/
dist/
.auth/
.env
EOF

# 5. Write playwright.config.ts
echo "🛠️ Generating playwright.config.ts..."
cat << 'EOF' > playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './src/specs',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 2 : undefined,
  reporter: process.env.CI ? 'dot' : 'html',
  
  use: {
    baseURL: 'https://demo.realworld.show', 
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    testIdAttribute: 'data-testid',
  },

  projects: [
    {
      name: 'setup',
      testMatch: /global\.setup\.ts/,
    },
    {
      name: 'chromium',
      use: { 
        ...devices['Desktop Chrome'],
        // storageState: '.auth/user.json', // Uncomment once real backend credentials are used
      },
      // dependencies: ['setup'], // Uncomment when ready to chain global setup
    },
  ],
});
EOF

# 6. Write src/utils/api-client.ts
echo "🔌 Generating API Client Layer..."
cat << 'EOF' > src/utils/api-client.ts
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
EOF

# 7. Write src/pages/base.page.ts
echo "📄 Generating Base Page abstraction Layer..."
cat << 'EOF' > src/pages/base.page.ts
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
EOF

# 8. Write src/pages/dashboard.page.ts
echo "📄 Generating Dashboard Page Object Model..."
cat << 'EOF' > src/pages/dashboard.page.ts
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
EOF

# 9. Write src/fixtures/page-objects.fixture.ts
echo "💉 Generating Dependency Injection Fixture Layer..."
cat << 'EOF' > src/fixtures/page-objects.fixture.ts
import { test as base } from '@playwright/test';
import { DashboardPage } from '../pages/dashboard.page';
import { ApiClient } from '../utils/api-client';

type MyFixtures = {
  dashboardPage: DashboardPage;
  apiClient: ApiClient;
};

export const test = base.extend<MyFixtures>({
  dashboardPage: async ({ page }, use) => {
    const dashboardPage = new DashboardPage(page);
    await use(dashboardPage);
  },
  apiClient: async ({ request }, use) => {
    const apiClient = new ApiClient(request);
    await use(apiClient);
  },
});

export { expect } from '@playwright/test';
EOF

# 10. Write src/specs/auth/global.setup.ts
echo "🔑 Generating Global Setup Orchestration Script..."
cat << 'EOF' > src/specs/auth/global.setup.ts
import { test as setup, expect } from '@playwright/test';

const authFile = '.auth/user.json';

setup('authenticate user via API', async ({ request }) => {
  const response = await request.post('https://api.realworld.io/api/users/login', {
    data: {
      user: {
        email: 'playwright_enterprise_demo@mail.com',
        password: 'Password123!'
      }
    }
  });

  expect(response.status()).toBe(200);
  await request.storageState({ path: authFile });
});
EOF

# 11. Write src/specs/e2e/dashboard.spec.ts
echo "🧪 Generating Functional E2E Spec (With Mocking Examples)..."
cat << 'EOF' > src/specs/e2e/dashboard.spec.ts
import { test, expect } from '../../fixtures/page-objects.fixture';

test.describe('Dashboard Functional Validations', () => {
  
  test.beforeEach(async ({ dashboardPage }) => {
    await dashboardPage.navigateTo('/');
  });

  test('should handle API mocking validation for an empty feed state', async ({ page, dashboardPage }) => {
    await page.route('**/api/articles**', async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({ articles: [], articlesCount: 0 }),
      });
    });

    await dashboardPage.navigateTo('/');
    await dashboardPage.loadGlobalFeed();

    const noArticlesText = page.getByText('No articles are here... yet.');
    await expect(noArticlesText).toBeVisible();
  });
});
EOF

# 12. Write GitHub Actions Workflow
echo "🏁 Generating CI/CD GitHub Actions Pipeline Workflow..."
cat << 'EOF' > .github/workflows/playwright.yml
name: Playwright Tests
on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]
jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: lts/*
        cache: 'npm'
    - name: Install dependencies
      run: npm ci
    - name: Install Playwright Browsers
      run: npx playwright install --with-deps
    - name: Run Playwright tests
      run: npm run test
    - uses: actions/upload-artifact@v4
      if: ${{ !cancelled() }}
      with:
        name: playwright-report
        path: playwright-report/
        retention-days: 30
EOF

# 13. Install Dependencies
echo "⚡ Installing ecosystem packages and type systems locally..."
npm install

echo "🌐 Syncing Playwright managed browser binaries..."
npx playwright install

echo "✅ Framework scaffold complete! Run 'npm run test:ui' to see it operational."