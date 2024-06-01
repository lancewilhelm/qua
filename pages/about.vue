<template>
  <div class="about-page narrow-width scroll">
    <div class="about-title">
      what is <span id="title">qua</span>?
    </div>
    <div class="about-section">
      <span id="title">qua</span> is a web-based platform for performing qualitative analysis for research projects. Often, us who have built this tool used complicated pay-to-use software, free but limited software, or even worse, spreadsheets for our qualitative analysis. We wanted to build a tool that was free, open-source, and easy to use. We hope that you enjoy using <span id="title">qua</span> as much as we enjoyed building it.
    </div>
    <div class="about-title">
      how do I use <span id="title">qua</span>?
    </div>
    <div class="about-section">
      To use <span id="title">qua</span>, you must first create an account. Once you have created an account, you can create projects where you upload your data for analysis. Once you have added data to your project, you can begin coding your data (more on coding below...). After you have coded your data, you can begin analysis with the codebook you have created. We have built in some primitive and experimental tools to help with this process. We hope to add more tools in the future. Once you have finished your analysis, you can export your data and analysis for use in your research.
    </div>
    <div class="about-title">
      what is coding?
    </div>
    <div class="about-section">
      TEMP: Coding is the process of labeling data with a code. For example, if you have a transcript of an interview, you might code a section of the transcript with the code "positive" if the interviewee said something positive. Coding is a way to organize your data for analysis. You can create as many codes as you like and apply them to your data as you see fit. (add some more from literature of the open coding process, grounded theory, etc.)
    </div>
    <div class="about-title">
      what are some tools in <span id="title">qua</span>?
    </div>
    <div class="about-section">
      TEMP: We have built in some primitive and experimental tools to help with the qualitative analysis process. We hope to add more tools in the future. Some of the tools we have built in are:
      <ul>
        <li>Codebook: A place to store your codes and their descriptions.</li>
        <li>Code: A place to apply your codes to your data.</li>
        <li>Analysis: A place to view your coded data and perform analysis.</li>
        <li>Export: A place to export your data and analysis for use in your research.</li>
      </ul>
    </div>
    <div class="about-title">
      who built <span id="title">qua</span>?
    </div>
    <div class="about-section">
      <span id="title">qua</span> was built by <a href="https://lancewilhelm.com">Lance</a>
    </div>
    <div class="about-title">
      how can I contribute to <span id="title">qua</span>?
    </div>
    <div class="about-section">
      <span id="title">qua</span> is an open-source project. You can contribute to the project by visiting the <a href="https://github.com/lancewilhelm/qua">GitHub repository</a>. We welcome all contributions, big and small. If you have an idea for a feature, a bug to report, or a code improvement, please feel free to contribute.
    </div>
    <div class="about-title">
      disclaimer
    </div>
    <div class="about-section">
      <span id="title">qua</span> is an experimental project. If your work is important to you, please make sure to back up your data. We are not responsible for any data loss or corruption.
    </div>
  </div>
</template>

<script setup>
</script>

<style scoped>
.about-page {
    display: grid;
    gap: 1rem;
    height: fit-content;
}

.about-title {
    font-size: 1.7rem;
    font-weight: 900;
    font-family: var(--font-family);
    color: var(--main-color);
}

.about-section {
    font-family: var(--font-family);
    font-size: 1.2rem;
    margin-bottom: 1rem;
}

#title {
    font-family: var(--alt-font-family);
    font-weight: 600;
    color: var(--main-color);
}

</style>