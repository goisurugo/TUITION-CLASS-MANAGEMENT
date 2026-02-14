<template>
  <q-page class="flex flex-center bg-grey-2">
    <q-card class="auth-card q-pa-lg shadow-2 rounded-borders">
      <q-card-section class="text-center">
        <div class="text-h4 text-weight-bold text-black q-mb-md">Create Account</div>
        <div class="text-grey-7">Join our LMS platform today</div>
      </q-card-section>

      <q-card-section>
        <q-form @submit="handleRegister" class="q-gutter-md">
          <q-input
            v-model="name"
            label="Full Name"
            type="text"
            dense
            outlined
            bg-color="white"
            color="primary"
            class="text-black"
            lazy-rules
            :rules="[(val) => (val && val.length > 0) || 'Please enter your full name']"
          />

          <q-input
            v-model="email"
            label="Email"
            type="email"
            dense
            outlined
            bg-color="white"
            color="primary"
            class="text-black"
            lazy-rules
            :rules="[(val) => (val && val.length > 0) || 'Please enter your email']"
          />

          <q-input
            v-model="password"
            label="Password"
            type="password"
            dense
            outlined
            bg-color="white"
            color="primary"
            class="text-black"
            lazy-rules
            :rules="[(val) => (val && val.length > 6) || 'Password must be at least 6 characters']"
          />

          <q-input
            v-model="confirmPassword"
            label="Confirm Password"
            type="password"
            dense
            outlined
            bg-color="white"
            color="primary"
            class="text-black"
            lazy-rules
            :rules="[(val) => val === password || 'Passwords do not match']"
          />

          <div class="q-mt-lg">
            <q-btn
              label="Register"
              type="submit"
              color="black"
              class="full-width q-py-sm text-white"
              unelevated
              :loading="loading"
            />
          </div>
        </q-form>
      </q-card-section>

      <q-card-section class="text-center q-mt-sm">
        <div class="text-grey-8">
          Already have an account?
          <router-link
            to="/login"
            class="text-primary text-weight-bold"
            style="text-decoration: none"
            >Login</router-link
          >
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from 'src/boot/supabase'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const router = useRouter()

const name = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const loading = ref(false)

const handleRegister = async () => {
  loading.value = true
  try {
    const { error } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
      options: {
        data: {
          full_name: name.value,
        },
      },
    })

    if (error) {
      $q.notify({
        color: 'negative',
        message: error.message,
        icon: 'error',
      })
    } else {
      $q.notify({
        color: 'positive',
        message: 'Registration successful! Please verify your email.',
        icon: 'check',
      })
      router.push('/login')
    }
  } catch (err) {
    console.error(err)
    $q.notify({
      color: 'negative',
      message: 'An unexpected error occurred',
      icon: 'error',
    })
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-card {
  width: 100%;
  max-width: 400px;
  border-radius: 12px;
}
</style>
