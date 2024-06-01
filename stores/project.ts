// stores/project.js
import { defineStore } from 'pinia';

export const useProjectStore = defineStore('currentProject', {
    state: () => ({
        currentProject: import.meta.client ? JSON.parse(localStorage.getItem('currentProject')) || null : null,
    }),
    actions: {
        setCurrentProject(project: Object) {
            this.currentProject = project;
            localStorage.setItem('currentProject', JSON.stringify(project));
        },
        clearCurrentProject() {
            this.currentProject = null;
            localStorage.removeItem('currentProject');
        },
        listenToStorageChanges() {
            window.addEventListener('storage', (event) => {
                if (event.key === 'currentProject') {
                    this.currentProject = event.newValue;
                }
            });
        }
    }
});
