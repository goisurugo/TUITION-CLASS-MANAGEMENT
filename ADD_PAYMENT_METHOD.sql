-- Add payment_method column to payments table
ALTER TABLE public.payments 
ADD COLUMN IF NOT EXISTS payment_method text DEFAULT 'Cash';

-- Update the existing records to have 'Cash' as default if null (though default handles new ones)
UPDATE public.payments SET payment_method = 'Cash' WHERE payment_method IS NULL;
