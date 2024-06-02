const animate = require("tailwindcss-animate")

/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: false,

  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    fontFamily: {
      mono: ['"Roboto Mono"', 'ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', '"Liberation Mono"', '"Courier New"', 'monospace'],
      alt: ['Poppins', 'ui-sans-serif', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'Noto Sans', 'sans-serif'],
    },
    extend: {
      gridTemplateColumns: {
        'color-picker': '1fr auto',
        'code-group': 'auto 1fr',
        'quote-item': '1fr 3fr',
        'code-page': 'auto auto 1fr auto auto',
        '1.5fr-1fr': '1.5fr 1fr',
        'theme-buttons': 'repeat(auto-fit, minmax(17rem, 1fr))',
      },
      gridTemplateRows: {
        'grid': '[title-start] auto [projects-start] 1fr [new-proj-start] auto [new-proj-end]',
        'auto-1fr': 'auto 1fr',
      },
      spacing: {
        '4.5': '1.125rem',
      },
      gridColumn: {
        'content': 'content',
      },
      gridRowStart: {
        'content-end': 'content-end',
        'padding-start': 'padding-start',
      },
      translate: {
        '2px': '2px',
        '3px': '3px',
      },
      borderWidth: {
        '1': '1px',
        '3': '3px'
      },
      boxShadow: {
        '68-solid': '6px 8px 0px rgb(0, 0, 0)',
        '46-solid': '4px 6px 0px rgb(0, 0, 0)',
        '35-solid': '3px 5px 0px rgb(0, 0, 0)',
        '23-solid': '2px 3px 0px rgb(0, 0, 0)',
        '12-solid': '1px 2px 0px rgb(0, 0, 0)',
      },
      fontSize: {
        'logo': ['2.5rem', '3.4rem'],
      },
      colors: {
        bg: "var(--bg-color)",
        main: "var(--main-color)",
        caret: "var(--caret-color)",
        sub: "var(--sub-color)",
        'sub-alt': "var(--sub-alt-color)",
        text: "var(--text-color)",
        error: "var(--error-color)",
        'error-extra': "var(--error-extra-color)",
        'colorful-error': "var(--colorful-error-color)",
        'colorful-error-extra': "var(--colorful-error-extra-color)",
      },
      borderRadius: {
        xl: "calc(var(--radius) + 4px)",
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: 0 },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: 0 },
        },
        "collapsible-down": {
          from: { height: 0 },
          to: { height: 'var(--radix-collapsible-content-height)' },
        },
        "collapsible-up": {
          from: { height: 'var(--radix-collapsible-content-height)' },
          to: { height: 0 },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
        "collapsible-down": "collapsible-down 0.2s ease-in-out",
        "collapsible-up": "collapsible-up 0.2s ease-in-out",
      },
    },
  },
  plugins: [animate],
}