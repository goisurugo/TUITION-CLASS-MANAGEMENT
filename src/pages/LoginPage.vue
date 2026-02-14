<template>
  <q-layout view="lHh Lpr lFf">
    <q-page-container>
      <div class="row window-height justify-center items-center bg-login relative-position">
        <q-btn
          to="/"
          color="white"
          icon="arrow_back"
          label="Back to Home"
          flat
          rounded
          class="absolute-top-left q-ma-lg"
          no-caps
        />
        <div class="col-11 col-sm-8 col-md-5 col-lg-4">
          <q-card class="shadow-24 rounded-borders overflow-hidden">
            <q-card-section class="bg-primary text-white text-center q-pa-lg">
              <div class="text-h4 text-weight-bolder q-mb-xs">
                Class<span class="text-secondary">Master</span>
              </div>
              <div class="text-subtitle2 text-purple-2">by Isuru Education Systems</div>
            </q-card-section>

            <q-card-section class="q-pa-xl">
              <q-form @submit="handleLogin" class="q-gutter-md">
                <div class="text-h6 text-center text-grey-8 q-mb-md">Owner Login</div>

                <q-input
                  v-model="email"
                  label="Email Address"
                  outlined
                  rounded
                  dense
                  type="email"
                  lazy-rules
                  :rules="[(val) => !!val || 'Email is required']"
                >
                  <template v-slot:prepend>
                    <q-icon name="email" color="primary" />
                  </template>
                </q-input>

                <q-input
                  v-model="password"
                  label="Password"
                  outlined
                  rounded
                  dense
                  :type="showPassword ? 'text' : 'password'"
                  lazy-rules
                  :rules="[(val) => !!val || 'Password is required']"
                >
                  <template v-slot:prepend>
                    <q-icon name="lock" color="primary" />
                  </template>
                  <template v-slot:append>
                    <q-icon
                      :name="showPassword ? 'visibility' : 'visibility_off'"
                      class="cursor-pointer"
                      @click="showPassword = !showPassword"
                    />
                  </template>
                </q-input>

                <div class="row justify-between items-center q-mb-md">
                  <q-checkbox v-model="rememberMe" label="Remember me" size="sm" color="primary" />
                  <a
                    href="#"
                    class="text-primary text-weight-bold"
                    style="text-decoration: none; font-size: 0.9em"
                    >Forgot Password?</a
                  >
                </div>

                <q-btn
                  label="Login to Dashboard"
                  type="submit"
                  color="primary"
                  rounded
                  unelevated
                  class="full-width q-py-sm text-weight-bold shadow-3"
                  size="lg"
                  :loading="loading"
                />
              </q-form>
            </q-card-section>

            <q-card-section class="text-center q-pb-lg">
              <div class="text-grey-6 text-caption">Powered by Isuru Education Systems</div>
            </q-card-section>
          </q-card>
        </div>
      </div>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { supabase } from 'src/boot/supabase'

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const rememberMe = ref(false)
const loading = ref(false)
const router = useRouter()
const $q = useQuasar()

async function handleLogin() {
  loading.value = true
  try {
    const { error } = await supabase.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })

    if (error) throw error

    $q.notify({
      type: 'positive',
      message: 'Welcome back! Login successful.',
      position: 'top',
    })

    router.push('/dashboard')
  } catch (err) {
    $q.notify({
      type: 'negative',
      message: err.message || 'Login failed. Please check your credentials.',
      position: 'top',
    })
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.bg-login {
  background: radial-gradient(circle at top right, #352263 0%, #1f1d2b 100%);
}
</style>
