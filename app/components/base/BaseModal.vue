<script setup lang="ts">
const emit = defineEmits(["close", "submit"]);

document.addEventListener("keydown", (event: KeyboardEvent) => {
  if (event.key === "Escape") {
    if (
      event.target instanceof HTMLTextAreaElement ||
      event.target instanceof HTMLInputElement
    ) {
      event.target.blur();
    } else {
      emit("close");
    }
  } else if (event.key === "Enter") {
    if (
      event.target instanceof HTMLTextAreaElement ||
      event.target instanceof HTMLInputElement
    ) {
      event.target.blur();
    } else {
      emit("submit");
    }
  }
});
</script>

<template>
  <div
    id="modal"
    class="fixed flex items-center justify-center z-20 left-0 top-0 w-full h-full overflow-auto bg-black/60"
    @click="emit('close')"
  >
    <div
      id="modal-content"
      class="flex flex-col bg-(--bg-color) p-5 rounded-lg w-96 shadow-[6px_8px_0px_black] text-text"
      @click.stop
    >
      <slot />
    </div>
  </div>
</template>
