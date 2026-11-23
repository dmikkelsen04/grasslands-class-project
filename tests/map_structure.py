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

# Original floors retain their exact dimensions and positions.
spawn_ground = box(named("MapSpawn1"))
assert abs(spawn_ground[1][0] - spawn_ground[0][0] - 343.25) < .01
assert abs(spawn_ground[1][2] - spawn_ground[0][2] - 181) < .01
floors = [box(named(f"GrasslandGround_{i}")) for i in range(1, 5)]
stripe = box(named("SafeZoneStripe"))
assert all(abs(b[1][1] - 1) < .01 for b in floors + [stripe, spawn_ground])
assert abs(max(b[1][2] for b in floors) - stripe[0][2]) < .01
assert abs(stripe[1][2] - spawn_ground[0][2]) < .01
assert abs(min(b[0][2] for b in floors) + 337) < .01
spawn = box(spawns[0])
for axis in (0, 2):
    assert spawn_ground[0][axis] <= spawn[0][axis] <= spawn[1][axis] <= spawn_ground[1][axis]

# The removed biome exit must be closed with a solid original-style wall.
wall = named("ClassProjectEndWall")
lower = next(i for i in wall.findall("Item") if name(i) == "Lower")
low, high = box(lower)
assert abs(high[2] + 337) < .01 and low[0] <= -117.75 and high[0] >= 88
assert high[1] > 25 and low[1] < 1
collision = prop(lower, "CanCollide")
assert collision is None or collision.text == "true"
assert len(named("EncounterGrassPatches").findall("Item")) == 5
assert len(named("Plots").findall("Item")) == 5
assert not any("bicycle" in name(i).lower() or "bike" in name(i).lower() for i in workspace.iter("Item")), "Bike left in map"
assert not any(name(i) in ("BootstrapFloor", "BootstrapSpawn") for i in items)
print(f"PASS: {len(parts)} anchored parts, original-size floors, safe spawn, sealed biome exit, five grass patches, no bikes or legacy gameplay.")
