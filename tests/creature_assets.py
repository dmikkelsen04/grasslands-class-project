"""Check the built asset boundary, rig connectivity, and playable animation data."""
import json
import math
import sys
import xml.etree.ElementTree as ET

root = ET.parse(sys.argv[1] if len(sys.argv) > 1 else "build/grasslands.rbxlx").getroot()
items = list(root.iter("Item"))
refs = {i.get("referent"): i for i in items}
expected = {"Chicken", "WaddleDuck", "GrumpyBison", "MoodyCow", "BouncyPig", "WoolballSheep", "Scarecrow", "CornfedColossus"}


def prop(item, key):
    return next((p for p in item.find("Properties") if p.get("name") == key), None)


def name(item):
    return prop(item, "Name").text


def named(label):
    matches = [i for i in items if name(i) == label]
    assert len(matches) == 1, label
    return matches[0]


assets = named("CreatureAssets")
rigs = {name(i): i for i in assets.findall("Item")}
animations = {name(i): i for i in named("CreatureAnimationData").findall("Item")}
assert set(rigs) == set(animations) == expected
clip_count = pose_count = 0
for species, rig in rigs.items():
    descendants = list(rig.iter("Item"))
    assert all(i.get("class") not in {"Script", "LocalScript", "ModuleScript", "RemoteEvent", "RemoteFunction", "ProximityPrompt", "ClickDetector", "Humanoid", "Animator"} for i in descendants)
    primary_ref = prop(rig, "PrimaryPart").text
    parts = [i for i in descendants if i.get("class") in {"Part", "MeshPart", "UnionOperation", "WedgePart"}]
    part_refs = {i.get("referent") for i in parts}
    assert primary_ref in part_refs
    graph = {r: set() for r in part_refs}
    joint_names = set()
    for part in parts:
        assert prop(part, "CanCollide").text == "false", species
        anchored = prop(part, "Anchored")
        assert (anchored is not None and anchored.text == "true") == (part.get("referent") == primary_ref), species
    for joint in descendants:
        if joint.get("class") in {"Motor6D", "Weld", "WeldConstraint"}:
            p0, p1 = prop(joint, "Part0").text, prop(joint, "Part1").text
            assert p0 in part_refs and p1 in part_refs, f"External/disconnected joint: {species}"
            graph[p0].add(p1)
            graph[p1].add(p0)
            if joint.get("class") == "Motor6D":
                key = name(refs[p0]) + "/" + name(refs[p1])
                assert key not in joint_names
                joint_names.add(key)
    visited, pending = set(), [primary_ref]
    while pending:
        item = pending.pop()
        if item not in visited:
            visited.add(item)
            pending.extend(graph[item] - visited)
    assert visited == part_refs, f"Loose parts in {species}"
    clips = {name(i): i for i in animations[species].findall("Item")}
    assert set(clips) == {"Idle", "Walk"}
    for clip in clips.values():
        assert clip.get("class") == "StringValue"
        data = json.loads(prop(clip, "Value").text)
        frames = data["frames"]
        assert data["duration"] > 0 and len(frames) > 1
        times = [frame[0] for frame in frames]
        assert times[0] == 0 and all(a < b for a, b in zip(times, times[1:]))
        assert abs(times[-1] - data["duration"]) < 1e-6
        for _, poses in frames:
            assert set(poses) == joint_names, f"Rig/clip mismatch: {species}"
            for cf, weight, style, direction in poses.values():
                assert len(cf) == 12 and all(math.isfinite(x) for x in cf)
                assert 0 <= weight <= 1 and style in range(6) and direction in range(3)
                pose_count += 1
        assert any(frames[0][1] != f[1] for f in frames[1:]), f"Static clip: {species}"
        clip_count += 1
print(f"PASS: eight connected script-free rigs, {clip_count} matching clips, {pose_count} finite poses.")
