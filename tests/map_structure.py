"""Validate the built map's safety/packaging invariants using Python's standard library."""
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

place = Path(sys.argv[1] if len(sys.argv) > 1 else "build/grasslands.rbxlx")
root = ET.parse(place).getroot()
items = list(root.iter("Item"))


def prop(item, name):
    return next((p for p in item.find("Properties") if p.get("name") == name), None)


def name(item):
    return prop(item, "Name").text


def named(label):
    matches = [item for item in items if name(item) == label]
    assert len(matches) == 1, f"Expected one {label}, got {len(matches)}"
    return matches[0]


def box(item):
    frame = prop(item, "CFrame")
    size = prop(item, "Size") or prop(item, "size")
    position = [float(frame.findtext(axis)) for axis in ("X", "Y", "Z")]
    half = [float(size.findtext(axis)) / 2 for axis in ("X", "Y", "Z")]
    return ([p - h for p, h in zip(position, half)], [p + h for p, h in zip(position, half)])


workspace = next(item for item in items if item.get("class") == "Workspace")
assert not any(i.get("class") in ("Script", "LocalScript", "ModuleScript") for i in workspace.iter("Item")), "Old gameplay code leaked into scenery"
assert not any(i.get("class") in ("RemoteEvent", "RemoteFunction", "ProximityPrompt", "ClickDetector") for i in workspace.iter("Item")), "Unexpected old gameplay interaction"
part_classes = {"Part", "MeshPart", "UnionOperation", "WedgePart", "CornerWedgePart", "SpawnLocation", "TrussPart", "Seat", "VehicleSeat"}
parts = [i for i in workspace.iter("Item") if i.get("class") in part_classes]
assert parts and all(prop(i, "Anchored") is not None and prop(i, "Anchored").text == "true" for i in parts), "Unanchored map geometry"
spawns = [i for i in items if i.get("class") == "SpawnLocation"]
assert len(spawns) == 1, "Exactly one player spawn is required"
assert prop(spawns[0], "Enabled").text == "true", "Spawn is disabled"
assert prop(spawns[0], "Neutral").text == "true", "Spawn must accept every player"

grass = box(named("GrasslandsFoundation"))
spawn_ground = box(named("SpawnFoundation"))
assert grass[1][0] - grass[0][0] >= 480 and grass[1][2] - grass[0][2] >= 500
assert abs(grass[1][1] - spawn_ground[1][1]) < 0.01, "Ground elevations differ at the entrance"
assert abs(grass[1][2] - spawn_ground[0][2]) < 0.01, "Gap between spawn and meadow"
spawn = box(spawns[0])
for axis in (0, 2):
    assert spawn_ground[0][axis] <= spawn[0][axis] <= spawn[1][axis] <= spawn_ground[1][axis], "Spawn is outside the supporting floor"

limits = (grass[0][0], grass[1][0], grass[0][2], spawn_ground[1][2])
wall_group = named("BoundaryColliders")
walls = {name(i): i for i in wall_group.findall("Item")}
assert set(walls) == {"West", "East", "North", "South"}
for side, item in walls.items():
    collision = prop(item, "CanCollide")
    # Roblox XML may omit default-valued properties; BasePart.CanCollide defaults to true.
    assert collision is None or collision.text == "true", f"{side} wall is not solid"
    low, high = box(item)
    assert low[1] < 1 and high[1] > 100, f"{side} wall does not prevent walking/jumping out"
    if side in ("West", "East"):
        edge = limits[0] if side == "West" else limits[1]
        assert low[0] <= edge <= high[0] and low[2] <= limits[2] and high[2] >= limits[3]
    else:
        edge = limits[2] if side == "North" else limits[3]
        assert low[2] <= edge <= high[2] and low[0] <= limits[0] and high[0] >= limits[1]

assert len(named("CreatureAreas").findall("Item")) >= 3, "Missing future creature clearings"
assert not any(name(i) in ("BootstrapFloor", "BootstrapSpawn") for i in items)
print(f"PASS: {len(parts)} anchored map parts, one safe spawn, continuous ground, closed perimeter, and no embedded gameplay.")
