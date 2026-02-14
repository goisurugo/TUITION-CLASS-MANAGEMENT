<template>
  <q-page class="q-pa-md bg-grey-1">
    <div class="row q-mb-md items-center justify-between">
      <div>
        <h4 class="text-h4 text-weight-bolder q-my-none text-dark">
          Payments <span class="text-secondary">Records</span>
        </h4>
        <div class="text-grey-7 text-subtitle1">Manage student fee payments</div>
      </div>
      <q-btn
        color="secondary"
        text-color="dark"
        icon="add"
        label="New Payment"
        rounded
        unelevated
        class="shadow-3 text-weight-bold"
        @click="openAddDialog"
      />
      <q-btn
        color="primary"
        text-color="white"
        icon="download"
        label="Export CSV"
        rounded
        unelevated
        class="shadow-3 text-weight-bold q-ml-sm"
        @click="exportToCsv"
      />
    </div>

    <!-- Filters & Table -->
    <q-card class="shadow-2 rounded-borders">
      <q-table
        :rows="payments"
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
            placeholder="Search Payments"
            rounded
            outlined
            bg-color="white"
          >
            <template v-slot:append>
              <q-icon name="search" />
            </template>
          </q-input>
        </template>

        <template v-slot:body-cell-student="props">
          <q-td :props="props">
            <div class="text-weight-bold">{{ props.row.students?.full_name || 'Unknown' }}</div>
          </q-td>
        </template>

        <template v-slot:body-cell-course="props">
          <q-td :props="props">
            <q-chip dense color="purple-1" text-color="primary">
              {{ props.row.courses?.name || 'Unknown' }}
            </q-chip>
          </q-td>
        </template>

        <template v-slot:body-cell-amount="props">
          <q-td :props="props">
            <span class="text-green-8 text-weight-bold">
              {{ formatCurrency(props.row.amount) }}
            </span>
          </q-td>
        </template>

        <template v-slot:body-cell-month="props">
          <q-td :props="props">
            <q-badge color="primary" rounded outline>
              {{ formatDateMonth(props.row.month) }}
            </q-badge>
          </q-td>
        </template>

        <template v-slot:body-cell-actions="props">
          <q-td :props="props" align="right">
            <q-btn
              flat
              round
              color="negative"
              icon="delete"
              size="sm"
              @click="deletePayment(props.row.id)"
            />
            <q-btn
              flat
              round
              color="primary"
              icon="receipt"
              size="sm"
              @click="printInvoice(props.row)"
            >
              <q-tooltip>Print Receipt</q-tooltip>
            </q-btn>
          </q-td>
        </template>
      </q-table>
    </q-card>

    <!-- Add Payment Dialog -->
    <q-dialog v-model="dialogVisible" persistent>
      <q-card style="min-width: 600px" class="rounded-borders">
        <q-card-section class="bg-secondary text-dark row items-center q-py-sm">
          <div class="text-h6 text-weight-bold">Record Payment</div>
          <q-space />
          <q-btn icon="close" flat round dense v-close-popup />
        </q-card-section>

        <q-separator />

        <q-card-section class="q-pa-lg">
          <q-form @submit="savePayment">
            <div class="row q-col-gutter-md">
              <div class="col-12">
                <q-select
                  v-model="form.student_id"
                  :options="studentOptions"
                  option-value="id"
                  :option-label="(item) => `${item.full_name} (${item.id.slice(0, 8)})`"
                  label="Select Student (Name or ID)"
                  outlined
                  dense
                  use-input
                  input-debounce="0"
                  @filter="filterStudents"
                  emit-value
                  map-options
                  :rules="[(val) => !!val || 'Please select a student']"
                >
                  <template v-slot:option="scope">
                    <q-item v-bind="scope.itemProps">
                      <q-item-section>
                        <q-item-label>{{ scope.opt.full_name }}</q-item-label>
                        <q-item-label caption
                          >ID: {{ scope.opt.id.slice(0, 8) }} | Grade:
                          {{ scope.opt.grade }}</q-item-label
                        >
                      </q-item-section>
                    </q-item>
                  </template>
                </q-select>
              </div>

              <div class="col-12">
                <q-select
                  v-model="form.course_id"
                  :options="courseOptions"
                  option-value="id"
                  option-label="name"
                  label="Select Course"
                  outlined
                  dense
                  emit-value
                  map-options
                  @update:model-value="onCourseSelect"
                  :rules="[(val) => !!val || 'Please select a course']"
                />
              </div>

              <div class="col-12 col-md-6">
                <q-input
                  v-model="form.month"
                  type="month"
                  label="Payment Month"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Month is required']"
                />
              </div>
              <div class="col-12 col-md-6">
                <q-input
                  v-model="form.amount"
                  label="Amount (LKR)"
                  type="number"
                  outlined
                  dense
                  prefix="Rs."
                  :rules="[(val) => !!val || 'Amount is required']"
                />
              </div>

              <div class="col-12 col-md-6">
                <q-select
                  v-model="form.payment_method"
                  :options="['Cash', 'Visa', 'MasterCard', 'Bank Transfer']"
                  label="Payment Method"
                  outlined
                  dense
                  :rules="[(val) => !!val || 'Method is required']"
                />
              </div>

              <div class="col-12">
                <q-input
                  v-model="form.remarks"
                  label="Remarks (Optional)"
                  outlined
                  dense
                  type="textarea"
                  rows="2"
                />
              </div>
            </div>

            <div class="row justify-end q-gutter-sm q-mt-xl">
              <q-btn label="Cancel" color="grey" flat v-close-popup />
              <q-btn
                label="Save Payment"
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

    <!-- Hidden Receipt Template for Printing -->
    <div id="receipt-container" class="print-only">
      <div v-if="receiptData" class="receipt-box">
        <div class="header">
          <div class="logo">
            <q-icon name="school" size="md" />
          </div>
          <div class="title">ISURU LMS</div>
          <div class="subtitle">Tuition Class Management</div>
          <div class="contact">Tel: 077-1234567</div>
        </div>

        <div class="divider"></div>

        <div class="details">
          <div class="row">
            <span>Date:</span>
            <span>{{ formatDate(receiptData.paid_date) }}</span>
          </div>
          <div class="row">
            <span>Receipt No:</span>
            <span>#{{ receiptData.id.slice(0, 6) }}</span>
          </div>
          <div class="row">
            <span>Student:</span>
            <span>{{ receiptData.students?.full_name }}</span>
          </div>
          <div class="row">
            <span>ID:</span>
            <span>{{ receiptData.students?.id.slice(0, 8) }}</span>
          </div>
        </div>

        <div class="divider"></div>

        <div class="items">
          <div class="row header-row">
            <span>Description</span>
            <span>Amount</span>
          </div>
          <div class="row">
            <span>{{ receiptData.courses?.name }} ({{ formatDateMonth(receiptData.month) }})</span>
            <span>{{ formatCurrency(receiptData.amount) }}</span>
          </div>
        </div>

        <div class="divider bottom"></div>

        <div class="total">
          <div class="row">
            <span>TOTAL</span>
            <span class="highlight">{{ formatCurrency(receiptData.amount) }}</span>
          </div>
          <div class="row method">
            <span>Paid by:</span>
            <span>{{ receiptData.payment_method }}</span>
          </div>
        </div>

        <div class="footer">
          <div>Thank you!</div>
          <div class="software">Powered by ClassMaster LMS</div>
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from 'src/boot/supabase'
import { useQuasar, date, exportFile } from 'quasar'

const $q = useQuasar()
const payments = ref([])
const loading = ref(false)
const filter = ref('')
const dialogVisible = ref(false)
const saving = ref(false)
const receiptData = ref(null)

// Select Options
const allStudents = ref([])
const studentOptions = ref([])
const courseOptions = ref([])

const form = ref({
  student_id: null,
  course_id: null,
  month: date.formatDate(Date.now(), 'YYYY-MM'),
  amount: '',
  payment_method: 'Cash',
  remarks: '',
})

const columns = [
  {
    name: 'student',
    align: 'left',
    label: 'Student',
    field: (row) => row.students?.full_name,
    sortable: true,
  },
  {
    name: 'course',
    align: 'left',
    label: 'Course',
    field: (row) => row.courses?.name,
    sortable: true,
  },
  { name: 'month', align: 'left', label: 'Month', field: 'month', sortable: true },
  { name: 'paid_date', align: 'left', label: 'Paid Date', field: 'paid_date', sortable: true },
  { name: 'amount', align: 'right', label: 'Amount', field: 'amount', sortable: true },
  {
    name: 'payment_method',
    align: 'center',
    label: 'Method',
    field: 'payment_method',
    sortable: true,
  },
  { name: 'actions', align: 'center', label: '', field: 'actions' },
]

function formatCurrency(value) {
  if (!value) return 'Rs. 0.00'
  return new Intl.NumberFormat('en-LK', { style: 'currency', currency: 'LKR' }).format(value)
}

function formatDateMonth(monthStr) {
  if (!monthStr) return ''
  // Convert YYYY-MM to readable format e.g. "October 2023"
  const [year, month] = monthStr.split('-')
  const d = new Date(year, month - 1)
  return d.toLocaleString('default', { month: 'long', year: 'numeric' })
}

function formatDate(dateStr) {
  return date.formatDate(dateStr, 'YYYY-MM-DD HH:mm')
}

async function fetchPayments() {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('payments')
      .select('*, students(full_name), courses(name)')
      .order('created_at', { ascending: false })

    if (error) throw error
    payments.value = data
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Failed to fetch payments' })
    console.error(err)
  } finally {
    loading.value = false
  }
}

async function fetchDropdownData() {
  try {
    const { data: students } = await supabase
      .from('students')
      .select('id, full_name, grade')
      .order('full_name')
    allStudents.value = students || []

    const { data: courses } = await supabase
      .from('courses')
      .select('id, name, fee, grade')
      .order('name')
    courseOptions.value = courses || []
  } catch (err) {
    console.error('Error fetching dropdowns:', err)
  }
}

function filterStudents(val, update) {
  if (val === '') {
    update(() => {
      studentOptions.value = allStudents.value
    })
    return
  }

  update(() => {
    const needle = val.toLowerCase()
    studentOptions.value = allStudents.value.filter(
      (v) =>
        v.full_name.toLowerCase().indexOf(needle) > -1 || v.id.toLowerCase().indexOf(needle) > -1,
    )
  })
}

import { watch } from 'vue'

// Auto-fill Logic
watch(
  () => form.value.student_id,
  (newVal) => {
    if (!newVal) return

    const student = allStudents.value.find((s) => s.id === newVal)
    if (student && student.grade) {
      // Find course matching student grade
      const matchingCourse = courseOptions.value.find((c) => c.grade === student.grade)
      if (matchingCourse) {
        form.value.course_id = matchingCourse.id
        onCourseSelect(matchingCourse.id) // Trigger fee auto-fill
      }
    }
  },
)

function onCourseSelect(courseId) {
  // Auto-fill amount based on course fee if available
  const course = courseOptions.value.find((c) => c.id === courseId)
  if (course && course.fee) {
    form.value.amount = course.fee
  }
}

function openAddDialog() {
  form.value = {
    student_id: null,
    course_id: null,
    month: date.formatDate(Date.now(), 'YYYY-MM'),
    amount: '',
    payment_method: 'Cash',
    remarks: '',
  }
  fetchDropdownData() // Refresh dropdowns
  dialogVisible.value = true
}

async function savePayment() {
  saving.value = true
  try {
    const { error } = await supabase.from('payments').insert([
      {
        student_id: form.value.student_id,
        course_id: form.value.course_id,
        month: form.value.month,
        amount: form.value.amount,
        payment_method: form.value.payment_method,
        remarks: form.value.remarks,
        paid_date: new Date().toISOString(),
      },
    ])

    if (error) throw error

    $q.notify({ type: 'positive', message: 'Payment recorded successfully' })
    dialogVisible.value = false
    fetchPayments()
  } catch (err) {
    $q.notify({ type: 'negative', message: 'Error saving payment' })
    console.error(err)
  } finally {
    saving.value = false
  }
}

function printInvoice(row) {
  receiptData.value = row
  // Allow DOM to update then print
  setTimeout(() => {
    window.print()
  }, 100)
}

function wrapCsvValue(val) {
  let formatted = val === void 0 || val === null ? '' : String(val)
  formatted = formatted.split('"').join('""')
  return `"${formatted}"`
}

function exportToCsv() {
  const content = [columns.map((col) => wrapCsvValue(col.label))]
    .concat(
      payments.value.map((row) =>
        columns
          .map((col) =>
            wrapCsvValue(
              typeof col.field === 'function'
                ? col.field(row)
                : row[col.field === void 0 ? col.name : col.field],
              col.format,
              row,
            ),
          )
          .join(','),
      ),
    )
    .join('\r\n')

  const status = exportFile('payments-export.csv', content, 'text/csv')

  if (status !== true) {
    $q.notify({
      message: 'Browser denied file download...',
      color: 'negative',
      icon: 'warning',
    })
  }
}

async function deletePayment(id) {
  if (!confirm('Are you sure you want to delete this payment record?')) return

  try {
    const { error } = await supabase.from('payments').delete().eq('id', id)
    if (error) throw error
    $q.notify({ type: 'positive', message: 'Record deleted' })
    fetchPayments()
  } catch (err) {
    console.error(err)
    $q.notify({ type: 'negative', message: 'Failed to delete record' })
  }
}

onMounted(() => {
  fetchPayments()
})
</script>

<style scoped>
/* Screen styles */
.print-only {
  display: none;
}

/* Print styles for POS Printer */
@media print {
  body * {
    visibility: hidden;
  }

  #receipt-container,
  #receipt-container * {
    visibility: visible;
  }

  #receipt-container {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%; /* Adapts to printer width setting */
    display: block;
    background: white;
    padding: 0;
    margin: 0;
  }

  .receipt-box {
    width: 100%;
    max-width: 80mm; /* Max width for 80mm printer */
    margin: 0 auto;
    font-family: 'Courier New', Courier, monospace; /* Monospace for alignment */
    font-size: 12px;
    color: black;
    padding-bottom: 20px;
  }

  .header {
    text-align: center;
    margin-bottom: 10px;
  }

  .header .title {
    font-size: 16px;
    font-weight: bold;
    text-transform: uppercase;
  }

  .header .subtitle {
    font-size: 10px;
  }

  .divider {
    border-top: 1px dashed #000;
    margin: 5px 0;
  }

  .divider.bottom {
    border-top: 1px solid #000;
  }

  .details {
    margin-bottom: 5px;
  }

  .row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 2px;
  }

  .items {
    margin-bottom: 5px;
  }

  .header-row {
    font-weight: bold;
    text-transform: uppercase;
  }

  .total {
    margin-top: 5px;
    font-weight: bold;
    font-size: 14px;
  }

  .total .method {
    font-weight: normal;
    font-size: 10px;
    margin-top: 2px;
  }

  .footer {
    text-align: center;
    margin-top: 15px;
    font-size: 10px;
  }

  .footer .software {
    font-size: 8px;
    margin-top: 5px;
    font-style: italic;
  }
}
</style>
