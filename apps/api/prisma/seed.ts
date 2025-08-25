import { PrismaClient } from '../generated/prisma';

const prisma = new PrismaClient();

async function main() {
  // Create Plans
  await prisma.plan.upsert({
    where: { code: 'FREE' },
    update: {},
    create: {
      code: 'FREE',
      name: 'Free Plan',
      priceCents: 0,
      currency: 'USD',
      interval: 'LIFETIME',
      featuresJson: {},
      isActive: true,
    },
  });

  await prisma.plan.upsert({
    where: { code: 'PRO' },
    update: {},
    create: {
      code: 'PRO',
      name: 'Pro Plan',
      priceCents: 999, // 9.99 USD
      currency: 'USD',
      interval: 'MONTHLY',
      featuresJson: {},
      isActive: true,
    },
  });

  // Create System Categories
  const systemCategories = [
    { code: 'HOUSING', name: 'Housing', icon: '🏠' },
    { code: 'FOOD', name: 'Food', icon: '🍔' },
    { code: 'TRANSPORTATION', name: 'Transportation', icon: '🚗' },
    { code: 'UTILITIES', name: 'Utilities', icon: '💡' },
    { code: 'SHOPPING', name: 'Shopping', icon: '🛍️' },
    { code: 'ENTERTAINMENT', name: 'Entertainment', icon: '🎉' },
    { code: 'HEALTH', name: 'Health', icon: '🏥' },
    { code: 'EDUCATION', name: 'Education', icon: '📚' },
    { code: 'TRAVEL', name: 'Travel', icon: '✈️' },
    { code: 'OTHER', name: 'Other', icon: '❓' },
  ];

  for (const category of systemCategories) {
    await prisma.category.upsert({
      where: { code: category.code },
      update: {},
      create: {
        code: category.code,
        name: category.name,
        icon: category.icon,
        isSystem: true,
      },
    });
  }

  console.log('Seed data created successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });