export default function (theme: String) {
    if (import.meta.client) {
        const headScript = document.querySelector('#currentTheme');
        const link = document.createElement('link');
        link.type = 'text/css';
        link.rel = 'stylesheet';
        link.href = `/css/themes/${theme}.css`;
        link.id = 'nextTheme';
        link.onload = () => {
            if (headScript) {
                headScript.remove();
            }
            link.id = 'currentTheme';
        };
        document.head.appendChild(link);
    }
}
