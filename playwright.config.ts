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
