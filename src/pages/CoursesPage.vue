<template>
  <q-page class="q-pa-md bg-grey-1">
    <div class="row q-mb-md items-center justify-between">
      <div>
        <h4 class="text-h4 text-weight-bolder q-my-none text-dark">
          Courses <span class="text-secondary">Catalog</span>
        </h4>
        <div class="text-grey-7 text-subtitle1">Manage offered courses and classes</div>
      </div>
      <q-btn
        color="secondary"
        text-color="dark"
        icon="add"
        label="Add Course"
        rounded
        unelevated
        class="shadow-3 transition-fast text-weight-bold"
        @click="openAddDialog"
      />
    </div>

    <!-- Data Table -->
    <q-card class="shadow-2 rounded-borders">
      <q-table
        :rows="courses"
        :columns="columns"
        row-key="id"
        :filter="filter"
        :loading="loading"
        flat
        bordered
        separator="horizontal"
      >
        <template v-slot:top-right>
          <q-input
            dense
            debounce="300"
            v-model="filter"
            placeholder="Search Courses"
            rounded
            outlined
            bg-color="white"
          >
            <template v-slot:append>
              <q-icon name="search" />
            </template>
          </q-input>
        </template>

        <template v-slot:body-cell-actions="props">
          <q-td :props="props" class="q-gutter-sm">
            <q-btn
              flat
              round
              color="primary"
              icon="edit"
              size="sm"
              @click="editCourse(props.row)"
            />
            <q-btn
              flat
              round
              color="negative"
              icon="delete"
              size="sm"
              @click="deleteCourse(props.row.id)"
            />
          </q-td>
        </template>

        <template v-slot:body-cell-fee="props">
          <q-td :props="props">
            <q-badge color="green-1" text-color="green-9" class="text-weight-bold" rounded>
              {{ formatCurrency(props.row.fee) }}
            </q-badge>
          </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- Dialog -->
    <q-dialog v-model="dialogVisible" persistent>
      <q-card style="min-width: 600px" class="rounded-borders">
        <q-card-section class="bg-secondary text-dark row items-center q-py-sm">
          <div class="text-h6 text-weight-bold">
            {{ isEdit ? 'Edit Course' : 'Create New Course' }}
          </div>
          <q-space />
          <q-btn icon="close" flat round dense v-close-popup />
        </q-card-section>

        <q-separator />

        <q-card-section class="q-pa-lg">
          <q-form @submit="saveCourse">
            <div class="row q-col-gutter-md">
              <div class="col-12">
                <q-input
                  v-model="form.name"
                  label="Course Name (e.g. 2026 Revision)"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Name is required']"
                />
              </div>

              <div class="col-12 col-md-6">
                <q-select
                  v-model="form.subject"
                  :options="subjectOptions"
                  label="Subject"
                  outlined
                  dense
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="form.grade"
                  :options="gradeOptions"
                  label="Grade"
                  outlined
                  dense
                />
              </div>

              <div class="col-12 col-md-6">
                <q-input
                  v-model="form.fee"
                  label="Course Fee (LKR)"
                  type="number"
                  outlined
                  dense
                  prefix="Rs."
                />
              </div>
              <div class="col-12 col-md-6">
                <q-select
                  v-model="form.scheduleDay"
                  :options="dayOptions"
                  label="Class Day"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Day is required']"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="form.scheduleTime"
                  label="Time"
                  outlined
                  dense
                  mask="time"
                  :rules="['time']"
                >
                  <template v-slot:append>
                    <q-icon name="access_time" class="cursor-pointer">
                      <q-popup-proxy cover transition-show="scale" transition-hide="scale">
                        <q-time v-model="form.scheduleTime">
                          <div class="row items-center justify-end">
                            <q-btn v-close-popup label="Close" color="primary" flat />
                          </div>
                        </q-time>
                      </q-popup-proxy>
                    </q-icon>
                  </template>
                </q-input>
              </div>

              <div class="col-12">
                <q-input
                  v-model="form.description"
                  label="Description"
                  outlined
                  dense
                  type="textarea"
                  rows="3"
                />
              </div>
            </div>

            <div class="row justify-end q-gutter-sm q-mt-xl">
              <q-btn label="Cancel" color="grey" flat v-close-popup />
              <q-btn
                :label="isEdit ? 'Update Course' : 'Create Course'"
                type="submit"
                color="primary"
                unelevated
                :loading="saving"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from 'src/boot/supabase'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const courses = ref([])
const loading = ref(false)
const filter = ref('')
const dialogVisible = ref(false)
const isEdit = ref(false)
const saving = ref(false)

const form = ref({
  id: null,
  name: '',
  subject: '',
  grade: '',
  fee: '',
  description: '',
  scheduleDay: '',
  scheduleTime: '',
})

const gradeOptions = [
  'Grade 6',
  'Grade 7',
  'Grade 8',
  'Grade 9',
  'Grade 10',
  'Grade 11',
  'AL - Maths',
  'AL - Bio',
  'AL - Tech',
  'AL - Commerce',
  'AL - Arts',
]
const subjectOptions = [
  'Combined Maths',
  'Physics',
  'Chemistry',
  'Biology',
  'ICT',
  'English',
  'Sinhala',
  'History',
  'Science',
  'Commerce',
  'Accounting',
  'Economics',
]

const dayOptions = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

const columns = [
  { name: 'name', align: 'left', label: 'Course Name', field: 'name', sortable: true },
  { name: 'subject', align: 'left', label: 'Subject', field: 'subject', sortable: true },
  { name: 'grade', align: 'left', label: 'Grade', field: 'grade', sortable: true },
  { name: 'schedule', align: 'left', label: 'Schedule', field: 'schedule' },
  { name: 'fee', align: 'right', label: 'Fee', field: 'fee', sortable: true },
  { name: 'actions', align: 'center', label: 'Actions', field: 'actions' },
]

function openAddDialog() {
  isEdit.value = false
  form.value = {
    id: null,
    name: '',
    subject: '',
    grade: '',
    fee: '',
    description: '',
    scheduleDay: 'Monday',
    scheduleTime: '08:00',
  }
  dialogVisible.value = true
}

function editCourse(row) {
  isEdit.value = true
  const [day, ...rest] = (row.schedule || '').split(' ')
  form.value = {
    ...row,
    scheduleDay: dayOptions.includes(day) ? day : 'Monday',
    scheduleTime: rest.join(' ') || '08:00',
  }
  dialogVisible.value = true
}

async function fetchCourses() {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('courses')
      .select('*')
      .order('created_at', { ascending: false })
    if (error) throw error
    courses.value = data
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Failed to fetch courses' })
    console.error(err)
  } finally {
    loading.value = false
  }
}

async function saveCourse() {
  saving.value = true
  try {
    if (isEdit.value) {
      const { error } = await supabase
        .from('courses')
        .update({
          name: form.value.name,
          subject: form.value.subject,
          grade: form.value.grade,
          fee: form.value.fee,
          description: form.value.description,
          schedule: `${form.value.scheduleDay} ${form.value.scheduleTime}`,
        })
        .eq('id', form.value.id)
      if (error) throw error
      $q.notify({ type: 'positive', message: 'Course updated successfully' })
    } else {
      const { error } = await supabase.from('courses').insert([
        {
          name: form.value.name,
          subject: form.value.subject,
          grade: form.value.grade,
          fee: form.value.fee,
          description: form.value.description,
          schedule: `${form.value.scheduleDay} ${form.value.scheduleTime}`,
        },
      ])
      if (error) throw error
      $q.notify({ type: 'positive', message: 'Course created successfully' })
    }
    dialogVisible.value = false
    fetchCourses()
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Error saving course' })
    console.error(err)
  } finally {
    saving.value = false
  }
}

async function deleteCourse(id) {
  try {
    // Check for related records
    const { count: paymentCount, error: paymentError } = await supabase
      .from('payments')
      .select('*', { count: 'exact', head: true })
      .eq('course_id', id)

    const { count: attendanceCount, error: attendanceError } = await supabase
      .from('attendance')
      .select('*', { count: 'exact', head: true })
      .eq('course_id', id)

    if (paymentError) throw paymentError
    if (attendanceError) throw attendanceError

    const hasRelated = (paymentCount || 0) > 0 || (attendanceCount || 0) > 0

    let confirmMessage = 'Are you sure you want to delete this course?'
    if (hasRelated) {
      confirmMessage = `Warning: This course has ${paymentCount} payments and ${attendanceCount} attendance records. Deleting will permanently remove ALL related history. Continue?`
    }

    $q.dialog({
      title: 'Confirm Course Deletion',
      message: confirmMessage,
      cancel: true,
      persistent: true,
      ok: {
        label: 'Delete',
        color: 'negative',
      },
    }).onOk(async () => {
      try {
        // Cascade Delete
        if (paymentCount > 0) {
          const { error } = await supabase.from('payments').delete().eq('course_id', id)
          if (error) throw error
        }

        if (attendanceCount > 0) {
          const { error } = await supabase.from('attendance').delete().eq('course_id', id)
          if (error) throw error
        }

        const { error } = await supabase.from('courses').delete().eq('id', id)
        if (error) throw error

        $q.notify({ type: 'positive', message: 'Course deleted successfully' })
        fetchCourses()
      } catch (err) {
        const errorMsg = err.message || 'Unknown error'
        const errorDetails = err.details || ''

        $q.notify({
          type: 'negative',
          message: `Failed to delete: ${errorMsg}`,
          caption: errorDetails,
          timeout: 5000,
          actions: [{ label: 'Dismiss', color: 'white' }],
        })
        console.error(err)
      }
    })
  } catch (err) {
    console.error(err)
    $q.notify({ type: 'negative', message: 'Error checking related records' })
  }
}

function formatCurrency(value) {
  if (!value) return 'Rs. 0.00'
  return new Intl.NumberFormat('en-LK', { style: 'currency', currency: 'LKR' }).format(value)
}

onMounted(() => {
  fetchCourses()
})
</script>

<style scoped>
.transition-fast {
  transition: transform 0.2s;
}
.transition-fast:active {
  transform: scale(0.95);
}
</style>
