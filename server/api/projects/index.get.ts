import { logger } from "@/utils/logger";
import { projects } from "~/utils/db/schema";
import { cloudDb } from "@/utils/db/cloud";
import { auth } from "~/utils/auth";
import { eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {
  logger.debug("GET /api/projects");

  // Ensure the user is authenticated
  const session = await auth.api.getSession({
    headers: event.headers,
  });

  if (!session) {
    logger.error("GET /api/projects: Unauthorized access attempt");
    setResponseStatus(event, 401);
    return {
      message: "Unauthorized",
    };
  }

  const userId = session.user.id;

  try {
    const projectsResponse = await cloudDb
      .select()
      .from(projects)
      .where(eq(projects.createdBy, userId));

    logger.debug("GET /api/projects: Selected projects");
    return { projects: projectsResponse };
  } catch (error) {
    logger.error(error, "GET /api/projects: Error fetching projects");
    setResponseStatus(event, 500);
    return {
      message: "Internal Server Error",
    };
  }
});
