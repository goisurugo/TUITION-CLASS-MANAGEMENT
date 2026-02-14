<template>
  <q-page class="q-pa-md bg-grey-1">
    <div class="row q-col-gutter-lg">
      <!-- Welcome Section -->
      <div class="col-12 q-mb-sm">
        <h4 class="text-h4 text-weight-bolder q-my-none text-dark">
          Dashboard <span class="text-primary">Overview</span>
        </h4>
        <div class="text-grey-7 text-subtitle1">
          Welcome back, Admin! Here's what's happening today.
        </div>
      </div>

      <!-- Stats Cards -->
      <div class="col-12 col-md-3">
        <q-card class="stats-card bg-primary text-white shadow-3">
          <q-card-section class="q-pa-lg">
            <div class="row items-center justify-between">
              <div>
                <div class="text-subtitle2 text-purple-2 text-uppercase text-weight-bold">
                  Total Students
                </div>
                <div class="text-h3 text-weight-bolder q-mt-xs">{{ totalStudents }}</div>
              </div>
              <q-avatar
                color="white"
                text-color="primary"
                icon="people"
                size="50px"
                class="shadow-2"
              />
            </div>
            <div class="q-mt-md flex items-center">
              <q-badge
                :color="studentGrowth >= 0 ? 'green-1' : 'red-1'"
                :text-color="studentGrowth >= 0 ? 'green-8' : 'red-8'"
                class="q-mr-sm q-py-xs q-px-sm"
              >
                <q-icon
                  :name="studentGrowth >= 0 ? 'trending_up' : 'trending_down'"
                  size="xs"
                  class="q-mr-xs"
                />
                {{ studentGrowth }}%
              </q-badge>
              <span class="text-purple-1 text-caption">from last month</span>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card class="stats-card bg-white text-dark shadow-3">
          <q-card-section class="q-pa-lg">
            <div class="row items-center justify-between">
              <div>
                <div class="text-subtitle2 text-grey-6 text-uppercase text-weight-bold">
                  Active Courses
                </div>
                <div class="text-h3 text-weight-bolder q-mt-xs">{{ activeCourses }}</div>
              </div>
              <q-avatar
                color="secondary"
                text-color="dark"
                icon="school"
                size="50px"
                class="shadow-2"
              />
            </div>
            <div class="q-mt-md flex items-center">
              <span class="text-grey-6 text-caption">Total Active Classes</span>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card class="stats-card bg-indigo-10 text-white shadow-3">
          <q-card-section class="q-pa-lg">
            <div class="row items-center justify-between">
              <div>
                <div class="text-subtitle2 text-grey-4 text-uppercase text-weight-bold">
                  Revenue
                </div>
                <div class="text-h3 text-weight-bolder q-mt-xs text-secondary">
                  Rs. {{ formatNumber(totalRevenue) }}
                </div>
              </div>
              <q-avatar
                color="grey-9"
                text-color="secondary"
                icon="attach_money"
                size="50px"
                class="shadow-2"
              />
            </div>
            <div class="q-mt-md flex items-center">
              <span
                :class="revenueGrowth >= 0 ? 'text-green-4' : 'text-red-4'"
                class="text-weight-bold"
                >{{ revenueGrowth >= 0 ? '+' : '' }}{{ revenueGrowth }}%</span
              >
              <span class="text-grey-6 text-caption q-ml-sm">monthly growth</span>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-3">
        <q-card class="stats-card bg-white text-dark shadow-3">
          <q-card-section class="q-pa-lg">
            <div class="row items-center justify-between">
              <div>
                <div class="text-subtitle2 text-grey-6 text-uppercase text-weight-bold">
                  Attendance
                </div>
                <div class="text-h3 text-weight-bolder q-mt-xs">{{ attendanceRate }}%</div>
              </div>
              <q-avatar
                color="red-1"
                text-color="red"
                icon="event_busy"
                size="50px"
                class="shadow-2"
              />
            </div>
            <div class="q-mt-md flex items-center">
              <span class="text-grey-6 text-caption">Overall Participation</span>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <!-- Recent Activity / Charts Section -->
      <div class="col-12 col-md-8">
        <q-card class="shadow-2 rounded-borders">
          <q-card-section class="row items-center justify-between q-pb-none">
            <div class="text-h6 text-weight-bold">Recent Enrollments</div>
            <q-btn flat color="primary" label="View All" rounded no-caps />
          </q-card-section>
          <q-card-section>
            <q-table
              fixed-header
              flat
              :rows="recentEnrollments"
              :columns="columns"
              row-key="name"
              hide-bottom
            >
              <template v-slot:header="props">
                <q-tr :props="props">
                  <q-th
                    v-for="col in props.cols"
                    :key="col.name"
                    :props="props"
                    class="text-grey-8 text-weight-bold"
                  >
                    {{ col.label }}
                  </q-th>
                </q-tr>
              </template>
              <template v-slot:body="props">
                <q-tr :props="props" class="hover-bg">
                  <q-td key="name" :props="props">
                    <div class="row items-center">
                      <q-avatar size="32px" color="grey-3" text-color="primary" class="q-mr-sm">{{
                        props.row.name.charAt(0)
                      }}</q-avatar>
                      <div class="text-weight-medium">{{ props.row.name }}</div>
                    </div>
                  </q-td>
                  <q-td key="course" :props="props">
                    <q-chip dense color="purple-1" text-color="primary">{{
                      props.row.course
                    }}</q-chip>
                  </q-td>
                  <q-td key="date" :props="props" class="text-grey-7">
                    {{ props.row.date }}
                  </q-td>
                  <q-td key="status" :props="props">
                    <q-badge
                      :color="props.row.status === 'Paid' ? 'secondary' : 'grey-4'"
                      :text-color="props.row.status === 'Paid' ? 'dark' : 'grey-8'"
                      :label="props.row.status"
                      rounded
                      class="q-py-xs q-px-sm"
                    />
                  </q-td>
                </q-tr>
              </template>
            </q-table>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-md-4">
        <q-card class="bg-primary text-white shadow-3 rounded-borders fit">
          <q-card-section>
            <div class="text-h6 text-weight-bold">Today's Classes ({{ todayName }})</div>
            <div class="text-purple-2 text-caption">Schedule for the day</div>
          </q-card-section>
          <q-list separator dark class="q-px-sm" v-if="upcomingClasses.length > 0">
            <q-item
              v-for="cls in upcomingClasses"
              :key="cls.id"
              clickable
              v-ripple
              class="rounded-borders q-my-sm hover-light"
            >
              <q-item-section avatar>
                <div class="bg-white-20 rounded-borders q-pa-sm">
                  <q-icon name="class" color="white" />
                </div>
              </q-item-section>
              <q-item-section>
                <q-item-label class="text-weight-bold">{{ cls.name }}</q-item-label>
                <q-item-label caption class="text-purple-1">{{ cls.schedule }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <q-chip size="sm" color="secondary" text-color="dark">{{ cls.grade }}</q-chip>
              </q-item-section>
            </q-item>
          </q-list>
          <div v-else class="text-center q-pa-lg text-grey-4">
            <q-icon name="event_available" size="md" />
            <div class="q-mt-sm">No classes scheduled for today</div>
          </div>
        </q-card>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from 'src/boot/supabase'
import { date } from 'quasar'

const columns = [
  { name: 'name', align: 'left', label: 'STUDENT NAME', field: 'name', sortable: true },
  { name: 'course', align: 'left', label: 'GRADE / COURSE', field: 'course', sortable: true },
  { name: 'date', align: 'left', label: 'JOINED DATE', field: 'date', sortable: true },
  { name: 'status', align: 'left', label: 'STATUS', field: 'status' },
]

const recentEnrollments = ref([])
const totalStudents = ref(0)
const activeCourses = ref(0)
const totalRevenue = ref(0) // New Ref for Revenue
const attendanceRate = ref(0) // New Ref for Attendance

// Dynamic Stats
const studentGrowth = ref(0)
const revenueGrowth = ref(0)
const upcomingClasses = ref([])
const todayName = date.formatDate(Date.now(), 'dddd')

function formatNumber(value) {
  if (!value) return '0'
  if (value >= 1000000) return (value / 1000000).toFixed(1) + 'M'
  if (value >= 1000) return (value / 1000).toFixed(1) + 'k'
  return value.toLocaleString()
}

async function fetchDashboardData() {
  try {
    // 1. Fetch Total Students Count
    const { count: studentCount, error: studentError } = await supabase
      .from('students')
      .select('*', { count: 'exact', head: true })

    if (!studentError) totalStudents.value = studentCount

    // 2. Fetch Active Courses Count
    const { count: courseCount, error: courseError } = await supabase
      .from('courses')
      .select('*', { count: 'exact', head: true })

    if (!courseError) activeCourses.value = courseCount

    // 3. Fetch Recent Enrollments (Newest Students)
    const { data: students, error: enrollError } = await supabase
      .from('students')
      .select('full_name, grade, created_at')
      .order('created_at', { ascending: false })
      .limit(5)

    if (enrollError) throw enrollError

    recentEnrollments.value = students.map((student) => ({
      name: student.full_name,
      course: student.grade || 'N/A', // Using Grade as Course/Stream proxy
      date: date.formatDate(student.created_at, 'YYYY-MM-DD'),
      status: 'Active', // Default status for new students
    }))

    // 4. Fetch Total Revenue (from payments)
    const { data: payments, error: paymentError } = await supabase.from('payments').select('amount')

    if (!paymentError && payments) {
      const sum = payments.reduce((acc, curr) => acc + (curr.amount || 0), 0)
      totalRevenue.value = sum
    }

    // 5. Fetch Attendance Stats
    const { count: totalAttendance, error: totalAttError } = await supabase
      .from('attendance')
      .select('*', { count: 'exact', head: true })

    const { count: presentAttendance, error: presentAttError } = await supabase
      .from('attendance')
      .select('*', { count: 'exact', head: true })
      .eq('status', 'Present')

    if (!totalAttError && !presentAttError && totalAttendance > 0) {
      attendanceRate.value = Math.round((presentAttendance / totalAttendance) * 100)
    }

    // 6. Calculate Student Growth (This Month vs Last Month)
    const startOfMonth = date.formatDate(date.startOfDate(new Date(), 'month'), 'YYYY-MM-DD')
    const startOfLastMonth = date.formatDate(
      date.addToDate(date.startOfDate(new Date(), 'month'), { month: -1 }),
      'YYYY-MM-DD',
    )

    const { count: thisMonthStudents, error: tmError } = await supabase
      .from('students')
      .select('*', { count: 'exact', head: true })
      .gte('created_at', startOfMonth)

    const { count: lastMonthStudents, error: lmError } = await supabase
      .from('students')
      .select('*', { count: 'exact', head: true })
      .gte('created_at', startOfLastMonth)
      .lt('created_at', startOfMonth)

    if (!tmError && !lmError && lastMonthStudents > 0) {
      studentGrowth.value = Math.round(
        ((thisMonthStudents - lastMonthStudents) / lastMonthStudents) * 100,
      )
    } else if (thisMonthStudents > 0 && lastMonthStudents === 0) {
      studentGrowth.value = 100 // 100% growth if started from 0
    }

    // 7. Calculate Revenue Growth (This Month vs Last Month)
    // Using 'month' column which is YYYY-MM
    const currentMonthStr = date.formatDate(new Date(), 'YYYY-MM')
    const lastMonthStr = date.formatDate(date.addToDate(new Date(), { month: -1 }), 'YYYY-MM')

    const { data: thisMonthPayments } = await supabase
      .from('payments')
      .select('amount')
      .eq('month', currentMonthStr)
    const { data: lastMonthPayments } = await supabase
      .from('payments')
      .select('amount')
      .eq('month', lastMonthStr)

    const thisMonthRevenue = thisMonthPayments?.reduce((sum, p) => sum + (p.amount || 0), 0) || 0
    const lastMonthRevenue = lastMonthPayments?.reduce((sum, p) => sum + (p.amount || 0), 0) || 0

    if (lastMonthRevenue > 0) {
      revenueGrowth.value = Math.round(
        ((thisMonthRevenue - lastMonthRevenue) / lastMonthRevenue) * 100,
      )
    } else if (thisMonthRevenue > 0) {
      revenueGrowth.value = 100
    }

    // 8. Fetch Upcoming Classes (Simple Day Match)
    const { data: allCourses } = await supabase
      .from('courses')
      .select('id, name, grade, schedule, subject')
    if (allCourses) {
      // Simple regex to check if today's prominent 3 letters exist in schedule string (e.g. "Mon" in "Monday")
      const shortDay = todayName.substring(0, 3)
      upcomingClasses.value = allCourses
        .filter(
          (c) => c.schedule && (c.schedule.includes(todayName) || c.schedule.includes(shortDay)),
        )
        .slice(0, 5) // Limit to 5
    }
  } catch (err) {
    console.error('Error fetching dashboard data:', err)
  }
}

onMounted(() => {
  fetchDashboardData()
})
</script>

<style lang="scss" scoped>
.stats-card {
  border-radius: 16px;
  transition:
    transform 0.3s ease,
    box-shadow 0.3s ease;
  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  }
}

.rounded-borders {
  border-radius: 16px;
}

.bg-white-20 {
  background: rgba(255, 255, 255, 0.2);
}

.hover-bg {
  transition: background-color 0.2s;
  &:hover {
    background-color: #f5f5f5;
  }
}

.hover-light {
  transition: background-color 0.2s;
  &:hover {
    background-color: rgba(255, 255, 255, 0.1);
  }
}
</style>
