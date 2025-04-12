import { logger } from "~/utils/logger";
import { auth } from "~/utils/auth";
import { type InsertProjects, projects } from "~/utils/db/schema";
import { cloudDb } from "~/utils/db/cloud";
import { sql } from "drizzle-orm";

export function coerceDate(value: unknown): Date {
  if (value instanceof Date) return value;
  if (typeof value === "number" || typeof value === "string")
    return new Date(value);
  return new Date();
}

export default defineEventHandler(async (event) => {
  logger.info("PUT /api/projects");

  // Check for authorized user
  const session = await auth.api.getSession({
    headers: event.headers,
  });

  if (!session) {
    logger.error("PUT /api/projects: Unauthorized access attempt");
    setResponseStatus(event, 401);
    return {
      message: "Unauthorized",
    };
  }

  // const userId = session.user.id;

  // Parse the request body
  const { updates }: { updates: InsertProjects } = await readBody(event);

  if (!updates || !updates.name) {
    logger.error("PUT /api/projects: Invalid request, updates are required");
    setResponseStatus(event, 400);
    return { message: "Invalid request: name required" };
  }

  updates.createdAt = coerceDate(updates.createdAt);
  updates.updatedAt = coerceDate(new Date());

  try {
    const result = await cloudDb
      .insert(projects)
      .values(updates)
      .onConflictDoUpdate({
        target: projects.id,
        set: {
          name: sql.raw("EXCLUDED.name"),
          description: sql.raw("EXCLUDED.description"),
          tags: sql.raw("EXCLUDED.tags"),
          members: sql.raw("EXCLUDED.members"),
          updatedAt: sql.raw("EXCLUDED.updated_at"),
          parent: sql.raw("EXCLUDED.parent"),
        },
      })
      .returning();

    return { result: result[0], success: true };
  } catch (error) {
    logger.error(error, "PUT /api/projects: Error updating project");
    setResponseStatus(event, 500);
    return { message: "Internal server error" };
  }
});
