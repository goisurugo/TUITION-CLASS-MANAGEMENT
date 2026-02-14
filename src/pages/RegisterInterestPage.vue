<template>
  <q-layout view="lHh Lpr lFf">
    <q-header class="bg-primary text-white q-py-sm">
      <q-toolbar class="container">
        <q-btn flat dense round icon="arrow_back" color="white" to="/" />
        <q-toolbar-title class="text-weight-bolder">
          <q-icon name="school" size="md" class="q-mr-sm" />
          Class<span class="text-secondary">Master</span>
        </q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-page-container>
      <q-page class="bg-brand flex flex-center">
        <div class="container row items-center justify-between q-pa-md full-width">
          <!-- Left Content -->
          <div class="col-12 col-md-6 q-pr-md-xl text-white">
            <q-badge
              color="secondary"
              text-color="dark"
              label="Next Gen LMS"
              class="q-mb-md text-weight-bold"
            />
            <h1 class="text-h3 text-weight-bolder q-my-sm leading-tight">
              Transform Your <br />
              <span class="text-secondary">Tuition Institute</span>
            </h1>
            <p class="text-h6 text-grey-4 q-mb-lg font-light">
              The professional choice for attendance, payments, and student management. Join the
              elite circle of institutes using ClassMaster.
            </p>

            <div class="row q-gutter-sm q-mb-xl">
              <div class="col-12 row items-center q-mb-sm">
                <q-icon name="verified" color="secondary" size="sm" class="q-mr-sm" />
                <span class="text-subtitle1">Automated Fee Tracking</span>
              </div>
              <div class="col-12 row items-center q-mb-sm">
                <q-icon name="verified" color="secondary" size="sm" class="q-mr-sm" />
                <span class="text-subtitle1">QR Attendance System</span>
              </div>
              <div class="col-12 row items-center">
                <q-icon name="verified" color="secondary" size="sm" class="q-mr-sm" />
                <span class="text-subtitle1">Secure Owner Dashboard</span>
              </div>
            </div>

            <!-- Contact Box -->
            <div class="bg-white-10 rounded-borders q-pa-md border-left-secondary">
              <div class="text-overline text-grey-4">GET YOUR ACCESS</div>
              <div class="row items-center q-mt-xs">
                <q-btn
                  icon="call"
                  color="secondary"
                  text-color="dark"
                  round
                  unelevated
                  class="q-mr-md"
                />
                <div>
                  <div class="text-h6 text-weight-bold">+94 77 787 9729</div>
                  <div class="text-caption text-secondary">Call for instant activation</div>
                </div>
              </div>
            </div>

            <div class="q-mt-md text-caption text-grey-6">
              ClassMaster is a product of
              <span class="text-weight-bold">Isuru Education Systems</span>.
            </div>
          </div>

          <!-- Right Content (Media) -->
          <div class="col-12 col-md-6 q-mt-xl q-mt-md-0">
            <div class="media-container relative-position">
              <div class="absolute-bg-accent"></div>
              <q-card class="overflow-hidden shadow-24 rounded-lg bg-dark">
                <q-img
                  src="https://placehold.co/600x400/1f1d2b/ffcf5c?text=ClassMaster+Demo"
                  :ratio="16 / 9"
                  class="dimmed"
                >
                  <div class="absolute-full flex flex-center">
                    <q-btn
                      round
                      color="white"
                      text-color="primary"
                      icon="play_arrow"
                      size="lg"
                      class="pulse-shadow"
                    />
                  </div>
                </q-img>
                <q-card-section class="bg-dark text-white">
                  <div class="row items-center justify-between">
                    <div>
                      <div class="text-subtitle1 text-weight-bold">System Walkthrough</div>
                      <div class="text-caption text-grey">See how ClassMaster works</div>
                    </div>
                    <q-rating v-model="rating" size="sm" color="secondary" readonly />
                  </div>
                </q-card-section>
              </q-card>
            </div>
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
const rating = ref(5)
</script>

<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
}

.bg-brand {
  /* Using $primary (#352263) to $dark (#1f1d2b) gradient */
  background: radial-gradient(circle at top right, #352263 0%, #1f1d2b 100%);
  min-height: 100vh;
}

.leading-tight {
  line-height: 1.1;
}

.font-light {
  font-weight: 300;
}

.bg-white-10 {
  background: rgba(255, 255, 255, 0.08);
}

.border-left-secondary {
  border-left: 4px solid #ffcf5c; /* $secondary */
}

/* 3D Floating Effect for Media */
.media-container {
  perspective: 1000px;
}

.absolute-bg-accent {
  position: absolute;
  top: 20px;
  right: -20px;
  width: 100%;
  height: 100%;
  background: rgba(255, 207, 92, 0.1); /* $secondary with opacity */
  border-radius: 16px;
  z-index: 0;
}

.rounded-lg {
  border-radius: 16px;
  position: relative;
  z-index: 1;
}

.dimmed {
  filter: brightness(0.9);
}

.pulse-shadow {
  box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.7);
  animation: pulse-white 2s infinite cubic-bezier(0.66, 0, 0, 1);
}

@keyframes pulse-white {
  to {
    box-shadow: 0 0 0 20px rgba(255, 255, 255, 0);
  }
}
</style>
