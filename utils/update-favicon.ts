export default function () {
    setTimeout(async () => {
        let mainColor, subColor, textColor
        const st = getComputedStyle(document.body)
        mainColor = st.getPropertyValue('--main-color').trim()
        subColor = st.getPropertyValue('--sub-color').trim()
        textColor = st.getPropertyValue('--text-color').trim()

        const svgPre = `
            <svg width="100%" height="100%" viewBox="0 0 200 200" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" xmlns:serif="http://www.serif.com/" style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;">
            <style>
                #bottom {
                    fill: ${mainColor};
                }
                #middle {
                    fill: ${subColor};
                }
                #top {
                    fill: ${textColor};
                }
            </style>
            <g transform="matrix(1,0,0,1,-454.947,0)">
                <g id="favicon3" transform="matrix(1,0,0,1,454.947,0)">
                    <g transform="matrix(16.9605,0,0,16.9605,-969.105,-1567.78)">
                        <rect id="bottom" x="64.517" y="100.207" width="2.052" height="3.106"/>
                    </g>
                    <g transform="matrix(16.9605,0,0,16.9605,-969.105,-1567.78)">
                        <path id="middle" d="M64.517,100.207L64.517,99.281C64.285,99.561 64.003,99.785 63.671,99.953C63.339,100.121 62.961,100.205 62.537,100.205C61.993,100.205 61.489,100.061 61.025,99.773C60.561,99.485 60.191,99.081 59.915,98.561C59.639,98.041 59.501,97.449 59.501,96.785C59.501,96.438 59.539,96.111 59.614,95.803L61.848,95.803C61.834,95.826 61.819,95.849 61.805,95.873C61.661,96.121 61.589,96.425 61.589,96.785C61.589,97.145 61.661,97.447 61.805,97.691C61.949,97.935 62.133,98.119 62.357,98.243C62.581,98.367 62.813,98.429 63.053,98.429C63.293,98.429 63.527,98.367 63.755,98.243C63.983,98.119 64.167,97.933 64.307,97.685C64.447,97.437 64.517,97.133 64.517,96.773C64.517,96.413 64.447,96.111 64.307,95.867C64.295,95.845 64.282,95.824 64.268,95.803L66.569,95.803L66.569,100.207L64.517,100.207Z"/>
                    </g>
                    <g transform="matrix(16.9605,0,0,16.9605,-969.105,-1567.78)">
                        <path id="top" d="M59.614,95.803C59.683,95.522 59.784,95.258 59.915,95.009C60.191,94.489 60.563,94.083 61.031,93.791C61.499,93.499 62.009,93.353 62.561,93.353C62.985,93.353 63.365,93.427 63.701,93.575C64.037,93.723 64.309,93.929 64.517,94.193L64.517,93.425L66.569,93.425L66.569,95.803L64.268,95.803C64.134,95.591 63.965,95.428 63.761,95.315C63.537,95.191 63.301,95.129 63.053,95.129C62.813,95.129 62.581,95.191 62.357,95.315C62.155,95.427 61.985,95.59 61.848,95.803L59.614,95.803Z"/>
                    </g>
                </g>
            </g>
        </svg>`

        const faviconElement = document.getElementById('favicon');
        if (faviconElement) {
            faviconElement.setAttribute('href', 'data:image/svg+xml;base64,' + btoa(svgPre));
        }
    }, 125)
}
