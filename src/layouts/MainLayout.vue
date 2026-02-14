<template>
  <q-layout view="lHh Lpr lFf" class="bg-grey-1 font-body">
    <q-header class="bg-white text-dark shadow-1 header-blur">
      <q-toolbar class="q-py-sm">
        <q-btn
          flat
          dense
          round
          icon="menu"
          aria-label="Menu"
          color="primary"
          @click="toggleLeftDrawer"
        />

        <q-toolbar-title class="text-weight-bolder text-primary">
          <q-icon name="school" size="md" class="q-mr-sm" />
          Class<span class="text-secondary">Master</span>
        </q-toolbar-title>

        <q-space />

        <div class="q-gutter-sm row items-center no-wrap">
          <q-input
            dense
            outlined
            rounded
            placeholder="Search..."
            v-model="search"
            class="q-mr-md gt-xs search-input"
            bg-color="grey-1"
          >
            <template v-slot:prepend>
              <q-icon name="search" />
            </template>
          </q-input>

          <q-btn round dense flat color="grey-6" icon="notifications_none">
            <q-badge color="red" floating rounded dot />
            <q-tooltip>Notifications</q-tooltip>
          </q-btn>

          <q-btn round flat class="q-ml-sm">
            <q-avatar size="36px" class="shadow-2">
              <img :src="userAvatar || 'https://cdn.quasar.dev/img/boy-avatar.png'" />
            </q-avatar>
            <q-menu>
              <q-list style="min-width: 150px">
                <q-item clickable v-close-popup to="/dashboard/settings">
                  <q-item-section>Profile</q-item-section>
                </q-item>
                <q-item clickable v-close-popup to="/dashboard/settings">
                  <q-item-section>Settings</q-item-section>
                </q-item>
                <q-separator />
                <q-item clickable v-close-popup @click="handleLogout">
                  <q-item-section class="text-red">Logout</q-item-section>
                </q-item>
              </q-list>
            </q-menu>
          </q-btn>
        </div>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      :width="260"
      class="bg-primary text-white drawer-gradient"
    >
      <q-scroll-area class="fit">
        <div class="q-pa-lg text-center">
          <div class="text-h5 text-weight-bold tracking-wide">ClassMaster</div>
          <div class="text-caption text-purple-2">by Isuru Education Systems</div>
        </div>

        <q-list padding class="q-px-md">
          <q-item-label header class="text-purple-2 text-weight-bold text-uppercase q-mb-sm"
            >Menu</q-item-label
          >

          <template v-for="item in menuItems" :key="item.path">
            <q-item
              clickable
              v-ripple
              :to="item.path"
              active-class="active-menu-item"
              class="rounded-borders q-mb-xs transition-fast"
              :exact="item.path === '/dashboard'"
            >
              <q-item-section avatar>
                <q-icon :name="item.icon" />
              </q-item-section>
              <q-item-section class="text-weight-medium">
                {{ item.label }}
              </q-item-section>
            </q-item>
          </template>
        </q-list>

        <div class="absolute-bottom q-pa-md">
          <!-- Digital Clock -->
          <div class="text-center q-mb-md">
            <div class="text-h4 text-weight-bolder text-white font-mono">{{ currentTime }}</div>
            <div class="text-caption text-purple-2 text-uppercase text-weight-bold">
              {{ currentDate }}
            </div>
          </div>

          <q-card class="bg-white-10 text-white rounded-borders q-pa-sm" flat>
            <div class="row items-center no-wrap">
              <q-icon name="support_agent" size="sm" class="q-mr-sm" />
              <div class="text-caption">Need Help?</div>
            </div>
          </q-card>
        </div>
      </q-scroll-area>
    </q-drawer>

    <q-footer class="bg-primary text-white text-center q-pa-sm shadow-up-2">
      <div class="text-subtitle2">
        &copy; 2026 ClassMaster LMS. Developed by
        <span class="text-secondary text-weight-bold">Isuru Buddhika</span>
      </div>
    </q-footer>

    <q-page-container>
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar, date } from 'quasar'
import { supabase } from 'src/boot/supabase'

const leftDrawerOpen = ref(false)
const search = ref('')
const router = useRouter()
const $q = useQuasar()
const userAvatar = ref('')

const menuItems = [
  { label: 'Dashboard', icon: 'dashboard', path: '/dashboard' },
  { label: 'Students', icon: 'people_alt', path: '/dashboard/students' },
  { label: 'Courses', icon: 'library_books', path: '/dashboard/courses' },
  { label: 'Attendance', icon: 'access_time', path: '/dashboard/attendance' },
  { label: 'Payments', icon: 'payments', path: '/dashboard/payments' },
  { label: 'Settings', icon: 'settings', path: '/dashboard/settings' },
]

const currentTime = ref('')
const currentDate = ref('')
let timer

const updateTime = () => {
  const now = Date.now()
  currentTime.value = date.formatDate(now, 'hh:mm:ss A')
  currentDate.value = date.formatDate(now, 'dddd, D MMMM')
}

function toggleLeftDrawer() {
  leftDrawerOpen.value = !leftDrawerOpen.value
}

async function handleLogout() {
  try {
    const { error } = await supabase.auth.signOut()
    if (error) throw error

    $q.notify({
      color: 'positive',
      message: 'Logged out successfully',
      icon: 'check',
    })

    router.push('/login')
  } catch (error) {
    $q.notify({
      color: 'negative',
      message: 'Error logging out: ' + error.message,
      icon: 'error',
    })
  }
}

onMounted(async () => {
  updateTime()
  timer = setInterval(updateTime, 1000)

  const {
    data: { user },
  } = await supabase.auth.getUser()
  if (user) {
    userAvatar.value = user.user_metadata?.avatar_url || ''
  }

  supabase.auth.onAuthStateChange((event, session) => {
    if (session?.user) {
      userAvatar.value = session.user.user_metadata?.avatar_url || ''
    } else {
      userAvatar.value = ''
    }
  })
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>

<style lang="scss" scoped>
.font-body {
  font-family: 'Roboto', 'Helvetica Neue', Helvetica, Arial, sans-serif;
}

.header-blur {
  backdrop-filter: blur(10px);
  background-color: rgba(255, 255, 255, 0.9) !important;
}

.drawer-gradient {
  background: linear-gradient(145deg, $primary 0%, darken($primary, 15%) 100%);
}

.bg-white-10 {
  background: rgba(255, 255, 255, 0.1);
}

.active-menu-item {
  background: $secondary;
  color: $dark;
  font-weight: 700;
  box-shadow: 0 4px 15px rgba(255, 207, 92, 0.4);

  .q-icon {
    color: $dark;
  }
}

.search-input {
  width: 300px;
  .q-field__control {
    border-radius: 12px;
  }
}

.transition-fast {
  transition: all 0.3s ease;
  &:hover {
    transform: translateX(5px);
  }
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.font-mono {
  font-family: 'Courier New', Courier, monospace;
  letter-spacing: 0.05em;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
