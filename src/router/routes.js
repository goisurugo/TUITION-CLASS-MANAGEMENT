const routes = [
  {
    path: '/',
    component: () => import('pages/LandingPage.vue'),
  },

  {
    path: '/dashboard',
    component: () => import('layouts/MainLayout.vue'),
    meta: { requiresAuth: true },
    children: [
      { path: '', component: () => import('pages/IndexPage.vue') },
      { path: 'students', component: () => import('pages/StudentsPage.vue') },
      { path: 'courses', component: () => import('pages/CoursesPage.vue') },
      { path: 'attendance', component: () => import('pages/AttendancePage.vue') },
      { path: 'payments', component: () => import('pages/PaymentsPage.vue') },
      { path: 'settings', component: () => import('pages/SettingsPage.vue') },
    ],
  },

  {
    path: '/login',
    component: () => import('pages/LoginPage.vue'),
  },

  {
    path: '/register',
    component: () => import('layouts/AuthLayout.vue'),
    children: [{ path: '', component: () => import('pages/RegisterPage.vue') }],
  },

  {
    path: '/register-interest',
    component: () => import('pages/RegisterInterestPage.vue'),
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
  },
]

export default routes
