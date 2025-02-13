function findStablePaths(edges) {
    const graph = new Map();
    edges.forEach(([start, end, quantum]) => {
        if (!graph.has(start)) graph.set(start, []);
        graph.get(start).push([end, quantum]);
    });

    let maxProduct = -Infinity;
    let bestPaths = [];

    function dfs(node, visited, path, product) {
        if (visited.has(node)) return;
        
        visited.add(node);
        path.push(node);

        if (graph.get(node) === undefined || graph.get(node).length === 0) {
            if (product > maxProduct) {
                maxProduct = product;
                bestPaths = [path.slice()];
            } else if (product === maxProduct) {
                bestPaths.push(path.slice());
            }
        } else {
            graph.get(node).forEach(([neighbor, quantum]) => {
                dfs(neighbor, new Set(visited), path.slice(), product * quantum);
            });
        }
    }

    graph.forEach((_, start) => {
        dfs(start, new Set(), [], 1);
    });

    return bestPaths;
}

// Test case
const edges = [
    [0, 1, 5],
    [1, 2, 2],
    [2, 3, -1],
    [3, 4, 3],
    [0, 4, 7],
    [0, 2, -4],
    [2, 4, 2]
];

console.log(findStablePaths(edges));
