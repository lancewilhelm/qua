<script setup>
definePageMeta({
    middleware: 'auth',
})

const supabase = useSupabaseClient()
const projectStore = useProjectStore()
const codes = ref([])
let graph

function renderGraph() {
    const container = document.querySelector('.graph-page')
    const data = graph.getGraphData()

    const options = {
        nodes: {
            shape: 'dot',
            size: 20,
            font: {
                size: 20,
            },
        },
        edges: {
            width: 2,
        },
        layout: {
            hierarchical: {
                direction: 'UD',
                sortMethod: 'directed',
            },
        },
        physics: {
            enabled: false,
        },
    }

    const network = new vis.Network(container, data, options)
}

class CodeNode {
    constructor(code) {
        this.id = code._id
        this.code = code
        this.instances = []
        this.projectId = code.projectId
        this.color = code.color
        this.parent = code.parent
    }

    addInstance(instance) {
        this.instances.push(instance)
    }
}

class InstanceNode {
    constructor(instance) {
        this.id = instance._id
        this.uid = instance.uid
        this.fileId = instance.fileId
        this.data = instance.data
        this.startOffset = instance.startOffset
        this.endOffset = instance.endOffset
        this.createdAt = instance.createdAt
        this.codeId = ''
    }

    setCodeId(codeId) {
        this.codeId = codeId
    }
}

class Graph {
    constructor() {
        this.codeNodes = []
        this.instanceNodes = []
        this.edges = []
    }

    addCodeNode(code) {
        this.codeNodes.push(new CodeNode(code))
    }

    addInstanceNode(instance) {
        this.instanceNodes.push(new InstanceNode(instance))
    }

    getCodeNode(id) {
        return this.codeNodes.find((node) => node.id === id)
    }

    getInstanceNode(id) {
        return this.instanceNodes.find((node) => node.id === id)
    }

    addEdge(codeNode, instanceNode) {
        const code = this.getCodeNode(codeNode._id)
        const instance = this.getInstanceNode(instanceNode._id)

        code.addInstance(instance)
        instance.setCodeId(code.id)

        this.edges.push({
            codeId: code.id,
            instanceId: instance.id,
        })
    }

    getEdges() {
        return this.edges
    }

    getNodes() {
        return {
            codeNodes: this.codeNodes,
            instanceNodes: this.instanceNodes,
        }
    }

    getGraph() {
        return {
            nodes: this.getNodes(),
            edges: this.getEdges(),
        }
    }

    getGraphData() {
        return {
            nodes: this.codeNodes.map((node) => {
                return {
                    id: node.id,
                    label: node.code.name,
                    color: node.color,
                }
            }),
            edges: this.edges.map((edge) => {
                return {
                    from: edge.instanceId,
                    to: edge.codeId,
                }
            }),
        }
    }
}

// Fetch codes
await supabase
    .from('codes')
    .select(
        `
        *,
        code_instances (
            *
        )`
    )
    .eq('project_id', projectStore.currentProject.id)
    .then((res) => {
        codes.value = res.data
    })
</script>

<template>
    <div class="flex flex-col items-center justify-center h-full rounded-lg border-3 border-main full-width no-scroll">
        <h1>Graph</h1>
    </div>
</template>