<script setup lang="ts">
import type { Tables } from '~/types/supabase'

defineEmits(['submit'])
const project = defineModel<Tables<'projects'>>('project')
const showModal = defineModel<boolean>('showModal')

defineProps({
    newProject: {
        type: Boolean,
        default: false,
    }
})

const tagInput = ref('')

function deleteTag(tag: string) {
    if (project.value && project.value.tags) {
        project.value.tags = project.value.tags.filter((t) => t !== tag)
    }
}

function closeModal() {
    tagInput.value = ''
    showModal.value = false
}
</script>

<template>
    <BaseModal
        v-if="showModal && project"
        @close="closeModal"
        @submit="$emit('submit')"
    >
        <div class="font-mono font-bold text-lg">{{ newProject ? 'new' : 'edit' }} project</div>
        <form class="grid justify-center items-center grid-cols-1">
            <div class="font-mono text-main text-left">name</div>
            <input
                v-model="project.name"
                type="text"
                autocomplete="off"
                placeholder="project name"
                name="name"
            >
            <div class="font-mono text-main text-left">descritpion</div>
            <textarea
                v-model="project.description"
                placeholder="project description"
                name="description"
                rows="7"
                maxlength="250"
            />
            <div class="font-mono text-main text-left">tags</div>
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
                            if (tagInput !== '' && project?.tags) {
                                project.tags.push(tagInput)
                                tagInput = ''
                            }
                        }
                    "
                >
                <div class="flex flex-row flex-wrap self-center">
                    <div
                        v-for="tag in project.tags"
                        :key="tag"
                        class="flex gap-1 bg-main text-bg rounded-lg py-1 px-2 text-xs font-bold m-0.5"
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
                <button
                    type="button"
                    class="modal-btn"
                    @click="closeModal"
                >
                    cancel
                </button>
                <button
                    type="button"
                    class="modal-btn"
                    @click="$emit('submit')"
                >
                    {{ newProject ? 'create' : 'save' }}
                </button>
            </div>
        </form>
    </BaseModal>
</template>

