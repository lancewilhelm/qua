import { logger } from "~/utils/logger";
import { auth } from "~/utils/auth";
import { projects } from "~/utils/db/schema";
import { cloudDb } from "~/utils/db/cloud";

export default defineEventHandler(async (event) => {
  logger.info("POST /api/projects");

  // Check for authorized user
  const session = await auth.api.getSession({
    headers: event.headers,
  });

  if (!session) {
    logger.error("POST /api/projects: Unauthorized access attempt");
    setResponseStatus(event, 401);
    return {
      message: "Unauthorized",
    };
  }

  const userId = session.user.id;

  // Parse the request body
  const {
    name,
    description,
    tags,
  }: { name: string; description: string; tags: string[] } =
    await readBody(event);

  if (!name) {
    logger.error("POST /api/projects: Invalid request, name required");
    setResponseStatus(event, 400);
    return { message: "Invalid request: name required" };
  }

  try {
    const result = await cloudDb
      .insert(projects)
      .values({ name, description, tags, createdBy: userId })
      .returning();

    return { result: result[0], success: true };
  } catch (error) {
    logger.error(error, "POST /api/projects: Error creating project");
    setResponseStatus(event, 500);
    return { message: "Internal server error" };
  }
});
