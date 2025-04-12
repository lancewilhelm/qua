<script setup lang="ts">
import type { SelectProjects } from "~/utils/db/schema";

const props = defineProps<{
  open: boolean;
  title: string;
  submitButton: string;
}>();

const project = defineModel<Partial<SelectProjects> | null>("project");

const emit = defineEmits(["submit", "close"]);

const tagInput = ref("");

function deleteTag(tag: string) {
  if (!project.value?.tags) return;
  project.value.tags = project.value.tags.filter((t) => t !== tag);
}

function closeModal() {
  tagInput.value = "";
  emit("close");
}

const nameRef = ref<HTMLInputElement | null>(null);

watch(
  () => props.open,
  () => {
    if (props.open) {
      nextTick(() => {
        nameRef.value?.focus();
      });
    }
  },
);
</script>

<template>
  <BaseModal
    v-if="open && project"
    @close="closeModal"
    @submit="$emit('submit')"
  >
    <div class="font-bold text-lg">{{ title }}</div>
    <form class="grid justify-center items-center grid-cols-1">
      <div class="font-mono text-(--main-color) text-left">name</div>
      <input
        ref="nameRef"
        v-model="project.name"
        type="text"
        autocomplete="off"
        placeholder="project name"
        name="name"
      />
      <div class="font-mono text-(--main-color) text-left">descritpion</div>
      <textarea
        v-model="project.description"
        placeholder="project description"
        name="description"
        rows="7"
        maxlength="250"
      />
      <div class="font-mono text-(--main-color) text-left">tags</div>
      <div class="flex flex-row items-start mb-1">
        <input
          v-model="tagInput"
          type="text"
          autocomplete="off"
          class="w-36 mr-2"
          placeholder="enter tag"
          name="tags"
          @keydown.enter.stop="
            () => {
              if (tagInput !== '') {
                project?.tags?.push(tagInput);
                tagInput = '';
              }
            }
          "
        />
        <div class="flex flex-wrap self-center ml-2">
          <div
            v-for="tag in project.tags"
            :key="tag"
            class="flex gap-1 bg-(--main-color) text-(--bg-color) rounded-lg py-1 px-2 text-xs font-bold m-0.5"
          >
            {{ tag }}
            <div
              class="cursor-pointer hover:text-error active:text-error-extra"
              @click="deleteTag(tag)"
            >
              <Icon name="fa6-solid:xmark" />
            </div>
          </div>
        </div>
      </div>
      <div class="grid gap-4 grid-cols-2">
        <button type="button" class="modal-btn" @click="closeModal">
          cancel
        </button>
        <button type="button" class="modal-btn" @click="$emit('submit')">
          {{ submitButton }}
        </button>
      </div>
    </form>
  </BaseModal>
</template>
