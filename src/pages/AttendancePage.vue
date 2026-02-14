<template>
  <q-page class="q-pa-md bg-grey-1">
    <div class="row q-mb-md items-center justify-between">
      <div>
        <h4 class="text-h4 text-weight-bolder q-my-none text-dark">
          Class <span class="text-primary">Attendance</span>
        </h4>
        <div class="text-grey-7 text-subtitle1">Mark student attendance for classes</div>
      </div>
      <div>
        <q-btn
          color="white"
          text-color="primary"
          icon="history"
          label="History"
          rounded
          unelevated
          @click="showHistory = !showHistory"
          class="q-mr-sm"
        />
      </div>
    </div>

    <!-- Marking UI Container -->
    <div v-show="!showHistory">
      <!-- Attendance Controls -->
      <q-card class="shadow-2 rounded-borders q-mb-md">
        <q-card-section>
          <div class="row q-col-gutter-md items-center">
            <div class="col-12 col-md-4">
              <q-select
                v-model="selectedCourse"
                :options="courseOptions"
                option-label="name"
                label="Select Course"
                outlined
                dense
                bg-color="white"
                clearable
                @update:model-value="fetchStudents"
              />
              <q-toggle
                v-model="filterByGrade"
                label="Filter by Grade"
                left-label
                dense
                class="q-mt-xs text-grey-7"
                @update:model-value="fetchStudents"
              />
            </div>
            <div class="col-12 col-md-3">
              <q-input
                v-model="selectedDate"
                mask="date"
                :rules="['date']"
                label="Date"
                outlined
                dense
                bg-color="white"
              >
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy cover transition-show="scale" transition-hide="scale">
                      <q-date v-model="selectedDate" @update:model-value="fetchAttendanceData">
                        <div class="row items-center justify-end">
                          <q-btn v-close-popup label="Close" color="primary" flat />
                        </div>
                      </q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
            </div>
            <div class="col-12 col-md-3">
              <q-input
                v-model="selectedTime"
                mask="time"
                :rules="['time']"
                label="Time"
                outlined
                dense
                bg-color="white"
              >
                <template v-slot:append>
                  <q-icon name="access_time" class="cursor-pointer">
                    <q-popup-proxy cover transition-show="scale" transition-hide="scale">
                      <q-time v-model="selectedTime" format24h>
                        <div class="row items-center justify-end">
                          <q-btn v-close-popup label="Close" color="primary" flat />
                        </div>
                      </q-time>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
            </div>
            <div class="col-12 col-md-2 text-right">
              <q-btn
                :color="hasUnsavedChanges ? 'negative' : 'positive'"
                text-color="white"
                :icon="hasUnsavedChanges ? 'save' : 'check_circle'"
                :label="hasUnsavedChanges ? 'Save Changes' : 'Saved'"
                rounded
                unelevated
                class="shadow-3 text-weight-bold"
                :disable="!selectedCourse || studentRows.length === 0"
                :loading="saving"
                @click="saveAttendance"
              />
            </div>
          </div>
        </q-card-section>
      </q-card>
    </div>

    <!-- History Section (Visible on toggle) -->
    <q-expand-transition>
      <div v-if="showHistory" class="q-mb-md">
        <q-card class="shadow-2 rounded-borders">
          <q-card-section>
            <div class="row items-center justify-between q-mb-md">
              <div class="text-h6">Attendance Records</div>
              <q-btn
                icon="download"
                label="Export CSV"
                color="primary"
                flat
                dense
                no-caps
                @click="exportToCsv"
              />
            </div>

            <!-- Date Filters -->
            <div class="row q-col-gutter-sm items-center q-mb-md bg-grey-1 q-pa-sm rounded-borders">
              <div class="col-12 col-md-3">
                <q-input
                  dense
                  outlined
                  v-model="historyFrom"
                  label="From Date"
                  mask="date"
                  bg-color="white"
                >
                  <template v-slot:append>
                    <q-icon name="event" class="cursor-pointer">
                      <q-popup-proxy cover transition-show="scale" transition-hide="scale">
                        <q-date v-model="historyFrom">
                          <div class="row items-center justify-end">
                            <q-btn v-close-popup label="Close" color="primary" flat />
                          </div>
                        </q-date>
                      </q-popup-proxy>
                    </q-icon>
                  </template>
                </q-input>
              </div>
              <div class="col-12 col-md-3">
                <q-input
                  dense
                  outlined
                  v-model="historyTo"
                  label="To Date"
                  mask="date"
                  bg-color="white"
                >
                  <template v-slot:append>
                    <q-icon name="event" class="cursor-pointer">
                      <q-popup-proxy cover transition-show="scale" transition-hide="scale">
                        <q-date v-model="historyTo">
                          <div class="row items-center justify-end">
                            <q-btn v-close-popup label="Close" color="primary" flat />
                          </div>
                        </q-date>
                      </q-popup-proxy>
                    </q-icon>
                  </template>
                </q-input>
              </div>
              <div class="col-12 col-md-2">
                <q-btn
                  color="primary"
                  icon="search"
                  label="Filter"
                  @click="fetchHistory"
                  unelevated
                  class="full-width"
                />
              </div>
            </div>
          </q-card-section>
          <q-card-section>
            <q-table
              flat
              bordered
              :rows="historyRows"
              :columns="historyColumns"
              row-key="id"
              :loading="historyLoading"
            >
              <template v-slot:body-cell-status="props">
                <q-td :props="props">
                  <q-chip
                    size="sm"
                    :color="
                      props.row.status === 'Present'
                        ? 'green-1'
                        : props.row.status === 'Absent'
                          ? 'red-1'
                          : 'orange-1'
                    "
                    :text-color="
                      props.row.status === 'Present'
                        ? 'green-9'
                        : props.row.status === 'Absent'
                          ? 'red-9'
                          : 'orange-9'
                    "
                  >
                    {{ props.row.status }}
                  </q-chip>
                </q-td>
              </template>
            </q-table>
          </q-card-section>
        </q-card>
      </div>
    </q-expand-transition>

    <!-- Students List (Inside logic wrapper) -->
    <div v-if="!showHistory">
      <q-card v-if="selectedCourse" class="shadow-2 rounded-borders transition-fast">
        <q-card-section v-if="loading" class="text-center q-pa-lg">
          <q-spinner-dots color="primary" size="3em" />
          <div class="text-grey-6 q-mt-sm">Loading students...</div>
        </q-card-section>

        <q-card-section v-else-if="studentRows.length > 0" class="q-pa-none">
          <q-list separator>
            <q-item-label header class="bg-grey-2 text-weight-bold q-py-sm text-center">
              Marking Attendance for: <span class="text-primary">{{ selectedCourse.name }}</span> -
              {{ selectedDate }}
            </q-item-label>

            <q-item v-for="student in studentRows" :key="student.id" class="q-py-md hover-bg">
              <q-item-section avatar>
                <q-avatar color="grey-3" text-color="primary" class="text-weight-bold">
                  {{ student.full_name.charAt(0) }}
                </q-avatar>
              </q-item-section>

              <q-item-section>
                <q-item-label class="text-weight-bold text-subtitle1">{{
                  student.full_name
                }}</q-item-label>
                <q-item-label caption
                  >{{ student.grade }} | ID: {{ student.id.slice(0, 8) }}</q-item-label
                >
              </q-item-section>

              <q-item-section side>
                <div class="row q-gutter-sm">
                  <q-btn-toggle
                    v-model="student.status"
                    push
                    glossy
                    toggle-color="primary"
                    :options="[
                      { label: 'Present', value: 'Present', slot: 'present' },
                      { label: 'Absent', value: 'Absent', slot: 'absent' },
                      { label: 'Late', value: 'Late', slot: 'late' },
                    ]"
                  >
                    <template v-slot:present>
                      <q-icon name="check_circle" color="green-4" />
                    </template>
                    <template v-slot:absent>
                      <q-icon name="cancel" color="red-4" />
                    </template>
                    <template v-slot:late>
                      <q-icon name="schedule" color="orange-4" />
                    </template>
                  </q-btn-toggle>
                </div>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>

        <q-card-section v-else class="text-center q-pa-lg">
          <q-icon name="sentiment_dissatisfied" size="4em" color="grey-4" />
          <div class="text-h6 text-grey-6 q-mt-md">No students found for this grade</div>
          <div class="text-caption text-grey-5">
            Try adding students with Grade: {{ selectedCourse.grade }}
          </div>
        </q-card-section>
      </q-card>

      <!-- Placeholder when no course selected -->
      <div v-else class="text-center q-mt-xl text-grey-5">
        <q-icon name="school" size="6em" />
        <div class="text-h5 q-mt-md">Select a course to start</div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { supabase } from 'src/boot/supabase'
import { useQuasar, date, exportFile } from 'quasar'

const $q = useQuasar()
const courseOptions = ref([])
const selectedCourse = ref(null)
const selectedDate = ref(date.formatDate(Date.now(), 'YYYY/MM/DD'))
const selectedTime = ref(date.formatDate(Date.now(), 'HH:mm')) // Time Variable
const studentRows = ref([])
const loading = ref(false)
const hasUnsavedChanges = ref(false)
const saving = ref(false)

watch(
  studentRows,
  () => {
    if (!loading.value) {
      hasUnsavedChanges.value = true
    }
  },
  { deep: true },
)

// History Data
// History Data
// History Data
const showHistory = ref(false)
const historyRows = ref([])
const historyLoading = ref(false)
// Date Filters for History
const historyFrom = ref(date.formatDate(Date.now(), 'YYYY/MM/DD'))
const historyTo = ref(date.formatDate(Date.now(), 'YYYY/MM/DD'))

const historyColumns = [
  {
    name: 'student_id',
    label: 'Student ID',
    field: 'student_display_id',
    align: 'left',
    sortable: true,
  },
  { name: 'student', label: 'Student Name', field: 'student_name', align: 'left', sortable: true },
  { name: 'status', label: 'Status', field: 'status', align: 'center', sortable: true },
  { name: 'date', label: 'Date', field: 'date', align: 'left', sortable: true },
  { name: 'time', label: 'Time', field: 'time', align: 'left', sortable: true },
  { name: 'course', label: 'Course', field: 'course_name', align: 'left', sortable: true },
]

const filterByGrade = ref(true) // New toggle for filtering

function wrapCsvValue(val, formatFn) {
  let formatted = formatFn !== void 0 ? formatFn(val) : val
  formatted = formatted === void 0 || formatted === null ? '' : String(formatted)
  formatted = formatted.split('"').join('""')
  return `"${formatted}"`
}

function exportToCsv() {
  const content = [historyColumns.map((col) => wrapCsvValue(col.label))]
    .concat(
      historyRows.value.map((row) =>
        historyColumns
          .map((col) =>
            wrapCsvValue(
              typeof col.field === 'function'
                ? col.field(row)
                : row[col.field === void 0 ? col.name : col.field],
              col.id,
            ),
          )
          .join(','),
      ),
    )
    .join('\r\n')

  const status = exportFile('attendance-history.csv', content, 'text/csv')

  if (status !== true) {
    $q.notify({
      message: 'Browser denied file download...',
      color: 'negative',
      icon: 'warning',
    })
  }
}

async function fetchHistory() {
  historyLoading.value = true
  try {
    let query = supabase
      .from('attendance')
      .select(
        `
        id,
        date,
        time,
        status,
        course_id,
        courses ( name ),
        students ( id, full_name, grade )
      `,
      )
      .order('date', { ascending: false })
      .order('time', { ascending: false })

    // Apply Date Range Filter
    if (historyFrom.value) query = query.gte('date', historyFrom.value)
    if (historyTo.value) query = query.lte('date', historyTo.value)

    const { data: records, error } = await query

    if (error) throw error

    // Map to flat structure
    historyRows.value = records.map((row) => ({
      id: row.id,
      date: row.date,
      time: row.time || '00:00',
      course_name: row.courses?.name || 'Unknown',
      student_name: row.students?.full_name || 'Unknown',
      student_display_id: row.students?.id ? row.students.id.slice(0, 8) : 'N/A',
      status: row.status,
    }))
  } catch (err) {
    console.error('Error fetching history:', err)
  } finally {
    historyLoading.value = false
  }
}

// ... existing fetchCourses ...
async function fetchCourses() {
  try {
    const { data, error } = await supabase.from('courses').select('*').order('name')
    if (error) throw error
    courseOptions.value = data
  } catch (err) {
    console.error('Error fetching courses:', err)
    $q.notify({ type: 'negative', message: 'Failed to load courses' })
  }
}

// ... existing fetchStudents ...
async function fetchStudents() {
  if (!selectedCourse.value) return

  loading.value = true
  studentRows.value = []

  try {
    let query = supabase
      .from('students')
      .select('*')
      .order('grade', { ascending: true })
      .order('full_name', { ascending: true })

    // Conditionally Apply Grade Filter
    if (filterByGrade.value && selectedCourse.value.grade) {
      query = query.eq('grade', selectedCourse.value.grade)
    }

    const { data: students, error: studentError } = await query

    if (studentError) throw studentError

    // 2. Fetch existing attendance for this date/course
    const { data: attendance, error: attendanceError } = await supabase
      .from('attendance')
      .select('*')
      .eq('course_id', selectedCourse.value.id)
      .eq('date', selectedDate.value)
      .eq('time', selectedTime.value) // NOW FILTERING BY TIME TOO

    if (attendanceError) throw attendanceError

    studentRows.value = students
      .map((student) => {
        const record = attendance.find((a) => a.student_id === student.id)
        return {
          ...student,
          status: record ? record.status : 'Present', // Default status
          attendance_id: record ? record.id : null,
        }
      })
      .sort((a, b) => {
        // Priority 1: Match course grade
        const aMatch = a.grade === selectedCourse.value.grade
        const bMatch = b.grade === selectedCourse.value.grade
        if (aMatch && !bMatch) return -1
        if (!aMatch && bMatch) return 1

        // Priority 2: Sort by Grade
        if (a.grade < b.grade) return -1
        if (a.grade > b.grade) return 1

        // Priority 3: Sort by Name
        return a.full_name.localeCompare(b.full_name)
      })

    // Reset unsaved changes after load
    hasUnsavedChanges.value = false
  } catch (err) {
    console.error('Error fetching data:', err)
    $q.notify({
      type: 'negative',
      message: 'Failed to load students. Please check database connection.',
    })
  } finally {
    loading.value = false
  }
}

watch([selectedDate, selectedTime], () => {
  if (selectedCourse.value) {
    fetchStudents()
  }
})

const fetchAttendanceData = fetchStudents

async function saveAttendance() {
  saving.value = true
  try {
    const timeToSave = selectedTime.value ? selectedTime.value.trim() : '00:00'

    const upsertData = studentRows.value.map((row) => ({
      student_id: row.id,
      course_id: selectedCourse.value.id,
      date: selectedDate.value,
      time: timeToSave,
      status: row.status,
    }))

    // Upsert with new Time constraint
    const { error } = await supabase
      .from('attendance')
      .upsert(upsertData, { onConflict: 'student_id, course_id, date, time' })

    if (error) throw error

    $q.notify({
      type: 'positive',
      message: 'Attendance saved successfully',
      icon: 'check_circle',
    })

    hasUnsavedChanges.value = false // Reset explicitly on save
    fetchStudents()
    fetchHistory() // Refresh history
  } catch (err) {
    console.error('Error saving attendance:', err)
    let msg = 'Failed to save attendance'

    if (err.code === 'PGRST102' || err.code === '23505') {
      // Explicit instruction for the constraint error
      msg = 'Constraint Error: Please run FINAL_DB_FIX.sql in Supabase SQL Editor.'
    } else if (err.message) {
      msg += ': ' + err.message
    }

    $q.notify({
      type: 'negative',
      message: msg,
      timeout: 8000,
      actions: [{ label: 'Dismiss', color: 'white' }],
    })
  } finally {
    saving.value = false
  }
}

onMounted(() => {
  fetchCourses()
  fetchHistory() // Initial load
})
</script>

<style scoped>
.hover-bg:hover {
  background-color: #f5f5f5;
}
.transition-fast {
  animation: fadeIn 0.3s ease-in-out;
}
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
