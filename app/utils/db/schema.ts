import {
  sqliteTable,
  text,
  integer,
  type AnySQLiteColumn,
} from "drizzle-orm/sqlite-core";
import { v4 as uuidv4 } from "uuid";
import type { InferInsertModel, InferSelectModel } from "drizzle-orm";

// Users table for better-auth
export const users = sqliteTable("users", {
  id: text("id").primaryKey(),
  name: text("name").notNull(),
  email: text("email").notNull().unique(),
  emailVerified: integer("email_verified", { mode: "boolean" }).notNull(),
  image: text("image"),
  createdAt: integer("created_at", { mode: "timestamp" }).notNull(),
  updatedAt: integer("updated_at", { mode: "timestamp" }).notNull(),
  role: text("role").notNull(),
});

// Session table for better-auth
export const sessions = sqliteTable("sessions", {
  id: text("id").primaryKey(),
  expiresAt: integer("expires_at", { mode: "timestamp" }).notNull(),
  token: text("token").notNull().unique(),
  createdAt: integer("created_at", { mode: "timestamp" }).notNull(),
  updatedAt: integer("updated_at", { mode: "timestamp" }).notNull(),
  ipAddress: text("ip_address"),
  userAgent: text("user_agent"),
  userId: text("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
});

// Accounts table for better-auth
export const accounts = sqliteTable("accounts", {
  id: text("id").primaryKey(),
  accountId: text("account_id").notNull(),
  providerId: text("provider_id").notNull(),
  userId: text("user_id")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }),
  accessToken: text("access_token"),
  refreshToken: text("refresh_token"),
  idToken: text("id_token"),
  accessTokenExpiresAt: integer("access_token_expires_at", {
    mode: "timestamp",
  }),
  refreshTokenExpiresAt: integer("refresh_token_expires_at", {
    mode: "timestamp",
  }),
  scope: text("scope"),
  password: text("password"),
  createdAt: integer("created_at", { mode: "timestamp" }).notNull(),
  updatedAt: integer("updated_at", { mode: "timestamp" }).notNull(),
});

// Verifications table for better-auth
export const verifications = sqliteTable("verifications", {
  id: text("id").primaryKey(),
  identifier: text("identifier").notNull(),
  value: text("value").notNull(),
  expiresAt: integer("expires_at", { mode: "timestamp" }).notNull(),
  createdAt: integer("created_at", { mode: "timestamp" }),
  updatedAt: integer("updated_at", { mode: "timestamp" }),
});

// Code Instances Table
export const codeInstances = sqliteTable("code_instances", {
  id: text("id")
    .primaryKey()
    .$defaultFn(() => uuidv4()),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  createdBy: text("created_by"), // UUID as text
  codeId: text("code_id").references(() => codes.id, { onDelete: "cascade" }), // Foreign key
  data: text("data"),
  startOffset: integer("start_offset"),
  endOffset: integer("end_offset"),
  fileId: text("file_id").references(() => files.id, { onDelete: "cascade" }), // Foreign key
  importance: integer("importance"), // New column
  memo: text("memo"), // New column
});

// Codes Table
export const codes = sqliteTable("codes", {
  id: text("id")
    .primaryKey()
    .$defaultFn(() => uuidv4()),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  projectId: text("project_id").references(() => projects.id, {
    onDelete: "cascade",
  }), // Foreign key
  code: text("code"),
  color: text("color"),
  parent: text("parent").references((): AnySQLiteColumn => codes.id, {
    onDelete: "cascade",
  }), // Self-referencing foreign key
  createdBy: text("created_by"), // UUID as text
  group: integer("group", { mode: "boolean" }).default(false),
});

// USER SETTINGS TABLE
export const userSettings = sqliteTable("user_settings", {
  userId: text("user_id").primaryKey().unique(),
  settings: text("settings", { mode: "json" }).notNull().default("{}"),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
});

// // Configs Table
// export const configs = sqliteTable("configs", {
//   id: text("id")
//     .primaryKey()
//     .$defaultFn(() => uuidv4()),
//   updatedAt: integer("updated_at", { mode: "timestamp" })
//     .notNull()
//     .$defaultFn(() => new Date()),
//   userId: text("user_id").references(() => users.id, { onDelete: "cascade" }), // Foreign key
//   displayName: text("display_name"),
//   theme: text("theme").default("camping"),
//   favoriteThemes: json("favorite_themes").nullable(), // Consider how to store arrays
//   editorTheme: text("editor_theme").default("theme"),
//   codeFontSize: integer("code_font_size").default(16),
//   codeLineNumbers: boolean("code_line_numbers").default(false),
//   codeFontFamily: text("code_font_family").default("Roboto Mono"),
//   codeLineHeight: integer("code_line_height").default(16),
//   randomTheme: boolean("random_theme").default(false),
//   editorFilePanelWidth: integer("editor_file_panel_width").default(275),
//   editorCodePanelWidth: integer("editor_code_panel_width").default(275),
//   newCodeRandomColor: boolean("new_code_random_color").default(true),
//   codeTextColor: text("code_text_color"), // New column
//   dynamicCodeTextColor: boolean("dynamic_code_text_color").default(true), // New column
//   codeBoxShadow: boolean("code_box_shadow").default(true), // New column
//   codeGroupChildrenCircles: boolean("code_group_children_circles").default(
//     true,
//   ), // New column
//   codeGroupChildrenStats: boolean("code_group_children_stats").default(true), // New column
// });

// Files Table
export const files = sqliteTable("files", {
  id: text("id")
    .primaryKey()
    .$defaultFn(() => uuidv4()),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  createdBy: text("created_by"), // UUID as text
  projectId: text("project_id").references(() => projects.id, {
    onDelete: "cascade",
  }), // Foreign key
  parent: text("parent").references((): AnySQLiteColumn => files.id, {
    onDelete: "cascade",
  }), // Self-referencing foreign key
  name: text("name"),
  type: text("type"),
  folder: integer("folder", { mode: "boolean" }).default(false),
  notes: text("notes"), // New column
});

// Projects Table
export const projects = sqliteTable("projects", {
  id: text("id")
    .primaryKey()
    .$defaultFn(() => uuidv4()),
  createdAt: integer("created_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  createdBy: text("created_by"), // UUID as text
  updatedAt: integer("updated_at", { mode: "timestamp" })
    .notNull()
    .$defaultFn(() => new Date()),
  name: text("name").notNull(),
  description: text("description"),
  members: text("members", { mode: "json" }).$type<string[]>(),
  tags: text("tags", { mode: "json" }).$type<string[]>(),
  parent: text("parent"),
});

// TYPE
export type InsertUserSettings = InferInsertModel<typeof userSettings>;
export type InsertProjects = InferInsertModel<typeof projects>;

export type SelectUserSettings = InferSelectModel<typeof userSettings>;
export type SelectProjects = InferSelectModel<typeof projects>;
