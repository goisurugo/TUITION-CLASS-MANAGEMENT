<template>
  <q-layout view="lHh Lpr lFf">
    <q-header class="bg-brand-header text-white q-py-sm isuru-font" elevated>
      <q-toolbar class="container">
        <q-toolbar-title class="text-weight-bolder">
          <q-icon name="business" size="md" class="q-mr-sm" />
          Isuru <span class="text-secondary">Education Systems</span>
        </q-toolbar-title>
        <q-btn
          flat
          icon="login"
          label="ClassMaster Login"
          to="/login"
          class="q-px-md text-weight-bold"
        />
      </q-toolbar>
    </q-header>

    <q-page-container>
      <!-- Hero Section -->
      <section class="hero-section text-white flex flex-center column text-center q-pa-xl">
        <h1 class="text-h2 text-weight-bolder q-mb-md">Empowering Education with Technology</h1>
        <p class="text-h5 q-mb-xl text-grey-4" style="max-width: 800px">
          Parent company of <span class="text-secondary text-weight-bold">ClassMaster</span> - The
          leading Tuition Class Management System in Sri Lanka.
        </p>
        <div class="row q-gutter-md">
          <q-btn
            color="secondary"
            text-color="dark"
            size="lg"
            label="Get ClassMaster LMS"
            rounded
            push
            class="pulse-btn text-weight-bold"
            to="/register-interest"
          />
          <q-btn outline color="white" size="lg" label="Owner Login" rounded to="/login" />
        </div>
        <div class="q-mt-lg text-caption text-grey-5">
          Experience the power of 17+ Years of Innovation
        </div>
      </section>

      <!-- Features Grid -->
      <section class="q-pa-xl bg-grey-1">
        <div class="row q-col-gutter-lg container q-mx-auto">
          <div class="col-12 text-center q-mb-lg">
            <h2 class="text-h4 text-primary text-weight-bold">Our Flagship Product</h2>
            <div class="text-subtitle1 text-grey-7">
              ClassMaster - The Ultimate Institute Management Solution.
            </div>
          </div>

          <div class="col-12 col-md-4" v-for="feature in features" :key="feature.title">
            <q-card class="feature-card items-center text-center q-pa-lg">
              <div class="icon-box q-mb-md">
                <q-icon :name="feature.icon" size="3rem" color="primary" />
              </div>
              <div class="text-h6 text-weight-bold q-mb-sm">{{ feature.title }}</div>
              <div class="text-grey-7">{{ feature.description }}</div>
            </q-card>
          </div>
        </div>
      </section>

      <!-- Trust/Developer Section (Small) -->
      <section class="q-py-xl bg-white border-top">
        <div class="container q-mx-auto text-center">
          <div class="text-subtitle1 text-italic text-grey-8 q-mb-md">
            "Education is the passport to the future, for tomorrow belongs to those who prepare for
            it today."
          </div>

          <div class="row justify-center items-center q-gutter-md">
            <q-avatar size="80px" class="shadow-2">
              <img src="/profile.jpg" style="object-fit: cover" />
            </q-avatar>

            <div class="text-left">
              <div class="text-subtitle1 text-weight-bold text-dark no-margin">Isuru Buddhika</div>
              <div class="text-caption text-primary text-weight-medium no-margin">
                MSc. IT & Strategic Innovation (Kingston, UK)
              </div>
              <div class="text-caption text-grey-7 no-margin">
                Lead Architect & Full Stack Specialist
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CTA Footer -->
      <section class="bg-dark text-white q-pa-xl text-center">
        <h3 class="text-h3 text-weight-bold q-mb-md">Ready to Scale Your Institute?</h3>
        <p class="text-h6 text-grey-4 q-mb-lg">Get started with Isuru Education Systems.</p>
        <q-btn
          outline
          color="secondary"
          label="Contact Us"
          size="lg"
          class="q-px-xl"
          href="mailto:sales@isurueducation.com"
        />
      </section>

      <q-footer class="bg-black text-grey-6 text-center q-py-md">
        &copy; 2026 Isuru Education Systems. All Rights Reserved.
      </q-footer>
    </q-page-container>
  </q-layout>
</template>

<script setup>
const features = [
  {
    title: 'Student Management',
    icon: 'people',
    description: 'Easily register, track, and manage student profiles and academic progress.',
  },
  {
    title: 'Smart Payments',
    icon: 'payments',
    description: 'Track fees, generate invoices, and get monthly revenue reports instantly.',
  },
  {
    title: 'Attendance Tracking',
    icon: 'verified_user',
    description: 'Mark attendance via QR or manual entry. SMS alerts to parents (Coming Soon).',
  },
]
</script>

<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
}

.bg-brand-header {
  background: #352263; /* Primary */
}

.hero-section {
  background:
    linear-gradient(to bottom right, rgba(53, 34, 99, 0.92), rgba(31, 29, 43, 0.96)),
    url('https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?q=80&w=1920&auto=format&fit=crop');
  background-size: cover;
  background-position: center;
  min-height: 85vh;
  clip-path: polygon(0 0, 100% 0, 100% 90%, 0 100%);
}

.feature-card {
  transition:
    transform 0.3s ease,
    box-shadow 0.3s ease;
  height: 100%;
}

.feature-card:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.icon-box {
  background: #f3e5f5; /* Light Purple tint */
  width: 80px;
  height: 80px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto;
}

.pulse-btn {
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(255, 207, 92, 0.7); /* Secondary Color Shadow */
  }
  70% {
    box-shadow: 0 0 0 10px rgba(255, 207, 92, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(255, 207, 92, 0);
  }
}

.border-gray {
  border: 1px solid #e0e0e0;
}

.hover-effect {
  transition: all 0.3s ease;
}

.hover-effect:hover {
  transform: scale(1.02);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1) !important;
}

.letter-spacing {
  letter-spacing: 1px;
}

.border-top {
  border-top: 1px solid #e0e0e0;
}
</style>
