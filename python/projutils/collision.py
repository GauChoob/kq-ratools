

class CollisionIDs:
    """A helper object that gets the Collision IDs"""
    def __init__(self, file: str = "python/collision_ids.asm"):
        self.ids = {}
        with open(file, "r") as f:
            for line in f.readlines():
                if line[0:4] != "DEF ":
                    continue
                params = line[4:].split("EQU $")
                if len(params) != 2:
                    raise ValueError("Unable to read format of collision file!")
                name = params[0].lstrip().rstrip()
                val = int(params[1].lstrip().rstrip(), 16)
                self.ids[val] = name
