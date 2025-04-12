PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_projects` (
	`id` text PRIMARY KEY NOT NULL,
	`created_at` integer NOT NULL,
	`created_by` text,
	`name` text NOT NULL,
	`description` text,
	`members` text,
	`tags` text,
	`parent` text
);
--> statement-breakpoint
INSERT INTO `__new_projects`("id", "created_at", "created_by", "name", "description", "members", "tags", "parent") SELECT "id", "created_at", "created_by", "name", "description", "members", "tags", "parent" FROM `projects`;--> statement-breakpoint
DROP TABLE `projects`;--> statement-breakpoint
ALTER TABLE `__new_projects` RENAME TO `projects`;--> statement-breakpoint
PRAGMA foreign_keys=ON;