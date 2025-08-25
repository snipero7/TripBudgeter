-- CreateTable
CREATE TABLE "public"."users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "name" TEXT NOT NULL,
    "tz" TEXT,
    "locale" TEXT,
    "passwordHash" TEXT,
    "provider" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."roles" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."user_roles" (
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("userId","roleId")
);

-- CreateTable
CREATE TABLE "public"."devices" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fcm_token" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "last_seen_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."plans" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "price_cents" INTEGER NOT NULL,
    "currency" TEXT NOT NULL,
    "interval" TEXT NOT NULL,
    "features_json" JSONB NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."subscriptions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "planId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "start_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3),
    "auto_renew" BOOLEAN NOT NULL,
    "trial_end_at" TIMESTAMP(3),

    CONSTRAINT "subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."invoices" (
    "id" TEXT NOT NULL,
    "subscriptionId" TEXT NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "currency" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "issued_at" TIMESTAMP(3) NOT NULL,
    "paid_at" TIMESTAMP(3),

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."payments" (
    "id" TEXT NOT NULL,
    "invoiceId" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "provider_payment_id" TEXT NOT NULL,
    "amount_cents" INTEGER NOT NULL,
    "currency" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL,
    "captured_at" TIMESTAMP(3),

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."coupons" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "amount_off_cents" INTEGER,
    "percent_off" DOUBLE PRECISION,
    "valid_from" TIMESTAMP(3),
    "valid_until" TIMESTAMP(3),
    "applies_to_plan_id" TEXT,
    "max_redemptions" INTEGER,
    "redeemed_count" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "coupons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."trips" (
    "id" TEXT NOT NULL,
    "ownerId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3),
    "base_currency" TEXT NOT NULL,
    "emergency_pct" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "trips_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."trip_members" (
    "id" TEXT NOT NULL,
    "tripId" TEXT NOT NULL,
    "userId" TEXT,
    "guest_name" TEXT,
    "role" TEXT NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL DEFAULT 1,

    CONSTRAINT "trip_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."categories" (
    "id" TEXT NOT NULL,
    "owner_user_id" TEXT,
    "name" TEXT NOT NULL,
    "icon" TEXT,
    "is_system" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."trip_categories" (
    "id" TEXT NOT NULL,
    "tripId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "budget_cents" INTEGER NOT NULL,

    CONSTRAINT "trip_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."expenses" (
    "id" TEXT NOT NULL,
    "tripId" TEXT NOT NULL,
    "member_payer_id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "currency" TEXT NOT NULL,
    "fx_rate_used" DOUBLE PRECISION,
    "amount_base" INTEGER NOT NULL,
    "spent_at" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "method" TEXT NOT NULL,
    "is_prepaid" BOOLEAN NOT NULL,
    "is_refundable" BOOLEAN NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "expenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."expense_splits" (
    "id" TEXT NOT NULL,
    "expenseId" TEXT NOT NULL,
    "memberId" TEXT NOT NULL,
    "share_base" INTEGER NOT NULL,

    CONSTRAINT "expense_splits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."settlements" (
    "id" TEXT NOT NULL,
    "tripId" TEXT NOT NULL,
    "from_member_id" TEXT NOT NULL,
    "to_member_id" TEXT NOT NULL,
    "amount_base" INTEGER NOT NULL,
    "method" TEXT NOT NULL,
    "settled_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "settlements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."fx_rates" (
    "id" TEXT NOT NULL,
    "base" TEXT NOT NULL,
    "quote" TEXT NOT NULL,
    "rate" DOUBLE PRECISION NOT NULL,
    "as_of_date" TIMESTAMP(3) NOT NULL,
    "source" TEXT NOT NULL,

    CONSTRAINT "fx_rates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."documents" (
    "id" TEXT NOT NULL,
    "tripId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "file_url" TEXT NOT NULL,
    "original_name" TEXT NOT NULL,
    "uploadedBy" TEXT NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."receipts" (
    "id" TEXT NOT NULL,
    "expenseId" TEXT NOT NULL,
    "file_url" TEXT NOT NULL,
    "ocr_text" TEXT,
    "ocr_amount" INTEGER,
    "confidence" DOUBLE PRECISION,

    CONSTRAINT "receipts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ocr_jobs" (
    "id" TEXT NOT NULL,
    "expenseId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "finished_at" TIMESTAMP(3),
    "error" TEXT,

    CONSTRAINT "ocr_jobs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ads_banners" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "image_url" TEXT NOT NULL,
    "link_url" TEXT NOT NULL,
    "placement" TEXT NOT NULL,
    "priority" INTEGER NOT NULL,
    "start_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3) NOT NULL,
    "countries" TEXT[],
    "min_app_version" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "ads_banners_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ads_targets" (
    "id" TEXT NOT NULL,
    "bannerId" TEXT NOT NULL,
    "attribute" TEXT NOT NULL,
    "operator" TEXT NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "ads_targets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."notifications" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "payload_json" JSONB NOT NULL,
    "sent_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."audit_logs" (
    "id" TEXT NOT NULL,
    "actor_user_id" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "metadata_json" JSONB NOT NULL,
    "ip" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "public"."users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "public"."users"("phone");

-- CreateIndex
CREATE INDEX "users_is_active_idx" ON "public"."users"("is_active");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "public"."roles"("name");

-- CreateIndex
CREATE INDEX "user_roles_userId_idx" ON "public"."user_roles"("userId");

-- CreateIndex
CREATE INDEX "user_roles_roleId_idx" ON "public"."user_roles"("roleId");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_userId_roleId_key" ON "public"."user_roles"("userId", "roleId");

-- CreateIndex
CREATE UNIQUE INDEX "devices_fcm_token_key" ON "public"."devices"("fcm_token");

-- CreateIndex
CREATE INDEX "devices_userId_idx" ON "public"."devices"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "plans_code_key" ON "public"."plans"("code");

-- CreateIndex
CREATE INDEX "plans_is_active_idx" ON "public"."plans"("is_active");

-- CreateIndex
CREATE INDEX "subscriptions_userId_idx" ON "public"."subscriptions"("userId");

-- CreateIndex
CREATE INDEX "subscriptions_planId_idx" ON "public"."subscriptions"("planId");

-- CreateIndex
CREATE INDEX "subscriptions_status_idx" ON "public"."subscriptions"("status");

-- CreateIndex
CREATE INDEX "invoices_subscriptionId_idx" ON "public"."invoices"("subscriptionId");

-- CreateIndex
CREATE INDEX "invoices_status_idx" ON "public"."invoices"("status");

-- CreateIndex
CREATE UNIQUE INDEX "payments_provider_payment_id_key" ON "public"."payments"("provider_payment_id");

-- CreateIndex
CREATE INDEX "payments_invoiceId_idx" ON "public"."payments"("invoiceId");

-- CreateIndex
CREATE INDEX "payments_status_idx" ON "public"."payments"("status");

-- CreateIndex
CREATE UNIQUE INDEX "coupons_code_key" ON "public"."coupons"("code");

-- CreateIndex
CREATE INDEX "trips_ownerId_idx" ON "public"."trips"("ownerId");

-- CreateIndex
CREATE INDEX "trips_start_date_idx" ON "public"."trips"("start_date");

-- CreateIndex
CREATE INDEX "trips_end_date_idx" ON "public"."trips"("end_date");

-- CreateIndex
CREATE INDEX "trips_status_idx" ON "public"."trips"("status");

-- CreateIndex
CREATE INDEX "trips_deleted_at_idx" ON "public"."trips"("deleted_at");

-- CreateIndex
CREATE INDEX "trip_members_tripId_idx" ON "public"."trip_members"("tripId");

-- CreateIndex
CREATE INDEX "trip_members_userId_idx" ON "public"."trip_members"("userId");

-- CreateIndex
CREATE INDEX "categories_owner_user_id_idx" ON "public"."categories"("owner_user_id");

-- CreateIndex
CREATE INDEX "categories_is_system_idx" ON "public"."categories"("is_system");

-- CreateIndex
CREATE INDEX "trip_categories_tripId_idx" ON "public"."trip_categories"("tripId");

-- CreateIndex
CREATE INDEX "trip_categories_categoryId_idx" ON "public"."trip_categories"("categoryId");

-- CreateIndex
CREATE UNIQUE INDEX "trip_categories_tripId_categoryId_key" ON "public"."trip_categories"("tripId", "categoryId");

-- CreateIndex
CREATE INDEX "expenses_tripId_idx" ON "public"."expenses"("tripId");

-- CreateIndex
CREATE INDEX "expenses_member_payer_id_idx" ON "public"."expenses"("member_payer_id");

-- CreateIndex
CREATE INDEX "expenses_categoryId_idx" ON "public"."expenses"("categoryId");

-- CreateIndex
CREATE INDEX "expenses_amount_base_idx" ON "public"."expenses"("amount_base");

-- CreateIndex
CREATE INDEX "expenses_spent_at_idx" ON "public"."expenses"("spent_at");

-- CreateIndex
CREATE INDEX "expenses_deleted_at_idx" ON "public"."expenses"("deleted_at");

-- CreateIndex
CREATE INDEX "expense_splits_expenseId_idx" ON "public"."expense_splits"("expenseId");

-- CreateIndex
CREATE INDEX "expense_splits_memberId_idx" ON "public"."expense_splits"("memberId");

-- CreateIndex
CREATE INDEX "settlements_tripId_idx" ON "public"."settlements"("tripId");

-- CreateIndex
CREATE INDEX "settlements_from_member_id_idx" ON "public"."settlements"("from_member_id");

-- CreateIndex
CREATE INDEX "settlements_to_member_id_idx" ON "public"."settlements"("to_member_id");

-- CreateIndex
CREATE INDEX "settlements_settled_at_idx" ON "public"."settlements"("settled_at");

-- CreateIndex
CREATE INDEX "fx_rates_as_of_date_idx" ON "public"."fx_rates"("as_of_date");

-- CreateIndex
CREATE UNIQUE INDEX "fx_rates_base_quote_as_of_date_key" ON "public"."fx_rates"("base", "quote", "as_of_date");

-- CreateIndex
CREATE INDEX "documents_tripId_idx" ON "public"."documents"("tripId");

-- CreateIndex
CREATE UNIQUE INDEX "receipts_expenseId_key" ON "public"."receipts"("expenseId");

-- CreateIndex
CREATE INDEX "receipts_expenseId_idx" ON "public"."receipts"("expenseId");

-- CreateIndex
CREATE UNIQUE INDEX "ocr_jobs_expenseId_key" ON "public"."ocr_jobs"("expenseId");

-- CreateIndex
CREATE INDEX "ocr_jobs_expenseId_idx" ON "public"."ocr_jobs"("expenseId");

-- CreateIndex
CREATE INDEX "ocr_jobs_status_idx" ON "public"."ocr_jobs"("status");

-- CreateIndex
CREATE INDEX "ads_banners_placement_idx" ON "public"."ads_banners"("placement");

-- CreateIndex
CREATE INDEX "ads_banners_priority_idx" ON "public"."ads_banners"("priority");

-- CreateIndex
CREATE INDEX "ads_banners_start_at_idx" ON "public"."ads_banners"("start_at");

-- CreateIndex
CREATE INDEX "ads_banners_end_at_idx" ON "public"."ads_banners"("end_at");

-- CreateIndex
CREATE INDEX "ads_banners_is_active_idx" ON "public"."ads_banners"("is_active");

-- CreateIndex
CREATE INDEX "ads_banners_deleted_at_idx" ON "public"."ads_banners"("deleted_at");

-- CreateIndex
CREATE INDEX "ads_targets_bannerId_idx" ON "public"."ads_targets"("bannerId");

-- CreateIndex
CREATE INDEX "notifications_userId_idx" ON "public"."notifications"("userId");

-- CreateIndex
CREATE INDEX "notifications_sent_at_idx" ON "public"."notifications"("sent_at");

-- CreateIndex
CREATE INDEX "audit_logs_actor_user_id_idx" ON "public"."audit_logs"("actor_user_id");

-- CreateIndex
CREATE INDEX "audit_logs_created_at_idx" ON "public"."audit_logs"("created_at");

-- AddForeignKey
ALTER TABLE "public"."user_roles" ADD CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."user_roles" ADD CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "public"."roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."devices" ADD CONSTRAINT "devices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."subscriptions" ADD CONSTRAINT "subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."subscriptions" ADD CONSTRAINT "subscriptions_planId_fkey" FOREIGN KEY ("planId") REFERENCES "public"."plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."invoices" ADD CONSTRAINT "invoices_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "public"."subscriptions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."payments" ADD CONSTRAINT "payments_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "public"."invoices"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."trips" ADD CONSTRAINT "trips_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."trip_members" ADD CONSTRAINT "trip_members_tripId_fkey" FOREIGN KEY ("tripId") REFERENCES "public"."trips"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."trip_members" ADD CONSTRAINT "trip_members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."trip_categories" ADD CONSTRAINT "trip_categories_tripId_fkey" FOREIGN KEY ("tripId") REFERENCES "public"."trips"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."trip_categories" ADD CONSTRAINT "trip_categories_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."expenses" ADD CONSTRAINT "expenses_tripId_fkey" FOREIGN KEY ("tripId") REFERENCES "public"."trips"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."expenses" ADD CONSTRAINT "expenses_member_payer_id_fkey" FOREIGN KEY ("member_payer_id") REFERENCES "public"."trip_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."expenses" ADD CONSTRAINT "expenses_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."expense_splits" ADD CONSTRAINT "expense_splits_expenseId_fkey" FOREIGN KEY ("expenseId") REFERENCES "public"."expenses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."expense_splits" ADD CONSTRAINT "expense_splits_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "public"."trip_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."settlements" ADD CONSTRAINT "settlements_tripId_fkey" FOREIGN KEY ("tripId") REFERENCES "public"."trips"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."settlements" ADD CONSTRAINT "settlements_from_member_id_fkey" FOREIGN KEY ("from_member_id") REFERENCES "public"."trip_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."settlements" ADD CONSTRAINT "settlements_to_member_id_fkey" FOREIGN KEY ("to_member_id") REFERENCES "public"."trip_members"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."documents" ADD CONSTRAINT "documents_tripId_fkey" FOREIGN KEY ("tripId") REFERENCES "public"."trips"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."receipts" ADD CONSTRAINT "receipts_expenseId_fkey" FOREIGN KEY ("expenseId") REFERENCES "public"."expenses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ocr_jobs" ADD CONSTRAINT "ocr_jobs_expenseId_fkey" FOREIGN KEY ("expenseId") REFERENCES "public"."expenses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ads_targets" ADD CONSTRAINT "ads_targets_bannerId_fkey" FOREIGN KEY ("bannerId") REFERENCES "public"."ads_banners"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."audit_logs" ADD CONSTRAINT "audit_logs_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
