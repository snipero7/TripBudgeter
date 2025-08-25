import { Injectable } from '@nestjs/common';
import * as argon2 from 'argon2';
import { PrismaService } from '../prisma/prisma.service';
import { User } from '../../generated/prisma';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async createUser(data: { email: string; password?: string; name: string }): Promise<User> {
    const hashedPassword = data.password ? await argon2.hash(data.password) : undefined;
    return this.prisma.user.create({
      data: {
        email: data.email,
        passwordHash: hashedPassword,
        name: data.name,
      },
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { email },
    });
  }

  async findById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id },
    });
  }
}
