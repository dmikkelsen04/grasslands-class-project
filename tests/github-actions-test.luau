-- GitHub Actions Luau CI test
-- Upload this file to the root of your repository.
-- It should pass a Luau syntax check.

local function calculateDamage(baseDamage: number, multiplier: number): number
    return baseDamage * multiplier
end

local damage: number = calculateDamage(10, 2)
print("Luau CI syntax test passed: " .. tostring(damage))
