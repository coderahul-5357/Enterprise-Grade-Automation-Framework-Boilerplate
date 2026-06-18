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
