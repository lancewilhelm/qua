import { logger } from "~/utils/logger";
import { auth } from "~/utils/auth";
import { projects } from "~/utils/db/schema";
import { cloudDb } from "~/utils/db/cloud";
import { eq } from "drizzle-orm";

export default defineEventHandler(async (event) => {
  logger.info("DELETE /api/projects");

  // Check for authorized user
  const session = await auth.api.getSession({
    headers: event.headers,
  });

  if (!session) {
    logger.error("DELETE /api/projects: Unauthorized access attempt");
    setResponseStatus(event, 401);
    return {
      message: "Unauthorized",
    };
  }

  // const userId = session.user.id;

  // Parse the request body
  const { id }: { id: string } = await readBody(event);

  if (!id) {
    logger.error("DELETE /api/projects: Invalid request, project Id required");
    setResponseStatus(event, 400);
    return { message: "Invalid request: name required" };
  }

  try {
    await cloudDb.delete(projects).where(eq(projects.id, id));

    return { success: true };
  } catch (error) {
    logger.error(error, "DELETE /api/projects: Error deleting project");
    setResponseStatus(event, 500);
    return { message: "Internal server error" };
  }
});
