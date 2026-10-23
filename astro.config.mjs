// @ts-check
import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  // Full addresses in the link preview tags need the site's own address
  site: "https://volki-lzkv.ru",
  vite: {
    plugins: [tailwindcss()],
  },
});
