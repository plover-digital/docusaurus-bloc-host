# Docusaurus Podman container

This container builds and serves a Docusaurus site from a host folder of Markdown files.

Basic idea
- Build an image from `Containerfile`.
- Mount your Markdown folder into the container at `/docs` (or change `DOCS_DIR`).
- The container bootstraps a minimal Docusaurus site (if one isn't present in `/site`), copies your Markdown into the site's `docs/` directory, installs dependencies, builds (or runs dev), and serves the site on port 3000 by default.

Build the image (from repo root):

```bash
podman build -t docusaurus-container -f Containerfile .
```

Run (serve the built site):

```bash
podman run --rm -p 3000:3000 -v /path/to/your/markdown:/docs:Z -e MODE=build docusaurus-container
```

Run in dev mode (hot reload):

```bash
podman run --rm -p 3000:3000 -v /path/to/your/markdown:/docs:Z -e MODE=dev docusaurus-container
```

Notes
- If your host folder already contains a Docusaurus site structure, you can mount it and the script will use it (it only scaffolds when `/site/package.json` is missing).
- The container expects the docs to be at the mount point; it copies files into the internal site to avoid modifying the host files.
- Use `:Z` or `:z` volume mount flags on SELinux systems (like Fedora).

Environment variables
- DOCS_DIR: path inside container to read markdown from (default: `/docs`)
- SITE_DIR: where the Docusaurus site lives inside container (default: `/site`)
- PORT: port to serve on (default: `3000`)
- MODE: `build` or `dev` (default: `build`)

Troubleshooting
- First run will npm install; it can take several minutes. Rebuilding the image with cached node_modules is possible but not included here.
