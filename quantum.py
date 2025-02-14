def find_stable_paths(edges):
    from collections import defaultdict
    import math

    graph = defaultdict(list)
    for start, end, quantum in edges:
        graph[start].append((end, quantum))
    
    max_product = -math.inf
    best_paths = []

    def dfs(node, visited, path, product):
        nonlocal max_product, best_paths
        if node in visited:
            return
        
        visited.add(node)
        path.append(node)
        product *= quantum

        if len(graph[node]) == 0:
            if product > max_product:
                max_product = product
                best_paths = [path[:]]
            elif product == max_product:
                best_paths.append(path[:])
        
    for start in graph.keys():
        dfs(start, set(), [], 1)
    
    return best_paths
