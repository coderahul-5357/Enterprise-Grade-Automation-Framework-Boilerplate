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
