<template>
  <q-page class="q-pa-md bg-grey-1">
    <div class="row q-mb-md items-center justify-between">
      <div>
        <h4 class="text-h4 text-weight-bolder q-my-none text-dark">
          Students <span class="text-primary">Management</span>
        </h4>
        <div class="text-grey-7 text-subtitle1">Manage all student records</div>
      </div>
      <q-btn
        color="primary"
        icon="add"
        label="Add Student"
        rounded
        unelevated
        class="bg-primary text-white shadow-3 transition-fast"
        @click="openAddDialog"
      />
    </div>

    <!-- Data Table -->
    <q-card class="shadow-2 rounded-borders">
      <q-table
        :rows="students"
        :columns="columns"
        row-key="id"
        :filter="filter"
        :loading="loading"
        flat
        bordered
        separator="cell"
      >
        <template v-slot:top-right>
          <q-input dense debounce="300" v-model="filter" placeholder="Search" rounded outlined>
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
              @click="editStudent(props.row)"
            />
            <q-btn
              flat
              round
              color="negative"
              icon="delete"
              size="sm"
              @click="deleteStudent(props.row.id)"
            />
          </q-td>
        </template>

        <template v-slot:body-cell-joined_date="props">
          <q-td :props="props">
            <q-badge color="purple-1" text-color="primary" rounded>
              {{ formatDate(props.row.joined_date) }}
            </q-badge>
          </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- Dialog -->
    <q-dialog v-model="dialogVisible" persistent>
      <q-card style="min-width: 600px" class="rounded-borders">
        <q-card-section class="bg-primary text-white row items-center q-py-sm">
          <div class="text-h6">{{ isEdit ? 'Edit Student' : 'Add New Student' }}</div>
          <q-space />
          <q-btn icon="close" flat round dense v-close-popup />
        </q-card-section>

        <q-separator />

        <q-card-section class="q-pa-lg">
          <q-form @submit="saveStudent">
            <div class="row q-col-gutter-md">
              <div class="col-12">
                <q-input
                  v-model="form.full_name"
                  label="Full Name"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Name is required']"
                />
              </div>

              <div class="col-12 col-md-6">
                <q-input
                  v-model="form.phone"
                  label="Student Phone"
                  outlined
                  dense
                  mask="###-#######"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input v-model="form.email" label="Email" type="email" outlined dense />
              </div>

              <div class="col-12 col-md-6">
                <q-input v-model="form.parent_name" label="Parent Name" outlined dense />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="form.parent_phone"
                  label="Parent Phone"
                  outlined
                  dense
                  mask="###-#######"
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
                <q-input v-model="form.school" label="School" outlined dense />
              </div>
            </div>

            <div class="row justify-end q-gutter-sm q-mt-xl">
              <q-btn label="Cancel" color="grey" flat v-close-popup />
              <q-btn
                :label="isEdit ? 'Update' : 'Save'"
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
import { useQuasar, date } from 'quasar'

const $q = useQuasar()
const students = ref([])
const loading = ref(false)
const filter = ref('')
const dialogVisible = ref(false)
const isEdit = ref(false)
const saving = ref(false)

const form = ref({
  id: null,
  full_name: '',
  email: '',
  phone: '',
  parent_name: '',
  parent_phone: '',
  grade: '',
  school: '',
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

const columns = [
  { name: 'full_name', align: 'left', label: 'Student Name', field: 'full_name', sortable: true },
  { name: 'phone', align: 'left', label: 'Phone', field: 'phone' },
  { name: 'parent_name', align: 'left', label: 'Parent Name', field: 'parent_name' },
  { name: 'grade', align: 'left', label: 'Grade', field: 'grade', sortable: true },
  { name: 'school', align: 'left', label: 'School', field: 'school', sortable: true },
  { name: 'joined_date', align: 'left', label: 'Joined', field: 'joined_date', sortable: true },
  { name: 'actions', align: 'center', label: 'Actions', field: 'actions' },
]

function openAddDialog() {
  isEdit.value = false
  form.value = {
    id: null,
    full_name: '',
    email: '',
    phone: '',
    parent_name: '',
    parent_phone: '',
    grade: '',
    school: '',
  }
  dialogVisible.value = true
}

function editStudent(row) {
  isEdit.value = true
  form.value = { ...row }
  dialogVisible.value = true
}

async function fetchStudents() {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('students')
      .select('*')
      .order('created_at', { ascending: false })
    if (error) throw error
    students.value = data
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Failed to fetch students' })
    console.error(err)
  } finally {
    loading.value = false
  }
}

async function saveStudent() {
  saving.value = true
  try {
    if (isEdit.value) {
      const { error } = await supabase
        .from('students')
        .update({
          full_name: form.value.full_name,
          email: form.value.email,
          phone: form.value.phone,
          parent_name: form.value.parent_name,
          parent_phone: form.value.parent_phone,
          grade: form.value.grade,
          school: form.value.school,
        })
        .eq('id', form.value.id)
      if (error) throw error
      $q.notify({ type: 'positive', message: 'Student updated successfully' })
    } else {
      const { error } = await supabase.from('students').insert([
        {
          full_name: form.value.full_name,
          email: form.value.email,
          phone: form.value.phone,
          parent_name: form.value.parent_name,
          parent_phone: form.value.parent_phone,
          grade: form.value.grade,
          school: form.value.school,
        },
      ])
      if (error) throw error
      $q.notify({ type: 'positive', message: 'Student added successfully' })
    }
    dialogVisible.value = false
    fetchStudents()
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Error saving student' })
    console.error(err)
  } finally {
    saving.value = false
  }
}

async function deleteStudent(id) {
  try {
    // Check for related records in payments and attendance
    const { count: paymentCount, error: paymentError } = await supabase
      .from('payments')
      .select('*', { count: 'exact', head: true })
      .eq('student_id', id)

    const { count: attendanceCount, error: attendanceError } = await supabase
      .from('attendance')
      .select('*', { count: 'exact', head: true })
      .eq('student_id', id)

    if (paymentError) throw paymentError
    if (attendanceError) throw attendanceError

    const hasRelated = (paymentCount || 0) > 0 || (attendanceCount || 0) > 0

    let confirmMessage = 'Are you sure you want to delete this student?'
    if (hasRelated) {
      confirmMessage = `Warning: This student has ${paymentCount} payments and ${attendanceCount} attendance records. Deleting will permanently remove ALL their history. Continue?`
    }

    $q.dialog({
      title: 'Confirm Deletion',
      message: confirmMessage,
      cancel: true,
      persistent: true,
      ok: {
        label: 'Delete',
        color: 'negative',
      },
    }).onOk(async () => {
      try {
        // Manual Cascade Delete if confirmed
        if (paymentCount > 0) {
          const { error } = await supabase.from('payments').delete().eq('student_id', id)
          if (error) throw error
        }

        if (attendanceCount > 0) {
          const { error } = await supabase.from('attendance').delete().eq('student_id', id)
          if (error) throw error
        }

        // Delete the student
        const { error } = await supabase.from('students').delete().eq('id', id)
        if (error) throw error

        $q.notify({ type: 'positive', message: 'Student and related records deleted' })
        fetchStudents()
      } catch (err) {
        const errorMsg = err.message || 'Unknown error'
        const errorDetails = err.details || ''
        const errorHint = err.hint || ''

        $q.notify({
          type: 'negative',
          message: `Failed to delete: ${errorMsg}`,
          caption: errorDetails ? `${errorDetails} ${errorHint}` : undefined,
          timeout: 5000,
          actions: [{ label: 'Dismiss', color: 'white' }],
        })
        console.error('Delete error full object:', err)
      }
    })
  } catch (err) {
    const errorMsg = err.message || 'Unknown error'
    $q.notify({ type: 'negative', message: `Database Error: ${errorMsg}` })
    console.error(err)
  }
}

function formatDate(dateStr) {
  if (!dateStr) return '-'
  return date.formatDate(dateStr, 'YYYY-MM-DD')
}

onMounted(() => {
  fetchStudents()
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
