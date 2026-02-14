import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_KEY
const supabase = createClient(supabaseUrl, supabaseKey)

export default ({ app }) => {
  // for use inside Vue files (Options API) through this.$supabase
  app.config.globalProperties.$supabase = supabase
}

export { supabase }
