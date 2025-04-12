ALTER TABLE `code_instances` ADD `updated_at` integer NOT NULL;--> statement-breakpoint
ALTER TABLE `codes` ADD `updated_at` integer NOT NULL;--> statement-breakpoint
ALTER TABLE `files` ADD `updated_at` integer NOT NULL;--> statement-breakpoint
ALTER TABLE `projects` ADD `updated_at` integer NOT NULL;