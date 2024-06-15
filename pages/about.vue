<script setup lang="ts">
</script>

<template>
  <div class="grid gap-4 narrow-width scroll">
    <div class="text-2xl font-mono text-main font-black">
      what is <span id="title">qua</span>?
    </div>
    <div class="font-mono text-xl mb-4">
      <span id="title">qua</span> is a web-based platform for performing qualitative analysis for research projects. Often, us who have built this tool used complicated pay-to-use software, free but limited software, or even worse, spreadsheets for our qualitative analysis. We wanted to build a tool that was free, open-source, and easy to use. We hope that you enjoy using <span id="title">qua</span> as much as we enjoyed building it.
    </div>
    <div class="text-2xl font-mono text-main font-black">
      how do I use <span id="title">qua</span>?
    </div>
    <div class="font-mono text-xl mb-4">
      To use <span id="title">qua</span>, you must first create an account. Once you have created an account, you can create projects where you upload your data for analysis. Once you have added data to your project, you can begin coding your data (more on coding below...). After you have coded your data, you can begin analysis with the codebook you have created. We have built in some primitive and experimental tools to help with this process. We hope to add more tools in the future. Once you have finished your analysis, you can export your data and analysis for use in your research.
    </div>
    <div class="text-2xl font-mono text-main font-black">
      what is coding?
    </div>
    <div class="font-mono text-xl mb-4">
      TEMP: Coding is the process of labeling data with a code. For example, if you have a transcript of an interview, you might code a section of the transcript with the code "positive" if the interviewee said something positive. Coding is a way to organize your data for analysis. You can create as many codes as you like and apply them to your data as you see fit. (add some more from literature of the open coding process, grounded theory, etc.)
    </div>
    <div class="text-2xl font-mono text-main font-black">
      what are some tools in <span id="title">qua</span>?
    </div>
    <div class="font-mono text-xl mb-4">
      TEMP: We have built in some primitive and experimental tools to help with the qualitative analysis process. We hope to add more tools in the future. Some of the tools we have built in are:
      <ul>
        <li>Codebook: A place to store your codes and their descriptions.</li>
        <li>Code: A place to apply your codes to your data.</li>
        <li>Analysis: A place to view your coded data and perform analysis.</li>
        <li>Export: A place to export your data and analysis for use in your research.</li>
      </ul>
    </div>
    <div class="text-2xl font-mono text-main font-black">
      who built <span id="title">qua</span>?
    </div>
    <div class="font-mono text-xl mb-4">
      <span id="title">qua</span> was built by <a href="https://lancewilhelm.com">Lance</a>
    </div>
    <div class="text-2xl font-mono text-main font-black">
      how can I contribute to <span id="title">qua</span>?
    </div>
    <div class="font-mono text-xl mb-4">
      <span id="title">qua</span> is an open-source project. You can contribute to the project by visiting the <a href="https://github.com/lancewilhelm/qua">GitHub repository</a>. We welcome all contributions, big and small. If you have an idea for a feature, a bug to report, or a code improvement, please feel free to contribute.
    </div>
    <div class="text-2xl font-mono text-main font-black">
      disclaimer
    </div>
    <div class="font-mono text-xl mb-4">
      <span id="title">qua</span> is an experimental project. If your work is important to you, please make sure to back up your data. We are not responsible for any data loss or corruption.
    </div>
  </div>
</template>

<style scoped>
#title {
    font-family: var(--alt-font-family);
    font-weight: 600;
    color: var(--main-color);
}
</style>