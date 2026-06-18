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
