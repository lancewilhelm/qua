![qua](./logo.png)

![Nuxt](https://img.shields.io/badge/Nuxt-%23010113?style=for-the-badge&logo=nuxtdotjs)
![Vue](https://img.shields.io/badge/Vue-%23191A22?style=for-the-badge&logo=vuedotjs)
![Supabase](https://img.shields.io/badge/Supabase-%230E0E10?style=for-the-badge&logo=supabase)

Open source QDA software, because I don't want to pay for one and I got tired of using excel.

That should do it for now...more to come.

# running locally

If you are going to develop this project yourself, you will need to create a `.env` file in the root of the project with the following content:

```
SUPABASE_URL=https://your-supabase-url.supabase.co (replace with your supabase url)
SUPABASE_KEY=your-supabase-key (replace with your supabase key)
BASE_URL=http://localhost:3000 (replace with your local development url)
SUPABASE_AUTH_GITHUB_CLIENT_ID=your-github-client-id (optional if using github auth)
SUPABASE_AUTH_GITHUB_CLIENT_SECRET=your-github-client-secret (optional if using github auth)
LOCAL_DEV=true (optional if you will be resetting your database often)
```

The `LOCAL_DEV` variable was created to handle local Supabase storage. When initializing the local Supabase instance, there is currently no way to popultate objects in the `files` storage bucket. This flag points the application to use data from the `public/samples/` directory instead of fetching a signed url from the Supabase storage endpoint. Keep this in mind if you plan to upload data locally as the data will not be able to be accessed. Reference the [FileViewerPanel](./components/FileViewerPanel.vue) component for this implementation.

## Supabase

This project takes advantage of [Supabase](https://supabase.com/) for authentication, database, and storage for now. You have two options for setting up Supabase:

1) Create a project on [Supabase](https://supabase.com/) and use the provided URL and key in your `.env` file. All data will be stored in your Supabase project on their servers. **TODO: Need to add information on how to set up the database schema.**
2) Run a local instance of Supabase using [Supabase CLI](https://supabase.com/docs/guides/cli/local-development). Grab the URL and key from the CLI output and use them in your `.env` file. All data will be stored locally on your machine. This is recommended for development as this repo contains migrations and seed information in [./supabase](./supabase/). **Not recommended for long term usage as you may lose your data if you are not careful. Instead, use the Supabase Platform resources to ensure your data is backed up, i.e. option 1.** (Requires Docker)

Once you have set up Supabase, you can start the application locally.

## running the app

Make sure to install the dependencies:

```bash
# npm
npm install
```

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev
```

You may want to change the host to `127.0.0.1` if `localhost` is acting slow for you.

## production / deployment

Check out the [Nuxt deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information on building and deploying. This project is currently configured for client-side-rendering (CSR) only so you can serve it or deploy it on any static hosting provider.
