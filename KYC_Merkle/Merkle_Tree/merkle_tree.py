import hashlib
import json

def sha256(data):
    return hashlib.sha256(data.encode('utf-8')).hexdigest()

class MerkleTree:
    def __init__(self, hashes):
        self.leaves = hashes
        self.tree = []
        self.create_tree()

    def create_tree(self):
        tree_levels = [self.leaves]
        while len(tree_levels[-1]) > 1:
            current_level = tree_levels[-1]
            next_level = []
            for i in range(0, len(current_level), 2):
                left_child = current_level[i]
                right_child = current_level[i+1] if i+1 < len(current_level) else current_level[i]
                next_level.append(sha256(left_child + right_child))
            tree_levels.append(next_level)
        self.tree = tree_levels

    def get_root(self):
        return self.tree[-1][0] if self.tree else None

    def get_proof(self, item_hash):
        proof = []
        for level in range(len(self.tree) - 1):
            index = self.tree[level].index(item_hash)
            sibling_index = index + 1 if index % 2 == 0 else index - 1
            sibling_index = min(sibling_index, len(self.tree[level]) - 1)
            proof.append((sibling_index, self.tree[level][sibling_index]))
            item_hash = sha256(item_hash + self.tree[level][sibling_index])
        return proof

    def verify_proof(self, item_hash, proof):
        for sibling_index, sibling_hash in proof:
            item_hash = sha256(item_hash + sibling_hash)
        return item_hash == self.get_root()

# Assume we have a function that retrieves 50 hashed pieces of encrypted user data
def get_user_data_hashes():
    # This function would actually retrieve stored hashes of encrypted user data
    # Here, we simulate it by generating random hashes for the sake of the example
    return [sha256(f'user_data{i}') for i in range(50)]

# This is where you would call your function that gets the 50 hashes
hashes = get_user_data_hashes()

# Create the Merkle tree with the hashes
merkle_tree = MerkleTree(hashes)

# Output the Merkle root
print("Merkle Root:", merkle_tree.get_root())

# Assume we want to prove inclusion for the first hash
item_hash_to_prove = hashes[0]
proof = merkle_tree.get_proof(item_hash_to_prove)
print(f"Proof for item hash {item_hash_to_prove}:", json.dumps(proof, indent=2))

# Verify the proof for the first hash
valid = merkle_tree.verify_proof(item_hash_to_prove, proof)
print(f"Item hash {item_hash_to_prove} proof is valid:", valid)
