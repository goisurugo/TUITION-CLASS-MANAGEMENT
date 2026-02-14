<template>
  <q-page class="q-pa-md bg-grey-1">
    <div class="row q-mb-md items-center justify-between">
      <div>
        <h4 class="text-h4 text-weight-bolder q-my-none text-dark">
          System <span class="text-primary">Settings</span>
        </h4>
        <div class="text-grey-7 text-subtitle1">Manage your account and preferences</div>
      </div>
    </div>

    <div class="row q-col-gutter-md">
      <!-- Sidebar / Tabs -->
      <div class="col-12 col-md-3">
        <q-card class="shadow-2 rounded-borders">
          <q-list separator>
            <q-item
              clickable
              v-ripple
              :active="tab === 'profile'"
              @click="tab = 'profile'"
              active-class="bg-purple-1 text-primary"
            >
              <q-item-section avatar>
                <q-icon name="person" />
              </q-item-section>
              <q-item-section>Profile Settings</q-item-section>
              <q-item-section side>
                <q-icon name="chevron_right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              v-ripple
              :active="tab === 'security'"
              @click="tab = 'security'"
              active-class="bg-purple-1 text-primary"
            >
              <q-item-section avatar>
                <q-icon name="security" />
              </q-item-section>
              <q-item-section>Security</q-item-section>
              <q-item-section side>
                <q-icon name="chevron_right" />
              </q-item-section>
            </q-item>

            <q-item
              clickable
              v-ripple
              :active="tab === 'notifications'"
              @click="tab = 'notifications'"
              active-class="bg-purple-1 text-primary"
            >
              <q-item-section avatar>
                <q-icon name="notifications" />
              </q-item-section>
              <q-item-section>Notifications</q-item-section>
              <q-item-section side>
                <q-icon name="chevron_right" />
              </q-item-section>
            </q-item>
          </q-list>
        </q-card>
      </div>

      <!-- Content Area -->
      <div class="col-12 col-md-9">
        <q-tab-panels v-model="tab" animated class="bg-transparent q-pa-none">
          <!-- Profile Panel -->
          <q-tab-panel name="profile" class="q-pa-none">
            <q-card class="shadow-2 rounded-borders">
              <q-card-section>
                <div class="text-h6 text-weight-bold q-mb-md">Profile Information</div>
                <q-form @submit="updateProfile" class="q-gutter-md">
                  <div class="row q-col-gutter-md">
                    <div class="col-12 flex justify-center q-mb-md">
                      <q-avatar size="100px" class="shadow-3">
                        <img
                          :src="profile.avatar_url || 'https://cdn.quasar.dev/img/boy-avatar.png'"
                        />
                        <q-badge
                          floating
                          color="secondary"
                          rounded
                          class="cursor-pointer"
                          @click="triggerFileSelect"
                        >
                          <q-icon name="edit" size="xs" color="dark" />
                        </q-badge>
                      </q-avatar>
                      <input
                        type="file"
                        ref="fileInput"
                        style="display: none"
                        accept="image/*"
                        @change="uploadAvatar"
                      />
                    </div>
                    <div class="col-12 col-md-6">
                      <q-input
                        v-model="profile.email"
                        label="Email Address"
                        outlined
                        dense
                        readonly
                        hint="Email cannot be changed"
                      />
                    </div>
                    <div class="col-12 col-md-6">
                      <q-input
                        v-model="profile.full_name"
                        label="Full Name"
                        outlined
                        dense
                        :rules="[(val) => !!val || 'Name is required']"
                      />
                    </div>
                    <div class="col-12 col-md-6">
                      <q-input v-model="profile.phone" label="Phone Number" outlined dense />
                    </div>
                    <div class="col-12 col-md-6">
                      <q-input v-model="profile.institute" label="Institute Name" outlined dense />
                    </div>
                  </div>
                  <div class="text-right">
                    <q-btn
                      label="Save Changes"
                      type="submit"
                      color="primary"
                      unelevated
                      :loading="loading"
                    />
                  </div>
                </q-form>
              </q-card-section>
            </q-card>
          </q-tab-panel>

          <!-- Security Panel -->
          <q-tab-panel name="security" class="q-pa-none">
            <q-card class="shadow-2 rounded-borders">
              <q-card-section>
                <div class="text-h6 text-weight-bold q-mb-md">Change Password</div>
                <q-form @submit="updatePassword" class="q-gutter-md">
                  <q-input
                    v-model="security.password"
                    label="New Password"
                    type="password"
                    outlined
                    dense
                    :rules="[(val) => val.length >= 6 || 'Password must be at least 6 characters']"
                  />
                  <q-input
                    v-model="security.confirmPassword"
                    label="Confirm New Password"
                    type="password"
                    outlined
                    dense
                    :rules="[(val) => val === security.password || 'Passwords do not match']"
                  />
                  <div class="text-right">
                    <q-btn
                      label="Update Password"
                      type="submit"
                      color="primary"
                      unelevated
                      :loading="loading"
                    />
                  </div>
                </q-form>
              </q-card-section>
            </q-card>
          </q-tab-panel>

          <!-- Notifications Panel -->
          <q-tab-panel name="notifications" class="q-pa-none">
            <q-card class="shadow-2 rounded-borders">
              <q-card-section>
                <div class="text-h6 text-weight-bold q-mb-md">Notification Preferences</div>
                <q-list>
                  <q-item tag="label" v-ripple>
                    <q-item-section>
                      <q-item-label>Email Notifications</q-item-label>
                      <q-item-label caption>Receive emails about student payments</q-item-label>
                    </q-item-section>
                    <q-item-section side>
                      <q-toggle color="primary" v-model="notifications.email" />
                    </q-item-section>
                  </q-item>

                  <q-item tag="label" v-ripple>
                    <q-item-section>
                      <q-item-label>SMS Alerts</q-item-label>
                      <q-item-label caption>Send SMS when attendance is marked absent</q-item-label>
                    </q-item-section>
                    <q-item-section side>
                      <q-toggle color="primary" v-model="notifications.sms" />
                    </q-item-section>
                  </q-item>

                  <q-item tag="label" v-ripple>
                    <q-item-section>
                      <q-item-label>System Updates</q-item-label>
                      <q-item-label caption>Get notified about system maintenance</q-item-label>
                    </q-item-section>
                    <q-item-section side>
                      <q-toggle color="primary" v-model="notifications.updates" />
                    </q-item-section>
                  </q-item>
                </q-list>
              </q-card-section>
            </q-card>
          </q-tab-panel>
        </q-tab-panels>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from 'src/boot/supabase'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const tab = ref('profile')
const loading = ref(false)
const fileInput = ref(null)
const currentUser = ref(null)

const profile = ref({
  email: '',
  full_name: '',
  phone: '',
  institute: 'Isuru Tutors',
  avatar_url: '',
})

const security = ref({
  password: '',
  confirmPassword: '',
})

const notifications = ref({
  email: true,
  sms: false,
  updates: true,
})

async function fetchUser() {
  try {
    const {
      data: { user },
      error,
    } = await supabase.auth.getUser()
    if (error) throw error

    if (user) {
      currentUser.value = user
      profile.value.email = user.email
      profile.value.full_name = user.user_metadata?.full_name || ''
      profile.value.phone = user.user_metadata?.phone || ''
      profile.value.institute = user.user_metadata?.institute || 'Isuru Tutors'
      profile.value.avatar_url = user.user_metadata?.avatar_url || ''
    }
  } catch (err) {
    console.error('Error fetching user:', err)
  }
}

function triggerFileSelect() {
  fileInput.value.click()
}

async function uploadAvatar(event) {
  const file = event.target.files[0]
  if (!file) return

  loading.value = true
  try {
    if (!currentUser.value) throw new Error('User not loaded')

    const fileExt = file.name.split('.').pop()
    const fileName = `${currentUser.value.id}-${Math.random()}.${fileExt}`
    const filePath = `${fileName}`

    const { error: uploadError } = await supabase.storage.from('avatars').upload(filePath, file)

    if (uploadError) throw uploadError

    const {
      data: { publicUrl },
    } = supabase.storage.from('avatars').getPublicUrl(filePath)

    const { error: updateError } = await supabase.auth.updateUser({
      data: { avatar_url: publicUrl },
    })

    if (updateError) throw updateError

    profile.value.avatar_url = publicUrl
    $q.notify({ type: 'positive', message: 'Avatar updated successfully' })
  } catch (err) {
    console.error('Error uploading avatar:', err)
    $q.notify({ type: 'negative', message: 'Failed to upload avatar: ' + err.message })
  } finally {
    loading.value = false
  }
}

async function updateProfile() {
  loading.value = true
  try {
    const { error } = await supabase.auth.updateUser({
      data: {
        full_name: profile.value.full_name,
        phone: profile.value.phone,
        institute: profile.value.institute,
      },
    })

    if (error) throw error

    $q.notify({ type: 'positive', message: 'Profile updated successfully' })
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Error updating profile' })
    console.error(err)
  } finally {
    loading.value = false
  }
}

async function updatePassword() {
  loading.value = true
  try {
    const { error } = await supabase.auth.updateUser({
      password: security.value.password,
    })

    if (error) throw error

    $q.notify({ type: 'positive', message: 'Password updated successfully' })
    security.value.password = ''
    security.value.confirmPassword = ''
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Error updating password' })
    console.error(err)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchUser()
})
</script>
