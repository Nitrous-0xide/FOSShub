
local WeaponGcPatcher = function(b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    return function()
      local b, M = 0, 0
      while true do
        local S = F.No_Recoil
          or F.No_Spread
          or F.Rapid_Fire
          or F.Rage_Enabled
          or F.No_Bullet_Waste
          or F.No_Melee_Cooldown
          or F.Instant_Grenade
          or F.Instant_Scope
          or F.No_Flashbang
        if b < 1 then
          task.wait(4)
        elseif S then
          local B, D = task.wait, M > 0 and (next(N) == nil and 4 or 30)
          B(D or 8)
        else
          task.wait(120)
        end
        b += 1
        if not F.No_Recoil then
          if not F.No_Spread then
            if not F.Rapid_Fire then
              if not F.Rage_Enabled then
                if not F.No_Bullet_Waste then
                  if not F.No_Melee_Cooldown then
                    if not F.Instant_Grenade then
                      if not F.Instant_Scope then
                        if not F.No_Flashbang then
                          continue
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
        local b, B = pcall(getgc, true)
        if not b then
          continue
        end
        b = #B
        S = 0
        for D = 1, b, 1 do
          local b = B[D]
          if type(b) == "table" then
            if N[b] then
            else
              if
                rawget(b, "ShootCooldown") ~= nil
                or rawget(b, "ShootRecoil") ~= nil
                or rawget(b, "CameraKick") ~= nil
                or rawget(b, "AimRecoil") ~= nil
                or rawget(b, "FireRate") ~= nil
                or rawget(b, "AutoFire") ~= nil
                or rawget(b, "AttackCooldown") ~= nil
                or rawget(b, "DetonateDelay") ~= nil
                or rawget(b, "AimSpeed") ~= nil
                or rawget(b, "Cooldown") ~= nil
              then
                if setreadonly then
                  pcall(setreadonly, b, false)
                end
                D = { _RecoilKeys = {}, _SpreadKeys = {} }
                for B, h in pairs(b) do
                  D[B] = h
                  if type(B) == "string" then
                    h = B:lower()
                    if h:find("recoil") then
                      D._RecoilKeys[#D._RecoilKeys + 1] = B
                    elseif h:find("kick") then
                      D._RecoilKeys[#D._RecoilKeys + 1] = B
                    elseif h:find("spread") then
                      D._SpreadKeys[#D._SpreadKeys + 1] = B
                    end
                  end
                end
                N[b] = D
                M += 1
              else
              end
              if rawget(b, "AttemptToFlash") and type(rawget(b, "AttemptToFlash")) == "function" and not rawget(b, "__PH_FLASH_HOOKED") then
                if setreadonly then
                  pcall(setreadonly, b, false)
                end
                rawset(b, "__PH_FLASH_HOOKED", true)
                local N = b.AttemptToFlash
                b.AttemptToFlash = function(...)
                  if F.No_Flashbang then
                    return
                  end
                  return N(...)
                end
              end
              if rawget(b, "UpdateAmmo") and type(rawget(b, "UpdateAmmo")) == "function" and not rawget(b, "__PH_AMMO_HOOKED") then
                if setreadonly then
                  pcall(setreadonly, b, false)
                end
                rawset(b, "__PH_AMMO_HOOKED", true)
                local N = b.UpdateAmmo
                b.UpdateAmmo = function(M, ...)
                  local B = N(M, ...)
                  if F.Rage_Auto_Reload then
                    if F.Rage_Enabled then
                      if M.ClientItem then
                        if M.ClientItem.IsEquipped then
                          local N = M:_GetAmmoVariables()
                          if N then
                            if N == 0 then
                              _()
                            end
                          end
                        end
                      end
                    end
                  end
                  return B
                end
              end
              if rawget(b, "StartShooting") and type(rawget(b, "StartShooting")) == "function" and not rawget(b, "__PH_RAPID_HOOKED") then
                if setreadonly then
                  pcall(setreadonly, b, false)
                end
                rawset(b, "__PH_RAPID_HOOKED", true)
                local N = b.StartShooting
                b.StartShooting = function(b, _, M)
                  local B = F.Rage_Enabled or F.Rapid_Fire
                  if B then
                    if b.Info then
                      if b.Info.AutoFire ~= nil then
                        b.Info.AutoFire = true
                      end
                    end
                  end
                  local F, D, h, W = N(b, _, M)
                  if B then
                    if rawget(b, "_shoot_cooldown") ~= nil then
                      b._shoot_cooldown = 0
                    end
                    if rawget(b, "_is_input_queueing") ~= nil then
                      b._is_input_queueing = false
                    end
                    if rawget(b, "_burst_count") ~= nil then
                      b._burst_count = 0
                    end
                    if rawget(b, "_last_shot_time") ~= nil then
                      b._last_shot_time = 0
                    end
                    if rawget(b, "_next_shot_time") ~= nil then
                      b._next_shot_time = 0
                    end
                  end
                  return F, D, h, W
                end
              end
            end
          else
          end
          S += 1
          if S >= 50 then
            task.wait()
            S = 0
          else
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - WeaponStatsPatcher

  Role: Weapon stat table patcher. Rewrites ShootCooldown, FireRate, recoil/spread, ammo and melee cooldowns on
  cached weapon-info tables.
  Category: combat
  Recovered factory key: 6212   source position: 139   bytes: 2157

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1]=config, [2]=number factory, [3]=cache, [4]=property setter, [5]=weapon-info registry.

  Persisted config fields: Instant_Grenade, Instant_Scope, No_Bullet_Waste, No_Melee_Cooldown, No_Recoil,
  No_Spread, Rage_Enabled, Rage_Fire_Rate, Rapid_Fire

  Runtime/state fields: Rage_Seed_Spread, Rapid_Fire_Speed

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local WeaponStatsPatcher = function(b, b, b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    return function()
      local b, B, D, h = F.Rage_Enabled or F.Rapid_Fire, F.No_Recoil or F.Rage_Enabled, F.Rage_Enabled or F.No_Spread, F.No_Bullet_Waste
      if b then
      elseif B then
      elseif D then
      elseif h then
      elseif not F.No_Melee_Cooldown then
        if not F.Instant_Grenade then
          if not F.Instant_Scope then
            return
          end
        end
      end
      local W = F.Rage_Enabled and F.Rage_Fire_Rate or F.Rapid_Fire_Speed
      W = if type(W) ~= "number" then 0 else if W < 0 then 0 else W
      local U, s = h and 9999 or nil, F.Rage_Enabled and F.Rage_Seed_Spread or 0
      local c, Y = N(s, s, s), pairs
      for N, g in Y(_) do
        if g.ShootCooldown ~= nil then
          M(N, "ShootCooldown", b and W or g.ShootCooldown)
        end
        if g.ShootBurstCooldown ~= nil then
          M(N, "ShootBurstCooldown", b and W or g.ShootBurstCooldown)
        end
        if g.EquipCooldown ~= nil then
          M(N, "EquipCooldown", g.EquipCooldown)
        end
        if g.FireRate ~= nil then
          M(N, "FireRate", b and 1000 or g.FireRate)
        end
        if g.AutoFire ~= nil then
          M(N, "AutoFire", b and true or g.AutoFire)
        end
        if g.BurstFire ~= nil then
          M(N, "BurstFire", b and false or g.BurstFire)
        end
        if g.BurstSize ~= nil then
          M(N, "BurstSize", b and 1 or g.BurstSize)
        end
        if g.Cooldown ~= nil then
          M(N, "Cooldown", b and W or g.Cooldown)
        end
        if g.MagSize ~= nil then
          M(N, "MagSize", U or g.MagSize)
        end
        if g.SpareAmmo ~= nil then
          M(N, "SpareAmmo", U or g.SpareAmmo)
        end
        if g.Ammo ~= nil then
          M(N, "Ammo", U or g.Ammo)
        end
        if g.AttackCooldown ~= nil then
          M(N, "AttackCooldown", F.No_Melee_Cooldown and 0 or g.AttackCooldown)
        end
        if g.AttackDelay ~= nil then
          M(N, "AttackDelay", F.No_Melee_Cooldown and 0 or g.AttackDelay)
        end
        if g.DetonateDelay ~= nil then
          M(N, "DetonateDelay", F.Instant_Grenade and 0 or g.DetonateDelay)
        end
        if g.AimSpeed ~= nil then
          M(N, "AimSpeed", F.Instant_Scope and 9999 or g.AimSpeed)
        end
        h = #g._RecoilKeys
        for b = 1, h, 1 do
          local F = g._RecoilKeys[b]
          b = g[F]
          if B then
            if type(b) == "number" then
              M(N, F, 0)
            elseif typeof(b) == "Vector3" then
              M(N, F, S)
            end
          else
            M(N, F, b)
          end
        end
        local b = #g._SpreadKeys
        for F = 1, b, 1 do
          local b = g._SpreadKeys[F]
          F = g[b]
          if D then
            if type(F) == "number" then
              M(N, b, s)
            elseif typeof(F) == "Vector3" then
              M(N, b, c)
            end
          else
            M(N, b, F)
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - AimTargetController

  Role: Aim target / rage-revert controller. Chooses silent-aim targets, resolves hit parts, records and replays
  rage-revert positions, and gates target updates on Void_Spam / Rage / Silent Aim state.
  Category: combat
  Recovered factory key: 211   source position: 120   bytes: 1929

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 14
    deps[1]=config, [2]=void-spam gate, [3]=clock, [4]=timer cell, [5]=LocalPlayer, [6]=default distance,
    [7]=Players, [8]=team check, [9]=visibility check, [10]=distance filter, [11]=aim state, [12]=part resolver,
    [13]=target chooser, [14]=rage-revert cache.

  Persisted config fields: Rage_Enabled, Rage_Hitbox, Rage_Revert, Sa_Enabled, Sa_Part, Void_Spam,
  Wallbang_Enabled

  Runtime/state fields: Sa_Target_Part, Sa_Target_Player, Sa_Target_Pos, Sa_Use_Live

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local AimTargetController = function(b, F, F, F, F)
  return function(F, N)
    local N = F[1]
    local _ = F[2]
    local M = F[3]
    local S = F[4]
    local B = F[5]
    local D = F[6]
    local h = F[7]
    local W = F[8]
    local U = F[9]
    local s = F[10]
    local c = F[11]
    local Y = F[12]
    local g = F[13]
    local o = F[14]
    return function()
      local F, V = N.Rage_Enabled, N.Void_Spam
      if V and _ then
        local q = M()
        if q - S[6][S[5]] >= 0.08 then
          S[6][S[5]] = q
          local q = B.Character
          local j, m = q and (q:FindFirstChild("HumanoidRootPart"))
          if j then
            local i, k, G = ipairs, b[62](h:GetPlayers()), D
            for D, h in i(b:Js(k)) do
              if h ~= B and not W(B, h) then
                if U(h) then
                else
                  if s(h) then
                    D = h.Character and h.Character:FindFirstChild("HumanoidRootPart")
                    if D then
                      q = (j.Position - D.Position).Magnitude
                      if q < G then
                        G, m = q, h
                      else
                      end
                    else
                    end
                  else
                  end
                end
              else
              end
            end
          else
          end
          c.Sa_Target_Player = m
          if m then
            if m.Character then
              j = m.Character
              q = j:FindFirstChild("HitboxHead") or j:FindFirstChild("Head") or Y(m, N.Rage_Hitbox or "Head")
              c.Sa_Target_Part = q
              c.Sa_Use_Live = true
              c.Sa_Target_Pos = q and q.Position or nil
            else
              c.Sa_Target_Part = nil
              c.Sa_Target_Pos = nil
            end
          else
            c.Sa_Target_Part = nil
            c.Sa_Target_Pos = nil
          end
        end
        return
      end
      V = F or N.Sa_Enabled
      V = _ and V
      if V then
        local b = M()
        if b - S[6][S[5]] >= 0.08 then
          S[6][S[5]] = b
          local b = g(true)
          c.Sa_Target_Player = b
          if b then
            if s(b) then
              local _, M = F and N.Rage_Hitbox or N.Sa_Part
              if N.Wallbang_Enabled then
                if _ == "Head" then
                  if b.Character then
                    local S = b.Character
                    M = S:FindFirstChild("HitboxHead") or S:FindFirstChild("Head") or Y(b, _)
                  else
                    M = (Y(b, _))
                  end
                else
                  M = (Y(b, _))
                end
              else
                M = (Y(b, _))
              end
              c.Sa_Target_Part = M
              if F and N.Rage_Revert and o[b] then
                _ = o[b]
                local b = _.Data[1]
                c.Sa_Use_Live = false
                if b then
                  c.Sa_Target_Pos = b.P
                else
                  c.Sa_Target_Pos = M and M.Position or nil
                end
              else
                c.Sa_Use_Live = true
                c.Sa_Target_Pos = M and M.Position or nil
              end
            else
              c.Sa_Target_Pos = nil
              c.Sa_Target_Part = nil
            end
          else
            c.Sa_Target_Pos = nil
            c.Sa_Target_Part = nil
          end
        end
      else
        c.Sa_Target_Pos = nil
        c.Sa_Target_Player = nil
        c.Sa_Target_Part = nil
      end
    end
  end
end

--[[
  Phantom Hub - TargetSelector

  Role: Target selector. Scores players by FOV, distance and health using the selected aim logic, with team and
  Katana-user filtering.
  Category: combat
  Recovered factory key: 72   source position: 40   bytes: 1620

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 13
    deps[1..13]=config, Players, LocalPlayer, visibility/team helpers and aim state.

  Persisted config fields: Aim_Logic, Aim_Part, Aim_Team_Check, Anti_Katana, Fov_Size, Rage_Enabled,
  Rage_Hitbox, Rage_Selection, Sa_Part, Sa_Random_Hitbox, Sa_Team_Check, Sa_Visible_Check, Show_Fov

  Runtime/state fields: Aa_Active, Aim_Part_List, Katana_Users, Rage_Fov, Rage_Visible_Check

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local TargetSelector = function(b, b, b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    return function(b)
      local g = F.CurrentCamera
      local F, o, V, q, j, m =
        g.CFrame.Position,
        g.ViewportSize / 2,
        b and _.Sa_Part or _.Aim_Part,
        b and _.Sa_Team_Check or _.Aim_Team_Check,
        _.Rage_Enabled and _.Rage_Visible_Check or (b and _.Sa_Visible_Check or false),
        _.Rage_Enabled and _.Rage_Selection or _.Aim_Logic
      V = if _.Rage_Enabled then _.Rage_Hitbox else V
      local i = _.Rage_Enabled
      local k, G, A, l, r, E, Z, d =
        b and _.Sa_Random_Hitbox and not i,
        M.Aim_Part_List,
        i and 1000 or 1500,
        i and _.Rage_Fov or _.Fov_Size,
        _.Show_Fov or i,
        M.Aa_Active,
        _.Anti_Katana,
        S:GetPlayers()
      local _, S, L, e = #d, V, N
      for H = 1, _, 1 do
        i = d[H]
        if i == B then
          continue
        elseif D(i) then
          if q then
            if h(i, B) then
              continue
            end
          end
        else
          continue
        end
        if W(i) then
          continue
        end
        if Z then
          if M.Katana_Users[i] then
            continue
          end
        end
        V = if k then G[U(1, #G)] else S
        b = s(i, V)
        if not b then
          continue
        end
        H = b.Position
        local b = (H - F).Magnitude
        if b > A then
          continue
        end
        local F, _ = g:WorldToViewportPoint(H)
        if E then
        elseif _ then
          if F.Z < 0 then
            continue
          end
        else
          continue
        end
        _ = F.Z > 0 and (o - c(F.X, F.Y)).Magnitude or N
        if E then
        elseif r then
          if _ > l then
            continue
          end
        end
        if j then
          if not (Y(H, i.Character)) then
            continue
          end
        end
        H = nil
        if E then
          H = b
        else
          if m == "Closest Player" then
            H = b
          else
            if m == "Distance" then
              H = b
            else
              if m == "Health" then
                F = i.Character:FindFirstChildOfClass("Humanoid")
                H = F and F.Health or N
              else
                H = _
              end
            end
          end
        end
        if H < L then
          L, e = H, i
        else
        end
      end
      return e
    end
  end
end

--[[
  Phantom Hub - BackstabAim

  Role: Backstab aim helper. Validates range/team/duel constraints, finds a backstab position behind the target,
  and feeds the aim target state.
  Category: combat
  Recovered factory key: 93   source position: 239   bytes: 1410

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 16
    deps[1..16]=config, target state, team/duel/range helpers and CFrame math.

  Persisted config fields: Aimbot_Enabled, Backstab_Only_Duel, Backstab_Range, Backstab_Return,
  Backstab_Team_Check

  Runtime/state fields: Backstab_Offset, Current_Aim_Target

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local BackstabAim = function(b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    local g = b[14]
    local o = b[15]
    local V = b[16]
    return function(b)
      if b then
        if not (F()) then
          N(b)
          return
        end
      else
        N(b)
        return
      end
      if _.Backstab_Only_Duel then
        if not (M()) then
          N(b)
          return
        end
      end
      local F = b:FindFirstChild("HumanoidRootPart")
      if not F then
        return
      end
      local M = S[6][S[5]]
      if B(b, M) then
      else
        M = D(_.Backstab_Range, _.Backstab_Team_Check)
        S[6][S[5]] = M
      end
      if not M then
        N(b)
        return
      end
      if not _.Aimbot_Enabled then
        h.Current_Aim_Target = M
        W[6][W[5]] = true
      end
      local N = M.Character
      local B = N and N:FindFirstChild("HumanoidRootPart") or U(M, "Body")
      if not B then
        S[6][S[5]] = nil
        return
      end
      N = _.Backstab_Return
      if N then
        if s[6][s[5]] then
          return
        end
      end
      local S = B.CFrame
      local B = c((S * c(0, 0, _.Backstab_Offset)).Position) * (S - S.Position) * Y(0, 3.141592653589793, 0)
      if N then
        s[6][s[5]] = true
        task.spawn(function()
          local N = F.CFrame
          g(3)
          F.CFrame = B
          o()
          task.wait(0.03)
          if F then
            if F.Parent then
              F.CFrame = N
            end
          end
          V[6][V[5]], s[6][s[5]] = nil, false
        end)
        return
      end
      if V[6][V[5]] ~= M then
        g(3)
        V[6][V[5]] = M
      end
      S = b:FindFirstChildOfClass("Humanoid")
      if S then
        if S.AutoRotate then
          S.AutoRotate = false
        end
      end
      F.CFrame = B
      if not s[6][s[5]] then
        s[6][s[5]] = true
        task.spawn(function()
          o()
          s[6][s[5]] = false
        end)
      end
    end
  end
end

--[[
  Phantom Hub - ShieldDetector

  Role: Riot-shield detector. Scans characters, tools and viewmodels for shield models and tracks the shield
  weld/part data.
  Category: combat
  Recovered factory key: 38   source position: 101   bytes: 1320

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1..5]=Players, LocalPlayer, config, cache and instance helpers.
  Runtime/state fields: Shield_Detect_Radius

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local ShieldDetector = function(b, b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    return function()
      local b = F.Character and F.Character:FindFirstChild("HumanoidRootPart") and F.Character.HumanoidRootPart.Position
      if not b then
        return false
      end
      local B = N:GetPlayers()
      local N = #B
      for D = 1, N, 1 do
        local N = B[D]
        if N == F then
          continue
        elseif _(N) then
          if M(N, F) then
            continue
          end
        else
          continue
        end
        D = N.Character:FindFirstChild("HumanoidRootPart") and N.Character.HumanoidRootPart.Position
        if D then
          if (b - D).Magnitude > S.Shield_Detect_Radius then
            continue
          end
        else
          continue
        end
        D = N.Character:FindFirstChild("Model") or N.Character
        if D then
          local b = D:FindFirstChild("UnequippedViewModel", true) or D:FindFirstChild("_riot_shield_back", true)
          if b then
            for F, F in ipairs(b:GetDescendants()) do
              if F:IsA("Weld") or F:IsA("Motor6D") then
                if not (F.Part0 and F.Part0.Name == "UpperTorso") then
                  if F.Part1 then
                    if not (F.Part1.Name == "UpperTorso") then
                      return true
                    end
                  else
                    return true
                  end
                end
              end
            end
            local b = D:FindFirstChild("Shield", true) or D:FindFirstChild("RiotShield", true)
            if b and b.Parent and (b.Parent:IsA("Model") or b.Parent:IsA("Tool")) then
              if N.Character:FindFirstChild("RightGrip", true) then
                return true
              elseif N.Character:FindFirstChild("LeftGrip", true) then
                return true
              end
            end
          end
        end
      end
      return false
    end
  end
end

--[[
  Phantom Hub - HitFeedback

  Role: Hit feedback. Detects damage dealt to the current aim target and triggers hit sounds/markers only for
  valid hits.
  Category: combat
  Recovered factory key: 94   source position: 43   bytes: 1180

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 12
    deps[1..12]=config, aim state, sound/marker dispatch and Humanoid helpers.

  Persisted config fields: Hit_Marker, Hit_Sound_Enabled

  Runtime/state fields: Current_Aim_Target, Hit_Only_Target, Is_Auto_Shooting, Sa_Target_Player

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local HitFeedback = function(b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    return function()
      if not F.Hit_Sound_Enabled then
        if not F.Hit_Marker then
          if next(N) then
            _(N)
          end
          return
        end
      end
      local b = Enum.UserInputType.MouseButton1
      if M:IsMouseButtonPressed(b) then
        D[6][D[5]] = B()
      elseif S.Is_Auto_Shooting then
        D[6][D[5]] = B()
      end
      local _, M, Y = B() - D[6][D[5]] < 0.25, S.Sa_Target_Player or S.Current_Aim_Target, h.CurrentCamera
      local S, B, D = Y and Y.CFrame.LookVector, Y and Y.CFrame.Position, W:GetPlayers()
      b = #D
      for h = 1, b, 1 do
        Y = D[h]
        if Y ~= U then
          h = Y.Character
          local b = h and (h:FindFirstChildOfClass("Humanoid"))
          if b then
            if s(Y, U) then
              N[Y] = nil
            else
              local D, W = N[Y], b.Health
              if D then
                if W < D - 0.05 then
                  if _ then
                    local b
                    if F.Hit_Only_Target then
                      b = Y == M
                    else
                      if Y == M then
                        b = true
                      else
                        if S then
                          if B then
                            local F = h:FindFirstChild("HumanoidRootPart") or h:FindFirstChild("Head")
                            if F then
                              local _ = F.Position - B
                              b = if _.Magnitude > 0.1 then S:Dot(_.Unit) > 0.985 else b
                            else
                            end
                          else
                          end
                        else
                        end
                      end
                    end
                    if b then
                      c(Y)
                    end
                  end
                end
              end
              N[Y] = W
            end
          else
            N[Y] = nil
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - VoidSpamAutoShoot

  Role: Void spam / auto-shoot. Fires the equipped tool at the configured delay and maintains the firing state
  consumed by silent aim.
  Category: combat
  Recovered factory key: 13437   source position: 202   bytes: 988

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 8
    deps[1..8]=config, tool access, clock and firing state cells.

  Persisted config fields: Rage_Auto_Shoot, Rage_Enabled, Rage_Fire_Rate, Void_Spam, Void_Spam_Attack_Delay

  Runtime/state fields: Sa_Target_Player, Sa_Target_Pos, Vs_Firing, Vs_Last_Fire

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local VoidSpamAutoShoot = function(b, b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    return function()
      if F.Void_Spam then
        local b = N.Character
        if b then
          if not (b:FindFirstChildOfClass("Tool")) then
            return
          end
        else
          return
        end
        if _:GetMouseLocation() then
          if Game:GetService("GuiService").SelectedObject then
            return
          end
        end
        local b, N = M.Sa_Target_Player, S()
        if b then
          if B(b) then
            if not M.Vs_Firing then
              if N - (M.Vs_Last_Fire or 0) >= F.Void_Spam_Attack_Delay then
                M.Vs_Last_Fire = N
                M.Vs_Firing = true
                if mouse1press then
                  mouse1press()
                end
                if mouse1release then
                  mouse1release()
                end
                M.Vs_Firing = false
              end
            end
          end
        end
        return
      end
      if F.Rage_Enabled then
        if F.Rage_Auto_Shoot then
          local b, N, _ = D(), M.Sa_Target_Player, S()
          if b then
          elseif N then
            if B(N) then
              if M.Sa_Target_Pos then
                if _ - h[6][h[5]] >= F.Rage_Fire_Rate then
                  h[6][h[5]] = _
                  if mouse1press then
                    mouse1press()
                  end
                  if mouse1release then
                    mouse1release()
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - Triggerbot

  Role: Triggerbot. Fires when the crosshair/aim ray intersects an enemy, respecting team check, delay and
  cooldown.
  Category: combat
  Recovered factory key: 14   source position: 19   bytes: 932

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 14
    deps[1..14]=config, camera/mouse, target state, clock and input helpers.

  Persisted config fields: Trigger_Cooldown, Trigger_Delay, Trigger_Team_Check

  Runtime/state fields: Trig_Cam, Trig_Char

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local Triggerbot = function(b, b, b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    local g = b[14]
    return function(b, o)
      if b then
        if not (F()) then
          N[6][N[5]] = 0
          return
        end
      else
        N[6][N[5]] = 0
        return
      end
      local F = o or _.CurrentCamera
      o = F.CFrame
      local V = o.Position
      if M.Trig_Cam ~= F or M.Trig_Char ~= b then
        M.Trig_Cam = F
        M.Trig_Char = b
        S.FilterDescendantsInstances = { F, b }
      end
      F, b = _:Raycast(V, o.LookVector * 3000, S), false
      if F then
        if F.Instance then
          V = B(F.Instance)
          b = if V
            then if V ~= D
              then if h(V) then if W(V) then b else if U.Trigger_Team_Check then if s(V, D) then b else true else true else b
              else b
            else b
        else
        end
      else
      end
      if b then
        F = c()
        if N[6][N[5]] == 0 then
          N[6][N[5]] = F
        end
        if F - N[6][N[5]] >= U.Trigger_Delay then
          if F - Y[6][Y[5]] >= U.Trigger_Cooldown then
            g()
            Y[6][Y[5]] = F
          end
        end
      else
        N[6][N[5]] = 0
      end
    end
  end
end

--[[
  Phantom Hub - AimTargetState

  Role: Aim target state manager. Chooses or clears the current aim target from Rage/Silent Aim gating and
  mouse-button state.
  Category: combat
  Recovered factory key: 2582   source position: 90   bytes: 636

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 8
    deps[1..8]=config, input, target validator, target chooser and aim state.

  Persisted config fields: Aim_Hold_Rmb, Aimbot_Enabled, Rage_Enabled

  Runtime/state fields: Current_Aim_Target, Mm_Since

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local AimTargetState = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    return function()
      local b = F.Rage_Enabled
      local W, U = if b then not b else F.Aimbot_Enabled
      if W then
        b = F.Aim_Hold_Rmb
        U = if b then N:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) else not b
      else
        U = W
      end
      if U then
        if _.Current_Aim_Target then
          if not (M(_.Current_Aim_Target)) then
            _.Current_Aim_Target = nil
          end
        end
        if not _.Current_Aim_Target then
          _.Current_Aim_Target = S(false)
        end
      else
        if not B[6][B[5]] then
          _.Current_Aim_Target = nil
        end
        D[6][D[5]], h[6][h[5]] = 0, 0
        _.Mm_Since = 0
      end
    end
  end
end

--[[
  Phantom Hub - RageRevertRecorder

  Role: Rage revert recorder. Records HumanoidRootPart positions for other players and replays them when
  Rage_Revert is enabled.
  Category: combat
  Recovered factory key: 14905   source position: 10   bytes: 572

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 6
    deps[1..6]=config, Players, LocalPlayer, visibility filter, revert cache and clock.

  Persisted config fields: Rage_Enabled, Rage_Revert

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local RageRevertRecorder = function(b, b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    return function()
      if F.Rage_Enabled then
        if not F.Rage_Revert then
          return
        end
      else
        return
      end
      local b, F = N:GetPlayers(), _()
      local N = #b
      for _ = 1, N, 1 do
        local N = b[_]
        if N ~= M then
          if N.Character then
            if S(N) then
              _ = N.Character:FindFirstChild("HumanoidRootPart")
              if _ then
                local b = B[N]
                if b then
                else
                  b = { Idx = 1, Data = {} }
                  B[N] = b
                end
                local N = b.Data[b.Idx]
                if N then
                else
                  N = {}
                  b.Data[b.Idx] = N
                end
                N.P = _.Position
                N.T = F
                b.Idx = b.Idx % 12 + 1
              end
            end
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - NearestTargetSearch

  Role: Nearest-target search. Scans players and returns the closest valid body part, with team and visibility
  filters.
  Category: combat
  Recovered factory key: 15   source position: 228   bytes: 550

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 6
    deps[1..6]=LocalPlayer, Players, team check, visibility check, distance helper and body-part resolver.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local NearestTargetSearch = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    return function(b, D)
      local h = F.Character
      local W = h and (h:FindFirstChild("HumanoidRootPart"))
      if not W then
        return nil
      end
      local U, s = W.Position, N:GetPlayers()
      local N, W, c = #s, b
      for Y = 1, N, 1 do
        h = s[Y]
        if h == F then
          continue
        elseif _(h) then
          if D then
            if M(h, F) then
              continue
            end
          end
        else
          continue
        end
        if S(h) then
          continue
        end
        Y = B(h, "Body")
        if Y then
          b = (Y.Position - U).Magnitude
          if b < W then
            W, c = b, h
          else
          end
        else
        end
      end
      return c
    end
  end
end

--[[
  Phantom Hub - BackstabValidator

  Role: Backstab validator. Checks whether a candidate is behind the target and within Backstab_Range/team
  constraints.
  Category: combat
  Recovered factory key: 118   source position: 28   bytes: 502

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1..5]=config, LocalPlayer, range and angle helpers.

  Persisted config fields: Backstab_Range, Backstab_Team_Check

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local BackstabValidator = function(b, b, b, b, b, b)
  return function(b, F, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    return function(b, B)
      if B then
        if not B.Parent then
          return false
        end
      else
        return false
      end
      if not (F(B)) then
        return false
      end
      if N.Backstab_Team_Check then
        if _(B, M) then
          return false
        end
      end
      local F, _ = b:FindFirstChild("HumanoidRootPart"), S(B, "Body")
      if F then
        if not _ then
          return false
        end
      else
        return false
      end
      B, b = (_.Position - F.Position).Magnitude, N.Backstab_Range + 10
      return B <= b
    end
  end
end

--[[
  Phantom Hub - NearestPlayerSearch

  Role: Nearest-player search. Returns the closest player with a HumanoidRootPart/Body part.
  Category: combat
  Recovered factory key: 97   source position: 23   bytes: 469

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1..5]=LocalPlayer, Players, filter, distance helper and part resolver.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local NearestPlayerSearch = function(b, F, F, F, F)
  return function(F)
    local N = F[1]
    local _ = F[2]
    local M = F[3]
    local S = F[4]
    local B = F[5]
    return function()
      local F = N.Character
      local D = F and (F:FindFirstChild("HumanoidRootPart"))
      if not D then
        return nil, 0
      end
      local h, W, U, s = ipairs, b[62](M:GetPlayers()), _
      for _, M in h(b:Js(W)) do
        if M ~= N then
          if S(M) then
            F = B(M, "Body")
            if F then
              _ = (F.Position - D.Position).Magnitude
              if _ < U then
                U, s = _, M
              else
              end
            else
            end
          else
          end
        else
        end
      end
      return s, s and U or 0
    end
  end
end

--[[
  Phantom Hub - RageResolver

  Role: Rage resolver. Chooses between Zero Velocity and Desync resolver modes based on target movement.
  Category: combat
  Recovered factory key: 7   source position: 112   bytes: 425

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 4
    deps[1..4]=config, target state, velocity history and resolver output.
  Runtime/state fields: Rage_Resolver

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local RageResolver = function(b, b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    return function(b, S)
      if F.Rage_Resolver == "Zero Velocity" then
        return N
      elseif F.Rage_Resolver == "Desync Resolver" then
        if _[b] then
          if #_[b].Data >= 2 then
            local F = _[b]
            local b, N = F.Data[1], F.Data[2]
            if b then
              if N then
                if b.T ~= N.T then
                  F = (b.P - N.P) / (b.T - N.T)
                  local b, N, _ = F.X, S.Y, F.Z
                  return M(b, N, _)
                end
              end
            end
          end
        end
      end
      return S
    end
  end
end

--[[
  Phantom Hub - VisibilityRay

  Role: Visibility ray. Raycasts from the camera/character to a target part and reports clear line of sight.
  Category: combat
  Recovered factory key: 9   source position: 27   bytes: 392

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1..5]=camera, raycast params, filter and target part.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local VisibilityRay = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    return function(b, B)
      local D, h = F.CurrentCamera, N.Character
      if _[6][_[5]] ~= D or M[6][M[5]] ~= h then
        _[6][_[5]], M[6][M[5]] = D, h
        S.FilterDescendantsInstances = h and { D, h } or { D }
      end
      h = D.CFrame.Position
      D = F:Raycast(h, b - h, S)
      if D then
        return D.Instance:IsDescendantOf(B)
      end
      return true
    end
  end
end

--[[
  Phantom Hub - ShieldCache

  Role: Shield cache. Scans players for shields and caches the results for auto-shoot shield checks.
  Category: combat
  Recovered factory key: 35   source position: 225   bytes: 369

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 3
    deps[1..3]=config, shield scanner and cache.
  Runtime/state fields: Auto_Shoot_Shield_Check, Check_Shields_Impl, Shield_Check_R, Shield_Check_T

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local ShieldCache = function(b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    return function()
      if not F.Auto_Shoot_Shield_Check then
        return false
      end
      local b = N()
      if b - (_.Shield_Check_T or 0) < 0.2 then
        local F = _.Shield_Check_R or false
        return F
      end
      _.Shield_Check_T = b
      local b, F = pcall(_.Check_Shields_Impl)
      _.Shield_Check_R = b and F or false
      return _.Shield_Check_R
    end
  end
end

--[[
  Phantom Hub - AutoReload

  Role: Auto reload. Re-equips/reloads the current weapon when Rage_Auto_Reload is enabled and the magazine is
  empty.
  Category: combat
  Recovered factory key: 5058   source position: 85   bytes: 314

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 4
    deps[1..4]=config, LocalPlayer, reload helper and ammo check.

  Persisted config fields: Rage_Auto_Reload, Rage_Enabled

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local AutoReload = function(b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    return function(b)
      if F.Rage_Enabled then
        if F.Rage_Auto_Reload then
          if b then
            if b:FindFirstChild("HumanoidRootPart") then
              local b = N()
              if b ~= nil then
                if b == 0 then
                  _()
                else
                  M[6][M[5]] = false
                end
              end
            end
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - DuelCheck

  Role: Duel check. Calls the Fighter's GetDuel and reports whether the player is currently in a duel.
  Category: combat
  Recovered factory key: 112   source position: 131   bytes: 209

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1]=Fighter getter, deps[2]=player identifier.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local DuelCheck = function(b, b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    return function()
      local b = F()
      if not b then
        return false
      end
      local F, _ = pcall(function()
        return b:GetDuel(N)
      end)
      return F and _ ~= nil
    end
  end
end

--[[
  Phantom Hub - EquipItem

  Role: Equip item. Calls LocalFighter:EquipItem for the requested tool.
  Category: combat
  Recovered factory key: 25   source position: 52   bytes: 201

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 1
    deps[1]=Fighter getter.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local EquipItem = function(b, b, b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    return function(b)
      local N = F()
      local F = N and N.LocalFighter
      if F then
        pcall(function()
          F:EquipItem(b)
        end)
        return true
      end
      return false
    end
  end
end

-- ============================================================================
-- VISUALS / ESP / CHAMS (6 factories)
-- ============================================================================

--[[
  Phantom Hub - EspRenderer

  Role: Player ESP renderer. Draws boxes, fills, gradients, health bars, names, distance text, head circles,
  skeletons and tracers with Drawing objects. Handles R6/R15 bone layouts plus team/visibility filtering.
  Category: visuals
  Recovered factory key: 81   source position: 193   bytes: 5642

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 22
    deps[1]=hide-player, [2]=hide-bones, [3]=Vector3.new, [4]=pixel-height rounding, [5]=property setter,
    [6]=config, [7]=drawing visibility, [8]=3D box renderer, [9]=color lerp, [10]=Vector2.new, [11]=distance
    format, [12]=loadout text, [13]=clamp, [14..15]=health colors, [16..17]=R15/R6 bones, [18]=hide-skeleton,
    [19]=part screen position, [20]=visibility check, [21..22]=screen-coordinate tables.

  Persisted config fields: Box_Color, Box_Fill_Color, Box_Fill_Expand_X, Box_Fill_Expand_Y, Box_Fill_Opacity,
  Distance_Color, Esp_Box, Esp_Box_Fill, Esp_Box_Gradient, Esp_Box_Type, Esp_Distance, Esp_Head_Circle,
  Esp_Health_Bar, Esp_Name, Esp_Outline, Esp_Skeleton, Esp_Tracers, Grad_Bands, Head_Circle, Health_Bar,
  Name_Color, Skeleton_Color, Tracer_Color, Tracer_Thickness

  Runtime/state fields: Bone_Parts, Box_Fill, Box_Gradient_Bands, Box_Gradient_Color1, Box_Gradient_Color2,
  Box_Gradient_Direction, Box_Gradient_Opacity, Cam_Pos, Corner_Lines, Enemy_Loadout, Health_Bar_Bg, Hp_Lerp,
  Local_Pos, Tracer_From

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local EspRenderer = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    local g = b[14]
    local o = b[15]
    local V = b[16]
    local q = b[17]
    local j = b[18]
    local m = b[19]
    local i = b[20]
    local k = b[21]
    local G = b[22]
    return function(b, A, l, r)
      local E, Z = r.Camera, b.Character
      if not Z then
        F(A)
        return
      end
      local d = Z:FindFirstChildOfClass("Humanoid")
      if d then
        if d.Health <= 0 then
          F(A)
          return
        end
      else
        F(A)
        return
      end
      if A.Char ~= Z or not A.Parts.Hrp or not A.Parts.Head or not A.Parts.Hrp.Parent then
        A.Char = Z
        A.Parts.Head = Z:FindFirstChild("HitboxHead", true) or Z:FindFirstChild("Head", true)
        A.Parts.Hrp = Z:FindFirstChild("HumanoidRootPart")
          or Z:FindFirstChild("HumanoidRootPart", true)
          or Z:FindFirstChild("UpperTorso", true)
          or Z:FindFirstChild("Torso", true)
        N(A.Bone_Parts)
      end
      local L, e = A.Parts.Hrp, A.Parts.Head
      if L then
        if not e then
          F(A)
          return
        end
      else
        F(A)
        return
      end
      local H = L.Position
      L = (H - r.Cam_Pos).Magnitude
      if L > 2500 then
        F(A)
        return
      end
      L = e.Position
      local n, u = E:WorldToViewportPoint(L + _(0, 0.5, 0))
      local y, R = E:WorldToViewportPoint(H - _(0, 3.5, 0))
      if (if u then not R else not u) or n.Z < 0 or y.Z < 0 then
        F(A)
        return
      end
      R = M(n.Y - y.Y)
      e = R * 0.6
      local F, _ = n.X - e / 2, n.Y
      A.Hidden = false
      S(A, A.Name, "Outline", B.Esp_Outline)
      S(A, A.Distance, "Outline", B.Esp_Outline)
      if B.Esp_Box then
        if B.Esp_Box_Type == "3D" then
          D(A.Box_Fill, false)
          for M = 1, 16, 1 do
            D(A.Grad_Bands[M], false)
          end
          D(A.Box, false)
          for M = 1, 8, 1 do
            D(A.Corner_Lines[M], false)
          end
          h(E, Z, A)
        elseif B.Esp_Box_Type == "Standard" then
          u = #A.Box3
          for M = 1, u, 1 do
            D(A.Box3[M], false)
          end
          if B.Esp_Box_Gradient then
            D(A.Box_Fill, false)
            local M, h, C =
              1 - B.Box_Gradient_Opacity / 100, math.max(1, math.min(16, B.Box_Gradient_Bands)), B.Box_Gradient_Direction ~= "Horizontal"
            for I = 1, h, 1 do
              local x, a = A.Grad_Bands[I], h == 1 and 0 or (I - 1) / (h - 1)
              x.Color = W(B.Box_Gradient_Color1, B.Box_Gradient_Color2, a)
              x.Transparency = M
              if C then
                local W, C = math.floor(_ + (I - 1) * R / h + 0.5), math.floor(_ + I * R / h + 0.5)
                x.Size = U(e, math.max(1, C - W))
                x.Position = U(F, W)
              else
                local W, C = math.floor(F + (I - 1) * e / h + 0.5), math.floor(F + I * e / h + 0.5)
                x.Size = U(math.max(1, C - W), R)
                x.Position = U(W, _)
              end
              D(x, true)
            end
            M = h + 1
            for h = M, 16, 1 do
              D(A.Grad_Bands[h], false)
            end
          elseif B.Esp_Box_Fill then
            for M = 1, 16, 1 do
              D(A.Grad_Bands[M], false)
            end
            local M, h = B.Box_Fill_Expand_X, B.Box_Fill_Expand_Y
            A.Box_Fill.Size = U(e + M * 2, R + h * 2)
            A.Box_Fill.Position = U(F - M, _ - h)
            A.Box_Fill.Color = B.Box_Fill_Color
            A.Box_Fill.Transparency = 1 - B.Box_Fill_Opacity / 100
            D(A.Box_Fill, true)
          else
            D(A.Box_Fill, false)
            for M = 1, 16, 1 do
              D(A.Grad_Bands[M], false)
            end
          end
          D(A.Box, true)
          A.Box.Size = U(e, R)
          A.Box.Position = U(F, _)
          S(A, A.Box, "Color", B.Box_Color)
          for M = 1, 8, 1 do
            D(A.Corner_Lines[M], false)
          end
        else
          D(A.Box_Fill, false)
          for M = 1, 16, 1 do
            D(A.Grad_Bands[M], false)
          end
          D(A.Box, false)
          local M = #A.Box3
          for h = 1, M, 1 do
            D(A.Box3[h], false)
          end
          local M, h, W, C, I = e / 3, A.Corner_Lines, _ + R, F + e, B.Box_Color
          h[1].From = U(F, _)
          h[1].To = U(F + M, _)
          S(A, h[1], "Color", I)
          D(h[1], true)
          h[2].From = U(F, _)
          h[2].To = U(F, _ + M)
          S(A, h[2], "Color", I)
          D(h[2], true)
          h[3].From = U(C - M, _)
          h[3].To = U(C, _)
          S(A, h[3], "Color", I)
          D(h[3], true)
          h[4].From = U(C, _)
          h[4].To = U(C, _ + M)
          S(A, h[4], "Color", I)
          D(h[4], true)
          h[5].From = U(F, W)
          h[5].To = U(F + M, W)
          S(A, h[5], "Color", I)
          D(h[5], true)
          h[6].From = U(F, W - M)
          h[6].To = U(F, W)
          S(A, h[6], "Color", I)
          D(h[6], true)
          h[7].From = U(C - M, W)
          h[7].To = U(C, W)
          S(A, h[7], "Color", I)
          D(h[7], true)
          h[8].From = U(C, W - M)
          h[8].To = U(C, W)
          S(A, h[8], "Color", I)
          D(h[8], true)
        end
      else
        D(A.Box_Fill, false)
        for M = 1, 16, 1 do
          D(A.Grad_Bands[M], false)
        end
        D(A.Box, false)
        for M = 1, 8, 1 do
          D(A.Corner_Lines[M], false)
        end
        local M = #A.Box3
        for h = 1, M, 1 do
          D(A.Box3[h], false)
        end
      end
      if B.Esp_Head_Circle then
        local M, h = E:WorldToViewportPoint(L)
        if h then
          if M.Z > 0 then
            D(A.Head_Circle, true)
            A.Head_Circle.Position = U(M.X, M.Y)
            A.Head_Circle.Radius = e / 5
            S(A, A.Head_Circle, "Color", B.Box_Color)
          else
            D(A.Head_Circle, false)
          end
        else
          D(A.Head_Circle, false)
        end
      else
        D(A.Head_Circle, false)
      end
      if B.Esp_Name then
        D(A.Name, true)
        S(A, A.Name, "Text", b.Name)
        A.Name.Position = U(n.X, _ - 16)
        S(A, A.Name, "Color", B.Name_Color)
      else
        D(A.Name, false)
      end
      if B.Esp_Distance then
        L = s((r.Local_Pos - H).Magnitude)
        D(A.Distance, true)
        S(A, A.Distance, "Text", L .. "m")
        A.Distance.Position = U(n.X, _ + R + 2)
        S(A, A.Distance, "Color", B.Distance_Color)
      else
        D(A.Distance, false)
      end
      if B.Enemy_Loadout then
        u = c(b)
        if u ~= "" then
          D(A.Loadout, true)
          S(A, A.Loadout, "Text", u)
          A.Loadout.Position = U(n.X, _ + R + (B.Esp_Distance and 16 or 2))
          S(A, A.Loadout, "Color", B.Name_Color)
        else
          D(A.Loadout, false)
        end
      else
        D(A.Loadout, false)
      end
      if B.Esp_Health_Bar then
        u = d.MaxHealth
        n = u > 0 and Y(d.Health / u, 0, 1) or 0
        A.Hp_Lerp = A.Hp_Lerp + (n - A.Hp_Lerp) * Y(l * 8, 0, 1)
        b = R * A.Hp_Lerp
        D(A.Health_Bar_Bg, true)
        A.Health_Bar_Bg.From = U(F - 6, _)
        A.Health_Bar_Bg.To = U(F - 6, _ + R)
        D(A.Health_Bar, true)
        A.Health_Bar.From = U(F - 6, _ + R)
        A.Health_Bar.To = U(F - 6, _ + R - b)
        A.Health_Bar.Color = g:Lerp(o, A.Hp_Lerp)
      else
        D(A.Health_Bar_Bg, false)
        D(A.Health_Bar, false)
      end
      if B.Esp_Tracers then
        D(A.Tracer, true)
        A.Tracer.From = r.Tracer_From
        A.Tracer.To = U(y.X, y.Y)
        S(A, A.Tracer, "Color", B.Tracer_Color)
        S(A, A.Tracer, "Thickness", B.Tracer_Thickness)
      else
        D(A.Tracer, false)
      end
      if B.Esp_Skeleton then
        L, b, _, l = d.RigType == Enum.HumanoidRigType.R15 and V or q, A.Skeleton, A.Bone_Parts, B.Skeleton_Color
        N(j)
        u = #L
        for N = 1, u, 1 do
          y = L[N]
          e, n = y[1], y[2]
          H, R, r = m(Z, _, e), m(Z, _, n), b[N]
          if H and R and i(E, H, e) then
            if i(E, R, n) then
              r.From = U(k[e], G[e])
              r.To = U(k[n], G[n])
              S(A, r, "Color", l)
              D(r, true)
            elseif r then
              D(r, false)
            end
          elseif r then
            D(r, false)
          end
        end
        F = #L + 1
        for N = F, 14, 1 do
          if b[N] then
            D(b[N], false)
          end
        end
      else
        local b = A.Skeleton
        for F = 1, 14, 1 do
          D(b[F], false)
        end
      end
    end
  end
end

--[[
  Phantom Hub - CrosshairRenderer

  Role: Crosshair renderer. Draws the configurable crosshair (dot, T-shape, gap, outline, rainbow, rotation)
  each frame.
  Category: visuals
  Recovered factory key: 43   source position: 147   bytes: 1650

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 12
    deps[1..12]=config, Drawing objects, timer and color helpers.

  Persisted config fields: Crosshair_Color, Crosshair_Dot, Crosshair_Enabled, Crosshair_Gap, Crosshair_Outline,
  Crosshair_Rainbow, Crosshair_Rainbow_Speed, Crosshair_Rotate, Crosshair_Rotate_Speed, Crosshair_Size,
  Crosshair_T_Shape, Crosshair_Thickness, T_Shape

  Runtime/state fields: Cross_Dx, Cross_Dy

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local CrosshairRenderer = function(b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    return function(b, Y)
      if not F.Crosshair_Enabled then
        N()
        return
      end
      local N = _.Cross
      N.Hidden = false
      local g = F.Crosshair_Color
      if F.Crosshair_Rainbow then
        M[6][M[5]] = (M[6][M[5]] + Y * F.Crosshair_Rainbow_Speed * 0.1) % 1
        g = S(M[6][M[5]], 1, 1)
      else
      end
      local M, S, o, V, q, j, m, i, k, G =
        b.X,
        b.Y,
        F.Crosshair_Gap,
        F.Crosshair_Size,
        F.Crosshair_Thickness,
        F.Crosshair_Outline and true or false,
        F.Crosshair_T_Shape and true or false,
        F.Crosshair_Dot and true or false,
        1,
        0
      if F.Crosshair_Rotate then
        B[6][B[5]] = (B[6][B[5]] + Y * F.Crosshair_Rotate_Speed) % 6.283185307179586
        k, G = (math.cos(B[6][B[5]])), math.sin(B[6][B[5]])
      else
      end
      Y = N.Cx == nil or N.Out ~= j or N.T_Shape ~= m or N.Dot ~= i
      local F, B = Y or N.Cx ~= M or N.Cy ~= S or N.G ~= o or N.S ~= V or N.Cos ~= k or N.Sin ~= G, Y or N.T ~= q or N.Col ~= g
      if F then
      elseif B then
      else
        return
      end
      N.Cx = M
      N.Cy = S
      N.G = o
      N.S = V
      N.Cos = k
      N.Sin = G
      N.T = q
      N.Col = g
      N.Out = j
      N.T_Shape = m
      N.Dot = i
      Y, N = _.Cross_Dx, _.Cross_Dy
      for _ = 1, 4, 1 do
        local A, l = D[_], h[_]
        if _ == 3 and m or V <= 0 then
          W(A, false)
          W(l, false)
        else
          if F then
            local D, h = Y[_], N[_]
            local N, _, Y, m = D * o, h * o, D * (o + V), h * (o + V)
            h, D = U(M + (N * k - _ * G), S + (N * G + _ * k)), U(M + (Y * k - m * G), S + (Y * G + m * k))
            A.From = h
            A.To = D
            if j then
              l.From = h
              l.To = D
            end
          end
          if B then
            A.Thickness = q
            A.Color = g
            if j then
              l.Thickness = q + 2
            end
          end
          W(A, true)
          W(l, j)
        end
      end
      if i then
        if F then
          s.Position = b
        end
        if B then
          s.Radius = q
          s.Color = g
        end
        W(s, true)
        if j then
          if F then
            c.Position = b
          end
          if B then
            c.Radius = q + 1
          end
        end
        W(c, j)
      else
        W(s, false)
        W(c, false)
      end
    end
  end
end

--[[
  Phantom Hub - ChamsController

  Role: Chams controller. Applies material/color/transparency overrides to character body parts, with arms-only,
  weapon-only and rainbow modes.
  Category: visuals
  Recovered factory key: 58   source position: 25   bytes: 981

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 11
    deps[1..11]=config, character cache, material table, color helpers and refresh callback.

  Persisted config fields: Chams_Arms_Only, Chams_Color, Chams_Material, Chams_Rainbow, Chams_Transparency,
  Chams_Weapon_Only

  Runtime/state fields: Chams_Hue, Chams_Next, Is_Arm, Is_Weapon

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local ChamsController = function(b, b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    return function()
      local b = F()
      if not b then
        if N[6][N[5]] then
          N[6][N[5]] = nil
          _(M)
        end
        return
      end
      local F = S()
      if b ~= N[6][N[5]] then
        N[6][N[5]] = b
        D(b)
        B[6][B[5]] = false
      elseif B[6][B[5]] then
        N[6][N[5]] = b
        D(b)
        B[6][B[5]] = false
      elseif F < (h.Chams_Next or 0) then
        return
      end
      h.Chams_Next = F + (W.Chams_Rainbow and 0.03 or 0.1)
      b, F = U[W.Chams_Material] or Enum.Material.ForceField, W.Chams_Color
      F = if W.Chams_Rainbow then s(h.Chams_Hue, 1, 1) else F
      local N, _, S = W.Chams_Arms_Only, W.Chams_Weapon_Only, W.Chams_Transparency
      local B, D = N or _, #M
      for h = 1, D, 1 do
        local D = M[h]
        h = D.Part
        if not h.Parent then
          continue
        end
        if (if B then N and D.Is_Arm else not B) or _ and D.Is_Weapon then
          if h.Material ~= b then
            h.Material = b
          end
          if h.Color ~= F then
            h.Color = F
          end
          if h.Transparency ~= S then
            h.Transparency = S
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - EspOrchestrator

  Role: ESP orchestrator. Iterates visible players, updates cached ESP objects and dispatches
  box/name/health/tracer/skeleton renderers.
  Category: visuals
  Recovered factory key: 124   source position: 102   bytes: 962

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 12
    deps[1..12]=config, Players, camera, drawing cache and per-object renderers.

  Persisted config fields: Esp_Enabled, Esp_Team_Check, Esp_Tracers, Tracer_Origin

  Runtime/state fields: Cam_Pos, Esp_Objects, Local_Pos, Tracer_From

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local EspOrchestrator = function(b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    return function(b)
      if not F.Esp_Enabled then
        if N[6][N[5]] then
          N[6][N[5]] = false
          local Y, g = pairs, _.Esp_Objects
          for o, o in Y(g) do
            M(o)
          end
        end
        return
      end
      N[6][N[5]] = true
      local N = S.CurrentCamera
      if not N then
        return
      end
      B.Camera = N
      B.Cam_Pos = N.CFrame.Position
      local S = D.Character
      local Y = S and (S:FindFirstChild("HumanoidRootPart"))
      B.Local_Pos = Y and Y.Position or B.Cam_Pos
      if F.Esp_Tracers then
        S, Y = N.ViewportSize, F.Tracer_Origin
        if Y == "Top" then
          B.Tracer_From = h(S.X / 2, 0)
        elseif Y == "Center" then
          B.Tracer_From = h(S.X / 2, S.Y / 2)
        elseif Y == "Mouse" then
          local g = W:GetMouseLocation()
          B.Tracer_From = h(g.X, g.Y)
        else
          B.Tracer_From = h(S.X / 2, S.Y)
        end
      end
      N, Y = pairs, _.Esp_Objects
      for _, h in N(Y) do
        S = U(_) or F.Esp_Team_Check and s(_, D)
        if S then
          M(h)
        else
          c(_, h, b, B)
        end
      end
    end
  end
end

--[[
  Phantom Hub - HitMarkerRenderer

  Role: Hit marker renderer. Draws expanding line/diamond hit markers with configurable life, gap, size,
  thickness, color and rainbow speed.
  Category: visuals
  Recovered factory key: 37   source position: 16   bytes: 942

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 7
    deps[1..7]=config, marker list, camera, color helper and drawing factory.

  Persisted config fields: Hit_Marker_Color, Hit_Marker_Gap, Hit_Marker_Life, Hit_Marker_Rainbow,
  Hit_Marker_Rainbow_Speed, Hit_Marker_Size, Hit_Marker_Thickness

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local HitMarkerRenderer = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    return function(b)
      if #F == 0 then
        return
      end
      N[6][N[5]] = (N[6][N[5]] + b * 0.5 * _.Hit_Marker_Rainbow_Speed) % 1
      local h, W, U = M.CurrentCamera, S(), #F
      for M = U, 1, -1 do
        b = F[M]
        local S = (W - b.T0) / _.Hit_Marker_Life
        if S >= 1 then
          for W, W in ipairs(b.Lines) do
            W:Remove()
          end
          table.remove(F, M)
        else
          local F = b.Part and b.Part.Parent and b.Part.Position or b.Pos
          local M, W = h:WorldToViewportPoint(F)
          if W and M.Z > 0 then
            local h, W, U, s, c, Y, g =
              M.X,
              M.Y,
              _.Hit_Marker_Gap,
              _.Hit_Marker_Size,
              _.Hit_Marker_Rainbow and B(N[6][N[5]], 1, 1) or _.Hit_Marker_Color,
              1 - S,
              _.Hit_Marker_Thickness
            F = U + s
            for N = 1, 4, 1 do
              local _, M, S = (N == 1 or N == 3) and -1 or 1, N <= 2 and -1 or 1, b.Lines[N]
              S.Visible = true
              S.From = D(h + _ * U, W + M * U)
              S.To = D(h + _ * F, W + M * F)
              S.Color = c
              S.Transparency = Y
              S.Thickness = g
            end
          else
            for F, F in ipairs(b.Lines) do
              F.Visible = false
            end
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - DamageNumberHook

  Role: Damage-number hook. Watches BillboardGuis, parses numeric damage text and re-renders it using the
  configured hit-effect style.
  Category: visuals
  Recovered factory key: 59   source position: 92   bytes: 869

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 4
    deps[1..4]=config, style registry, replacement renderer and cache.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local DamageNumberHook = function(b, b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    return function(b)
      if not F[6][F[5]] then
        return
      end
      if not (b:IsA("BillboardGui")) then
        return
      end
      if b.Name == "PhantomDamageNumber" then
        return
      end
      task.defer(function()
        if not b.Parent then
          return
        end
        local F = b:FindFirstChildWhichIsA("TextLabel", true)
        if not F then
          return
        end
        local S = F.Text
        F = tonumber(S)
        if F then
          if not (F > 0) then
            return
          end
        else
          return
        end
        F = b.Adornee or b.Parent:IsA("BasePart") and b.Parent
        if not F then
          return
        end
        local B = if F:IsA("BasePart") then F else if F:IsA("Attachment") then F.Parent else if F:IsA("Model") then F.PrimaryPart else nil
        if B then
          if not (B:IsA("BasePart")) then
            return
          end
        else
          return
        end
        local F, D = ipairs, N[6][N[5]]
        for N, h in F(D) do
          if h == "Fortnite" then
            b.Enabled = false
            _(B, S)
          else
            N = M[h]
            if N then
              pcall(N, B)
            end
          end
        end
      end)
    end
  end
end

-- ============================================================================
-- MOVEMENT / ANTI-AIM (4 factories)
-- ============================================================================

--[[
  Phantom Hub - MovementAntiAimController

  Role: Movement, bhop/strafe and anti-aim controller. Applies WalkSpeed / JumpPower / strafe speed, Rage AA yaw
  and pitch, and handles the jump / anti-aim pause states.
  Category: movement
  Recovered factory key: 10167   source position: 113   bytes: 2646

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 16
    deps[1..16]=config, Humanoid/RootPart access, input state, anti-aim state and CFrame helpers.

  Persisted config fields: Aim_Hold_Rmb, Aimbot_Enabled, Jp_Enabled, Jump_Power, Rage_Aa_Aim_Pause,
  Rage_Aa_Enabled, Rage_Aa_Pitch, Rage_Aa_Yaw, Strafe_Speed, Walk_Speed, Ws_Enabled

  Runtime/state fields: Aa_Active, Aa_Rj, Aa_Rj_Char

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local MovementAntiAimController = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    local g = b[14]
    local o = b[15]
    local V = b[16]
    return function(b)
      local q = b and (b:FindFirstChildOfClass("Humanoid"))
      if q then
        local j = b:FindFirstChild("HumanoidRootPart")
        if F.Ws_Enabled then
          q.WalkSpeed = F.Walk_Speed
        end
        if F.Jp_Enabled then
          q.UseJumpPower = true
          q.JumpPower = F.Jump_Power
        end
        if F.Bhop then
          local m = Enum.KeyCode.Space
          if N:IsKeyDown(m) then
            if q.FloorMaterial ~= Enum.Material.Air then
              q.Jump = true
            end
          end
        end
        if F.Strafes then
          if q.FloorMaterial == Enum.Material.Air then
            local m = q.MoveDirection
            if j then
              if m.Magnitude > 0 then
                local i = _.CurrentCamera.CFrame
                local _, k = i.LookVector, i.RightVector
                local i, G = M(_.X, 0, _.Z).Unit, M(k.X, 0, k.Z).Unit
                k = i * m:Dot(i) + G * m:Dot(G)
                if k.Magnitude > 0 then
                  j.AssemblyLinearVelocity = M(k.X * F.Strafe_Speed, j.AssemblyLinearVelocity.Y, k.Z * F.Strafe_Speed)
                end
              end
            end
          end
        end
        local _ = F.Rage_Aa_Enabled and S(B)
        _ = _
          and (
            if F.Rage_Aa_Aim_Pause
              then if F.Aimbot_Enabled
                then if F.Aim_Hold_Rmb then if N:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then false else _ else false
                else _
              else _
          )
        D.Aa_Active = _ and F.Rage_Aa_Yaw ~= "None"
        if _ then
          if j then
            local N = if F.Rage_Aa_Yaw == "Spin"
              then (h() - W) * 100 % 6.283185307179586
              else if F.Rage_Aa_Yaw == "Jitter"
                then math.floor(h() * 600) % 2 == 0 and 3.141592653589793 or 0
                else if F.Rage_Aa_Yaw == "Backward" then U(180) else if F.Rage_Aa_Yaw == "Sideways" then U(90) else nil
            if N then
              if s[6][s[5]] == nil then
                s[6][s[5]] = q.AutoRotate
              end
              q.AutoRotate = false
              j.CFrame = c(j.Position) * Y(0, N, 0)
            elseif s[6][s[5]] ~= nil then
              q.AutoRotate = s[6][s[5]]
              s[6][s[5]] = nil
            end
          end
          local N, _ = D.Aa_Rj
          if D.Aa_Rj_Char ~= b or not N or not N.Parent then
            local M = b:FindFirstChild("RootJoint", true)
            if M then
              N = M
            else
              N = b:FindFirstChild("LowerTorso") and b.LowerTorso:FindFirstChild("Root")
            end
            D.Aa_Rj = N
            D.Aa_Rj_Char = b
            _ = N
          else
            _ = N
          end
          if _ then
            if not g[_] then
              g[_] = _.C0
            end
            local b, N = 0
            if F.Rage_Aa_Pitch == "Down" then
              b = U(-60)
              N = b
            else
              if F.Rage_Aa_Pitch == "Up" then
                b = U(60)
              else
                if F.Rage_Aa_Pitch == "Jitter" then
                  b = U(o(-60, 60) * 10)
                else
                end
              end
              N = b
            end
            if N ~= 0 then
              pcall(function()
                _.C0 = g[_] * Y(N, 0, 0)
              end)
            else
              pcall(function()
                _.C0 = g[_]
              end)
            end
          end
        else
          if s[6][s[5]] ~= nil then
            q.AutoRotate = s[6][s[5]]
            s[6][s[5]] = nil
          end
          if next(g) then
            local b = pairs
            for F, N in b(g) do
              if F and F.Parent then
                pcall(function()
                  F.C0 = N
                end)
              end
            end
            V(g)
          end
        end
      else
        s[6][s[5]] = nil
        D.Aa_Active = false
        if next(g) then
          local b = pairs
          for F, N in b(g) do
            if F then
              if F.Parent then
                F.C0 = N
              end
            end
          end
          V(g)
        end
      end
    end
  end
end

--[[
  Phantom Hub - FlyController

  Role: Fly controller. Converts movement input into a fly velocity and applies it to the HumanoidRootPart while
  Fly_Enabled is set.
  Category: movement
  Recovered factory key: 9656   source position: 97   bytes: 835

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1..5]=config, key input, Vector3 helper and physics state.

  Persisted config fields: Fly_Enabled, Fly_Speed

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local FlyController = function(b, b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    return function(b, B, D)
      if F.Fly_Enabled then
        if b then
          local h, W = b:FindFirstChild("HumanoidRootPart"), b:FindFirstChildOfClass("Humanoid")
          if h then
            if W then
              local b, U = W.MoveDirection
              if b.Magnitude > 0 then
                local W = B.CFrame
                local B, s = W.LookVector, W.RightVector
                local W, c = _(B.X, 0, B.Z).Unit, _(s.X, 0, s.Z).Unit
                U = B * b:Dot(W) + s * b:Dot(c)
              else
                U = N
              end
              U = if M:IsKeyDown(Enum.KeyCode.Space) then U + _(0, 1, 0) else U
              U = if M:IsKeyDown(Enum.KeyCode.LeftControl) or M:IsKeyDown(Enum.KeyCode.LeftShift) then U - _(0, 1, 0) else U
              S[6][S[5]] = if U.Magnitude > 0 then S[6][S[5]]:Lerp(U.Unit * F.Fly_Speed, 10 * D) else N
              h.CFrame = h.CFrame + S[6][S[5]] * D
              h.AssemblyLinearVelocity = N
              h.AssemblyAngularVelocity = N
            end
          end
        else
          S[6][S[5]] = N
        end
      else
        S[6][S[5]] = N
      end
    end
  end
end

--[[
  Phantom Hub - NoclipController

  Role: Noclip controller. Saves CanCollide state for character parts, disables collisions while Noclip is
  active and restores them afterwards.
  Category: movement
  Recovered factory key: 4655   source position: 30   bytes: 592

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1..5]=config, LocalPlayer, state flag, restore callback and part list.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local NoclipController = function(b, F, F, F, F, F)
  return function(F, N, N, N)
    local N = F[1]
    local _ = F[2]
    local M = F[3]
    local S = F[4]
    local B = F[5]
    return function()
      if N.Noclip and _.Character then
        if not M[6][M[5]] then
          S(B)
          local F, N = pairs, b[62](_.Character:GetDescendants())
          for _, _ in F(b:Js(N)) do
            if _:IsA("BasePart") then
              B[#B + 1] = { P = _, C = _.CanCollide }
            end
          end
          M[6][M[5]] = true
        end
        local b = #B
        for F = 1, b, 1 do
          local b = B[F]
          if b.P.Parent then
            b.P.CanCollide = false
          end
        end
      elseif M[6][M[5]] then
        local b = #B
        for F = 1, b, 1 do
          local b = B[F]
          if b.P then
            if b.P.Parent then
              b.P.CanCollide = b.C
            end
          end
        end
        S(B)
        M[6][M[5]] = false
      end
    end
  end
end

--[[
  Phantom Hub - MovementMetatablePatches

  Role: Movement metatable patches. Hooks WalkSpeed, JumpPower, third-person camera limits and
  LocalTransparencyModifier.
  Category: movement
  Recovered factory key: 7733   source position: 154   bytes: 552

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1..2]=config and the patched instance/metatable.

  Persisted config fields: Jp_Enabled, Third_Person, Ws_Enabled

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local MovementMetatablePatches = function(b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    return function(b, _, M)
      if not (checkcaller()) then
        if F.Third_Person then
          if _ == "LocalTransparencyModifier" then
            if M == 1 then
              return
            end
          end
          if _ == "CameraMaxZoomDistance" then
            if M < 1 then
              return
            end
          elseif _ == "CameraMinZoomDistance" then
            if M < 1 then
              return
            end
          end
        end
        if _ == "WalkSpeed" then
          if F.Ws_Enabled then
            return
          elseif _ == "JumpPower" then
            if F.Jp_Enabled then
              return
            end
          end
        elseif _ == "JumpPower" then
          if F.Jp_Enabled then
            return
          end
        end
      end
      local F = N[6][N[5]]
      return F(b, _, M)
    end
  end
end

-- ============================================================================
-- EXPLOIT / DESYNC / SPOOFING (6 factories)
-- ============================================================================

--[[
  Phantom Hub - NamecallGuard

  Role: Namecall hook. Blocks Kick / Teleport / TeleportToPlaceInstance / Ban, rewrites FireServer arguments
  while desync or void-spam is active, and implements projectile teleport / wallbang forwarding.
  Category: exploit
  Recovered factory key: 9390   source position: 110   bytes: 3658

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 11
    deps[1]=original namecall, [2]=config, [3]=CFrame encoder, [4]=hit-part helper, [5]=CFrame keys,
    [6..11]=desync/wallbang state and helpers.

  Persisted config fields: Desync_Enabled, Desync_Mode, Rage_Enabled, Sa_Enabled, Sa_Hit_Chance, Void_Spam,
  Wallbang_Enabled

  Runtime/state fields: CF_KEY_CAMERA, CF_KEY_OFFSET, CF_KEY_ORIGIN, CF_KEY_PART, Encode_Cframe,
  Premium_Hit_Part, Projectile_TP, Rage_Projectile_TP, SC_Enabled, SC_Helpers, Sa_Roll_Hit, Sa_Roll_Time,
  Sa_Target_Part, Sa_Target_Pos, Sa_Use_Live, Wallbang_Target, Wallbang_Until

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local NamecallGuard = function(b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    return function(b, ...)
      if checkcaller() then
        local c = F[6][F[5]]
        return c(b, ...)
      end
      local c = getnamecallmethod()
      if c == "Kick" then
        return nil
      end
      if c == "Teleport" then
        return nil
      elseif c == "TeleportToPlaceInstance" then
        return nil
      end
      if c == "Ban" then
        return nil
      elseif c == "ban" then
        return nil
      end
      local Y = N.Desync_Enabled and (N.Desync_Mode == "Chaos" or N.Desync_Mode == "Jitter" or N.Desync_Mode == "Void")
      local g = Y or N.Void_Spam
      if c == "FireServer" and g and typeof(b) == "Instance" then
        local g, o = b.Name, ...
        if g == "OutOfBounds" then
          return
        elseif type(o) == "string" then
          if o:lower():find("outofbound") then
            return
          end
        end
        o = b.Parent
        for V = 1, 4, 1 do
          if not o then
            break
          end
          if o.Name == "Fighter" then
            if g == "OutOfBounds" then
              return
            end
          end
          o = o.Parent
        end
      end
      if c == "FireServer" then
        if N.Wallbang_Enabled then
          if Premium then
            if Premium.Wallbang_Target then
              if typeof(b) == "Instance" then
                if b.Name == "UseItem" then
                  local g, o, V = ...
                  Y = o == "\26" and type(V) == "table" and (g == "`" or g == "\195\168")
                  if Y then
                    o = Premium.Wallbang_Target
                    g = o and Premium_Hit_Part(o)
                    if g then
                      local o = V[CF_KEY_CAMERA]
                      if type(o) == "table" then
                        local V = g.Position
                        local q = V - _(0, 5, 0)
                        local _, j = M(q, V), g.CFrame:ToObjectSpace(S(V))
                        o[CF_KEY_ORIGIN] = Encode_Cframe(_)
                        o[CF_KEY_CAMERA] = Encode_Cframe(S(V) * (_ - _.Position))
                        o[CF_KEY_PART] = g
                        o[CF_KEY_OFFSET] = Encode_Cframe(j)
                        Premium.Wallbang_Until = B() + 0.15
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      if c == "WaitForChild" and N.SC_Enabled and next(D[6][D[5]]) ~= nil and typeof(b) == "Instance" then
        Y = ...
        if type(Y) == "string" and not b:FindFirstChild(Y) then
          local _, M = b, false
          for D = 1, 12, 1 do
            _ = _.Parent
            if not _ then
              break
            end
            if _.Name == "ViewModels" and _.Parent and _.Parent.Name == "Temp" then
              M = true
              break
            end
          end
          if M then
            pcall(SC_Helpers.EnsureChild, b, Y)
          end
        end
        if setnamecallmethod then
          pcall(setnamecallmethod, c)
        end
        local _ = F[6][F[5]]
        return _(b, ...)
      end
      Y = b == h and (N.Rage_Enabled or N.Sa_Enabled or N.Void_Spam)
      if Y then
        local _, M = N.Rage_Enabled and N.Rage_Projectile_TP
        if _ then
          M = _
        else
          local D = N.Rage_Enabled
          M = (if D then not D else N.Sa_Enabled) and N.Projectile_TP
        end
        _ = W.Sa_Target_Pos
        _ = if W.Sa_Use_Live then if W.Sa_Target_Part then if W.Sa_Target_Part.Parent then W.Sa_Target_Part.Position else _ else _ else _
        if not _ then
          local D = F[6][F[5]]
          return D(b, ...)
        end
        local D, h = (N.Rage_Enabled or N.Void_Spam) and 100 or N.Sa_Hit_Chance, B()
        if h - (W.Sa_Roll_Time or 0) > 0.06 then
          W.Sa_Roll_Time = h
          W.Sa_Roll_Hit = U(1, 100) <= D
        end
        h = W.Sa_Roll_Hit
        if c == "Raycast" then
          local N, B, W = ...
          if typeof(N) == "Vector3" then
            if typeof(B) == "Vector3" then
              if B.Magnitude > 15 then
                if h then
                  local B, U = (_ - N).Unit, F[6][F[5]]
                  return U(b, if M then _ - B * 1.5 else N, B * 5000, W)
                end
              end
            end
          end
        elseif c == "Spherecast" then
          local N, B, W, U = ...
          if typeof(N) == "Vector3" then
            if typeof(W) == "Vector3" then
              if W.Magnitude > 15 then
                if h then
                  local W, Y = (_ - N).Unit, F[6][F[5]]
                  return Y(b, if M then _ - W * 1.5 else N, B, W * 5000, U)
                end
              end
            end
          end
        elseif c == "Blockcast" then
          local N, B, W, U = ...
          if typeof(N) == "CFrame" then
            if typeof(W) == "Vector3" then
              if W.Magnitude > 15 then
                if h then
                  D = (_ - N.Position).Unit
                  local W, Y = if M then S(_ - D * 1.5) else N, F[6][F[5]]
                  return Y(b, W, B, D * 5000, U)
                end
              end
            end
          end
        elseif c == "FindPartOnRay" or c == "FindPartOnRayWithIgnoreList" or c == "FindPartOnRayWithWhitelist" then
          local N, S, B, D = ...
          if typeof(N) == "Ray" then
            if N.Direction.Magnitude > 15 then
              if h then
                local h, W = (_ - N.Origin).Unit, N.Origin
                W = if M then _ - h * 1.5 else W
                local N, _ = s(W, h * 5000), F[6][F[5]]
                return _(b, N, S, B, D)
              end
            end
          end
        end
      end
      c = F[6][F[5]]
      return c(b, ...)
    end
  end
end

--[[
  Phantom Hub - DesyncWallbangController

  Role: Desync, wallbang and position-lock controller. Builds the client/server CFrame streams, validates
  wallbang prerequisites, and applies the Jitter / Spin / Chaos / Void desync modes.
  Category: exploit
  Recovered factory key: 4353   source position: 109   bytes: 2699

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 16
    deps[1..16]=config, LocalPlayer, clock, notifier, CFrame helpers and cached client/server CFrames.

  Persisted config fields: Aimbot_Enabled, Desync_Distance, Desync_Enabled, Desync_Mode, Lock_Pos_Enabled,
  Sa_Enabled, Void_Spam, Wallbang_Enabled

  Runtime/state fields: Client_Cf, Current_Aim_Target, Free_Rage_Desync_Enabled, Free_Rage_Desync_Mode,
  Locked_Pos_Cf, Sa_Target_Player, Server_Cf, Wallbang_Target, Wallbang_Until

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local DesyncWallbangController = function(b, b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    local g = b[14]
    local o = b[15]
    local V = b[16]
    return function()
      local b = F.Character
      local q = b and (b:FindFirstChild("HumanoidRootPart"))
      if if q then not N(F) else not q then
        _.Server_Cf = nil
        _.Client_Cf = nil
        M()
        return
      end
      if S.Wallbang_Enabled then
        if not S.Aimbot_Enabled then
          if not S.Sa_Enabled then
            S.Wallbang_Enabled = false
            B:Notify("PHANTOM HUB", "Wallbang off: enable Aimbot or Silent Aim first", 5)
          end
        end
      end
      if S.Wallbang_Enabled then
        if _.Hooked then
          _.Wallbang_Target = h()
        elseif D() then
          _.Wallbang_Target = h()
        else
          S.Wallbang_Enabled = false
          B:Error("Wallbang unavailable on this executor")
        end
      else
        _.Wallbang_Target = nil
      end
      b = q.CFrame
      _.Client_Cf = b
      local F
      local B = W()
      if S.Wallbang_Enabled then
        if B < _.Wallbang_Until then
          local D = _.Wallbang_Target and _.Wallbang_Target.Character and _.Wallbang_Target.Character:FindFirstChild("HumanoidRootPart")
          if D then
            local W = D.CFrame * U(0, -5, 0)
            F = W
          else
          end
        else
        end
      else
      end
      if S.Lock_Pos_Enabled then
        if F then
        else
          if not s.Locked_Pos_Cf then
            s.Locked_Pos_Cf = b
          end
          F = s.Locked_Pos_Cf
        end
      else
        s.Locked_Pos_Cf = nil
      end
      local D
      if if F then not F else S.Desync_Enabled then
        local W, j = S.Desync_Mode, S.Desync_Distance
        if W == "Under" then
          F = b * U(0, -j, 0)
        else
          if W == "Behind" then
            F = b * U(0, 0, j)
          else
            if W == "Above" then
              F = b * U(0, j, 0)
            else
              if W == "Jitter" then
                local m, i, k = (c() - 0.5) * 2 * j * 10, (c() - 0.5) * j * 6, (c() - 0.5) * 2 * j * 10
                F = b * U(m, i, k)
              else
                if W == "Spin" then
                  F = b * Y(0, B * 120 % 6.283185307179586, 0) * U(0, 0, j)
                else
                  if W == "Chaos" then
                    local Y, m = (c() - 0.5) * 2 * j * 8, (c() - 0.5) * 2 * j * 8
                    F = b * U(Y, -j, m)
                  else
                    if W == "Void" then
                      local W = b.Position
                      F = U(W.X, W.Y - j * 80, W.Z)
                    else
                    end
                  end
                end
              end
            end
          end
        end
        D = F
      else
        D = F
      end
      B = D and S.Desync_Enabled and (S.Desync_Mode == "Jitter" or S.Desync_Mode == "Chaos")
      if B then
        pcall(function()
          local F = D.Position
          local W = g:GetPartBoundsInBox(U(F), o(6, 6, 6))
          for c, c in ipairs(W) do
            F = c.Name:lower()
            if F:find("barrier") then
              D = nil
              return
            elseif F:find("instakill") then
              D = nil
              return
            elseif F:find("oob") then
              D = nil
              return
            end
          end
        end)
      end
      if not D and S.Free_Rage_Desync_Enabled then
        B = S.Free_Rage_Desync_Mode
        if B == "Below" then
          D = b * U(0, -5, 0)
        else
          if B == "Up" then
            D = b * U(0, 5, 0)
          else
          end
        end
      else
      end
      if not D and S.Void_Spam then
        B = s.Current_Aim_Target or s.Sa_Target_Player
        if if B then not N(B) else not B then
          B = h()
          s.Sa_Target_Player = B
        else
        end
        if B then
          local F = b.Position
          D = U(F.X, F.Y - 500, F.Z)
        else
        end
      else
      end
      _.Server_Cf = D or b
      if D then
        V.Hrp = q
        V.Cf = b
        V.Vel = q.AssemblyLinearVelocity
        V.Rot = q.AssemblyAngularVelocity
        V.Active = true
        q.CFrame = D
      end
      M()
    end
  end
end

--[[
  Phantom Hub - PlayerIdentitySpoof

  Role: Player identity spoof loop. Rewrites player/character display strings in a loop; most likely
  chat/name/leaderboard spoofing.
  Category: exploit
  Recovered factory key: 127   source position: 195   bytes: 702

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 8
    deps[1..8]=Players, string buffers, config and property targets.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local PlayerIdentitySpoof = function(b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    return function()
      while true do
        local b = F[24](function()
          local W = F[1][F[2]][F[3]][F[4]][F[5]][F[6]][F[7]]
          local U, s = W[F[8]](W), F[9]
          for c, c in s(U) do
            if c[F[10]](c, F[11]) then
              if c[F[12]](c, F[20]) then
                W = c[F[20]][F[13]]
                if F[16](N, W[F[14]](W, 3)) then
                  _[6][_[5]] = c
                  break
                end
              end
            end
          end
          if _[6][_[5]] then
            U = _[6][_[5]][F[20]][F[13]]
            _[6][_[5]][F[20]][F[13]] = U[F[14]](U, 1, 2) .. N[1][F[14]](N[1], 1, 10) .. M .. S[6][S[5]] .. B[6][B[5]]
            _[6][_[5]][F[17]][F[18]] = D[6][D[5]]
            _[6][_[5]][F[20]][F[19]] = h[6][h[5]]
          end
        end)
        if b then
          F[21](F[23])
        else
          F[21](F[22])
        end
      end
    end
  end
end

--[[
  Phantom Hub - GameTitleSpoofer

  Role: Game-title spoofer. Builds a padded fake title string from encoded fragments and writes it to the title
  label.
  Category: exploit
  Recovered factory key: 82   source position: 83   bytes: 531

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 9
    deps[1..9]=timer state, string fragments, decoder and title label.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local GameTitleSpoofer = function(b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    return function()
      while true do
        if F[6][F[5]] then
          if N[6][N[5]] < _[6][_[5]] then
            N[6][N[5]] += 1
          end
          local b = M[6][M[5]](N[6][N[5]] / 5)
          D[6][D[5]] = S[B("P", 30780822482938)]
            .. S[B("\206", 10650770187967)]:rep(b)
            .. S[B("\218", 11767495764687)]:rep(20 - b)
            .. S[B("\18 \11", 17444542037878)]
            .. N[6][N[5]]
            .. S[B(" \207\135\147I", 4720313110828)]
        end
        h(0.03)
        if W[6][W[5]] then
          break
        end
      end
    end
  end
end

--[[
  Phantom Hub - GcDuelScanner

  Role: GC scanner for duel internals. Walks getgc tables to locate GetDuel/GetDuelByID functions.
  Category: exploit
  Recovered factory key: 21   source position: 229   bytes: 333

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1..2]=getgc and output cache.
  Runtime/state fields: Gc_Scan

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local GcDuelScanner = function(b, b, b, b, b, b)
  return function(b, F, F, F)
    local F = b[1]
    local N = b[2]
    return function()
      if F[6][F[5]] then
        local b = F[6][F[5]]
        return b
      end
      N.Gc_Scan("Duel", 60, function(b, b)
        return type(rawget(b, "GetDuel")) == "function" and type(rawget(b, "GetDuelByID")) == "function"
      end, function(b)
        F[6][F[5]] = b
      end)
      local b = F[6][F[5]]
      return b
    end
  end
end

--[[
  Phantom Hub - GcFighterScanner

  Role: GC scanner for Fighter/slide internals. Walks getgc tables to locate the Fighter metatable and
  SimulateInputBegan/Slide functions.
  Category: exploit
  Recovered factory key: 34   source position: 81   bytes: 333

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1..2]=getgc and output cache.
  Runtime/state fields: Gc_Scan

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local GcFighterScanner = function(b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    return function()
      if F[6][F[5]] then
        local b = F[6][F[5]]
        return b
      end
      N.Gc_Scan("Fighter", 60, function(b, b)
        return type(rawget(b, "SimulateInputBegan")) == "function" and type(rawget(b, "Slide")) == "function"
      end, function(b)
        F[6][F[5]] = b
      end)
      local b = F[6][F[5]]
      return b
    end
  end
end

-- ============================================================================
-- UI / LOADOUT VIEWER (4 factories)
-- ============================================================================

--[[
  Phantom Hub - LoadoutViewerGui

  Role: Loadout viewer GUI. Creates the PH_LoadoutViewer ScreenGui and lays out the target player's equipped
  weapon and loadout labels.
  Category: ui
  Recovered factory key: 24   source position: 61   bytes: 2296

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 9
    deps[1..9]=PlayerGui, config, target state and UI helper functions.
  Runtime/state fields: PH_LoadoutViewer

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local LoadoutViewerGui = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    return function()
      if F[6][F[5]] then
        if F[6][F[5]].Parent then
          return
        end
      end
      local b = gethui and gethui() or N:FindFirstChild("PlayerGui") or N:WaitForChild("PlayerGui")
      F[6][F[5]] = _(
        "ScreenGui",
        { Name = "PH_LoadoutViewer", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true },
        b
      )
      pcall(function()
        if syn then
          if syn.protect_gui then
            syn.protect_gui(F[6][F[5]])
          end
        end
      end)
      b = _(
        "Frame",
        { Size = UDim2.new(0, 320, 0, 150), Position = UDim2.new(0.5, -160, 0, 24), BackgroundColor3 = M.BG, BorderSizePixel = 0 },
        F[6][F[5]]
      )
      _("UICorner", { CornerRadius = UDim.new(0, 8) }, b)
      local F = _("UIStroke", { Color = M.Str, Thickness = 1 }, b)
      F.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      F = _("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = M.Ac, BorderSizePixel = 0 }, b)
      _("UICorner", { CornerRadius = UDim.new(0, 2) }, F)
      S[6][S[5]] = _("TextLabel", {
        Size = UDim2.new(1, -16, 0, 26),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = M.Ac,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "Waiting for target...",
      }, b)
      _("Frame", { Size = UDim2.new(1, -16, 0, 1), Position = UDim2.new(0, 8, 0, 32), BackgroundColor3 = M.Str, BorderSizePixel = 0 }, b)
      for N = 1, 4, 1 do
        B[6][B[5]][N] = _("TextLabel", {
          Size = UDim2.new(0, 180, 0, 22),
          Position = UDim2.new(0, 10, 0, 12 + N * 26),
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamMedium,
          TextSize = 13,
          TextColor3 = M.TxD,
          TextXAlignment = Enum.TextXAlignment.Left,
          Text = "[ " .. N .. " ]  -",
        }, b)
      end
      F = _(
        "Frame",
        { Size = UDim2.new(0, 110, 0, 100), Position = UDim2.new(1, -118, 0, 42), BackgroundColor3 = M.Con, BorderSizePixel = 0 },
        b
      )
      _("UICorner", { CornerRadius = UDim.new(0, 6) }, F)
      _("UIStroke", { Color = M.Str, Thickness = 1 }, F)
      D[6][D[5]] = _(
        "ViewportFrame",
        { Size = UDim2.new(1, -6, 1, -18), Position = UDim2.new(0, 3, 0, 3), BackgroundColor3 = M.Sec, BorderSizePixel = 0 },
        F
      )
      _("UICorner", { CornerRadius = UDim.new(0, 6) }, D[6][D[5]])
      h[6][h[5]] = _("Camera", {}, D[6][D[5]])
      D[6][D[5]].CurrentCamera = h[6][h[5]]
      D[6][D[5]].LightDirection = Vector3.new(-0.4, -1, -0.2)
      D[6][D[5]].Ambient = Color3.fromRGB(160, 160, 160)
      W[6][W[5]] = _("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -15),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = M.Tx,
        Text = "",
      }, F)
    end
  end
end

--[[
  Phantom Hub - LoadoutTextFormatter

  Role: Loadout viewer text formatter. Formats weapon slot names, ammo counts and attachment lines for the
  loadout panel.
  Category: ui
  Recovered factory key: 76   source position: 17   bytes: 1749

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 18
    deps[1..18]=config, target state, weapon cache and string helpers.

  Persisted config fields: Loadout_Viewer

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local LoadoutTextFormatter = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    local g = b[14]
    local o = b[15]
    local V = b[16]
    local q = b[17]
    local j = b[18]
    return function()
      if not F.Loadout_Viewer then
        if N[6][N[5]] then
          _()
        end
        return
      end
      M()
      local b = S()
      if b - B[6][B[5]] < 0.1 then
        return
      end
      B[6][B[5]] = b
      local F, N = D()
      if not F then
        h[6][h[5]].Text = "Waiting for target..."
        for _ = 1, 4, 1 do
          W[6][W[5]][_].Text = "[ " .. _ .. " ]  -"
          W[6][W[5]][_].TextColor3 = U.TxD
        end
        s[6][s[5]] = nil
        c[6][c[5]] = { nil, nil, nil, nil }
        Y[6][Y[5]] = { 0, 0, 0, 0 }
        g(nil)
        o[6][o[5]] = nil
        return
      end
      if s[6][s[5]] ~= F then
        s[6][s[5]] = F
        c[6][c[5]] = { nil, nil, nil, nil }
        Y[6][Y[5]] = { 0, 0, 0, 0 }
        o[6][o[5]] = nil
        g(nil)
      end
      h[6][h[5]].Text = "[ " .. F.Name .. " ]  |  " .. V(N) .. "m"
      local _, M = q(), F.Name .. " - "
      local S, B, D, h = string.len(M), {}
      if _ then
        for s, s in ipairs(_:GetChildren()) do
          if string.sub(s.Name, 1, S) == M then
            N = string.sub(s.Name, S + 1)
            F = string.split(N, " - ")[1]
            if F then
              if F ~= "" then
                B[F] = true
                D, h = s, F
              else
              end
            else
            end
          else
          end
        end
      else
      end
      N = pairs
      for s in N(B) do
        S = false
        for N = 1, 4, 1 do
          if c[6][c[5]][N] == s then
            Y[6][Y[5]][N] = b
            S = true
            break
          end
        end
        if not S then
          F = false
          for N = 1, 4, 1 do
            if c[6][c[5]][N] == nil then
              c[6][c[5]][N] = s
              Y[6][Y[5]][N] = b
              F = true
              break
            end
          end
          if not F then
            _, M = j, 1
            for F = 1, 4, 1 do
              if Y[6][Y[5]][F] < _ then
                _, M = Y[6][Y[5]][F], F
              else
              end
            end
            c[6][c[5]][M] = s
            Y[6][Y[5]][M] = b
          end
        end
      end
      for b = 1, 4, 1 do
        if c[6][c[5]][b] then
          W[6][W[5]][b].Text = "[ " .. b .. " ]  " .. c[6][c[5]][b]
          W[6][W[5]][b].TextColor3 = U.Tx
        else
          W[6][W[5]][b].Text = "[ " .. b .. " ]  -"
          W[6][W[5]][b].TextColor3 = U.TxD
        end
      end
      if D then
        if h ~= o[6][o[5]] then
          o[6][o[5]] = h
          g(D, h)
        end
      end
    end
  end
end

--[[
  Phantom Hub - LoadoutModelPreview

  Role: Loadout model preview. Clones a character/model into a ViewportFrame, strips scripts, computes a
  bounding box and frames it with the camera.
  Category: ui
  Recovered factory key: 10   source position: 185   bytes: 1239

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 3
    deps[1..3]=ViewportFrame, camera and clone/cache state.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local LoadoutModelPreview = function(b, F, F, F, F, F)
  return function(F, N)
    local N = F[1]
    local _ = F[2]
    local M = F[3]
    return function(F, S)
      if not N[6][N[5]] then
        return
      end
      local B, D = ipairs, N[6][N[5]]
      local h = b[62](D:GetChildren())
      for W, W in B(b:Js(h)) do
        if W ~= _[6][_[5]] then
          W:Destroy()
        end
      end
      if not F then
        if M[6][M[5]] then
          M[6][M[5]].Text = ""
        end
        return
      end
      local b = F:Clone()
      B, h = nil
      for W, U in ipairs(b:GetDescendants()) do
        if U:IsA("BasePart") then
          U.Anchored = true
          U.CanCollide = false
          if U.Transparency < 1 then
            W, D = U.Size * 0.5, U.Position
            local s, c = D - W, D + W
            if B then
              B, h =
                Vector3.new(math.min(B.X, s.X), math.min(B.Y, s.Y), math.min(B.Z, s.Z)),
                Vector3.new(math.max(h.X, c.X), math.max(h.Y, c.Y), math.max(h.Z, c.Z))
            else
              B, h = s, c
            end
          else
          end
        else
          if U:IsA("Script") then
            U:Destroy()
          elseif U:IsA("LocalScript") then
            U:Destroy()
          end
        end
      end
      b.Parent = N[6][N[5]]
      if B then
      else
        local N, W, U = pcall(function()
          return b:GetBoundingBox()
        end)
        if N then
          if W then
            D, F = W.Position - U * 0.5, W.Position + U * 0.5
            B, h = D, F
          else
          end
        else
        end
      end
      if B then
        D, F = (B + h) * 0.5, (h - B).Magnitude * 0.5
        F = if F <= 0 then 2 else F
        local b = math.rad(_[6][_[5]].FieldOfView)
        local N, B = F / math.tan(b * 0.5) * 1.1, Vector3.new(1, 0.35, 1).Unit
        _[6][_[5]].CFrame = CFrame.lookAt(D + B * N, D)
      end
      if M[6][M[5]] then
        M[6][M[5]].Text = S or ""
      end
    end
  end
end

--[[
  Phantom Hub - LoadoutScanner

  Role: Loadout scanner. Reads the local character's ViewModels and tools and builds the loadout list shown by
  the viewer.
  Category: ui
  Recovered factory key: 84   source position: 38   bytes: 808

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 3
    deps[1..3]=config, character/ViewModels and cache.
  Runtime/state fields: Loadout_Scan

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local LoadoutScanner = function(b, b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    return function(b)
      local M = F()
      if M - N.Loadout_Scan.T >= 0.5 then
        N.Loadout_Scan.T = M
        local F, S = {}, _:FindFirstChild("ViewModels")
        if S then
          for _, B in ipairs(S:GetDescendants()) do
            if B:IsA("Model") then
              _ = string.split(B.Name, " - ")
              if #_ >= 2 then
                local S, B = _[1], _[2]
                local _ = F[S]
                if _ then
                else
                  _ = { Seen = {}, Names = {} }
                  F[S] = _
                end
                if B ~= "" then
                  if not _.Seen[B] then
                    _.Seen[B] = true
                    _.Names[#_.Names + 1] = B
                  end
                end
              end
            end
          end
        end
        N.Loadout_Scan.Map = F
      end
      M = N.Loadout_Scan.Map[b.Name]
      local F, N = M and M.Names or {}, M and M.Seen or {}
      if #F == 0 then
        if b.Character then
          M = {}
          for _, _ in ipairs(b.Character:GetChildren()) do
            if _:IsA("Tool") then
              if not N[_.Name] then
                N[_.Name] = true
                M[#M + 1] = _.Name
              end
            end
          end
          F = M
        else
        end
      else
      end
      return F
    end
  end
end

-- ============================================================================
-- CAMERA / VIEWMODEL (2 factories)
-- ============================================================================

--[[
  Phantom Hub - CameraViewmodelSync

  Role: Camera/viewmodel sync. Applies CFrame changes to the camera and first-person viewmodel, optionally
  through the aim camera controller.
  Category: camera
  Recovered factory key: 77   source position: 176   bytes: 536

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 3
    deps[1..3]=aim-camera helper, camera and viewmodel container.
  Runtime/state fields: Aim_Cam_Ctrl, Get_Aim_Cam_Ctrl

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local CameraViewmodelSync = function(b, F, F, F, F, F)
  return function(F, N, N)
    local N = F[1]
    local _ = F[2]
    local M = F[3]
    return function(F, S, B)
      local D = N.Get_Aim_Cam_Ctrl()
      if D then
        if pcall(D.MimicRotation, D, B) then
          return
        end
        N.Aim_Cam_Ctrl = nil
      end
      F.CFrame = B
      F, D = S:Inverse() * B, _:FindFirstChild("ViewModels")
      if D then
        S = D:FindFirstChild("FirstPerson")
        if S then
          local N, _ = ipairs, b[62](S:GetChildren())
          for S, D in N(b:Js(_)) do
            B, S = D.Name, M.Name
            if B:find(S, 1, true) then
              local b = D:FindFirstChild("ViewModel")
              if b then
                b:PivotTo(b:GetPivot() * F)
              end
            end
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - CameraCframeBroadcast

  Role: Camera CFrame broadcast. Copies the current camera CFrame position to a list of parts/viewmodels.
  Category: camera
  Recovered factory key: 64   source position: 70   bytes: 240

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 4
    deps[1..4]=camera, position helper and target list.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local CameraCframeBroadcast = function(b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    return function()
      local b = F.CurrentCamera
      if not b then
        return
      end
      local F, S = N(b.CFrame.Position + _), pairs
      for b, b in S(M) do
        b.CFrame = F
      end
    end
  end
end

-- ============================================================================
-- INPUT HELPERS (1 factories)
-- ============================================================================

--[[
  Phantom Hub - Mouse2Clicker

  Role: Mouse2 clicker. Simulates mouse2 press/release through executor functions when needed by aim or
  backstab.
  Category: input
  Recovered factory key: 36   source position: 169   bytes: 382

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1..2]=mouse2 helpers.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local Mouse2Clicker = function(b, b, b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    return function()
      if mouse2press and mouse2release then
        mouse2press()
        task.wait(0.06)
        mouse2release()
      elseif mouse2click then
        mouse2click()
      else
        local b = F:GetMouse()
        local F, _ = b.X, game
        N:SendMouseButtonEvent(F, b.Y, 1, true, _, 0)
        task.wait(0.06)
        _, F = b.X, game
        N:SendMouseButtonEvent(_, b.Y, 1, false, F, 0)
      end
    end
  end
end

-- ============================================================================
-- CORE LOOP / STATE / CALLBACKS (12 factories)
-- ============================================================================

--[[
  Phantom Hub - FrameTickLoop

  Role: Frame tick loop. Accumulates RunService delta time and drives the per-frame renderers (ESP, tracers,
  chams, lighting, world tick).
  Category: core
  Recovered factory key: 7082   source position: 233   bytes: 1021

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 20
    deps[1..20]=timer cells, RunService, camera, lighting, config and render callbacks.

  Persisted config fields: CustLight_Enabled, Void_Spam

  Runtime/state fields: HB_Premium, World_Tick

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local FrameTickLoop = function(b, b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    local D = b[7]
    local h = b[8]
    local W = b[9]
    local U = b[10]
    local s = b[11]
    local c = b[12]
    local Y = b[13]
    local g = b[14]
    local o = b[15]
    local V = b[16]
    local q = b[17]
    local j = b[18]
    local m = b[19]
    local i = b[20]
    return function(b)
      F[6][F[5]] += b
      N[6][N[5]] += b
      local k, G = _.CurrentCamera, M.Character
      S[6][S[5]](B, G)
      if D.CustLight_Enabled then
        S[6][S[5]](h)
      end
      W.World_Tick = W.World_Tick + b
      if W.World_Tick >= 0.5 then
        W.World_Tick = 0
        S[6][S[5]](U)
      end
      if F[6][F[5]] >= 0.1 then
        F[6][F[5]] = 0
        S[6][S[5]](s)
      end
      if c then
        if N[6][N[5]] >= 1 then
          N[6][N[5]] = 0
          S[6][S[5]](Y)
        end
      end
      S[6][S[5]](g)
      S[6][S[5]](o)
      S[6][S[5]](V)
      S[6][S[5]](q, G, k)
      S[6][S[5]](j, G)
      S[6][S[5]](m, G, k, b)
      S[6][S[5]](i, G)
      if W.HB_Premium then
        S[6][S[5]](W.HB_Premium)
      end
      if D.Void_Spam and G then
        local b = G:FindFirstChildOfClass("Humanoid")
        if b and b.MaxHealth > 0 then
          if b.Health < b.MaxHealth then
            pcall(function()
              b.Health = b.MaxHealth
            end)
          end
        end
      end
    end
  end
end

--[[
  Phantom Hub - RngStateMixer

  Role: RNG state mixer. Advances the VM's 32-bit LCG state cells; part of the obfuscation/runtime support
  rather than feature logic.
  Category: core
  Recovered factory key: 3476   source position: 221   bytes: 803

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1..2]=state cells.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local RngStateMixer = function(b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    return function()
      local b = 1
      while true do
        if b <= 1 then
          if b <= 0 then
            F[6][F[5]] = (626367 * F[6][F[5]] + 114832689) % 268435456
            F[6][F[5]] = (953803 * F[6][F[5]] + 227760011) % 268435456
            F[6][F[5]] = (574891 * F[6][F[5]] + 87032203) % 268435456
            F[6][F[5]], b = (419083 * F[6][F[5]] + 203419143) % 268435456, 2
          else
            F[6][F[5]] = (741137 * F[6][F[5]] + 183119485) % 268435456
            F[6][F[5]] = (68469 * F[6][F[5]] + 213338789) % 268435456
            N[6][N[5]] = (1 * N[6][N[5]] + 145756634) % 268435456
            F[6][F[5]], b = (960591 * F[6][F[5]] + 157391177) % 268435456, 3
          end
        elseif b <= 2 then
          return
        else
          F[6][F[5]] = (592687 * F[6][F[5]] + 232974177) % 268435456
          F[6][F[5]] = (186895 * F[6][F[5]] + 150555135) % 268435456
          F[6][F[5]] = (870963 * F[6][F[5]] + 237171507) % 268435456
          F[6][F[5]], b = (73543 * F[6][F[5]] + 152676491) % 268435456, 0
        end
      end
    end
  end
end

--[[
  Phantom Hub - FeatureStateReset

  Role: Feature state reset. Clears cached ESP/aim/render state objects when a feature is toggled off or the
  script reloads.
  Category: core
  Recovered factory key: 23   source position: 216   bytes: 299

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 6
    deps[1..6]=cached state cells.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local FeatureStateReset = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    local B = b[6]
    return function()
      if F[6][F[5]] then
        F[6][F[5]]:Destroy()
        F[6][F[5]] = nil
      end
      N[6][N[5]] = {}
      _[6][_[5]] = nil
      M[6][M[5]] = { nil, nil, nil, nil }
      S[6][S[5]] = { 0, 0, 0, 0 }
      B[6][B[5]] = nil
    end
  end
end

--[[
  Phantom Hub - RngStateStepA

  Role: RNG state step (variant A). Advances the VM's LCG state cells.
  Category: core
  Recovered factory key: 7181   source position: 151   bytes: 296

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1..2]=state cells.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local RngStateStepA = function(b, b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    return function()
      local b = 0
      while true do
        if b <= 0 then
          F[6][F[5]] = F[6][F[5]] - F[6][F[5]] % 2 + 1
          N[6][N[5]] = (776169 * N[6][N[5]] + 75262313) % 268435456
          N[6][N[5]], b = (673457 * N[6][N[5]] + 148539669) % 268435456, 1
        else
          return
        end
      end
    end
  end
end

--[[
  Phantom Hub - RngStateReset

  Role: RNG/state reset. Resets VM state cells and calls a stored callback.
  Category: core
  Recovered factory key: 8338   source position: 77   bytes: 293

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 5
    deps[1..5]=state cells and callback.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local RngStateReset = function(b, b, b, b)
  return function(b, F, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    local M = b[4]
    local S = b[5]
    return function()
      local b = 0
      while true do
        if b <= 0 then
          F[6][F[5]] = true
          local F = N[6][N[5]][nil]
          _[6][_[5]](527842042, 4)
          M[6][M[5]] = 340085606
          S[6][S[5]]()
          b = 1
        else
          return
        end
      end
    end
  end
end

--[[
  Phantom Hub - RngStateStepB

  Role: RNG state step (variant B). Advances the VM's LCG state cells.
  Category: core
  Recovered factory key: 5603   source position: 121   bytes: 276

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 3
    deps[1..3]=state cells.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local RngStateStepB = function(b, b, b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    return function()
      local b = 0
      while true do
        if b <= 0 then
          F[6][F[5]] = true
          N[6][N[5]] = N[6][N[5]] - N[6][N[5]] % 2 + 1
          _[6][_[5]], b = (154043 * _[6][_[5]] + 97872385) % 268435456, 1
        else
          return
        end
      end
    end
  end
end

--[[
  Phantom Hub - RngStateStepC

  Role: RNG state step (variant C). Advances the VM's LCG state cells.
  Category: core
  Recovered factory key: 11360   source position: 171   bytes: 270

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 3
    deps[1..3]=state cells.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local RngStateStepC = function(b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    local _ = b[3]
    return function()
      local b = 0
      while true do
        if b <= 0 then
          F[6][F[5]] = true
          N[6][N[5]] = N[6][N[5]] - N[6][N[5]] % 2 + 1
          _[6][_[5]], b = (76509 * _[6][_[5]] + 121442925) % 268435456, 1
        else
          return
        end
      end
    end
  end
end

--[[
  Phantom Hub - InvokeCallbackWithState

  Role: Callback thunk. Invokes a stored callback with the current state-cell value.
  Category: core
  Recovered factory key: 11839   source position: 5   bytes: 177

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1]=callback, deps[2]=state cell.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local InvokeCallbackWithState = function(b, b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    return function()
      local b = 0
      while true do
        if b <= 0 then
          F[6][F[5]](N[6][N[5]])
          b = 1
        else
          return
        end
      end
    end
  end
end

--[[
  Phantom Hub - InvokeCallbackWithStateAlt

  Role: Callback thunk (variant). Invokes a stored callback with the current state-cell value.
  Category: core
  Recovered factory key: 15334   source position: 24   bytes: 177

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1]=callback, deps[2]=state cell.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local InvokeCallbackWithStateAlt = function(b, b, b, b, b, b)
  return function(b)
    local F = b[1]
    local N = b[2]
    return function()
      local b = 1
      while true do
        if b <= 0 then
          return
        else
          F[6][F[5]](N[6][N[5]])
          b = 0
        end
      end
    end
  end
end

--[[
  Phantom Hub - InvokeCallbackWithDepAndArg

  Role: Callback thunk. Invokes a stored callback with a dependency value and the caller's argument.
  Category: core
  Recovered factory key: 12396   source position: 215   bytes: 112

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1]=callback, deps[2]=bound dependency value.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local InvokeCallbackWithDepAndArg = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    local N = b[2]
    return function(b)
      F[6][F[5]](N, b)
    end
  end
end

--[[
  Phantom Hub - InvokeCallbackWithDepAndArgAlt

  Role: Callback thunk (variant). Invokes a stored callback with a dependency value and the caller's argument.
  Category: core
  Recovered factory key: 10971   source position: 76   bytes: 108

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1]=callback, deps[2]=bound dependency value.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local InvokeCallbackWithDepAndArgAlt = function(b, b, b, b)
  return function(b, F)
    local F = b[1]
    local N = b[2]
    return function(b)
      F[6][F[5]](N, b)
    end
  end
end

--[[
  Phantom Hub - InvokeCallback

  Role: Callback thunk. Invokes a stored callback with no arguments.
  Category: core
  Recovered factory key: 51   source position: 1   bytes: 86

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 1
    deps[1]=callback.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local InvokeCallback = function(b, b, b, b, b)
  return function(b, F, F)
    local F = b[1]
    return function()
      F()
    end
  end
end

-- ============================================================================
-- LURAPH VM / CRYPTO (4 factories)
-- ============================================================================

--[[
  Phantom Hub - LuraphVM

  Role: Luraph v15.1 virtual-machine interpreter. Implements the instruction dispatch loop, register/constant
  access, upvalues and the runtime shims used by the protected chunk. This is engine code, not Phantom Hub
  feature code.
  Category: vm
  Recovered factory key: 2056   source position: 184   bytes: 66185

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 0
    The VM object passed by the loader.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local LuraphVM = function(b, F, N, _, _, M, S, B, D, D, h, W, U, s, c, Y, g, g)
  local g, o, V, q, j, m, i, k, G, A, l, r, E, Z, d, L, e, H, n =
    b[11], b[62], b[63], b[123], b[17], b[122], b[28], b[8], b[39], b[78], b.Xs, b[90], b.vs, b[67], b[0], b[120], b[44], b[126], b[113]
  return function(u)
    local y, R, C, I, x, a, p, v, t, f, J, w, P, Q, K, z, T, O, X = g, o, V, q, j, m, i, k, G, A, l, r, E, Z, d, L, e, H, n
    return function(...)
      local g, o, V, q, j, m, i, k, G, A
      local l, r, E, Z, d, L = _[1]
      local e, H = _[2]
      local _ = y(F)
      local F, n
      if M == 154 then
        F, n = W, M
        while true do
          local b2, F2 = c[F]
          if b2 < 82 then
            if b2 >= 41 then
              if b2 >= 61 then
                if b2 >= 71 then
                  if b2 < 76 then
                    if b2 >= 73 then
                      if b2 >= 74 then
                        if b2 ~= 75 then
                          G, A, i, Z = E[9], E[8], E[5], E[7]
                          E = E[6]
                        else
                          _[h[F]] = _[S[F]] - Y[F]
                        end
                      else
                        _[S[F]] = _[Y[F]][h[F]]
                      end
                    else
                      if b2 ~= 72 then
                        _[h[F]] = _[S[F]] * U[F]
                      else
                        _[S[F]] = R(_[Y[F]]())
                      end
                    end
                  else
                    if b2 < 79 then
                      if b2 < 77 then
                        _[h[F]][U[F]] = B[F]
                      elseif b2 ~= 78 then
                        _[S[F]] = y(Y[F])
                      else
                        _[h[F]](U[F])
                      end
                    else
                      if b2 >= 80 then
                        if b2 == 81 then
                          e = _[h[F]]
                        else
                          _[Y[F]] = S[F] * _[h[F]]
                        end
                      else
                        _[S[F]] = _[Y[F]](C(_[h[F]], 1, _[h[F]].n))
                      end
                    end
                  end
                else
                  if b2 >= 66 then
                    if b2 >= 68 then
                      if b2 >= 69 then
                        if b2 ~= 70 then
                          _[h[F]](_[Y[F]], _[S[F]])
                        else
                          _[Y[F]] = _[S[F]] == _[h[F]]
                        end
                      else
                        j, q, m = Y[F], h[F], S[F]
                        d = j + q
                        _[j] = R(_[j](C(_, j + 1, d)))
                      end
                    else
                      if b2 ~= 67 then
                        _[Y[F]] = b[h[F]]
                      else
                        local N2, _2, M2 = S[F], _[Y[F]], _[h[F]]
                        local S2, B2 = I(_2, 4294967295), I(M2, 4294967295)
                        local M2, D2, h2, W2 = I(S2, 65535), x(S2, 16), I(B2, 65535), x(B2, 16)
                        _2 = I(M2 * h2 + a(I(M2 * W2 + D2 * h2, 65535), 16), 4294967295)
                        B2 = nil
                        repeat
                          W2 = _2 % 4294967296
                          if W2 ~= W2 then
                            B2 = 0
                            break
                          end
                          B2 = W2 - W2 % 1
                        until true
                        _[N2] = B2
                      end
                    end
                  else
                    if b2 < 63 then
                      if b2 == 62 then
                        _[S[F]] = _[Y[F]]()
                      else
                        _[S[F]] = p(_[Y[F]], N[F])
                      end
                    elseif b2 >= 64 then
                      if b2 == 65 then
                        _[h[F]] = S[F] + _[Y[F]]
                      else
                        _[h[F]] = u[S[F]][U[F]]
                      end
                    else
                      _[h[F]] = I(_[Y[F]], _[S[F]])
                    end
                  end
                end
              else
                if b2 < 51 then
                  if b2 >= 46 then
                    if b2 < 48 then
                      local N2, _2, M2
                      if b2 ~= 47 then
                        if V then
                          for S2 in v, V, nil do
                            local B2 = V[S2]
                            if B2 then
                              B2[6] = B2
                              B2[4] = _[S2]
                              B2[5] = 4
                              V[S2] = nil
                            end
                          end
                        end
                        if o then
                          for S2, B2 in v, o, nil do
                            local D2 = B2[4]
                            if o then
                              B2 = o[S2]
                              if B2 then
                                local h2, W2 = S2 + D2, y(D2)
                                t(_, S2, h2 - 1, 1, W2)
                                B2[6] = W2
                                B2[5] = 1
                                o[S2] = nil
                              end
                            end
                          end
                        end
                        return _[S[F]](_[Y[F]])
                      else
                        j, N2, _2, M2 = h[F], G()
                        if N2 then
                          _[j] = _2
                          _[j + 1] = M2
                          F = S[F]
                        else
                          F = Y[F]
                        end
                      end
                      q, m, d = N2, _2, M2
                    else
                      if b2 >= 49 then
                        if b2 ~= 50 then
                          _[S[F]] = _[Y[F]] == h[F]
                        else
                          _[S[F]] = _[h[F]] == U[F]
                        end
                      else
                        if V then
                          for N2 in v, V, nil do
                            local _2 = V[N2]
                            if _2 then
                              _2[6] = _2
                              _2[4] = _[N2]
                              _2[5] = 4
                              V[N2] = nil
                            end
                          end
                        end
                        if o then
                          for N2, _2 in v, o, nil do
                            local M2 = _2[4]
                            if o then
                              _2 = o[N2]
                              if _2 then
                                local S2, B2 = N2 + M2, y(M2)
                                t(_, N2, S2 - 1, 1, B2)
                                _2[6] = B2
                                _2[5] = 1
                                o[N2] = nil
                              end
                            end
                          end
                        end
                        return _[Y[F]]()
                      end
                    end
                  else
                    if b2 < 43 then
                      if b2 == 42 then
                        if V then
                          for N2 in v, V, nil do
                            local _2 = V[N2]
                            if _2 then
                              _2[6] = _2
                              _2[4] = _[N2]
                              _2[5] = 4
                              V[N2] = nil
                            end
                          end
                        end
                        if o then
                          for N2, _2 in v, o, nil do
                            local M2 = _2[4]
                            if o then
                              _2 = o[N2]
                              if _2 then
                                local S2 = y(M2)
                                t(_, N2, N2 + M2 - 1, 1, S2)
                                _2[6] = S2
                                _2[5] = 1
                                o[N2] = nil
                              end
                            end
                          end
                        end
                        return
                      else
                        if V then
                          for N2 in v, V, nil do
                            local _2 = V[N2]
                            if _2 then
                              _2[6] = _2
                              _2[4] = _[N2]
                              _2[5] = 4
                              V[N2] = nil
                            end
                          end
                        end
                        if o then
                          for N2, _2 in v, o, nil do
                            local M2 = _2[4]
                            if o then
                              _2 = o[N2]
                              if _2 then
                                local S2 = y(M2)
                                t(_, N2, N2 + M2 - 1, 1, S2)
                                _2[6] = S2
                                _2[5] = 1
                                o[N2] = nil
                              end
                            end
                          end
                        end
                        return N[F]
                      end
                    else
                      if b2 >= 44 then
                        if b2 == 45 then
                          _[Y[F]] = _[h[F]] ~= _[S[F]]
                        else
                          F2 = E
                          E, j, q = { [6] = F2, [7] = Z, [9] = G, [5] = i, [8] = A }, Y[F], f(J)
                          q(b, _[j], _[j + 1], _[j + 2])
                          Z = S[F]
                          F, G = h[F], q
                        end
                      else
                        u[Y[F]][_[S[F]]] = _[h[F]]
                      end
                    end
                  end
                else
                  if b2 < 56 then
                    if b2 < 53 then
                      if b2 == 52 then
                        j = Y[F]
                        q, m, d = _[j], _[j + 1], _[j + 2]
                        _[j] = q(m, d)
                      else
                        _[h[F]] = w(_[Y[F]], _[S[F]])
                      end
                    else
                      if b2 < 54 then
                        j = h[F]
                        _[j], _[j + 1] = U[F], S[F]
                      else
                        if b2 ~= 55 then
                          _[Y[F]] = _[h[F]] // S[F]
                        else
                          F = h[F]
                        end
                      end
                    end
                  else
                    if b2 < 58 then
                      if b2 ~= 57 then
                        _[h[F]] = _[Y[F]] * S[F]
                      else
                        j, q, m = h[F], S[F], Y[F]
                        d = _[j]
                        t(_, j + 1, j + q, m + 1, d)
                      end
                    else
                      if b2 < 59 then
                        j = u[Y[F]]
                        _[S[F]] = j[6][j[5]][N[F]]
                      else
                        if b2 ~= 60 then
                          F = if _[S[F]] < h[F] then F else Y[F]
                        else
                          q, j = (p(S[F], (I(p(l, (I(x(l, 29), 7))), 536870911)))), Y[F] + 1
                          for N2 = 1, h[F], 1 do
                            q = I(p(q, (a(q, 13))), 536870911)
                            q = p(q, (x(q, 13)))
                            q = I(p(q, (a(q, 14))), 536870911)
                            Y[j] = p(Y[j], (I(x(q, 0), 127)))
                            S[j] = p(S[j], (I(x(q, 7), 127)))
                            h[j] = p(h[j], (I(x(q, 14), 127)))
                            c[j] = p(c[j], (I(x(q, 21), 127)))
                            j = j + 1
                          end
                          c[F] = 89
                        end
                      end
                    end
                  end
                end
              end
            else
              if b2 >= 20 then
                if b2 < 30 then
                  if b2 < 25 then
                    if b2 >= 22 then
                      if b2 >= 23 then
                        if b2 ~= 24 then
                          j = u[S[F]]
                          _[Y[F]] = j[6][j[5]][h[F]]
                        else
                          _[h[F]] = p(_[S[F]], _[Y[F]])
                        end
                      else
                        j, q = S[F], _[h[F]]
                        _[j + 1] = q
                        _[j] = q[U[F]]
                        _[S[F + 1]] = _[h[F + 1]]
                        _[Y[F + 2]] = B[F + 2]
                        _[S[F + 3]] = _[h[F + 3]]
                        F = F + 3
                      end
                    else
                      if b2 == 21 then
                        _[S[F]] = p(U[F], N[F])
                      else
                        j, q, m = S[F], h[F], Y[F]
                        d, g, k = j + m - 1, j + q, R(_[j](C(_, j + 1, j + q)))
                        t(k, 1, m, j, _)
                      end
                    end
                  else
                    if b2 < 27 then
                      if b2 ~= 26 then
                        j, q = S[F], _[h[F]]
                        _[j + 1] = q
                        _[j] = q[U[F]]
                      else
                        j, q, m = Y[F], h[F], S[F]
                        d, g = j + m - 1, j + q
                        k = _[g]
                        r = k.n
                        H = q + r - 1
                        k.n = H
                        t(k, 1, r, q, k)
                        t(_, j + 1, g - 1, 1, k)
                        L = R(_[j](C(k, 1, k.n)))
                        t(L, 1, m, j, _)
                      end
                    else
                      if b2 < 28 then
                        j = _[h[F]]
                        _[S[F]] = R(C(j, Y[F], j.n))
                      else
                        if b2 == 29 then
                          P[B[F]][U[F]] = _[h[F]]
                        else
                          P[U[F]] = _[S[F]]
                        end
                      end
                    end
                  end
                else
                  if b2 >= 35 then
                    if b2 >= 38 then
                      local N2 = F
                      if b2 < 39 then
                        _[S[N2]] = {}
                      elseif b2 ~= 40 then
                        n = Y[N2]
                        F = S[N2] + 1
                        break
                      else
                        _[Y[N2]](_[S[N2]])
                      end
                      F = N2
                    else
                      if b2 < 36 then
                        _[Y[F]] = _[S[F]] .. _[h[F]]
                      else
                        if b2 ~= 37 then
                          F = _[h[F]]
                        else
                          _[h[F]] = w(_[Y[F]], B[F])
                        end
                      end
                    end
                  else
                    if b2 < 32 then
                      if b2 == 31 then
                        F = if U[F] <= _[h[F]] then F else S[F]
                      else
                        _[Y[F]] = _[h[F]] + B[F]
                      end
                    else
                      if b2 >= 33 then
                        if b2 == 34 then
                          _[Y[F]] = l
                        else
                          _[S[F]] = _[h[F]] >= Y[F]
                        end
                      else
                        _[S[F]](_[Y[F]], N[F])
                      end
                    end
                  end
                end
              else
                if b2 >= 10 then
                  if b2 < 15 then
                    if b2 >= 12 then
                      if b2 < 13 then
                        u[Y[F]][B[F]] = N[F]
                      else
                        if b2 == 14 then
                          l = _[Y[F]]
                        else
                          _[Y[F]] = _[S[F]] % N[F]
                        end
                      end
                    else
                      if b2 ~= 11 then
                        _[h[F]] = Y[F] - _[S[F]]
                      else
                        j, q, m, d = p(l, I(x(l, 14), 262143), (I(x(l, 28), 15))), h[F], Y[F], S[F]
                        g = m < 2097152 and 7 or 14
                        k, r = I(m, a(1, g) - 1), x(m, g)
                        c[F] = p(r, 96, (I(x(j, 21), 127)))
                        S[F] = p(d, 85, (I(x(j, 7), 127)))
                        Y[F] = p(k, 100, (I(j, 127)))
                        h[F] = p(q, 89, (I(x(j, 14), 127)))
                        F = F - 1
                      end
                    end
                  else
                    if b2 >= 17 then
                      if b2 < 18 then
                        _[h[F]] = _[Y[F]][_[S[F]]]
                      else
                        if b2 == 19 then
                          j = h[F]
                          _[j], _[j + 1] = Y[F], _[S[F]]
                        else
                          j, q, m = h[F], Y[F], S[F]
                          d = j + q
                          g = _[d]
                          k = g.n
                          r = q + k - 1
                          g.n = r
                          t(g, 1, k, q, g)
                          t(_, j + 1, d - 1, 1, g)
                          _[j] = R(_[j](C(g, 1, g.n)))
                        end
                      end
                    else
                      if b2 ~= 16 then
                        _[S[F]], _[Y[F]] = _[h[F]]()
                      else
                        _[S[F]](N[F], C(_[Y[F]], 1, _[Y[F]].n))
                      end
                    end
                  end
                else
                  if b2 >= 5 then
                    if b2 >= 7 then
                      if b2 >= 8 then
                        if b2 == 9 then
                          j, q = { ... }, Y[F]
                          t(j, 1, S[F], q, _)
                          _[S[F + 1]] = u[h[F + 1]]
                          _[h[F + 2]] = P[U[F + 2]]
                          _[S[F + 3]] = _[h[F + 3]](_[Y[F + 3]])
                          F = F + 3
                        else
                          j = S[F]
                          _[j], _[j + 1] = N[F], _[Y[F]]
                        end
                      else
                        _[h[F]] = _[S[F]] % _[Y[F]]
                      end
                    else
                      if b2 == 6 then
                        _[Y[F]] = _[h[F]] >= _[S[F]]
                      else
                        _[S[F]] = U[F] + N[F]
                      end
                    end
                  else
                    if b2 < 2 then
                      if b2 ~= 1 then
                        j = S[F]
                        _[j], _[j + 1] = Y[F], h[F]
                      else
                        j, q = S[F], Y[F]
                        m = { n = q - j + 1 }
                        t(_, j, q, 1, m)
                        _[h[F]] = m
                      end
                    else
                      if b2 >= 3 then
                        if b2 ~= 4 then
                          _[Y[F]] = _[S[F]] ~= N[F]
                        else
                          F = if _[S[F]] ~= h[F] then Y[F] else F
                        end
                      else
                        _[h[F]]()
                      end
                    end
                  end
                end
              end
            end
          else
            if b2 < 123 then
              if b2 < 102 then
                if b2 >= 92 then
                  if b2 >= 97 then
                    if b2 < 99 then
                      if b2 ~= 98 then
                        F = if _[S[F]] ~= N[F] then Y[F] else F
                      else
                        _[h[F]] = _[S[F]] <= _[Y[F]]
                      end
                    else
                      if b2 < 100 then
                        F = if Y[F] < _[h[F]] then F else S[F]
                      else
                        if b2 == 101 then
                          j, q = { ... }, Y[F]
                          t(j, 1, S[F], q, _)
                        else
                          j = u[Y[F]]
                          _[S[F]] = j[6][j[5]]
                        end
                      end
                    end
                  else
                    if b2 >= 94 then
                      if b2 < 95 then
                        _[S[F]] = not _[h[F]]
                      else
                        if b2 ~= 96 then
                          j = u[S[F]]
                          j[6][j[5]] = _[h[F]]
                        else
                          local N2, _2, M2 = Y[F], p(S[F], (I(p(e, (I(x(e, 29), 7))), 536870911))), D[4]
                          local S2 = p(M2[N2], 82680540)
                          M2[N2] = S2
                          M2, N2 = D[7], S2 + 1
                          S2 = Q(M2, N2)
                          local B2, D2
                          if S2 < 128 then
                            B2, D2 = S2, N2 + 1
                          else
                            local h2 = Q(M2, N2 + 1)
                            if h2 < 128 then
                              B2, D2 = S2 - 128 + h2 * 128, N2 + 2
                            else
                              local W2 = Q(M2, N2 + 2)
                              if W2 < 128 then
                                B2, D2 = (S2 - 128) * 128 + (h2 - 128) + W2 * 16384, N2 + 3
                              else
                                local U2 = Q(M2, N2 + 3)
                                B2, D2 =
                                  (S2 - 128) * 16384 + (h2 - 128) * 2097152 + (W2 - 128) + U2 % 128 * 128 + (U2 - U2 % 128) * 2097152,
                                  N2 + 4
                              end
                            end
                          end
                          N2, S2 = _2 * 16843009, D2 + B2
                          local h2 = S2 - B2 % 4
                          for B2 = D2, h2 - 1, 4 do
                            K(M2, B2, (p(z(M2, B2), N2)))
                          end
                          for N2 = h2, S2 - 1, 1 do
                            T(M2, N2, (p(Q(M2, N2), _2)))
                          end
                          Y[F] = 37
                          S[F] = 218
                          h[F] = 174
                          c[F] = 89
                        end
                      end
                    else
                      if b2 ~= 93 then
                        if V then
                          for N2 in v, V, nil do
                            local _2 = V[N2]
                            if _2 then
                              _2[6] = _2
                              _2[4] = _[N2]
                              _2[5] = 4
                              V[N2] = nil
                            end
                          end
                        end
                        if o then
                          for N2, _2 in v, o, nil do
                            local M2 = _2[4]
                            if o then
                              _2 = o[N2]
                              if _2 then
                                local S2 = y(M2)
                                t(_, N2, N2 + M2 - 1, 1, S2)
                                _2[6] = S2
                                _2[5] = 1
                                o[N2] = nil
                              end
                            end
                          end
                        end
                        return B[F], U[F]
                      else
                        j = h[F]
                        _[j], _[j + 1] = _[S[F]], _[Y[F]]
                      end
                    end
                  end
                else
                  if b2 < 87 then
                    if b2 < 84 then
                      if b2 == 83 then
                        _[Y[F]][_[S[F]]] = N[F]
                      else
                        j = Y[F]
                        local N2, _2 = G()
                        if N2 then
                          _[j] = _2
                          F = h[F]
                        else
                          F = S[F]
                        end
                        q, m = N2, _2
                      end
                    else
                      if b2 >= 85 then
                        if b2 ~= 86 then
                          j, q, m = Y[F], S[F], h[F]
                          d, g = _[j], j + q
                          k = _[g]
                          t(_, j + 1, g - 1, m + 1, d)
                          t(k, 1, k.n, m + q, d)
                        else
                          j = u[S[F]]
                          j[6][j[5]] = U[F]
                        end
                      else
                        _[S[F]] = _[h[F]](_[Y[F]])
                      end
                    end
                  else
                    if b2 >= 89 then
                      if b2 < 90 then
                      else
                        if b2 == 91 then
                          q, j = (p(S[F], (I(p(e, (I(x(e, 29), 7))), 536870911)))), Y[F] + 1
                          for N2 = 1, h[F], 1 do
                            q = I(p(q, (a(q, 13))), 536870911)
                            q = p(q, (x(q, 13)))
                            q = I(p(q, (a(q, 14))), 536870911)
                            Y[j] = p(Y[j], (I(x(q, 0), 127)))
                            S[j] = p(S[j], (I(x(q, 7), 127)))
                            h[j] = p(h[j], (I(x(q, 14), 127)))
                            c[j] = p(c[j], (I(x(q, 21), 127)))
                            j = j + 1
                          end
                          c[F] = 89
                        else
                          _[S[F]] = _[h[F]]
                        end
                      end
                    else
                      if b2 == 88 then
                        j = S[F]
                        _[j], _[j + 1] = _[Y[F]], N[F]
                      else
                        if V then
                          for N2 in v, V, nil do
                            local _2 = V[N2]
                            if _2 then
                              _2[6] = _2
                              _2[4] = _[N2]
                              _2[5] = 4
                              V[N2] = nil
                            end
                          end
                        end
                        if o then
                          for N2, _2 in v, o, nil do
                            local M2 = _2[4]
                            if o then
                              _2 = o[N2]
                              if _2 then
                                local S2 = y(M2)
                                t(_, N2, N2 + M2 - 1, 1, S2)
                                _2[6] = S2
                                _2[5] = 1
                                o[N2] = nil
                              end
                            end
                          end
                        end
                        return _[h[F]]
                      end
                    end
                  end
                end
              else
                if b2 < 112 then
                  if b2 < 107 then
                    if b2 < 104 then
                      if b2 == 103 then
                        _[Y[F]] = _[h[F]] / S[F]
                      else
                        local N2, _2, M2 = S[F], Y[F], D[4]
                        local S2 = p(M2[N2], 82680540)
                        M2[N2] = S2
                        N2, M2 = D[7], S2 + 1
                        S2 = Q(N2, M2)
                        local B2, D2
                        if S2 < 128 then
                          B2, D2 = S2, M2 + 1
                        else
                          local h2 = Q(N2, M2 + 1)
                          if h2 < 128 then
                            B2, D2 = S2 - 128 + h2 * 128, M2 + 2
                          else
                            local W2 = Q(N2, M2 + 2)
                            if W2 < 128 then
                              B2, D2 = (S2 - 128) * 128 + (h2 - 128) + W2 * 16384, M2 + 3
                            else
                              local U2 = Q(N2, M2 + 3)
                              B2, D2 =
                                (S2 - 128) * 16384 + (h2 - 128) * 2097152 + (W2 - 128) + U2 % 128 * 128 + (U2 - U2 % 128) * 2097152, M2 + 4
                            end
                          end
                        end
                        S2, M2 = _2 * 16843009, D2 + B2
                        local h2 = M2 - B2 % 4
                        for B2 = D2, h2 - 1, 4 do
                          K(N2, B2, (p(z(N2, B2), S2)))
                        end
                        for S2 = h2, M2 - 1, 1 do
                          T(N2, S2, (p(Q(N2, S2), _2)))
                        end
                        S[F] = 165
                        Y[F] = 132
                        h[F] = 7
                        c[F] = 89
                      end
                    else
                      if b2 < 105 then
                        j = u[S[F]]
                        j[6][j[5]][_[h[F]]] = _[Y[F]]
                      else
                        if b2 ~= 106 then
                          _[Y[F]] = N[F] .. _[S[F]]
                        else
                          _[h[F]] = _[S[F]] + _[Y[F]]
                        end
                      end
                    end
                  else
                    if b2 < 109 then
                      if b2 ~= 108 then
                        F = if _[Y[F]] < _[S[F]] then F else h[F]
                      else
                        if V then
                          for N2 in v, V, nil do
                            local _2 = V[N2]
                            if _2 then
                              _2[6] = _2
                              _2[4] = _[N2]
                              _2[5] = 4
                              V[N2] = nil
                            end
                          end
                        end
                        if o then
                          for N2, _2 in v, o, nil do
                            local M2 = _2[4]
                            if o then
                              _2 = o[N2]
                              if _2 then
                                local S2 = y(M2)
                                t(_, N2, N2 + M2 - 1, 1, S2)
                                _2[6] = S2
                                _2[5] = 1
                                o[N2] = nil
                              end
                            end
                          end
                        end
                        return _[h[F]](_[S[F]], _[Y[F]])
                      end
                    else
                      if b2 < 110 then
                        F2 = E
                        E, j = { [6] = F2, [7] = Z, [9] = G, [5] = i, [8] = A }, S[F]
                        i, A = _[j + 2] + 0, _[j + 1] + 0
                        G = _[j] - i
                        F = h[F]
                      else
                        if b2 ~= 111 then
                          G += i
                          j = if i <= 0 then G >= A else G <= A
                          if j then
                            _[S[F]] = G
                            F = h[F]
                          else
                            F = Y[F]
                          end
                        else
                          _[Y[F]] = _[S[F]] <= h[F]
                        end
                      end
                    end
                  end
                else
                  if b2 >= 117 then
                    if b2 < 120 then
                      if b2 < 118 then
                        _[S[F]] = _[h[F]] * _[Y[F]]
                      elseif b2 == 119 then
                        _[h[F]] = R(_[S[F]](_[Y[F]]))
                      else
                        local F2, N2, _2 = S[F], _[Y[F]]
                        repeat
                          local M2 = N2 % 4294967296
                          if M2 ~= M2 then
                            _2 = 0
                            break
                          end
                          _2 = M2 - M2 % 1
                        until true
                        _[F2] = _2
                      end
                    elseif b2 < 121 then
                      _[h[F]] = _[Y[F]] - _[S[F]]
                    elseif b2 == 122 then
                      _[S[F]] = _[h[F]] + Y[F]
                    else
                      _[h[F]] = P[U[F]]
                    end
                  else
                    if b2 >= 114 then
                      if b2 < 115 then
                        q, j = h[F], Y[F] + 1
                        for F2 = 1, S[F], 1 do
                          q = I(p(q, (a(q, 13))), 536870911)
                          q = p(q, (x(q, 13)))
                          q = I(p(q, (a(q, 14))), 536870911)
                          Y[j] = p(Y[j], (I(x(q, 0), 127)))
                          S[j] = p(S[j], (I(x(q, 7), 127)))
                          h[j] = p(h[j], (I(x(q, 14), 127)))
                          c[j] = p(c[j], (I(x(q, 21), 127)))
                          j = j + 1
                        end
                        c[F] = 89
                      else
                        if b2 ~= 116 then
                          _[S[F]] = u[Y[F]][_[h[F]]]
                        else
                          _[h[F]] = _[S[F]] ~= Y[F]
                        end
                      end
                    else
                      if b2 ~= 113 then
                        _[S[F]][Y[F]] = _[h[F]]
                      else
                        j = Y[F]
                        _[j], _[j + 1] = S[F], N[F]
                      end
                    end
                  end
                end
              end
            else
              if b2 < 143 then
                if b2 < 133 then
                  if b2 < 128 then
                    if b2 < 125 then
                      if b2 ~= 124 then
                        j = u[S[F]]
                        j[6][j[5]][_[h[F]]] = U[F]
                      else
                        _[Y[F]] = h[F] <= _[S[F]]
                      end
                    else
                      if b2 < 126 then
                        j, q, m = Y[F], { ... }, S[F]
                        t(q, 1, j - 1, m, _)
                        _[m + j - 1] = R(O(j, ...))
                      else
                        if b2 == 127 then
                          j = u[S[F]]
                          _[Y[F]] = j[6][j[5]][_[h[F]]]
                        else
                          F = if _[h[F]] <= Y[F] then F else S[F]
                        end
                      end
                    end
                  else
                    if b2 < 130 then
                      if b2 ~= 129 then
                        _[S[F]] = _[h[F]]
                        j = Y[F + 1]
                        q, m, d = _[j], _[j + 1], _[j + 2]
                        _[j] = q(m, d)
                        F = F + 1
                      else
                        if V then
                          local O = h[F]
                          local F2 = V[O]
                          if F2 then
                            F2[6] = F2
                            F2[4] = _[O]
                            F2[5] = 4
                            V[O] = nil
                          end
                          O = Y[F]
                          F2 = V[O]
                          if F2 then
                            F2[6] = F2
                            F2[4] = _[O]
                            F2[5] = 4
                            V[O] = nil
                          end
                          F2 = S[F]
                          O = V[F2]
                          if O then
                            O[6] = O
                            O[4] = _[F2]
                            O[5] = 4
                            V[F2] = nil
                          end
                        end
                      end
                    else
                      if b2 >= 131 then
                        if b2 == 132 then
                          _[h[F]] = _[Y[F]] - B[F]
                        else
                          F = if _[h[F]] then S[F] else Y[F]
                        end
                      else
                        _[Y[F]] = _[h[F]] / _[S[F]]
                      end
                    end
                  end
                else
                  if b2 < 138 then
                    if b2 >= 135 then
                      if b2 >= 136 then
                        if b2 ~= 137 then
                          _[S[F]][N[F]] = _[Y[F]]
                        else
                          _[Y[F]] = _[S[F]] .. N[F]
                        end
                      else
                        _[Y[F]] = _[S[F]] % h[F]
                      end
                    elseif b2 ~= 134 then
                      _[h[F]] = _[S[F]] < Y[F]
                    else
                      if V then
                        for O in v, V, nil do
                          local F2 = V[O]
                          if F2 then
                            F2[6] = F2
                            F2[4] = _[O]
                            F2[5] = 4
                            V[O] = nil
                          end
                        end
                      end
                      if o then
                        for O, F2 in v, o, nil do
                          local N2 = F2[4]
                          if o then
                            F2 = o[O]
                            if F2 then
                              local _2 = y(N2)
                              t(_, O, O + N2 - 1, 1, _2)
                              F2[6] = _2
                              F2[5] = 1
                              o[O] = nil
                            end
                          end
                        end
                      end
                      return _[h[F]], U[F]
                    end
                  else
                    if b2 < 140 then
                      if b2 == 139 then
                        _[Y[F]] = B[F]
                      else
                        _[Y[F]] = a(_[h[F]], S[F])
                      end
                    else
                      if b2 >= 141 then
                        if b2 ~= 142 then
                          if V then
                            local O = h[F]
                            local F2 = V[O]
                            if F2 then
                              F2[6] = F2
                              F2[4] = _[O]
                              F2[5] = 4
                              V[O] = nil
                            end
                          end
                        else
                          local O
                          local F2 = N[F]
                          if F2 then
                            local N2 = #F2 / 3
                            if N2 > 0 then
                              O = {}
                              local _2, M2 = V, o
                              for S2 = 1, N2, 1 do
                                local N2 = (S2 - 1) * 3
                                local B2, D2 = F2[N2 + 3], F2[N2 + 2]
                                if B2 == 0 then
                                  _2 = _2 or {}
                                  local h2 = _2[D2]
                                  if h2 then
                                  else
                                    h2 = { [6] = _, [5] = D2 }
                                    _2[D2] = h2
                                  end
                                  O[S2] = h2
                                else
                                  if B2 == 2 then
                                    O[S2] = _[D2]
                                  else
                                    if B2 == 3 then
                                      O[S2] = u[D2]
                                    else
                                      if B2 == 1 then
                                        M2 = M2 or {}
                                        local B2 = M2[D2]
                                        if B2 then
                                        else
                                          B2 = { [4] = F2[N2 + 1], [5] = D2, [6] = _ }
                                          M2[D2] = B2
                                        end
                                        O[S2] = B2
                                      else
                                      end
                                    end
                                  end
                                end
                              end
                              V, o = _2, M2
                            else
                            end
                          else
                          end
                          _[S[F]] = U[F](O, nil)
                          j = O
                        end
                      else
                        _[h[F]] = _[Y[F]] / B[F]
                      end
                    end
                  end
                end
              else
                if b2 >= 153 then
                  if b2 >= 158 then
                    if b2 < 161 then
                      if b2 < 159 then
                        j, q, m, d = h[F], S[F], p(l, I(x(l, 14), 262143), (I(x(l, 28), 15))), Y[F]
                        g = q < 16384 and 7 or (q < 2097152 and 14 or 21)
                        k, r = I(q, a(1, g) - 1), x(q, g)
                        c[F] = p(r, 97, (I(x(m, 21), 127)))
                        S[F] = p(k, 86, (I(x(m, 7), 127)))
                        Y[F] = p(d, 74, (I(m, 127)))
                        h[F] = p(j, 54, (I(x(m, 14), 127)))
                        F = F - 1
                      else
                        if b2 == 160 then
                          _[Y[F]] = e
                        else
                          _[h[F]] = _[Y[F]](B[F])
                        end
                      end
                    else
                      if b2 >= 162 then
                        if b2 == 163 then
                          F = if _[S[F]] then h[F] else Y[F]
                        else
                          _[h[F]][B[F]] = Y[F]
                        end
                      else
                        _[h[F]] = _[S[F]] // _[Y[F]]
                      end
                    end
                  else
                    if b2 >= 155 then
                      if b2 >= 156 then
                        if b2 == 157 then
                          _[S[F]] = P[N[F]][U[F]]
                        else
                          _[Y[F]] = p(_[S[F]], h[F])
                        end
                      else
                        _[Y[F]] = #_[h[F]]
                      end
                    elseif b2 == 154 then
                      _[h[F]][_[Y[F]]] = _[S[F]]
                    else
                      _[S[F]] = -_[Y[F]]
                    end
                  end
                else
                  if b2 < 148 then
                    if b2 >= 145 then
                      if b2 >= 146 then
                        if b2 ~= 147 then
                          _[h[F]] = Y[F]
                        else
                          _[S[F]] = u[h[F]]
                        end
                      else
                        local O, F2, N2 = Y[F], p(S[F], (I(p(l, (I(x(l, 29), 7))), 536870911))), D[4]
                        local _2 = p(N2[O], 82680540)
                        N2[O] = _2
                        O, N2 = D[7], _2 + 1
                        _2 = Q(O, N2)
                        local M2, S2
                        if _2 < 128 then
                          M2, S2 = _2, N2 + 1
                        else
                          local B2 = Q(O, N2 + 1)
                          if B2 < 128 then
                            M2, S2 = _2 - 128 + B2 * 128, N2 + 2
                          else
                            local D2 = Q(O, N2 + 2)
                            if D2 < 128 then
                              M2, S2 = (_2 - 128) * 128 + (B2 - 128) + D2 * 16384, N2 + 3
                            else
                              local h2 = Q(O, N2 + 3)
                              M2, S2 =
                                (_2 - 128) * 16384 + (B2 - 128) * 2097152 + (D2 - 128) + h2 % 128 * 128 + (h2 - h2 % 128) * 2097152, N2 + 4
                            end
                          end
                        end
                        N2, _2 = F2 * 16843009, S2 + M2
                        local B2 = _2 - M2 % 4
                        for M2 = S2, B2 - 1, 4 do
                          K(O, M2, (p(z(O, M2), N2)))
                        end
                        for N2 = B2, _2 - 1, 1 do
                          T(O, N2, (p(Q(O, N2), F2)))
                        end
                        Y[F] = 49
                        S[F] = 41
                        h[F] = 194
                        c[F] = 89
                      end
                    else
                      F = if b2 == 144 then if S[F] <= _[h[F]] then F else Y[F] else if _[h[F]] ~= _[Y[F]] then S[F] else F
                    end
                  else
                    if b2 >= 150 then
                      if b2 < 151 then
                        j = Y[F]
                        _[j], _[j + 1] = B[F], N[F]
                      else
                        if b2 ~= 152 then
                          _[Y[F]] = _[h[F]][B[F]]
                        else
                          _[h[F]] = I(_[Y[F]], B[F])
                        end
                      end
                    else
                      if b2 ~= 149 then
                        u[h[F]][B[F]] = _[Y[F]]
                      else
                        for O = S[F], Y[F], 1 do
                          _[O] = nil
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          F = F + 1
        end
      else
        F, n = W, M
      end
      if n == 243 then
        while true do
          local M, W = S[F]
          if M >= 85 then
            if M >= 128 then
              if M >= 149 then
                if M < 160 then
                  if M < 154 then
                    if M >= 151 then
                      if M >= 152 then
                        if M ~= 153 then
                          if V then
                            local O = c[F]
                            local b2 = V[O]
                            if b2 then
                              b2[6] = b2
                              b2[4] = _[O]
                              b2[5] = 4
                              V[O] = nil
                            end
                          end
                        else
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2 = y(F2)
                                  t(_, O, O + F2 - 1, 1, N2)
                                  b2[6] = N2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return
                        end
                      else
                        j, q, m, d = p(l, I(x(l, 14), 262143), (I(x(l, 28), 15))), c[F], h[F], Y[F]
                        g = m < 16384 and 7 or (m < 2097152 and 14 or 21)
                        k, r = x(m, g), I(m, a(1, g) - 1)
                        c[F] = p(q, 120, (I(x(j, 14), 127)))
                        Y[F] = p(d, 11, (I(j, 127)))
                        h[F] = p(r, 63, (I(x(j, 7), 127)))
                        S[F] = p(k, 22, (I(x(j, 21), 127)))
                        F = F - 1
                      end
                    else
                      if M == 150 then
                        _[Y[F]] = l
                      else
                        if V then
                          for O in v, V, nil do
                            local b2 = V[O]
                            if b2 then
                              b2[6] = b2
                              b2[4] = _[O]
                              b2[5] = 4
                              V[O] = nil
                            end
                          end
                        end
                        if o then
                          for O, b2 in v, o, nil do
                            local F2 = b2[4]
                            if o then
                              b2 = o[O]
                              if b2 then
                                local N2, _2 = O + F2, y(F2)
                                t(_, O, N2 - 1, 1, _2)
                                b2[6] = _2
                                b2[5] = 1
                                o[O] = nil
                              end
                            end
                          end
                        end
                        return N[F]
                      end
                    end
                  else
                    if M < 157 then
                      if M < 155 then
                        _[h[F]] = Y
                      elseif M == 156 then
                        u[h[F]][U[F]] = s[F]
                      else
                        _[c[F]] = Y[F] * _[h[F]]
                      end
                    elseif M >= 158 then
                      if M == 159 then
                        _[Y[F]] = _[c[F]] + N[F]
                      else
                        if V then
                          for O in v, V, nil do
                            local b2 = V[O]
                            if b2 then
                              b2[6] = b2
                              b2[4] = _[O]
                              b2[5] = 4
                              V[O] = nil
                            end
                          end
                        end
                        if o then
                          for O, b2 in v, o, nil do
                            local F2 = b2[4]
                            if o then
                              b2 = o[O]
                              if b2 then
                                local N2, _2 = O + F2, y(F2)
                                t(_, O, N2 - 1, 1, _2)
                                b2[6] = _2
                                b2[5] = 1
                                o[O] = nil
                              end
                            end
                          end
                        end
                        return U[F], N[F]
                      end
                    else
                      _[c[F]](_[Y[F]], N[F])
                    end
                  end
                else
                  if M >= 165 then
                    if M >= 168 then
                      if M >= 169 then
                        if not (M ~= 170) then
                          _[Y[F]](_[c[F]], _[h[F]])
                        end
                      else
                        if V then
                          for O in v, V, nil do
                            local b2 = V[O]
                            if b2 then
                              b2[6] = b2
                              b2[4] = _[O]
                              b2[5] = 4
                              V[O] = nil
                            end
                          end
                        end
                        if o then
                          for O, b2 in v, o, nil do
                            local F2 = b2[4]
                            if o then
                              b2 = o[O]
                              if b2 then
                                local N2, _2 = O + F2, y(F2)
                                t(_, O, N2 - 1, 1, _2)
                                b2[6] = _2
                                b2[5] = 1
                                o[O] = nil
                              end
                            end
                          end
                        end
                        return _[Y[F]], s[F]
                      end
                    else
                      if M >= 166 then
                        if M == 167 then
                          j = c[F]
                          _[j], _[j + 1] = N[F], _[Y[F]]
                        else
                          F = if _[c[F]] ~= h[F] then Y[F] else F
                        end
                      else
                        _[h[F]] = #_[Y[F]]
                      end
                    end
                  else
                    if M >= 162 then
                      if M >= 163 then
                        if M == 164 then
                          _[h[F]] = _[Y[F]] - _[c[F]]
                        else
                          j = u[Y[F]]
                          _[h[F]] = j[6][j[5]]
                        end
                      else
                        G, A, i, Z = E[9], E[8], E[5], E[7]
                        E = E[6]
                      end
                    else
                      if M == 161 then
                        _[c[F]] = x(_[h[F]], Y[F])
                      else
                        local O
                        local b2 = U[F]
                        if b2 then
                          local F2 = #b2 / 3
                          if F2 > 0 then
                            O = {}
                            local N2, _2 = V, o
                            for M2 = 1, F2, 1 do
                              local F2 = (M2 - 1) * 3
                              local S2, B2 = b2[F2 + 3], b2[F2 + 2]
                              if S2 == 0 then
                                N2 = N2 or {}
                                local D2 = N2[B2]
                                if D2 then
                                else
                                  D2 = { [6] = _, [5] = B2 }
                                  N2[B2] = D2
                                end
                                O[M2] = D2
                              else
                                if S2 == 2 then
                                  O[M2] = _[B2]
                                else
                                  if S2 == 3 then
                                    O[M2] = u[B2]
                                  else
                                    if S2 == 1 then
                                      _2 = _2 or {}
                                      local S2 = _2[B2]
                                      if S2 then
                                      else
                                        S2 = { [4] = b2[F2 + 1], [5] = B2, [6] = _ }
                                        _2[B2] = S2
                                      end
                                      O[M2] = S2
                                    else
                                    end
                                  end
                                end
                              end
                            end
                            V, o = N2, _2
                          else
                          end
                        else
                        end
                        _[h[F]] = s[F](O, nil)
                        j = O
                      end
                    end
                  end
                end
              else
                if M >= 138 then
                  if M >= 143 then
                    if M < 146 then
                      if M < 144 then
                        _[c[F]], _[h[F]] = _[Y[F]]()
                      else
                        if M == 145 then
                          F = if h[F] <= _[Y[F]] then F else c[F]
                        else
                          _[h[F]] = _[Y[F]] .. _[c[F]]
                        end
                      end
                    else
                      if M >= 147 then
                        if M == 148 then
                          q, j = Y[F], h[F] + 1
                          for O = 1, c[F], 1 do
                            q = I(p(q, (a(q, 13))), 536870911)
                            q = p(q, (x(q, 13)))
                            q = I(p(q, (a(q, 14))), 536870911)
                            Y[j] = p(Y[j], (I(x(q, 0), 127)))
                            h[j] = p(h[j], (I(x(q, 7), 127)))
                            c[j] = p(c[j], (I(x(q, 14), 127)))
                            S[j] = p(S[j], (I(x(q, 21), 127)))
                            j = j + 1
                          end
                          S[F] = 169
                        else
                          _[c[F]] = N[F] + U[F]
                        end
                      else
                        _[Y[F]] = _[c[F]] / h[F]
                      end
                    end
                  else
                    if M < 140 then
                      if M == 139 then
                        F = c[F]
                      else
                        _[c[F]] = _[Y[F]](N[F])
                      end
                    else
                      if M >= 141 then
                        if M == 142 then
                          _[h[F]] = _[Y[F]] ~= _[c[F]]
                        else
                          j = h[F]
                          local O, b2 = G()
                          if O then
                            _[j] = b2
                            F = Y[F]
                          else
                            F = c[F]
                          end
                          q, m = O, b2
                        end
                      else
                        _[c[F]][N[F]] = _[Y[F]]
                      end
                    end
                  end
                else
                  if M >= 133 then
                    if M >= 135 then
                      if M < 136 then
                        if V then
                          for O in v, V, nil do
                            local b2 = V[O]
                            if b2 then
                              b2[6] = b2
                              b2[4] = _[O]
                              b2[5] = 4
                              V[O] = nil
                            end
                          end
                        end
                        if o then
                          for O, b2 in v, o, nil do
                            local F2 = b2[4]
                            if o then
                              b2 = o[O]
                              if b2 then
                                local N2 = y(F2)
                                t(_, O, O + F2 - 1, 1, N2)
                                b2[6] = N2
                                b2[5] = 1
                                o[O] = nil
                              end
                            end
                          end
                        end
                        return _[c[F]](_[h[F]], C(_[Y[F]], 1, _[Y[F]].n))
                      elseif M == 137 then
                        _[h[F]] = _[c[F]] ~= Y[F]
                      else
                        _[h[F]] = _[c[F]] + Y[F]
                      end
                    elseif M ~= 134 then
                      _[Y[F]] = p(_[c[F]], N[F])
                    else
                      _[Y[F]][N[F]] = c[F]
                    end
                  else
                    if M >= 130 then
                      if M >= 131 then
                        if M == 132 then
                          u[c[F]][U[F]] = _[h[F]]
                        else
                          local O, b2, F2 = Y[F], p(h[F], (I(p(l, (I(x(l, 29), 7))), 536870911))), D[4]
                          local N2 = p(F2[O], 82680540)
                          F2[O] = N2
                          F2, O = D[7], N2 + 1
                          N2 = Q(F2, O)
                          local _2, M2
                          if N2 < 128 then
                            _2, M2 = N2, O + 1
                          else
                            local S2 = Q(F2, O + 1)
                            if S2 < 128 then
                              _2, M2 = N2 - 128 + S2 * 128, O + 2
                            else
                              local B2 = Q(F2, O + 2)
                              if B2 < 128 then
                                _2, M2 = (N2 - 128) * 128 + (S2 - 128) + B2 * 16384, O + 3
                              else
                                local D2 = Q(F2, O + 3)
                                _2, M2 =
                                  (N2 - 128) * 16384 + (S2 - 128) * 2097152 + (B2 - 128) + D2 % 128 * 128 + (D2 - D2 % 128) * 2097152, O + 4
                              end
                            end
                          end
                          O, N2 = b2 * 16843009, M2 + _2
                          local S2 = N2 - _2 % 4
                          for _2 = M2, S2 - 1, 4 do
                            K(F2, _2, (p(z(F2, _2), O)))
                          end
                          for O = S2, N2 - 1, 1 do
                            T(F2, O, (p(Q(F2, O), b2)))
                          end
                          Y[F] = 148
                          h[F] = 86
                          c[F] = 113
                          S[F] = 169
                        end
                      else
                        _[c[F]][_[h[F]]] = U[F]
                      end
                    else
                      if M == 129 then
                        _[c[F]] = not _[h[F]]
                      else
                        q, j = (p(h[F], (I(p(e, (I(x(e, 29), 7))), 536870911)))), Y[F] + 1
                        for O = 1, c[F], 1 do
                          q = I(p(q, (a(q, 13))), 536870911)
                          q = p(q, (x(q, 13)))
                          q = I(p(q, (a(q, 14))), 536870911)
                          Y[j] = p(Y[j], (I(x(q, 0), 127)))
                          h[j] = p(h[j], (I(x(q, 7), 127)))
                          c[j] = p(c[j], (I(x(q, 14), 127)))
                          S[j] = p(S[j], (I(x(q, 21), 127)))
                          j = j + 1
                        end
                        S[F] = 169
                      end
                    end
                  end
                end
              end
            else
              if M >= 106 then
                if M < 117 then
                  if M >= 111 then
                    if M < 114 then
                      if M < 112 then
                        q, j = (p(h[F], (I(p(l, (I(x(l, 29), 7))), 536870911)))), Y[F] + 1
                        for O = 1, c[F], 1 do
                          q = I(p(q, (a(q, 13))), 536870911)
                          q = p(q, (x(q, 13)))
                          q = I(p(q, (a(q, 14))), 536870911)
                          Y[j] = p(Y[j], (I(x(q, 0), 127)))
                          h[j] = p(h[j], (I(x(q, 7), 127)))
                          c[j] = p(c[j], (I(x(q, 14), 127)))
                          S[j] = p(S[j], (I(x(q, 21), 127)))
                          j = j + 1
                        end
                        S[F] = 169
                      else
                        if M ~= 113 then
                          _[c[F]] = w(_[Y[F]], _[h[F]])
                        else
                          _[h[F]] = R(_[c[F]](U[F]))
                        end
                      end
                    else
                      if M >= 115 then
                        if M ~= 116 then
                          _[Y[F]] = P[s[F]]
                        else
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2, _2 = O + F2 - 1, y(F2)
                                  t(_, O, N2, 1, _2)
                                  b2[6] = _2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return _[h[F]], _[Y[F]]
                        end
                      else
                        _[Y[F]] = c[F] - _[h[F]]
                      end
                    end
                  else
                    if M >= 108 then
                      if M >= 109 then
                        if M == 110 then
                          _[c[F]] = P[U[F]][N[F]]
                        else
                          _[c[F]] = R(_[Y[F]](_[h[F]]))
                        end
                      else
                        _[Y[F]] = u[c[F]]
                      end
                    else
                      if M ~= 107 then
                        _[h[F]]()
                      else
                        j, q, m = h[F], c[F], Y[F]
                        d = _[j]
                        t(_, j + 1, j + q, m + 1, d)
                      end
                    end
                  end
                else
                  if M >= 122 then
                    if M >= 125 then
                      if M >= 126 then
                        if M == 127 then
                          _[c[F]][N[F]] = U[F]
                        else
                          j = u[c[F]]
                          _[h[F]] = j[6][j[5]][_[Y[F]]]
                        end
                      else
                        if V then
                          for O in v, V, nil do
                            local b2 = V[O]
                            if b2 then
                              b2[6] = b2
                              b2[4] = _[O]
                              b2[5] = 4
                              V[O] = nil
                            end
                          end
                        end
                        if o then
                          for O, b2 in v, o, nil do
                            local F2 = b2[4]
                            if o then
                              b2 = o[O]
                              if b2 then
                                local N2 = y(F2)
                                t(_, O, O + F2 - 1, 1, N2)
                                b2[6] = N2
                                b2[5] = 1
                                o[O] = nil
                              end
                            end
                          end
                        end
                        return _[Y[F]]
                      end
                    else
                      if M < 123 then
                        W = E
                        E, j = { [6] = W, [7] = Z, [9] = G, [5] = i, [8] = A }, c[F]
                        i, A = _[j + 2] + 0, _[j + 1] + 0
                        G = _[j] - i
                        F = h[F]
                      else
                        if M ~= 124 then
                          _[Y[F]][c[F]] = _[h[F]]
                        else
                          _[c[F]] = _[Y[F]] % N[F]
                        end
                      end
                    end
                  else
                    if M >= 119 then
                      if M >= 120 then
                        if M ~= 121 then
                          _[Y[F] + _[h[F]]] = _[c[F]]
                        else
                          _[h[F]](U[F], C(_[c[F]], 1, _[c[F]].n))
                        end
                      else
                        _[c[F]] = h[F] ^ _[Y[F]]
                      end
                    else
                      if M ~= 118 then
                        j = c[F]
                        _[j], _[j + 1] = _[Y[F]], N[F]
                      else
                        F = if _[c[F]] < h[F] then F else Y[F]
                      end
                    end
                  end
                end
              else
                if M >= 95 then
                  if M < 100 then
                    if M < 97 then
                      if M == 96 then
                        j, q, m = Y[F], c[F], h[F]
                        d = j + q
                        _[j] = R(_[j](C(_, j + 1, d)))
                      else
                        _[Y[F]] = e
                      end
                    else
                      if M < 98 then
                        if V then
                          local O = c[F]
                          local b2 = V[O]
                          if b2 then
                            b2[6] = b2
                            b2[4] = _[O]
                            b2[5] = 4
                            V[O] = nil
                          end
                          b2 = Y[F]
                          O = V[b2]
                          if O then
                            O[6] = O
                            O[4] = _[b2]
                            O[5] = 4
                            V[b2] = nil
                          end
                          b2 = h[F]
                          O = V[b2]
                          if O then
                            O[6] = O
                            O[4] = _[b2]
                            O[5] = 4
                            V[b2] = nil
                          end
                        end
                      else
                        if M == 99 then
                          l = _[Y[F]]
                        else
                          j = Y[F]
                          _[j], _[j + 1] = _[h[F]], _[c[F]]
                        end
                      end
                    end
                  else
                    if M >= 103 then
                      if M < 104 then
                        _[c[F]] = I(_[h[F]], U[F])
                      else
                        if M ~= 105 then
                          _[h[F]] = _[c[F]] <= _[Y[F]]
                        else
                          e = _[c[F]]
                        end
                      end
                    else
                      if M < 101 then
                        _[h[F]] = _[c[F]] // Y[F]
                      else
                        if M == 102 then
                          F = if _[c[F]] <= Y[F] then F else h[F]
                        else
                          local O, b2, F2 = Y[F], _[h[F]], c[F]
                          local N2, _2 = I(b2, 4294967295), I(F2, 4294967295)
                          local b2, M2, S2, B2 = I(N2, 65535), x(N2, 16), I(_2, 65535), x(_2, 16)
                          F2 = I(b2 * S2 + a(I(b2 * B2 + M2 * S2, 65535), 16), 4294967295)
                          N2 = nil
                          repeat
                            S2 = F2 % 4294967296
                            if S2 ~= S2 then
                              N2 = 0
                              break
                            end
                            N2 = S2 - S2 % 1
                          until true
                          _[O] = N2
                        end
                      end
                    end
                  end
                else
                  if M < 90 then
                    if M >= 87 then
                      if M < 88 then
                        _[c[F]] = _[h[F]]
                        j, q, m = Y[F + 1], c[F + 1], h[F + 1]
                        d, g, k = j + m - 1, j + q, R(_[j](C(_, j + 1, j + q)))
                        t(k, 1, m, j, _)
                        F = F + 1
                      else
                        if M == 89 then
                          F = if _[c[F]] then h[F] else Y[F]
                        else
                          _[Y[F]] = S
                        end
                      end
                    else
                      if M ~= 86 then
                        F = if _[h[F]] ~= _[Y[F]] then c[F] else F
                      else
                        local O, b2, F2 = c[F], Y[F], D[4]
                        local N2 = p(F2[O], 82680540)
                        F2[O] = N2
                        O, F2 = D[7], N2 + 1
                        N2 = Q(O, F2)
                        local _2, M2
                        if N2 < 128 then
                          _2, M2 = N2, F2 + 1
                        else
                          local S2 = Q(O, F2 + 1)
                          if S2 < 128 then
                            _2, M2 = N2 - 128 + S2 * 128, F2 + 2
                          else
                            local B2 = Q(O, F2 + 2)
                            if B2 < 128 then
                              _2, M2 = (N2 - 128) * 128 + (S2 - 128) + B2 * 16384, F2 + 3
                            else
                              local D2 = Q(O, F2 + 3)
                              _2, M2 =
                                (N2 - 128) * 16384 + (S2 - 128) * 2097152 + (B2 - 128) + D2 % 128 * 128 + (D2 - D2 % 128) * 2097152, F2 + 4
                            end
                          end
                        end
                        F2, N2 = b2 * 16843009, M2 + _2
                        local S2 = N2 - _2 % 4
                        for _2 = M2, S2 - 1, 4 do
                          K(O, _2, (p(z(O, _2), F2)))
                        end
                        for F2 = S2, N2 - 1, 1 do
                          T(O, F2, (p(Q(O, F2), b2)))
                        end
                        c[F] = 217
                        Y[F] = 78
                        h[F] = 31
                        S[F] = 169
                      end
                    end
                  else
                    if M >= 92 then
                      if M >= 93 then
                        if M ~= 94 then
                          _[Y[F]] = _[h[F]] - s[F]
                        else
                          u[Y[F]][_[h[F]]] = _[c[F]]
                        end
                      else
                        j = u[Y[F]]
                        j[6][j[5]][_[c[F]]] = _[h[F]]
                      end
                    else
                      if M ~= 91 then
                        _[Y[F]] = _[h[F]] + _[c[F]]
                      elseif V then
                        local O = Y[F]
                        local b2 = V[O]
                        if b2 then
                          b2[6] = b2
                          b2[4] = _[O]
                          b2[5] = 4
                          V[O] = nil
                        end
                        b2 = c[F]
                        O = V[b2]
                        if O then
                          O[6] = O
                          O[4] = _[b2]
                          O[5] = 4
                          V[b2] = nil
                        end
                      end
                    end
                  end
                end
              end
            end
          else
            if M >= 42 then
              if M >= 63 then
                if M >= 74 then
                  if M < 79 then
                    if M >= 76 then
                      if M >= 77 then
                        if M ~= 78 then
                          j, q = c[F], _[h[F]]
                          _[j + 1] = q
                          _[j] = q[U[F]]
                        else
                          _[c[F]] = _[h[F]]()
                        end
                      else
                        _[Y[F]] = _[c[F]][h[F]]
                      end
                    else
                      if M == 75 then
                        F = if _[c[F]] < U[F] then F else h[F]
                      else
                        _[c[F]] = -_[Y[F]]
                      end
                    end
                  else
                    if M >= 82 then
                      if M >= 83 then
                        if M ~= 84 then
                          _[h[F]] = y(c[F])
                        else
                          local O, b2, F2 = Y[F], N[F], _[c[F]]
                          local N2, _2 = I(b2, 4294967295), I(F2, 4294967295)
                          local F2, M2, S2, B2 = I(N2, 65535), x(N2, 16), I(_2, 65535), x(_2, 16)
                          _2 = I(F2 * S2 + a(I(F2 * B2 + M2 * S2, 65535), 16), 4294967295)
                          b2 = nil
                          repeat
                            N2 = _2 % 4294967296
                            if N2 ~= N2 then
                              b2 = 0
                              break
                            end
                            b2 = N2 - N2 % 1
                          until true
                          _[O] = b2
                        end
                      else
                        F = if s[F] < _[Y[F]] then F else h[F]
                      end
                    else
                      if M >= 80 then
                        if M == 81 then
                          j = h[F]
                          _[j], _[j + 1] = U[F], s[F]
                        else
                          _[Y[F]][_[c[F]]] = _[h[F]]
                        end
                      else
                        _[h[F]] = _[Y[F]] < _[c[F]]
                      end
                    end
                  end
                else
                  if M >= 68 then
                    if M >= 71 then
                      if M >= 72 then
                        if M == 73 then
                          F = _[Y[F]]
                        else
                          _[h[F]] = _[c[F]] == U[F]
                        end
                      else
                        _[c[F]] = h
                      end
                    else
                      if M >= 69 then
                        if M == 70 then
                          _[Y[F]][h[F]] = c[F]
                        else
                          j = h[F]
                          _[j], _[j + 1] = U[F], c[F]
                        end
                      else
                        _[Y[F]] = N[F] .. _[c[F]]
                      end
                    end
                  else
                    if M < 65 then
                      if M == 64 then
                        local O, b2, F2 = h[F], _[c[F]]
                        repeat
                          local N2 = b2 % 4294967296
                          if N2 ~= N2 then
                            F2 = 0
                            break
                          end
                          F2 = N2 - N2 % 1
                        until true
                        _[O] = F2
                      else
                        j = h[F]
                        _[j], _[j + 1] = Y[F], s[F]
                      end
                    else
                      if M < 66 then
                        _[c[F]] = p(_[h[F]], _[Y[F]])
                      elseif M ~= 67 then
                        _[h[F]] = w(_[Y[F]], s[F])
                      else
                        _[h[F]] = _[Y[F]][_[c[F]]]
                      end
                    end
                  end
                end
              else
                if M >= 52 then
                  if M >= 57 then
                    if M < 60 then
                      if M < 58 then
                        _[h[F]] = _[Y[F]][s[F]]
                      elseif M ~= 59 then
                        _[c[F]] = _[h[F]] >= Y[F]
                      else
                        local O, b2, F2 = Y[F], h[F], s[F]
                        local N2, _2 = I(b2, 4294967295), I(F2, 4294967295)
                        local M2, S2, B2, D2 = I(N2, 65535), x(N2, 16), I(_2, 65535), x(_2, 16)
                        F2 = I(M2 * B2 + a(I(M2 * D2 + S2 * B2, 65535), 16), 4294967295)
                        b2 = nil
                        repeat
                          N2 = F2 % 4294967296
                          if N2 ~= N2 then
                            b2 = 0
                            break
                          end
                          b2 = N2 - N2 % 1
                        until true
                        _[O] = b2
                      end
                    elseif M >= 61 then
                      if M == 62 then
                        _[h[F]] = _[c[F]](C(_[Y[F]], 1, _[Y[F]].n))
                      else
                        _[Y[F]] = D
                      end
                    else
                      _[c[F]] = _[h[F]] - Y[F]
                    end
                  else
                    if M >= 54 then
                      if M < 55 then
                        j, q, m = Y[F], h[F], c[F]
                        d, g = j + m - 1, j + q
                        k = _[g]
                        r = k.n
                        H = q + r - 1
                        k.n = H
                        t(k, 1, r, q, k)
                        t(_, j + 1, g - 1, 1, k)
                        L = R(_[j](C(k, 1, k.n)))
                        t(L, 1, m, j, _)
                      else
                        if M == 56 then
                          local O, b2, F2 = Y[F], p(h[F], (I(p(e, (I(x(e, 29), 7))), 536870911))), D[4]
                          local N2 = p(F2[O], 82680540)
                          F2[O] = N2
                          O, F2 = D[7], N2 + 1
                          N2 = Q(O, F2)
                          local _2, M2
                          if N2 < 128 then
                            _2, M2 = N2, F2 + 1
                          else
                            local S2 = Q(O, F2 + 1)
                            if S2 < 128 then
                              _2, M2 = N2 - 128 + S2 * 128, F2 + 2
                            else
                              local B2 = Q(O, F2 + 2)
                              if B2 < 128 then
                                _2, M2 = (N2 - 128) * 128 + (S2 - 128) + B2 * 16384, F2 + 3
                              else
                                local D2 = Q(O, F2 + 3)
                                _2, M2 =
                                  (N2 - 128) * 16384 + (S2 - 128) * 2097152 + (B2 - 128) + D2 % 128 * 128 + (D2 - D2 % 128) * 2097152,
                                  F2 + 4
                              end
                            end
                          end
                          F2, N2 = b2 * 16843009, M2 + _2
                          local S2 = N2 - _2 % 4
                          for _2 = M2, S2 - 1, 4 do
                            K(O, _2, (p(z(O, _2), F2)))
                          end
                          for F2 = S2, N2 - 1, 1 do
                            T(O, F2, (p(Q(O, F2), b2)))
                          end
                          Y[F] = 24
                          h[F] = 111
                          c[F] = 88
                          S[F] = 169
                        else
                          j = u[Y[F]]
                          j[6][j[5]] = s[F]
                        end
                      end
                    else
                      if M == 53 then
                        _[Y[F]] = c[F] + _[h[F]]
                      else
                        F = if c[F] < _[Y[F]] then F else h[F]
                      end
                    end
                  end
                else
                  if M < 47 then
                    if M < 44 then
                      if M == 43 then
                        _[c[F]] = u[Y[F]][N[F]]
                      else
                        _[Y[F]] = c[F]
                      end
                    else
                      if M < 45 then
                        j = c[F]
                        local O, b2, F2 = G()
                        if O then
                          _[j] = b2
                          _[j + 1] = F2
                          F = Y[F]
                        else
                          F = h[F]
                        end
                        q, m, d = O, b2, F2
                      else
                        if M ~= 46 then
                          _[h[F]] = _[Y[F]] % c[F]
                        else
                          _[Y[F]](N[F])
                        end
                      end
                    end
                  else
                    if M >= 49 then
                      if M < 50 then
                        _[c[F]] = _[h[F]] >= _[Y[F]]
                      elseif M ~= 51 then
                        _[c[F]](U[F], _[h[F]])
                      else
                        _[c[F]] = _[h[F]]
                      end
                    elseif M == 48 then
                      _[Y[F]] = _[c[F]] * h[F]
                    else
                      _[h[F]] = c
                    end
                  end
                end
              end
            else
              if M >= 21 then
                if M < 31 then
                  if M >= 26 then
                    if M < 28 then
                      if M == 27 then
                        j, q, m = c[F], Y[F], h[F]
                        d, g = _[j], j + q
                        k = _[g]
                        t(_, j + 1, g - 1, m + 1, d)
                        t(k, 1, k.n, m + q, d)
                      else
                        _[Y[F]] = I(_[c[F]], _[h[F]])
                      end
                    else
                      if M >= 29 then
                        if M == 30 then
                          _[Y[F]] = _[c[F]] // _[h[F]]
                        else
                          F = if _[c[F]] then Y[F] else h[F]
                        end
                      else
                        _[c[F]] = b[Y[F]]
                      end
                    end
                  else
                    if M >= 23 then
                      if M < 24 then
                        _[c[F]] = _[Y[F]] <= h[F]
                      elseif M == 25 then
                        u[Y[F]][N[F]] = c[F]
                      else
                        _[h[F]] = _[Y[F]] * s[F]
                      end
                    else
                      if M == 22 then
                        _[h[F]] = X(_[c[F]])
                      else
                        j = u[Y[F]]
                        j[6][j[5]] = _[c[F]]
                      end
                    end
                  end
                else
                  if M >= 36 then
                    if M < 39 then
                      if M < 37 then
                        F = if _[Y[F]] ~= s[F] then h[F] else F
                      else
                        if M == 38 then
                          _[h[F]] = {}
                        else
                          _[h[F]] = _[Y[F]] == c[F]
                        end
                      end
                    else
                      if M < 40 then
                        _[Y[F]](_[h[F]])
                      else
                        if M ~= 41 then
                          _[Y[F]](s[F], N[F])
                        else
                          j, q, m, d = Y[F], h[F], p(l, I(x(l, 14), 262143), (I(x(l, 28), 15))), c[F]
                          g = j < 2097152 and 7 or 14
                          k, r = x(j, g), I(j, a(1, g) - 1)
                          h[F] = p(q, 60, (I(x(m, 7), 127)))
                          S[F] = p(k, 75, (I(x(m, 21), 127)))
                          c[F] = p(d, 46, (I(x(m, 14), 127)))
                          Y[F] = p(r, 57, (I(m, 127)))
                          F = F - 1
                        end
                      end
                    end
                  else
                    if M >= 33 then
                      if M >= 34 then
                        if M ~= 35 then
                          j = u[h[F]]
                          _[c[F]] = j[6][j[5]][U[F]]
                        else
                          _[c[F]] = _[Y[F]] % _[h[F]]
                        end
                      else
                        _[h[F]] = _[c[F]] < Y[F]
                      end
                    else
                      if M ~= 32 then
                        G += i
                        j = if i <= 0 then G >= A else G <= A
                        if j then
                          _[c[F]] = G
                          F = Y[F]
                        else
                          F = h[F]
                        end
                      else
                        _[c[F]] = _[Y[F]] / _[h[F]]
                      end
                    end
                  end
                end
              else
                if M < 10 then
                  if M < 5 then
                    if M < 2 then
                      if M ~= 1 then
                        F = if _[Y[F]] < _[c[F]] then F else h[F]
                      else
                        n = c[F]
                        F = Y[F] + 1
                        break
                      end
                    else
                      if M >= 3 then
                        if M == 4 then
                          _[Y[F]] = b
                        else
                          local O, b2, F2 = h[F], _[c[F]], _[Y[F]]
                          local N2, _2 = I(b2, 4294967295), I(F2, 4294967295)
                          local b2, M2, S2, B2 = I(N2, 65535), x(N2, 16), I(_2, 65535), x(_2, 16)
                          F2 = I(b2 * S2 + a(I(b2 * B2 + M2 * S2, 65535), 16), 4294967295)
                          S2 = nil
                          repeat
                            N2 = F2 % 4294967296
                            if N2 ~= N2 then
                              S2 = 0
                              break
                            end
                            S2 = N2 - N2 % 1
                          until true
                          _[O] = S2
                        end
                      else
                        j = Y[F]
                        _[j], _[j + 1] = c[F], h[F]
                      end
                    end
                  else
                    if M >= 7 then
                      if M >= 8 then
                        if M == 9 then
                          j = c[F]
                          _[j], _[j + 1] = _[h[F]], Y[F]
                        else
                          j, q, m = Y[F], c[F], h[F]
                          d, g, k = j + m - 1, j + q, R(_[j](C(_, j + 1, j + q)))
                          t(k, 1, m, j, _)
                        end
                      else
                        _[c[F]] = _[h[F]] * _[Y[F]]
                      end
                    else
                      if M ~= 6 then
                        W = E
                        E, j, q = { [6] = W, [7] = Z, [9] = G, [5] = i, [8] = A }, Y[F], f(J)
                        q(b, _[j], _[j + 1], _[j + 2])
                        Z = h[F]
                        F, G = c[F], q
                      else
                        _[h[F]] = p(_[c[F]], Y[F])
                      end
                    end
                  end
                else
                  if M >= 15 then
                    if M >= 18 then
                      if M < 19 then
                        _[c[F]] = _[Y[F]] == _[h[F]]
                      else
                        if M == 20 then
                          j, q = c[F], _[h[F]]
                          _[j + 1] = q
                          _[j] = q[U[F]]
                          _[c[F + 1]] = _[h[F + 1]]
                          _[h[F + 2]] = U[F + 2]
                          _[c[F + 3]] = _[h[F + 3]]
                          F = F + 3
                        else
                          _[c[F]] = _[h[F]] .. U[F]
                        end
                      end
                    else
                      if M < 16 then
                        _[c[F]] = N[F] * _[Y[F]]
                      else
                        if M ~= 17 then
                          j = c[F]
                          _[j], _[j + 1] = Y[F], _[h[F]]
                        else
                          _[h[F]][_[c[F]]] = Y[F]
                        end
                      end
                    end
                  else
                    if M >= 12 then
                      if M < 13 then
                        _[c[F]] = u[Y[F]][_[h[F]]]
                      elseif M ~= 14 then
                        _[h[F]] = a(_[Y[F]], c[F])
                      else
                        _[c[F]] = _[h[F]](_[Y[F]])
                      end
                    else
                      if M == 11 then
                        _[h[F]] = U[F]
                      else
                        j = u[Y[F]]
                        _[h[F]] = j[6][j[5]][c[F]]
                      end
                    end
                  end
                end
              end
            end
          end
          F = F + 1
        end
      else
      end
      if n == 150 then
        while true do
          local M, W = c[F]
          if M < 97 then
            if M >= 48 then
              if M >= 72 then
                if M >= 84 then
                  if M < 90 then
                    if M < 87 then
                      if M >= 85 then
                        if M == 86 then
                          _[S[F]] = w(_[h[F]], _[Y[F]])
                        else
                          j = Y[F]
                          _[j], _[j + 1] = B[F], N[F]
                        end
                      else
                        _[S[F]] = _[h[F]](U[F])
                      end
                    else
                      if M >= 88 then
                        if M == 89 then
                          _[Y[F]] = _[S[F]] < h[F]
                        else
                          _[Y[F]] = _[S[F]] <= h[F]
                        end
                      else
                        F = if Y[F] <= _[S[F]] then F else h[F]
                      end
                    end
                  else
                    if M < 93 then
                      if M >= 91 then
                        if M == 92 then
                          _[Y[F]] = S[F] - _[h[F]]
                        else
                          _[h[F]] = Y
                        end
                      else
                        _[S[F]] = U[F] + N[F]
                      end
                    else
                      if M >= 95 then
                        if M ~= 96 then
                          F = if B[F] < _[Y[F]] then F else h[F]
                        else
                          local O, b2, F2 = S[F], _[Y[F]]
                          repeat
                            local N2 = b2 % 4294967296
                            if N2 ~= N2 then
                              F2 = 0
                              break
                            end
                            F2 = N2 - N2 % 1
                          until true
                          _[O] = F2
                        end
                      else
                        if M == 94 then
                          _[h[F]] = _[Y[F]] // S[F]
                        else
                          j = Y[F]
                          _[j], _[j + 1] = _[h[F]], _[S[F]]
                        end
                      end
                    end
                  end
                else
                  if M >= 78 then
                    if M >= 81 then
                      if M >= 82 then
                        if M ~= 83 then
                          j = u[S[F]]
                          j[6][j[5]][_[Y[F]]] = h[F]
                        else
                          _[Y[F]] = a(_[S[F]], h[F])
                        end
                      else
                        F = if _[h[F]] <= Y[F] then F else S[F]
                      end
                    else
                      if M < 79 then
                        j, q, m = Y[F], S[F], h[F]
                        d, g = j + m - 1, j + q
                        k = _[g]
                        r = k.n
                        H = q + r - 1
                        k.n = H
                        t(k, 1, r, q, k)
                        t(_, j + 1, g - 1, 1, k)
                        L = R(_[j](C(k, 1, k.n)))
                        t(L, 1, m, j, _)
                      else
                        if M == 80 then
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2, _2 = O + F2 - 1, y(F2)
                                  t(_, O, N2, 1, _2)
                                  b2[6] = _2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return N[F]
                        else
                          _[S[F]] = _[Y[F]] .. N[F]
                        end
                      end
                    end
                  else
                    if M < 75 then
                      if M >= 73 then
                        if M ~= 74 then
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2 = y(F2)
                                  t(_, O, O + F2 - 1, 1, N2)
                                  b2[6] = N2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return _[h[F]]
                        else
                          _[Y[F]] = _[h[F]] >= S[F]
                        end
                      else
                        F = if _[S[F]] then h[F] else Y[F]
                      end
                    else
                      if M < 76 then
                        _[S[F]] = U[F] .. _[h[F]]
                      else
                        if M ~= 77 then
                        else
                          j, q, m = h[F], S[F], Y[F]
                          d = j + q
                          _[j] = R(_[j](C(_, j + 1, d)))
                        end
                      end
                    end
                  end
                end
              else
                if M < 60 then
                  if M < 54 then
                    if M >= 51 then
                      if M < 52 then
                        _[Y[F]] = _[h[F]] - S[F]
                      else
                        if M == 53 then
                          q, j = (p(h[F], (I(p(l, (I(x(l, 29), 7))), 536870911)))), S[F] + 1
                          for O = 1, Y[F], 1 do
                            q = I(p(q, (a(q, 13))), 536870911)
                            q = p(q, (x(q, 13)))
                            q = I(p(q, (a(q, 14))), 536870911)
                            S[j] = p(S[j], (I(x(q, 0), 127)))
                            h[j] = p(h[j], (I(x(q, 7), 127)))
                            Y[j] = p(Y[j], (I(x(q, 14), 127)))
                            c[j] = p(c[j], (I(x(q, 21), 127)))
                            j = j + 1
                          end
                          c[F] = 76
                        else
                          _[Y[F]] = _[S[F]] / N[F]
                        end
                      end
                    else
                      if M < 49 then
                        b[S[F]] = _[Y[F]]
                      elseif M == 50 then
                        _[S[F]] = Y[F]
                      else
                        _[Y[F]] = b[B[F]]
                      end
                    end
                  else
                    if M < 57 then
                      if M >= 55 then
                        if M == 56 then
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2 = y(F2)
                                  t(_, O, O + F2 - 1, 1, N2)
                                  b2[6] = N2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return _[S[F]], _[Y[F]]
                        else
                          j = h[F]
                          q, m, d, g = _[j], _[j + 1], _[j + 2], _[j + 3]
                          _[j] = q(m, d, g)
                        end
                      else
                        j = u[S[F]]
                        _[h[F]] = j[6][j[5]][_[Y[F]]]
                      end
                    else
                      if M >= 58 then
                        if M ~= 59 then
                          j = _[Y[F]]
                          _[h[F]] = R(C(j, S[F], j.n))
                        else
                          F = if _[h[F]] <= _[Y[F]] then F else S[F]
                        end
                      else
                        if V then
                          local O = h[F]
                          local b2 = V[O]
                          if b2 then
                            b2[6] = b2
                            b2[4] = _[O]
                            b2[5] = 4
                            V[O] = nil
                          end
                          b2 = Y[F]
                          O = V[b2]
                          if O then
                            O[6] = O
                            O[4] = _[b2]
                            O[5] = 4
                            V[b2] = nil
                          end
                        end
                      end
                    end
                  end
                else
                  if M < 66 then
                    if M >= 63 then
                      if M >= 64 then
                        if M ~= 65 then
                          _[Y[F]] = I(_[h[F]], S[F])
                        else
                          u[h[F]][B[F]] = U[F]
                        end
                      else
                        _[h[F]] = _[Y[F]][B[F]]
                      end
                    elseif M < 61 then
                      _[h[F]] = _[S[F]][_[Y[F]]]
                    elseif M == 62 then
                      _[S[F]] = l
                    else
                      _[S[F]](_[Y[F]], N[F])
                    end
                  else
                    if M < 69 then
                      if M < 67 then
                        _[S[F]] = R(_[h[F]](_[Y[F]]))
                      else
                        if M ~= 68 then
                          j, q, m = Y[F], h[F], S[F]
                          d = _[j]
                          t(_, j + 1, j + q, m + 1, d)
                        else
                          _[Y[F]] = P[B[F]]
                        end
                      end
                    else
                      if M < 70 then
                        _[h[F]] = w(Y[F], _[S[F]])
                      else
                        if M ~= 71 then
                          _[Y[F]](C(_[S[F]], 1, _[S[F]].n))
                        else
                          local O
                          local b2 = U[F]
                          if b2 then
                            local F2 = #b2 / 3
                            if F2 > 0 then
                              O = {}
                              local N2, _2 = V, o
                              for M2 = 1, F2, 1 do
                                local F2 = (M2 - 1) * 3
                                local S2, B2 = b2[F2 + 3], b2[F2 + 2]
                                if S2 == 0 then
                                  N2 = N2 or {}
                                  local D2 = N2[B2]
                                  if D2 then
                                  else
                                    D2 = { [6] = _, [5] = B2 }
                                    N2[B2] = D2
                                  end
                                  O[M2] = D2
                                else
                                  if S2 == 2 then
                                    O[M2] = _[B2]
                                  else
                                    if S2 == 3 then
                                      O[M2] = u[B2]
                                    else
                                      if S2 == 1 then
                                        _2 = _2 or {}
                                        local S2 = _2[B2]
                                        if S2 then
                                        else
                                          S2 = { [4] = b2[F2 + 1], [5] = B2, [6] = _ }
                                          _2[B2] = S2
                                        end
                                        O[M2] = S2
                                      else
                                      end
                                    end
                                  end
                                end
                              end
                              V, o = N2, _2
                            else
                            end
                          else
                          end
                          _[S[F]] = _[h[F]](O, nil)
                          j = O
                        end
                      end
                    end
                  end
                end
              end
            else
              if M >= 24 then
                if M >= 36 then
                  if M >= 42 then
                    if M >= 45 then
                      if M >= 46 then
                        if M == 47 then
                          _[h[F]] = p(B[F], _[Y[F]])
                        else
                          _[S[F]][_[h[F]]] = U[F]
                        end
                      else
                        local O, b2, F2 = S[F], _[Y[F]], _[h[F]]
                        local N2, _2 = I(b2, 4294967295), I(F2, 4294967295)
                        local F2, M2, S2, B2 = I(N2, 65535), x(N2, 16), I(_2, 65535), x(_2, 16)
                        N2 = I(F2 * S2 + a(I(F2 * B2 + M2 * S2, 65535), 16), 4294967295)
                        b2 = nil
                        repeat
                          S2 = N2 % 4294967296
                          if S2 ~= S2 then
                            b2 = 0
                            break
                          end
                          b2 = S2 - S2 % 1
                        until true
                        _[O] = b2
                      end
                    else
                      if M >= 43 then
                        if M == 44 then
                          _[h[F]] = u[Y[F]]
                          _[h[F + 1]] = u[Y[F + 1]]
                          j = Y[F + 2]
                          _[j], _[j + 1] = B[F + 2], N[F + 2]
                          _[Y[F + 3]] = _[S[F + 3]]
                          F = F + 3
                        else
                          _[S[F]] = _[h[F]] + U[F]
                        end
                      else
                        _[Y[F]] = S[F] + _[h[F]]
                      end
                    end
                  else
                    if M < 39 then
                      if M >= 37 then
                        if M ~= 38 then
                          _[Y[F]] = S[F] * _[h[F]]
                        else
                          _[h[F]] = _[S[F]] <= _[Y[F]]
                        end
                      else
                        j = h[F]
                        _[j], _[j + 1] = Y[F], S[F]
                      end
                    else
                      if M < 40 then
                        l = _[S[F]]
                      else
                        if M ~= 41 then
                          j = u[Y[F]]
                          _[h[F]] = j[6][j[5]][B[F]]
                        else
                          _[h[F]][B[F]] = U[F]
                        end
                      end
                    end
                  end
                else
                  if M < 30 then
                    if M < 27 then
                      if M < 25 then
                        u[S[F]][_[Y[F]]] = _[h[F]]
                      else
                        if M ~= 26 then
                          G, A, i, Z = E[9], E[8], E[5], E[7]
                          E = E[6]
                        else
                          _[S[F]] = U[F]
                        end
                      end
                    else
                      if M < 28 then
                        j = S[F]
                        local O, b2 = G()
                        if O then
                          _[j] = b2
                          F = Y[F]
                        else
                          F = h[F]
                        end
                        q, m = O, b2
                      else
                        if M ~= 29 then
                          F = if _[S[F]] < U[F] then F else h[F]
                        else
                          local O, b2, F2 = h[F], Y[F], _[S[F]]
                          local N2, _2 = I(b2, 4294967295), I(F2, 4294967295)
                          local F2, M2, S2, B2 = I(N2, 65535), x(N2, 16), I(_2, 65535), x(_2, 16)
                          N2 = I(F2 * S2 + a(I(F2 * B2 + M2 * S2, 65535), 16), 4294967295)
                          b2 = nil
                          repeat
                            M2 = N2 % 4294967296
                            if M2 ~= M2 then
                              b2 = 0
                              break
                            end
                            b2 = M2 - M2 % 1
                          until true
                          _[O] = b2
                        end
                      end
                    end
                  else
                    if M >= 33 then
                      if M >= 34 then
                        if M ~= 35 then
                          q, j = (p(h[F], (I(p(e, (I(x(e, 29), 7))), 536870911)))), S[F] + 1
                          for O = 1, Y[F], 1 do
                            q = I(p(q, (a(q, 13))), 536870911)
                            q = p(q, (x(q, 13)))
                            q = I(p(q, (a(q, 14))), 536870911)
                            S[j] = p(S[j], (I(x(q, 0), 127)))
                            h[j] = p(h[j], (I(x(q, 7), 127)))
                            Y[j] = p(Y[j], (I(x(q, 14), 127)))
                            c[j] = p(c[j], (I(x(q, 21), 127)))
                            j = j + 1
                          end
                          c[F] = 76
                        else
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2 = y(F2)
                                  t(_, O, O + F2 - 1, 1, N2)
                                  b2[6] = N2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return _[S[F]](_[Y[F]])
                        end
                      else
                        _[Y[F]] = y(h[F])
                      end
                    else
                      if M >= 31 then
                        if M ~= 32 then
                          _[S[F]] = I(_[h[F]], U[F])
                        else
                          q, j = Y[F], h[F] + 1
                          for O = 1, S[F], 1 do
                            q = I(p(q, (a(q, 13))), 536870911)
                            q = p(q, (x(q, 13)))
                            q = I(p(q, (a(q, 14))), 536870911)
                            S[j] = p(S[j], (I(x(q, 0), 127)))
                            h[j] = p(h[j], (I(x(q, 7), 127)))
                            Y[j] = p(Y[j], (I(x(q, 14), 127)))
                            c[j] = p(c[j], (I(x(q, 21), 127)))
                            j = j + 1
                          end
                          c[F] = 76
                        end
                      else
                        _[Y[F]](_[S[F]], C(_[h[F]], 1, _[h[F]].n))
                      end
                    end
                  end
                end
              else
                if M >= 12 then
                  if M >= 18 then
                    if M < 21 then
                      if M >= 19 then
                        if M ~= 20 then
                          _[h[F]][S[F]] = _[Y[F]]
                        else
                          _[Y[F]] = _[h[F]] % S[F]
                        end
                      else
                        j = u[h[F]]
                        j[6][j[5]] = _[Y[F]]
                      end
                    else
                      if M >= 22 then
                        if M ~= 23 then
                          _[h[F]](B[F], _[Y[F]])
                        else
                          _[S[F]] = S
                        end
                      else
                        _[h[F]] = x(_[S[F]], Y[F])
                      end
                    end
                  else
                    if M < 15 then
                      if M < 13 then
                        j, q, m = Y[F], S[F], h[F]
                        d, g, k = j + m - 1, j + q, R(_[j](C(_, j + 1, j + q)))
                        t(k, 1, m, j, _)
                      else
                        if M == 14 then
                          _[S[F]][_[h[F]]] = Y[F]
                        else
                          W = E
                          E, j = { [6] = W, [7] = Z, [9] = G, [5] = i, [8] = A }, h[F]
                          i, A = _[j + 2] + 0, _[j + 1] + 0
                          G = _[j] - i
                          F = S[F]
                        end
                      end
                    else
                      if M < 16 then
                        _[Y[F]] = _[S[F]] / _[h[F]]
                      elseif M ~= 17 then
                        _[S[F]] = _[Y[F]] * h[F]
                      else
                        _[S[F]] = I(_[Y[F]], _[h[F]])
                      end
                    end
                  end
                else
                  if M >= 6 then
                    if M < 9 then
                      if M < 7 then
                        local O, b2, F2 = S[F], p(h[F], (I(p(l, (I(x(l, 29), 7))), 536870911))), D[4]
                        local N2 = p(F2[O], 82680540)
                        F2[O] = N2
                        F2, O = D[7], N2 + 1
                        N2 = Q(F2, O)
                        local _2, M2
                        if N2 < 128 then
                          _2, M2 = N2, O + 1
                        else
                          local S2 = Q(F2, O + 1)
                          if S2 < 128 then
                            _2, M2 = N2 - 128 + S2 * 128, O + 2
                          else
                            local B2 = Q(F2, O + 2)
                            if B2 < 128 then
                              _2, M2 = (N2 - 128) * 128 + (S2 - 128) + B2 * 16384, O + 3
                            else
                              local D2 = Q(F2, O + 3)
                              _2, M2 =
                                (N2 - 128) * 16384 + (S2 - 128) * 2097152 + (B2 - 128) + D2 % 128 * 128 + (D2 - D2 % 128) * 2097152, O + 4
                            end
                          end
                        end
                        N2, O = b2 * 16843009, M2 + _2
                        local S2 = O - _2 % 4
                        for _2 = M2, S2 - 1, 4 do
                          K(F2, _2, (p(z(F2, _2), N2)))
                        end
                        for N2 = S2, O - 1, 1 do
                          T(F2, N2, (p(Q(F2, N2), b2)))
                        end
                        S[F] = 140
                        h[F] = 82
                        Y[F] = 187
                        c[F] = 76
                      elseif M ~= 8 then
                        _[h[F]] = b[Y[F]]
                      else
                        _[Y[F]] = X(_[h[F]])
                      end
                    elseif M < 10 then
                      P[B[F]] = _[Y[F]]
                    elseif M == 11 then
                      _[Y[F]] = N[F] + _[S[F]]
                    else
                      _[h[F]] = _[S[F]](_[Y[F]])
                    end
                  else
                    if M < 3 then
                      if M >= 1 then
                        if M == 2 then
                          _[h[F]][S[F]] = U[F]
                        else
                          F = _[Y[F]]
                        end
                      else
                        _[S[F]] = _[h[F]] % U[F]
                      end
                    else
                      if M >= 4 then
                        if M == 5 then
                          j = u[S[F]]
                          _[Y[F]] = j[6][j[5]]
                        else
                          j = Y[F]
                          _[j], _[j + 1] = S[F], N[F]
                        end
                      else
                        _[S[F]] = _[Y[F]] * _[h[F]]
                      end
                    end
                  end
                end
              end
            end
          else
            if M < 145 then
              if M >= 121 then
                if M >= 133 then
                  if M >= 139 then
                    if M >= 142 then
                      if M < 143 then
                        _[h[F]] = _[S[F]] ~= _[Y[F]]
                      else
                        if M ~= 144 then
                          j, q = Y[F], _[S[F]]
                          _[j + 1] = q
                          _[j] = q[N[F]]
                        else
                          _[S[F]] = Y[F] ^ _[h[F]]
                        end
                      end
                    else
                      if M < 140 then
                        j, q, m, d = h[F], S[F], Y[F], p(l, I(x(l, 14), 262143), (I(x(l, 28), 15)))
                        g = j < 2097152 and 7 or 14
                        k, r = I(j, a(1, g) - 1), x(j, g)
                        c[F] = p(r, 5, (I(x(d, 21), 127)))
                        Y[F] = p(m, 1, (I(x(d, 14), 127)))
                        h[F] = p(k, 62, (I(x(d, 7), 127)))
                        S[F] = p(q, 24, (I(d, 127)))
                        F = F - 1
                      else
                        if M == 141 then
                          u[S[F]][U[F]] = h[F]
                        else
                          _[Y[F]] = _[S[F]]
                        end
                      end
                    end
                  else
                    local O = F
                    if M < 136 then
                      if M >= 134 then
                        if M ~= 135 then
                          _[S[O]](_[Y[O]], _[h[O]])
                        else
                          _[S[O]] = P[N[O]][U[O]]
                        end
                      else
                        n = Y[O]
                        F = S[O] + 1
                        break
                      end
                    elseif M >= 137 then
                      if M == 138 then
                        _[S[O]] = w(_[h[O]], U[O])
                      else
                        _[Y[O]] = _[h[O]] * B[O]
                      end
                    else
                      if V then
                        for b2 in v, V, nil do
                          local F2 = V[b2]
                          if F2 then
                            F2[6] = F2
                            F2[4] = _[b2]
                            F2[5] = 4
                            V[b2] = nil
                          end
                        end
                      end
                      if o then
                        for b2, F2 in v, o, nil do
                          local N2 = F2[4]
                          if o then
                            F2 = o[b2]
                            if F2 then
                              local _2, M2 = b2 + N2 - 1, y(N2)
                              t(_, b2, _2, 1, M2)
                              F2[6] = M2
                              F2[5] = 1
                              o[b2] = nil
                            end
                          end
                        end
                      end
                      return _[h[O]](_[Y[O]], C(_[S[O]], 1, _[S[O]].n))
                    end
                    F = O
                  end
                else
                  if M >= 127 then
                    if M >= 130 then
                      if M >= 131 then
                        if M == 132 then
                          _[h[F]] = _[S[F]]()
                        else
                          F = if _[h[F]] then S[F] else Y[F]
                        end
                      else
                        _[S[F]] = _[Y[F]] + h[F]
                      end
                    else
                      if M >= 128 then
                        if M == 129 then
                          _[S[F]] = D
                        else
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2 = y(F2)
                                  t(_, O, O + F2 - 1, 1, N2)
                                  b2[6] = N2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return _[S[F]], C(_[h[F]], 1, _[h[F]].n)
                        end
                      else
                        _[h[F]] = _[Y[F]] == B[F]
                      end
                    end
                  else
                    if M < 124 then
                      if M >= 122 then
                        if M == 123 then
                          _[S[F]] = _[h[F]][Y[F]]
                        else
                          u[S[F]][U[F]] = _[h[F]]
                        end
                      else
                        j = u[Y[F]]
                        j[6][j[5]] = N[F]
                      end
                    else
                      if M < 125 then
                        _[h[F]] = u[Y[F]]
                      elseif M == 126 then
                        _[S[F]] = _[Y[F]] ~= h[F]
                      else
                        if V then
                          for O in v, V, nil do
                            local b2 = V[O]
                            if b2 then
                              b2[6] = b2
                              b2[4] = _[O]
                              b2[5] = 4
                              V[O] = nil
                            end
                          end
                        end
                        if o then
                          for O, b2 in v, o, nil do
                            local F2 = b2[4]
                            if o then
                              b2 = o[O]
                              if b2 then
                                local N2, _2 = O + F2, y(F2)
                                t(_, O, N2 - 1, 1, _2)
                                b2[6] = _2
                                b2[5] = 1
                                o[O] = nil
                              end
                            end
                          end
                        end
                        return _[Y[F]](_[h[F]], _[S[F]])
                      end
                    end
                  end
                end
              else
                if M < 109 then
                  if M < 103 then
                    if M >= 100 then
                      if M < 101 then
                        _[Y[F]] = _[S[F]]
                        j = Y[F + 1]
                        q, m, d = _[j], _[j + 1], _[j + 2]
                        _[j] = q(m, d)
                        F = F + 1
                      else
                        if M == 102 then
                          if V then
                            for O in v, V, nil do
                              local b2 = V[O]
                              if b2 then
                                b2[6] = b2
                                b2[4] = _[O]
                                b2[5] = 4
                                V[O] = nil
                              end
                            end
                          end
                          if o then
                            for O, b2 in v, o, nil do
                              local F2 = b2[4]
                              if o then
                                b2 = o[O]
                                if b2 then
                                  local N2, _2 = O + F2, y(F2)
                                  t(_, O, N2 - 1, 1, _2)
                                  b2[6] = _2
                                  b2[5] = 1
                                  o[O] = nil
                                end
                              end
                            end
                          end
                          return
                        else
                          F = if _[S[F]] < _[h[F]] then F else Y[F]
                        end
                      end
                    else
                      if M < 98 then
                        F = if _[h[F]] ~= Y[F] then S[F] else F
                      else
                        if M ~= 99 then
                          _[h[F]] = _[S[F]] > Y[F]
                        else
                          _[h[F]] = _[Y[F]] / S[F]
                        end
                      end
                    end
                  else
                    if M >= 106 then
                      if M >= 107 then
                        if M == 108 then
                          _[Y[F]] = _[S[F]] .. _[h[F]]
                        else
                          _[S[F]] = u[h[F]][U[F]]
                        end
                      else
                        j, q = Y[F], _[S[F]]
                        _[j + 1] = q
                        _[j] = q[N[F]]
                        _[Y[F + 1]] = _[S[F + 1]]
                        _[S[F + 2]] = U[F + 2]
                        _[Y[F + 3]] = _[S[F + 3]]
                        F = F + 3
                      end
                    else
                      if M < 104 then
                        _[h[F]] = w(B[F], _[Y[F]])
                      else
                        if M ~= 105 then
                          for O = Y[F], S[F], 1 do
                            _[O] = nil
                          end
                        else
                          G += i
                          j = if i <= 0 then G >= A else G <= A
                          if j then
                            _[h[F]] = G
                            F = S[F]
                          else
                            F = Y[F]
                          end
                        end
                      end
                    end
                  end
                else
                  if M >= 115 then
                    local O, b2, F2, N2, _2 = q, m, d, g, k
                    if M < 118 then
                      if M < 116 then
                        local M2
                        local S2 = N[F]
                        if S2 then
                          local B2 = #S2 / 3
                          if B2 > 0 then
                            M2 = {}
                            local D2, h2 = V, o
                            for W2 = 1, B2, 1 do
                              local B2 = (W2 - 1) * 3
                              local U2, s2 = S2[B2 + 3], S2[B2 + 2]
                              if U2 == 0 then
                                D2 = D2 or {}
                                local c2 = D2[s2]
                                if c2 then
                                else
                                  c2 = { [6] = _, [5] = s2 }
                                  D2[s2] = c2
                                end
                                M2[W2] = c2
                              else
                                if U2 == 2 then
                                  M2[W2] = _[s2]
                                else
                                  if U2 == 3 then
                                    M2[W2] = u[s2]
                                  else
                                    if U2 == 1 then
                                      h2 = h2 or {}
                                      local U2 = h2[s2]
                                      if U2 then
                                      else
                                        U2 = { [4] = S2[B2 + 1], [5] = s2, [6] = _ }
                                        h2[s2] = U2
                                      end
                                      M2[W2] = U2
                                    else
                                    end
                                  end
                                end
                              end
                            end
                            V, o = D2, h2
                          else
                          end
                        else
                        end
                        _[S[F]] = U[F](M2, nil)
                        j = M2
                      else
                        if M ~= 117 then
                          _[h[F]] = p(U[F], B[F])
                        else
                          _[S[F]](U[F], N[F])
                        end
                      end
                    else
                      local M2 = j
                      if M < 119 then
                        j, q = Y[F], S[F]
                        m = j + q
                        d = _[m]
                        g = d.n
                        if V then
                          for S2 in v, V, nil do
                            local B2 = V[S2]
                            if B2 then
                              B2[6] = B2
                              B2[4] = _[S2]
                              B2[5] = 4
                              V[S2] = nil
                            end
                          end
                        end
                        if o then
                          for S2, B2 in v, o, nil do
                            local D2 = B2[4]
                            if o then
                              B2 = o[S2]
                              if B2 then
                                local h2, W2 = S2 + D2 - 1, y(D2)
                                t(_, S2, h2, 1, W2)
                                B2[6] = W2
                                B2[5] = 1
                                o[S2] = nil
                              end
                            end
                          end
                        end
                        d.n = q + g - 1
                        t(d, 1, g, q, d)
                        t(_, j + 1, m - 1, 1, d)
                        return _[j](C(d, 1, d.n))
                      elseif M ~= 120 then
                        _[S[F]] = not _[h[F]]
                      else
                        _[Y[F]]()
                      end
                      j = M2
                    end
                    q, m, d, g, k = O, b2, F2, N2, _2
                  else
                    if M < 112 then
                      if M >= 110 then
                        if M ~= 111 then
                          _[h[F]] = -_[S[F]]
                        else
                          j = h[F]
                          local O, b2, F2 = G()
                          if O then
                            _[j] = b2
                            _[j + 1] = F2
                            F = S[F]
                          else
                            F = Y[F]
                          end
                          q, m, d = O, b2, F2
                        end
                      else
                        F = Y[F]
                      end
                    else
                      if M < 113 then
                        _[h[F]] = _[Y[F]] >= _[S[F]]
                      else
                        if M ~= 114 then
                          _[h[F]] = _[S[F]] < _[Y[F]]
                        else
                          j, q, m = Y[F], h[F], S[F]
                          d, g = _[j], j + q
                          k = _[g]
                          t(_, j + 1, g - 1, m + 1, d)
                          t(k, 1, k.n, m + q, d)
                        end
                      end
                    end
                  end
                end
              end
            else
              if M < 169 then
                if M >= 157 then
                  if M >= 163 then
                    if M < 166 then
                      if M < 164 then
                        _[S[F]] = _[Y[F]] - N[F]
                      elseif M ~= 165 then
                        _[S[F]] = p(_[h[F]], Y[F])
                      else
                        _[S[F]] = e
                      end
                    else
                      if M < 167 then
                        e = _[Y[F]]
                      else
                        if M == 168 then
                          _[S[F]] = _[h[F]] == Y[F]
                        else
                          _[S[F]] = R(_[h[F]]())
                        end
                      end
                    end
                  else
                    if M < 160 then
                      if M < 158 then
                        _[h[F]](B[F])
                      elseif M == 159 then
                        _[Y[F]] = _[S[F]] + _[h[F]]
                      else
                        _[h[F]] = I(U[F], _[S[F]])
                      end
                    else
                      if M >= 161 then
                        if M == 162 then
                          _[S[F]] = _[Y[F]] // _[h[F]]
                        else
                          j = S[F]
                          _[j], _[j + 1] = U[F], h[F]
                        end
                      else
                        _[h[F]] = _[S[F]] == _[Y[F]]
                      end
                    end
                  end
                else
                  if M < 151 then
                    if M >= 148 then
                      if M < 149 then
                        if V then
                          local O = h[F]
                          local b2 = V[O]
                          if b2 then
                            b2[6] = b2
                            b2[4] = _[O]
                            b2[5] = 4
                            V[O] = nil
                          end
                          b2 = Y[F]
                          O = V[b2]
                          if O then
                            O[6] = O
                            O[4] = _[b2]
                            O[5] = 4
                            V[b2] = nil
                          end
                          b2 = S[F]
                          O = V[b2]
                          if O then
                            O[6] = O
                            O[4] = _[b2]
                            O[5] = 4
                            V[b2] = nil
                          end
                        end
                      else
                        if M == 150 then
                          _[Y[F]] = u[h[F]][_[S[F]]]
                        else
                          j = u[S[F]]
                          j[6][j[5]][_[h[F]]] = _[Y[F]]
                        end
                      end
                    else
                      if M >= 146 then
                        if M ~= 147 then
                          u[Y[F]][_[h[F]]] = B[F]
                        else
                          _[Y[F]] = _[S[F]] - _[h[F]]
                        end
                      else
                        W = E
                        E, j, q = { [6] = W, [7] = Z, [9] = G, [5] = i, [8] = A }, Y[F], f(J)
                        q(b, _[j], _[j + 1], _[j + 2])
                        Z = S[F]
                        F, G = h[F], q
                      end
                    end
                  else
                    if M < 154 then
                      if M < 152 then
                        _[h[F]] = _[Y[F]](C(_[S[F]], 1, _[S[F]].n))
                      else
                        if M ~= 153 then
                          F = if Y[F] < _[h[F]] then F else S[F]
                        else
                          j = Y[F]
                          q, m, d = _[j], _[j + 1], _[j + 2]
                          _[j] = q(m, d)
                        end
                      end
                    else
                      if M < 155 then
                        F = if _[S[F]] ~= U[F] then h[F] else F
                      else
                        if M == 156 then
                          _[Y[F]] = p(_[h[F]], B[F])
                        else
                          j = u[Y[F]]
                          _[S[F]] = j[6][j[5]][h[F]]
                        end
                      end
                    end
                  end
                end
              else
                if M < 181 then
                  if M < 175 then
                    if M >= 172 then
                      if M < 173 then
                        j = h[F]
                        _[j], _[j + 1] = _[S[F]], U[F]
                      else
                        if M == 174 then
                          _[h[F]] = c
                        else
                          _[h[F]] = {}
                        end
                      end
                    else
                      if M < 170 then
                        _[S[F] + _[Y[F]]] = _[h[F]]
                      else
                        if M ~= 171 then
                          j, q, m, d = S[F], p(l, I(x(l, 14), 262143), (I(x(l, 28), 15))), Y[F], h[F]
                          g = j < 16384 and 7 or (j < 2097152 and 14 or 21)
                          k, r = I(j, a(1, g) - 1), x(j, g)
                          h[F] = p(d, 123, (I(x(q, 7), 127)))
                          Y[F] = p(m, 38, (I(x(q, 14), 127)))
                          S[F] = p(k, 104, (I(q, 127)))
                          c[F] = p(r, 24, (I(x(q, 21), 127)))
                          F = F - 1
                        else
                          _[Y[F]] = #_[h[F]]
                        end
                      end
                    end
                  else
                    if M < 178 then
                      if M >= 176 then
                        if M == 177 then
                          _[Y[F]] = h
                        else
                          _[S[F]][N[F]] = Y[F]
                        end
                      else
                        _[Y[F]][B[F]] = _[h[F]]
                      end
                    else
                      if M < 179 then
                        _[h[F]] = p(_[S[F]], _[Y[F]])
                      else
                        if M ~= 180 then
                          local W, O, b2 = Y[F], N[F], _[S[F]]
                          local F2, N2 = I(O, 4294967295), I(b2, 4294967295)
                          local b2, _2, M2, S2 = I(F2, 65535), x(F2, 16), I(N2, 65535), x(N2, 16)
                          O = I(b2 * M2 + a(I(b2 * S2 + _2 * M2, 65535), 16), 4294967295)
                          S2 = nil
                          repeat
                            N2 = O % 4294967296
                            if N2 ~= N2 then
                              S2 = 0
                              break
                            end
                            S2 = N2 - N2 % 1
                          until true
                          _[W] = S2
                        else
                          j = S[F]
                          _[j], _[j + 1] = Y[F], _[h[F]]
                        end
                      end
                    end
                  end
                else
                  if M < 187 then
                    if M >= 184 then
                      if M >= 185 then
                        if M ~= 186 then
                          if V then
                            local W = h[F]
                            local O = V[W]
                            if O then
                              O[6] = O
                              O[4] = _[W]
                              O[5] = 4
                              V[W] = nil
                            end
                          end
                        else
                          local W, O, b2 = S[F], p(h[F], (I(p(e, (I(x(e, 29), 7))), 536870911))), D[4]
                          local F2 = p(b2[W], 82680540)
                          b2[W] = F2
                          W, b2 = D[7], F2 + 1
                          F2 = Q(W, b2)
                          local N2, _2
                          if F2 < 128 then
                            N2, _2 = F2, b2 + 1
                          else
                            local M2 = Q(W, b2 + 1)
                            if M2 < 128 then
                              N2, _2 = F2 - 128 + M2 * 128, b2 + 2
                            else
                              local S2 = Q(W, b2 + 2)
                              if S2 < 128 then
                                N2, _2 = (F2 - 128) * 128 + (M2 - 128) + S2 * 16384, b2 + 3
                              else
                                local B2 = Q(W, b2 + 3)
                                N2, _2 =
                                  (F2 - 128) * 16384 + (M2 - 128) * 2097152 + (S2 - 128) + B2 % 128 * 128 + (B2 - B2 % 128) * 2097152,
                                  b2 + 4
                              end
                            end
                          end
                          F2, b2 = O * 16843009, _2 + N2
                          local M2 = b2 - N2 % 4
                          for N2 = _2, M2 - 1, 4 do
                            K(W, N2, (p(z(W, N2), F2)))
                          end
                          for F2 = M2, b2 - 1, 1 do
                            T(W, F2, (p(Q(W, F2), O)))
                          end
                          S[F] = 219
                          h[F] = 110
                          Y[F] = 11
                          c[F] = 76
                        end
                      else
                        _[S[F]] = _[Y[F]] % _[h[F]]
                      end
                    else
                      if M >= 182 then
                        if M ~= 183 then
                          j = h[F]
                          _[j], _[j + 1] = B[F], _[Y[F]]
                        else
                          F = if _[Y[F]] ~= _[S[F]] then h[F] else F
                        end
                      else
                        _[Y[F]](_[h[F]])
                      end
                    end
                  else
                    if M >= 190 then
                      if M >= 192 then
                        if M == 193 then
                          F = if _[Y[F]] < S[F] then F else h[F]
                        else
                          _[Y[F]](B[F], C(_[h[F]], 1, _[h[F]].n))
                        end
                      else
                        if M == 191 then
                          local W, O, b2 = h[F], _[S[F]], Y[F]
                          local F2, N2 = I(O, 4294967295), I(b2, 4294967295)
                          local _2, M2, S2, B2 = I(F2, 65535), x(F2, 16), I(N2, 65535), x(N2, 16)
                          b2 = I(_2 * S2 + a(I(_2 * B2 + M2 * S2, 65535), 16), 4294967295)
                          O = nil
                          repeat
                            F2 = b2 % 4294967296
                            if F2 ~= F2 then
                              O = 0
                              break
                            end
                            O = F2 - F2 % 1
                          until true
                          _[W] = O
                        else
                          if V then
                            for W in v, V, nil do
                              local O = V[W]
                              if O then
                                O[6] = O
                                O[4] = _[W]
                                O[5] = 4
                                V[W] = nil
                              end
                            end
                          end
                          if o then
                            for W, O in v, o, nil do
                              local b2 = O[4]
                              if o then
                                O = o[W]
                                if O then
                                  local F2, N2 = W + b2, y(b2)
                                  t(_, W, F2 - 1, 1, N2)
                                  O[6] = N2
                                  O[5] = 1
                                  o[W] = nil
                                end
                              end
                            end
                          end
                          return B[F], U[F]
                        end
                      end
                    else
                      if M < 188 then
                        local B, W, O = h[F], Y[F], D[4]
                        local b2 = p(O[B], 82680540)
                        O[B] = b2
                        B, O = D[7], b2 + 1
                        b2 = Q(B, O)
                        local F2, N2
                        if b2 < 128 then
                          F2, N2 = b2, O + 1
                        else
                          local _2 = Q(B, O + 1)
                          if _2 < 128 then
                            F2, N2 = b2 - 128 + _2 * 128, O + 2
                          else
                            local M2 = Q(B, O + 2)
                            if M2 < 128 then
                              F2, N2 = (b2 - 128) * 128 + (_2 - 128) + M2 * 16384, O + 3
                            else
                              local S2 = Q(B, O + 3)
                              F2, N2 =
                                (b2 - 128) * 16384 + (_2 - 128) * 2097152 + (M2 - 128) + S2 % 128 * 128 + (S2 - S2 % 128) * 2097152, O + 4
                            end
                          end
                        end
                        b2, O = W * 16843009, N2 + F2
                        local _2 = O - F2 % 4
                        for F2 = N2, _2 - 1, 4 do
                          K(B, F2, (p(z(B, F2), b2)))
                        end
                        for b2 = _2, O - 1, 1 do
                          T(B, b2, (p(Q(B, b2), W)))
                        end
                        h[F] = 6
                        Y[F] = 74
                        S[F] = 183
                        c[F] = 76
                      elseif M == 189 then
                        local M, B, W = S[F], _[h[F]], U[F]
                        local O, b2 = I(B, 4294967295), I(W, 4294967295)
                        local F2, N2, _2, M2 = I(O, 65535), x(O, 16), I(b2, 65535), x(b2, 16)
                        W = I(F2 * _2 + a(I(F2 * M2 + N2 * _2, 65535), 16), 4294967295)
                        F2 = nil
                        repeat
                          B = W % 4294967296
                          if B ~= B then
                            F2 = 0
                            break
                          end
                          F2 = B - B % 1
                        until true
                        _[M] = F2
                      else
                        _[S[F]][_[Y[F]]] = _[h[F]]
                      end
                    end
                  end
                end
              end
            end
          end
          F = F + 1
        end
      else
      end
      if n == 71 then
        while true do
          local M = S[F]
          if M >= 96 then
            local B
            if M >= 144 then
              if M >= 168 then
                if M >= 180 then
                  if M >= 186 then
                    if M < 189 then
                      if M >= 187 then
                        if M == 188 then
                          j = Y[F]
                          _[j], _[j + 1] = h[F], s[F]
                        else
                          local W
                          local n = s[F]
                          if n then
                            local O = #n / 3
                            if O > 0 then
                              W = {}
                              local b2, F2 = V, o
                              for N2 = 1, O, 1 do
                                local O = (N2 - 1) * 3
                                local _2, M2 = n[O + 3], n[O + 2]
                                if _2 == 0 then
                                  b2 = b2 or {}
                                  local S2 = b2[M2]
                                  if S2 then
                                  else
                                    S2 = { [6] = _, [5] = M2 }
                                    b2[M2] = S2
                                  end
                                  W[N2] = S2
                                else
                                  if _2 == 2 then
                                    W[N2] = _[M2]
                                  else
                                    if _2 == 3 then
                                      W[N2] = u[M2]
                                    else
                                      if _2 == 1 then
                                        F2 = F2 or {}
                                        local _2 = F2[M2]
                                        if _2 then
                                        else
                                          _2 = { [4] = n[O + 1], [5] = M2, [6] = _ }
                                          F2[M2] = _2
                                        end
                                        W[N2] = _2
                                      else
                                      end
                                    end
                                  end
                                end
                              end
                              V, o = b2, F2
                            else
                            end
                          else
                          end
                          _[Y[F]] = N[F](W, nil)
                          j = W
                        end
                      else
                        _[Y[F]][N[F]] = c[F]
                      end
                    else
                      if M < 190 then
                        q, j = c[F], Y[F] + 1
                        for W = 1, h[F], 1 do
                          q = I(p(q, (a(q, 13))), 536870911)
                          q = p(q, (x(q, 13)))
                          q = I(p(q, (a(q, 14))), 536870911)
                          Y[j] = p(Y[j], (I(x(q, 0), 127)))
                          c[j] = p(c[j], (I(x(q, 7), 127)))
                          h[j] = p(h[j], (I(x(q, 14), 127)))
                          S[j] = p(S[j], (I(x(q, 21), 127)))
                          j = j + 1
                        end
                        S[F] = 143
                      else
                        if M ~= 191 then
                          j, q, m = h[F], c[F], Y[F]
                          d = _[j]
                          t(_, j + 1, j + q, m + 1, d)
                        else
                          _[c[F]] = _[Y[F]] // h[F]
                        end
                      end
                    end
                  else
                    if M < 183 then
                      if M >= 181 then
                        if M == 182 then
                          q, j = (p(c[F], (I(p(l, (I(x(l, 29), 7))), 536870911)))), Y[F] + 1
                          for W = 1, h[F], 1 do
                            q = I(p(q, (a(q, 13))), 536870911)
                            q = p(q, (x(q, 13)))
                            q = I(p(q, (a(q, 14))), 536870911)
                            Y[j] = p(Y[j], (I(x(q, 0), 127)))
                            c[j] = p(c[j], (I(x(q, 7), 127)))
                            h[j] = p(h[j], (I(x(q, 14), 127)))
                            S[j] = p(S[j], (I(x(q, 21), 127)))
                            j = j + 1
                          end
                          S[F] = 143
                        else
                          if V then
                            for W in v, V, nil do
                              local n = V[W]
                              if n then
                                n[6] = n
                                n[4] = _[W]
                                n[5] = 4
                                V[W] = nil
                              end
                            end
                          end
                          if o then
                            for W, n in v, o, nil do
                              local O = n[4]
                              if o then
                                n = o[W]
                                if n then
                                  local b2 = y(O)
                                  t(_, W, W + O - 1, 1, b2)
                                  n[6] = b2
                                  n[5] = 1
                                  o[W] = nil
                                end
                              end
                            end
                          end
                          return _[h[F]](_[Y[F]], _[c[F]])
                        end
                      else
                        B = E
                        E, j = { [6] = B, [7] = Z, [9] = G, [5] = i, [8] = A }, h[F]
                        i, A = _[j + 2] + 0, _[j + 1] + 0
                        G = _[j] - i
                        F = Y[F]
                      end
                    else
                      if M < 184 then
                        _[Y[F]] = b
                      elseif M ~= 185 then
                        _[Y[F]] = x(_[h[F]], c[F])
                      else
                        _[h[F]] = _[c[F]] ~= U[F]
                      end
                    end
                  end
                else
                  if M < 174 then
                    if M >= 171 then
                      if M >= 172 then
                        if M ~= 173 then
                          if V then
                            for W in v, V, nil do
                              local n = V[W]
                              if n then
                                n[6] = n
                                n[4] = _[W]
                                n[5] = 4
                                V[W] = nil
                              end
                            end
                          end
                          if o then
                            for W, n in v, o, nil do
                              local O = n[4]
                              if o then
                                n = o[W]
                                if n then
                                  local b2, F2 = W + O, y(O)
                                  t(_, W, b2 - 1, 1, F2)
                                  n[6] = F2
                                  n[5] = 1
                                  o[W] = nil
                                end
                              end
                            end
                          end
                          return N[F], U[F]
                        else
                          j = h[F]
                          q, m, d, g = _[j], _[j + 1], _[j + 2], _[j + 3]
                          _[j] = q(m, d, g)
                        end
                      else
                        _[c[F]] = R(_[Y[F]]())
                      end
                    else
                      if M < 169 then
                        F = if _[h[F]] ~= s[F] then Y[F] else F
                      else
                        if M ~= 170 then
                          _[h[F]] = _[Y[F]] < _[c[F]]
                        else
                          _[h[F]] = -_[Y[F]]
                        end
                      end
                    end
                  else
                    if M < 177 then
                      if M < 175 then
                        if V then
                          local W = c[F]
                          local n = V[W]
                          if n then
                            n[6] = n
                            n[4] = _[W]
                            n[5] = 4
                            V[W] = nil
                          end
                          W = Y[F]
                          n = V[W]
                          if n then
                            n[6] = n
                            n[4] = _[W]
                            n[5] = 4
                            V[W] = nil
                          end
                        end
                      else
                        if M == 176 then
                          F = h[F]
                        else
                          u[h[F]][s[F]] = _[Y[F]]
                        end
                      end
                    else
                      if M >= 178 then
                        if M ~= 179 then
                          _[h[F]] = _[Y[F]] == s[F]
                        else
                          F = _[Y[F]]
                        end
                      else
                        j = u[Y[F]]
                        j[6][j[5]][_[h[F]]] = _[c[F]]
                      end
                    end
                  end
                end
              else
                if M < 156 then
                  if M >= 150 then
                    if M >= 153 then
                      if M >= 154 then
                        if M ~= 155 then
                          if V then
                            for W in v, V, nil do
                              local n = V[W]
                              if n then
                                n[6] = n
                                n[4] = _[W]
                                n[5] = 4
                                V[W] = nil
                              end
                            end
                          end
                          if o then
                            for W, n in v, o, nil do
                              local O = n[4]
                              if o then
                                n = o[W]
                                if n then
                                  local b2 = y(O)
                                  t(_, W, W + O - 1, 1, b2)
                                  n[6] = b2
                                  n[5] = 1
                                  o[W] = nil
                                end
                              end
                            end
                          end
                          return N[F]
                        else
                          _[Y[F]][s[F]] = N[F]
                        end
                      else
                        _[h[F]](s[F])
                      end
                    else
                      if M < 151 then
                        q, j = (p(c[F], (I(p(e, (I(x(e, 29), 7))), 536870911)))), Y[F] + 1
                        for W = 1, h[F], 1 do
                          q = I(p(q, (a(q, 13))), 536870911)
                          q = p(q, (x(q, 13)))
                          q = I(p(q, (a(q, 14))), 536870911)
                          Y[j] = p(Y[j], (I(x(q, 0), 127)))
                          c[j] = p(c[j], (I(x(q, 7), 127)))
                          h[j] = p(h[j], (I(x(q, 14), 127)))
                          S[j] = p(S[j], (I(x(q, 21), 127)))
                          j = j + 1
                        end
                        S[F] = 143
                      else
                        if M ~= 152 then
                          _[Y[F] + _[h[F]]] = _[c[F]]
                        else
                          j = u[c[F]]
                          _[Y[F]] = j[6][j[5]][h[F]]
                        end
                      end
                    end
                  else
                    if M >= 147 then
                      if M >= 148 then
                        if M ~= 149 then
                          F = if _[h[F]] < Y[F] then F else c[F]
                        else
                          j = u[c[F]]
                          _[Y[F]] = j[6][j[5]][N[F]]
                        end
                      else
                        _[Y[F]] = _[c[F]] / h[F]
                      end
                    else
                      if M < 145 then
                        local W, n, O = Y[F], h[F], _[c[F]]
                        local b2, F2 = I(n, 4294967295), I(O, 4294967295)
                        local O, N2, _2, M2 = I(b2, 65535), x(b2, 16), I(F2, 65535), x(F2, 16)
                        b2 = I(O * _2 + a(I(O * M2 + N2 * _2, 65535), 16), 4294967295)
                        N2 = nil
                        repeat
                          n = b2 % 4294967296
                          if n ~= n then
                            N2 = 0
                            break
                          end
                          N2 = n - n % 1
                        until true
                        _[W] = N2
                      elseif M ~= 146 then
                        _[Y[F]] = u[h[F]]
                      else
                        _[h[F]] = u[c[F]][U[F]]
                      end
                    end
                  end
                else
                  if M >= 162 then
                    if M >= 165 then
                      if M >= 166 then
                        if M ~= 167 then
                          _[c[F]] = _[Y[F]] - _[h[F]]
                        elseif V then
                          local W = h[F]
                          local n = V[W]
                          if n then
                            n[6] = n
                            n[4] = _[W]
                            n[5] = 4
                            V[W] = nil
                          end
                          W = c[F]
                          n = V[W]
                          if n then
                            n[6] = n
                            n[4] = _[W]
                            n[5] = 4
                            V[W] = nil
                          end
                          W = Y[F]
                          n = V[W]
                          if n then
                            n[6] = n
                            n[4] = _[W]
                            n[5] = 4
                            V[W] = nil
                          end
                        end
                      else
                        _[h[F]] = u[c[F]][_[Y[F]]]
                      end
                    else
                      if M >= 163 then
                        if M ~= 164 then
                          j = c[F]
                          _[j], _[j + 1] = Y[F], _[h[F]]
                        else
                          j = u[c[F]]
                          j[6][j[5]] = U[F]
                        end
                      else
                        _[h[F]] = Y[F]
                      end
                    end
                  else
                    if M < 159 then
                      if M < 157 then
                        if V then
                          local W = c[F]
                          local n = V[W]
                          if n then
                            n[6] = n
                            n[4] = _[W]
                            n[5] = 4
                            V[W] = nil
                          end
                        end
                      elseif M == 158 then
                        _[h[F]] = c[F] / _[Y[F]]
                      else
                        _[Y[F]] = _[h[F]] - s[F]
                      end
                    elseif M >= 160 then
                      if M == 161 then
                        _[c[F]] = _[h[F]] // _[Y[F]]
                      else
                        _[Y[F]] = {}
                      end
                    else
                      if V then
                        for W in v, V, nil do
                          local n = V[W]
                          if n then
                            n[6] = n
                            n[4] = _[W]
                            n[5] = 4
                            V[W] = nil
                          end
                        end
                      end
                      if o then
                        for W, n in v, o, nil do
                          local O = n[4]
                          if o then
                            n = o[W]
                            if n then
                              local b2, F2 = W + O, y(O)
                              t(_, W, b2 - 1, 1, F2)
                              n[6] = F2
                              n[5] = 1
                              o[W] = nil
                            end
                          end
                        end
                      end
                      return _[c[F]], N[F]
                    end
                  end
                end
              end
            else
              if M >= 120 then
                if M >= 132 then
                  if M < 138 then
                    if M >= 135 then
                      if M < 136 then
                        _[c[F]] = w(_[h[F]], _[Y[F]])
                      elseif M ~= 137 then
                        _[c[F]] = _[h[F]] ~= _[Y[F]]
                      else
                        _[h[F]][_[Y[F]]] = s[F]
                      end
                    elseif M < 133 then
                      _[c[F]] = _[h[F]] == Y[F]
                    elseif M ~= 134 then
                      _[Y[F]] = l
                    else
                      _[h[F]] = s[F] + U[F]
                    end
                  else
                    if M >= 141 then
                      if M >= 142 then
                        if not (M == 143) then
                          _[Y[F]] = w(_[h[F]], s[F])
                        end
                      else
                        _[h[F]] = _[c[F]] == _[Y[F]]
                      end
                    else
                      if M < 139 then
                        _[Y[F]] = I(_[h[F]], _[c[F]])
                      else
                        if M == 140 then
                          P[U[F]] = _[c[F]]
                        else
                          F = if _[h[F]] then c[F] else Y[F]
                        end
                      end
                    end
                  end
                else
                  if M < 126 then
                    if M >= 123 then
                      if M < 124 then
                        F = if _[Y[F]] ~= _[c[F]] then h[F] else F
                      else
                        if M == 125 then
                          F = if _[h[F]] then Y[F] else c[F]
                        else
                          _[c[F]] = _[h[F]] .. _[Y[F]]
                        end
                      end
                    else
                      if M < 121 then
                        local W, n, O = c[F], _[h[F]], Y[F]
                        local b2, F2 = I(n, 4294967295), I(O, 4294967295)
                        local n, O, N2, _2 = I(b2, 65535), x(b2, 16), I(F2, 65535), x(F2, 16)
                        F2 = I(n * N2 + a(I(n * _2 + O * N2, 65535), 16), 4294967295)
                        b2 = nil
                        repeat
                          n = F2 % 4294967296
                          if n ~= n then
                            b2 = 0
                            break
                          end
                          b2 = n - n % 1
                        until true
                        _[W] = b2
                      else
                        if M == 122 then
                          _[c[F]] = _[Y[F]] + h[F]
                        else
                          F = if _[h[F]] ~= Y[F] then c[F] else F
                        end
                      end
                    end
                  else
                    if M >= 129 then
                      if M < 130 then
                        if V then
                          for W in v, V, nil do
                            local n = V[W]
                            if n then
                              n[6] = n
                              n[4] = _[W]
                              n[5] = 4
                              V[W] = nil
                            end
                          end
                        end
                        if o then
                          for W, n in v, o, nil do
                            local O = n[4]
                            if o then
                              n = o[W]
                              if n then
                                local b2 = y(O)
                                t(_, W, W + O - 1, 1, b2)
                                n[6] = b2
                                n[5] = 1
                                o[W] = nil
                              end
                            end
                          end
                        end
                        return _[c[F]]
                      elseif M == 131 then
                        _[h[F]] = #_[Y[F]]
                      else
                        u[c[F]][_[Y[F]]] = _[h[F]]
                      end
                    elseif M < 127 then
                      _[h[F]] = _[Y[F]] % c[F]
                    elseif M == 128 then
                      _[Y[F]] = N[F] + _[c[F]]
                    else
                      _[Y[F]][h[F]] = _[c[F]]
                    end
                  end
                end
              else
                if M >= 108 then
                  if M < 114 then
                    if M >= 111 then
                      if M < 112 then
                        _[h[F]] = _[Y[F]] < c[F]
                      elseif M == 113 then
                        local W, n, O = h[F], Y[F], D[4]
                        local b2 = p(O[W], 82680540)
                        O[W] = b2
                        O, W = D[7], b2 + 1
                        b2 = Q(O, W)
                        local F2, N2
                        if b2 < 128 then
                          F2, N2 = b2, W + 1
                        else
                          local _2 = Q(O, W + 1)
                          if _2 < 128 then
                            F2, N2 = b2 - 128 + _2 * 128, W + 2
                          else
                            local M2 = Q(O, W + 2)
                            if M2 < 128 then
                              F2, N2 = (b2 - 128) * 128 + (_2 - 128) + M2 * 16384, W + 3
                            else
                              local S2 = Q(O, W + 3)
                              F2, N2 =
                                (b2 - 128) * 16384 + (_2 - 128) * 2097152 + (M2 - 128) + S2 % 128 * 128 + (S2 - S2 % 128) * 2097152, W + 4
                            end
                          end
                        end
                        W, b2 = n * 16843009, N2 + F2
                        local _2 = b2 - F2 % 4
                        for F2 = N2, _2 - 1, 4 do
                          K(O, F2, (p(z(O, F2), W)))
                        end
                        for W = _2, b2 - 1, 1 do
                          T(O, W, (p(Q(O, W), n)))
                        end
                        h[F] = 106
                        Y[F] = 225
                        c[F] = 210
                        S[F] = 143
                      else
                        u[h[F]][U[F]] = s[F]
                      end
                    else
                      if M >= 109 then
                        if M == 110 then
                          F = if _[c[F]] <= h[F] then F else Y[F]
                        else
                          _[h[F]] = _[c[F]][_[Y[F]]]
                        end
                      else
                        _[h[F]] = P[s[F]]
                      end
                    end
                  else
                    if M >= 117 then
                      if M >= 118 then
                        if M == 119 then
                          _[Y[F]] = _[c[F]][h[F]]
                        else
                          F = if h[F] < _[c[F]] then F else Y[F]
                        end
                      else
                        _[h[F]] = not _[Y[F]]
                      end
                    else
                      if M < 115 then
                        j = c[F]
                        _[j], _[j + 1] = U[F], _[h[F]]
                      else
                        if M ~= 116 then
                          _[Y[F]] = P[s[F]][N[F]]
                        else
                          if V then
                            for W in v, V, nil do
                              local n = V[W]
                              if n then
                                n[6] = n
                                n[4] = _[W]
                                n[5] = 4
                                V[W] = nil
                              end
                            end
                          end
                          if o then
                            for W, n in v, o, nil do
                              local O = n[4]
                              if o then
                                n = o[W]
                                if n then
                                  local b2, F2 = W + O, y(O)
                                  t(_, W, b2 - 1, 1, F2)
                                  n[6] = F2
                                  n[5] = 1
                                  o[W] = nil
                                end
                              end
                            end
                          end
                          return _[Y[F]](_[c[F]])
                        end
                      end
                    end
                  end
                else
                  if M >= 102 then
                    if M >= 105 then
                      if M < 106 then
                        _[h[F]] = p(_[Y[F]], s[F])
                      elseif M == 107 then
                        if V then
                          for W in v, V, nil do
                            local n = V[W]
                            if n then
                              n[6] = n
                              n[4] = _[W]
                              n[5] = 4
                              V[W] = nil
                            end
                          end
                        end
                        if o then
                          for W, n in v, o, nil do
                            local O = n[4]
                            if o then
                              n = o[W]
                              if n then
                                local b2 = y(O)
                                t(_, W, W + O - 1, 1, b2)
                                n[6] = b2
                                n[5] = 1
                                o[W] = nil
                              end
                            end
                          end
                        end
                        return _[Y[F]](_[h[F]], s[F])
                      else
                        _[h[F]] = _[Y[F]] ~= c[F]
                      end
                    else
                      if M < 103 then
                        F = if _[h[F]] < _[c[F]] then F else Y[F]
                      else
                        if M ~= 104 then
                          if V then
                            for W in v, V, nil do
                              local n = V[W]
                              if n then
                                n[6] = n
                                n[4] = _[W]
                                n[5] = 4
                                V[W] = nil
                              end
                            end
                          end
                          if o then
                            for W, n in v, o, nil do
                              local O = n[4]
                              if o then
                                n = o[W]
                                if n then
                                  local b2 = y(O)
                                  t(_, W, W + O - 1, 1, b2)
                                  n[6] = b2
                                  n[5] = 1
                                  o[W] = nil
                                end
                              end
                            end
                          end
                          return
                        else
                          _[c[F]] = _[h[F]] >= _[Y[F]]
                        end
                      end
                    end
                  else
                    if M >= 99 then
                      if M >= 100 then
                        if M == 101 then
                          if V then
                            for W in v, V, nil do
                              local n = V[W]
                              if n then
                                n[6] = n
                                n[4] = _[W]
                                n[5] = 4
                                V[W] = nil
                              end
                            end
                          end
                          if o then
                            for W, n in v, o, nil do
                              local O = n[4]
                              if o then
                                n = o[W]
                                if n then
                                  local b2, F2 = W + O, y(O)
                                  t(_, W, b2 - 1, 1, F2)
                                  n[6] = F2
                                  n[5] = 1
                                  o[W] = nil
                                end
                              end
                            end
                          end
                          return _[c[F]], _[h[F]]
                        else
                          _[h[F]] = _[Y[F]] > _[c[F]]
                        end
                      else
                        F = _[c[F]]
                      end
                    else
                      if M >= 97 then
                        if M ~= 98 then
                          B = E
                          E, j, q = { [6] = B, [7] = Z, [9] = G, [5] = i, [8] = A }, Y[F], f(J)
                          q(b, _[j], _[j + 1], _[j + 2])
                          Z = c[F]
                          F, G = h[F], q
                        else
                          b[N[F]] = _[c[F]]
                        end
                      else
                        _[c[F]] = p(U[F], N[F])
                      end
                    end
                  end
                end
              end
            end
          else
            if M >= 48 then
              if M >= 72 then
                if M >= 84 then
                  if M >= 90 then
                    if M < 93 then
                      if M >= 91 then
                        if M == 92 then
                          _[Y[F]] = _[h[F]] - c[F]
                        else
                          e = _[h[F]]
                        end
                      else
                        j, q, m = h[F], c[F], Y[F]
                        d, g = _[j], j + q
                        k = _[g]
                        t(_, j + 1, g - 1, m + 1, d)
                        t(k, 1, k.n, m + q, d)
                      end
                    else
                      if M >= 94 then
                        if M ~= 95 then
                          _[Y[F]] = _[h[F]] / s[F]
                        else
                          _[c[F]] = a(_[Y[F]], h[F])
                        end
                      else
                        _[c[F]]()
                      end
                    end
                  else
                    if M < 87 then
                      if M < 85 then
                        j = u[h[F]]
                        j[6][j[5]] = _[c[F]]
                      else
                        if M ~= 86 then
                          _[h[F]] = I(_[c[F]], Y[F])
                        else
                          j = Y[F]
                          _[j], _[j + 1] = _[h[F]], s[F]
                        end
                      end
                    else
                      if M >= 88 then
                        if M == 89 then
                          _[Y[F]] = I(_[c[F]], N[F])
                        else
                          j, q, m = h[F], c[F], Y[F]
                          d = j + q
                          g = _[d]
                          k = g.n
                          r = q + k - 1
                          g.n = r
                          t(g, 1, k, q, g)
                          t(_, j + 1, d - 1, 1, g)
                          _[j] = R(_[j](C(g, 1, g.n)))
                        end
                      else
                        _[c[F]](U[F], _[h[F]])
                      end
                    end
                  end
                else
                  if M >= 78 then
                    if M >= 81 then
                      if M >= 82 then
                        if M == 83 then
                          _[Y[F]] = _[c[F]] * h[F]
                        else
                          _[Y[F]](_[h[F]], s[F])
                        end
                      else
                        _[Y[F]] = _[h[F]] + _[c[F]]
                      end
                    else
                      if M >= 79 then
                        if M ~= 80 then
                          j = _[Y[F]]
                          _[h[F]] = R(C(j, c[F], j.n))
                        else
                          if V then
                            for B in v, V, nil do
                              local W = V[B]
                              if W then
                                W[6] = W
                                W[4] = _[B]
                                W[5] = 4
                                V[B] = nil
                              end
                            end
                          end
                          if o then
                            for B, W in v, o, nil do
                              local n = W[4]
                              if o then
                                W = o[B]
                                if W then
                                  local f, J = B + n - 1, y(n)
                                  t(_, B, f, 1, J)
                                  W[6] = J
                                  W[5] = 1
                                  o[B] = nil
                                end
                              end
                            end
                          end
                          return N[F], _[Y[F]]
                        end
                      else
                        j = c[F]
                        _[j], _[j + 1] = h[F], Y[F]
                      end
                    end
                  else
                    if M < 75 then
                      if M < 73 then
                        _[Y[F]] = N[F] .. _[c[F]]
                      elseif M ~= 74 then
                        _[h[F]][Y[F]] = c[F]
                      else
                        _[Y[F]] = _[h[F]](_[c[F]])
                      end
                    else
                      if M < 76 then
                        _[h[F]] = p(_[c[F]], _[Y[F]])
                      else
                        if M == 77 then
                          _[c[F]] = R(_[Y[F]](_[h[F]]))
                        else
                          j = c[F]
                          _[j], _[j + 1] = _[Y[F]], h[F]
                        end
                      end
                    end
                  end
                end
              else
                if M >= 60 then
                  if M < 66 then
                    if M >= 63 then
                      if M >= 64 then
                        if M == 65 then
                          _[c[F]] = p(_[h[F]], Y[F])
                        else
                          _[Y[F]] = I(h[F], _[c[F]])
                        end
                      else
                        _[Y[F]] = b[s[F]]
                      end
                    else
                      if M >= 61 then
                        if M ~= 62 then
                          _[Y[F]] = _[c[F]] <= _[h[F]]
                        else
                          _[Y[F]] = b[h[F]]
                        end
                      else
                        G, A, i, Z = E[9], E[8], E[5], E[7]
                        E = E[6]
                      end
                    end
                  else
                    if M >= 69 then
                      if M < 70 then
                        local B, W, E = Y[F], p(c[F], (I(p(e, (I(x(e, 29), 7))), 536870911))), D[4]
                        local Z = p(E[B], 82680540)
                        E[B] = Z
                        E, B = D[7], Z + 1
                        Z = Q(E, B)
                        local n, f
                        if Z < 128 then
                          n, f = Z, B + 1
                        else
                          local J = Q(E, B + 1)
                          if J < 128 then
                            n, f = Z - 128 + J * 128, B + 2
                          else
                            local O = Q(E, B + 2)
                            if O < 128 then
                              n, f = (Z - 128) * 128 + (J - 128) + O * 16384, B + 3
                            else
                              local b2 = Q(E, B + 3)
                              n, f = (Z - 128) * 16384 + (J - 128) * 2097152 + (O - 128) + b2 % 128 * 128 + (b2 - b2 % 128) * 2097152, B + 4
                            end
                          end
                        end
                        Z, B = W * 16843009, f + n
                        local J = B - n % 4
                        for n = f, J - 1, 4 do
                          K(E, n, (p(z(E, n), Z)))
                        end
                        for Z = J, B - 1, 1 do
                          T(E, Z, (p(Q(E, Z), W)))
                        end
                        Y[F] = 197
                        c[F] = 119
                        h[F] = 228
                        S[F] = 143
                      else
                        if M == 71 then
                          j, q = Y[F], _[c[F]]
                          _[j + 1] = q
                          _[j] = q[N[F]]
                        else
                          _[c[F]] = N[F]
                        end
                      end
                    else
                      if M < 67 then
                        _[h[F]] = w(Y[F], _[c[F]])
                      elseif M ~= 68 then
                        _[h[F]] = _[c[F]] .. U[F]
                      else
                        _[c[F]] = _[Y[F]]()
                      end
                    end
                  end
                else
                  if M >= 54 then
                    if M >= 57 then
                      if M < 58 then
                        F = if U[F] < _[h[F]] then F else c[F]
                      else
                        if M == 59 then
                          local B, W, E = c[F], _[h[F]], _[Y[F]]
                          local Z, n = I(W, 4294967295), I(E, 4294967295)
                          local W, f, J, O = I(Z, 65535), x(Z, 16), I(n, 65535), x(n, 16)
                          n = I(W * J + a(I(W * O + f * J, 65535), 16), 4294967295)
                          J = nil
                          repeat
                            E = n % 4294967296
                            if E ~= E then
                              J = 0
                              break
                            end
                            J = E - E % 1
                          until true
                          _[B] = J
                        else
                          _[c[F]] = _[Y[F]] <= h[F]
                        end
                      end
                    else
                      if M < 55 then
                        _[c[F]] = _[h[F]] * U[F]
                      else
                        if M ~= 56 then
                          j = c[F]
                          local B, W, E = G()
                          if B then
                            _[j] = W
                            _[j + 1] = E
                            F = Y[F]
                          else
                            F = h[F]
                          end
                          q, m, d = B, W, E
                        else
                          _[h[F]](_[c[F]])
                        end
                      end
                    end
                  else
                    if M < 51 then
                      if M >= 49 then
                        if M == 50 then
                          _[Y[F]] = _[c[F]][N[F]]
                        else
                          _[c[F]][_[Y[F]]] = _[h[F]]
                        end
                      else
                        _[h[F]] = _[Y[F]] % _[c[F]]
                      end
                    else
                      if M < 52 then
                        _[h[F]] = _
                      else
                        if M == 53 then
                          j = u[Y[F]]
                          _[h[F]] = j[6][j[5]]
                        else
                          P[N[F]][U[F]] = _[c[F]]
                        end
                      end
                    end
                  end
                end
              end
            else
              if M < 24 then
                if M >= 12 then
                  if M >= 18 then
                    if M >= 21 then
                      if M < 22 then
                        G += i
                        j = if i <= 0 then G >= A else G <= A
                        if j then
                          _[c[F]] = G
                          F = h[F]
                        else
                          F = Y[F]
                        end
                      else
                        if M ~= 23 then
                          _[h[F]][c[F]] = U[F]
                        else
                          j = c[F]
                          local B, W = G()
                          if B then
                            _[j] = W
                            F = h[F]
                          else
                            F = Y[F]
                          end
                          q, m = B, W
                        end
                      end
                    else
                      if M < 19 then
                        _[h[F]] = x(_[Y[F]], _[c[F]])
                      elseif M == 20 then
                        _[h[F]] = Y[F] ^ _[c[F]]
                      else
                        _[Y[F]] = _[c[F]] * _[h[F]]
                      end
                    end
                  else
                    if M < 15 then
                      if M < 13 then
                        j = c[F]
                        _[j], _[j + 1] = U[F], h[F]
                      else
                        if M ~= 14 then
                          _[c[F]] = _[h[F]] / _[Y[F]]
                        else
                          _[Y[F]] = _[c[F]]
                        end
                      end
                    else
                      if M >= 16 then
                        if M == 17 then
                          j, q, m = Y[F], h[F], c[F]
                          d = j + q
                          _[j] = R(_[j](C(_, j + 1, d)))
                        else
                          for B = Y[F], c[F], 1 do
                            _[B] = nil
                          end
                        end
                      else
                        F = if _[Y[F]] <= _[c[F]] then F else h[F]
                      end
                    end
                  end
                else
                  if M < 6 then
                    if M >= 3 then
                      if M < 4 then
                        j, q = h[F], c[F]
                        m = j + q
                        d = _[m]
                        g = d.n
                        if V then
                          for B in v, V, nil do
                            local W = V[B]
                            if W then
                              W[6] = W
                              W[4] = _[B]
                              W[5] = 4
                              V[B] = nil
                            end
                          end
                        end
                        if o then
                          for B, W in v, o, nil do
                            local i = W[4]
                            if o then
                              W = o[B]
                              if W then
                                local G, A = B + i, y(i)
                                t(_, B, G - 1, 1, A)
                                W[6] = A
                                W[5] = 1
                                o[B] = nil
                              end
                            end
                          end
                        end
                        d.n = q + g - 1
                        t(d, 1, g, q, d)
                        t(_, j + 1, m - 1, 1, d)
                        return _[j](C(d, 1, d.n))
                      elseif M ~= 5 then
                        _[c[F]](U[F], N[F])
                      else
                        j, q, m = h[F], c[F], Y[F]
                        d, g = j + m - 1, j + q
                        k = _[g]
                        r = k.n
                        H = q + r - 1
                        k.n = H
                        t(k, 1, r, q, k)
                        t(_, j + 1, g - 1, 1, k)
                        L = R(_[j](C(k, 1, k.n)))
                        t(L, 1, m, j, _)
                      end
                    else
                      if M >= 1 then
                        if M ~= 2 then
                          _[c[F]] = h[F] - _[Y[F]]
                        else
                          j, q, m, d = h[F], c[F], p(l, I(x(l, 14), 262143), (I(x(l, 28), 15))), Y[F]
                          g = d < 2097152 and 7 or 14
                          k, r = I(d, a(1, g) - 1), x(d, g)
                          c[F] = p(q, 113, (I(x(m, 7), 127)))
                          S[F] = p(r, 104, (I(x(m, 21), 127)))
                          Y[F] = p(k, 57, (I(m, 127)))
                          h[F] = p(j, 64, (I(x(m, 14), 127)))
                          F = F - 1
                        end
                      else
                        _[Y[F]] = c[F] * _[h[F]]
                      end
                    end
                  else
                    if M >= 9 then
                      if M < 10 then
                        j = u[Y[F]]
                        _[c[F]] = j[6][j[5]][_[h[F]]]
                      else
                        if M == 11 then
                          _[h[F]] = w(s[F], _[Y[F]])
                        else
                          F = if Y[F] <= _[c[F]] then F else h[F]
                        end
                      end
                    else
                      if M < 7 then
                        _[c[F]] = _[Y[F]] > h[F]
                      elseif M == 8 then
                        _[h[F]](C(_[c[F]], 1, _[c[F]].n))
                      else
                        local B, W, i = Y[F], p(c[F], (I(p(l, (I(x(l, 29), 7))), 536870911))), D[4]
                        local G = p(i[B], 82680540)
                        i[B] = G
                        B, i = D[7], G + 1
                        G = Q(B, i)
                        local D, A
                        if G < 128 then
                          D, A = G, i + 1
                        else
                          local E = Q(B, i + 1)
                          if E < 128 then
                            D, A = G - 128 + E * 128, i + 2
                          else
                            local Z = Q(B, i + 2)
                            if Z < 128 then
                              D, A = (G - 128) * 128 + (E - 128) + Z * 16384, i + 3
                            else
                              local L = Q(B, i + 3)
                              D, A = (G - 128) * 16384 + (E - 128) * 2097152 + (Z - 128) + L % 128 * 128 + (L - L % 128) * 2097152, i + 4
                            end
                          end
                        end
                        G, i = W * 16843009, A + D
                        local E = i - D % 4
                        for D = A, E - 1, 4 do
                          K(B, D, (p(z(B, D), G)))
                        end
                        for D = E, i - 1, 1 do
                          T(B, D, (p(Q(B, D), W)))
                        end
                        Y[F] = 110
                        c[F] = 109
                        h[F] = 214
                        S[F] = 143
                      end
                    end
                  end
                end
              else
                if M >= 36 then
                  if M >= 42 then
                    if M < 45 then
                      if M < 43 then
                        b[Y[F]] = _[c[F]]
                      elseif M == 44 then
                        _[Y[F]] = p(N[F], _[c[F]])
                      else
                        _[c[F]][U[F]] = _[h[F]]
                      end
                    else
                      if M >= 46 then
                        if M == 47 then
                          j = c[F]
                          _[j], _[j + 1] = _[h[F]], _[Y[F]]
                        else
                          _[h[F]] = X(_[Y[F]])
                        end
                      else
                        if V then
                          for B in v, V, nil do
                            local D = V[B]
                            if D then
                              D[6] = D
                              D[4] = _[B]
                              D[5] = 4
                              V[B] = nil
                            end
                          end
                        end
                        if o then
                          for B, D in v, o, nil do
                            local W = D[4]
                            if o then
                              D = o[B]
                              if D then
                                local U, i = B + W - 1, y(W)
                                t(_, B, U, 1, i)
                                D[6] = i
                                D[5] = 1
                                o[B] = nil
                              end
                            end
                          end
                        end
                        return _[h[F]](C(_[Y[F]], 1, _[Y[F]].n))
                      end
                    end
                  else
                    if M >= 39 then
                      if M < 40 then
                        j, q, m = h[F], Y[F], c[F]
                        d, g, k = j + m - 1, j + q, R(_[j](C(_, j + 1, j + q)))
                        t(k, 1, m, j, _)
                      else
                        if M ~= 41 then
                          local B, D, W = c[F], _[Y[F]]
                          repeat
                            local U = D % 4294967296
                            if U ~= U then
                              W = 0
                              break
                            end
                            W = U - U % 1
                          until true
                          _[B] = W
                        else
                          j, q, m, d = h[F], Y[F], c[F], p(l, I(x(l, 14), 262143), (I(x(l, 28), 15)))
                          g = j < 16384 and 7 or (j < 2097152 and 14 or 21)
                          k, r = I(j, a(1, g) - 1), x(j, g)
                          S[F] = p(r, 90, (I(x(d, 21), 127)))
                          h[F] = p(k, 117, (I(x(d, 14), 127)))
                          Y[F] = p(q, 66, (I(d, 127)))
                          c[F] = p(m, 126, (I(x(d, 7), 127)))
                          F = F - 1
                        end
                      end
                    else
                      if M >= 37 then
                        if M == 38 then
                          _[c[F]] = y(Y[F])
                        else
                          _[Y[F]] = _[c[F]] + N[F]
                        end
                      else
                        _[Y[F]] = I(N[F], _[c[F]])
                      end
                    end
                  end
                else
                  if M >= 30 then
                    if M < 33 then
                      if M >= 31 then
                        if M == 32 then
                          _[c[F]] = _[h[F] + _[Y[F]]]
                        else
                          _[Y[F]] = e
                        end
                      else
                        _[h[F]](_[c[F]], C(_[Y[F]], 1, _[Y[F]].n))
                      end
                    elseif M < 34 then
                      b[N[F]] = s[F]
                    elseif M ~= 35 then
                      _[c[F]] = _[Y[F]](N[F])
                    else
                      local b, S, B = Y[F], N[F], _[c[F]]
                      local D, W = I(S, 4294967295), I(B, 4294967295)
                      local S, U, g, i = I(D, 65535), x(D, 16), I(W, 65535), x(W, 16)
                      B = I(S * g + a(I(S * i + U * g, 65535), 16), 4294967295)
                      g = nil
                      repeat
                        W = B % 4294967296
                        if W ~= W then
                          g = 0
                          break
                        end
                        g = W - W % 1
                      until true
                      _[b] = g
                    end
                  else
                    if M < 27 then
                      if M < 25 then
                        l = _[Y[F]]
                      else
                        if M == 26 then
                          _[h[F]](_[c[F]], _[Y[F]])
                        else
                          _[h[F]] = Y[F] + _[c[F]]
                        end
                      end
                    else
                      if M >= 28 then
                        if M == 29 then
                          j = Y[F]
                          _[j], _[j + 1] = s[F], N[F]
                        else
                          j = h[F]
                          q, m, d = _[j], _[j + 1], _[j + 2]
                          _[j] = q(m, d)
                        end
                      else
                        j = Y[F]
                        m = j + h[F]
                        if V then
                          for b in v, V, nil do
                            local N = V[b]
                            if N then
                              N[6] = N
                              N[4] = _[b]
                              N[5] = 4
                              V[b] = nil
                            end
                          end
                        end
                        if o then
                          for b, N in v, o, nil do
                            local M = N[4]
                            if o then
                              N = o[b]
                              if N then
                                local S = y(M)
                                t(_, b, b + M - 1, 1, S)
                                N[6] = S
                                N[5] = 1
                                o[b] = nil
                              end
                            end
                          end
                        end
                        return _[j](C(_, j + 1, m))
                      end
                    end
                  end
                end
              end
            end
          end
          F = F + 1
        end
      end
    end
  end
end

--[[
  Phantom Hub - VmOpcodeDispatcher

  Role: VM instruction handler/dispatch state machine. Decodes opcode operands from the protected bytecode
  stream and forwards each instruction to the matching handler.
  Category: vm
  Recovered factory key: 7294   source position: 55   bytes: 2488

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 2
    deps[1] = VM handler table/self, deps[2] = active handler state.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local VmOpcodeDispatcher = function(b, F, F, F)
  return function(F, N, N)
    local N = F[1]
    local _ = F[2]
    return function(F, M, S)
      local B, D = 14
      local h, W, U, s, c, Y, g, o, V, q, j, m = F, M, S
      while true do
        S = nil
        if B <= 14 then
          if B <= 6 then
            if B <= 2 then
              if B <= 0 then
                M = b[67](V, U + 1)
                B, g = 12, M
              elseif B <= 1 then
                B, U = 26, U + 1
              else
                F = b[67](V, U + 3)
                B, Y, U = 21, (Y - 128) * 16384 + (g - 128) * 2097152 + (o - 128) + F % 128 * 128 + (F - F % 128) * 2097152, U + 4
              end
            elseif B <= 4 then
              if B <= 3 then
                local F = D[2]
                B, D = 22, F
              else
                B, Y, U = 21, Y - 128 + g * 128, U + 2
              end
            elseif B <= 5 then
              local F = b[67](s, c + 2)
              B, o = F < 128 and 6 or 18, F
            else
              B, Y, c = 13, (Y - 128) * 128 + (g - 128) + o * 16384, c + 3
            end
          elseif B <= 10 then
            if B <= 8 then
              if B <= 7 then
                local F, M, i = b[0], b[120](s, c + m), N[6][N[5]][W]
                F(V, m, (b[28](M, i, q)))
                S = _[6][_[5]][W]
                B, W = 9, S
              else
                local F = D[4]
                h[5] = b[88](h)
                local N, _, M = b:hs(h, V)
                local i = b[67](V, M)
                B, D, h, W, U, Y = i < 128 and 16 or 0, F, N, _, M, i
              end
            elseif B <= 9 then
              local F, N, _ = D[3], D[4], D[1]
              local M, i = F + N, N <= 0
              N, F = M >= _, M <= _
              _ = i and N or not i and F
              D[3] = M
              if _ then
                B, m = 7, M
              else
                B = 3
              end
            else
              return h, W
            end
          elseif B <= 12 then
            if B <= 11 then
              local F = b[67](V, U + 2)
              B, o = F < 128 and 19 or 2, F
            else
              B = g < 128 and 4 or 11
            end
          elseif B <= 13 then
            local F, N = 29, 147
            S = (U + W) % 256
            local _, M, m = b[99](Y), U * 16843009, Y - Y % 4
            local i, k = m - 1, 4 + 0
            local G = 0 - k
            local A = { i + 0, D, G, k, nil }
            B, D, W, g, o, V, q, j = 9, A, S, F, N, _, M, m
          else
            local F, N = h[4][W], h[7]
            local _ = F + 1
            F = b[67](N, _)
            B, s, c, Y = F < 128 and 17 or 30, N, _, F
          end
        elseif B <= 22 then
          if B <= 18 then
            if B <= 16 then
              if B <= 15 then
                B, g, U = 26, g - 128 + o * 128, U + 2
              else
                B, U = 21, U + 1
              end
            elseif B <= 17 then
              B, c = 13, c + 1
            else
              local F = b[67](s, c + 3)
              B, Y, c = 13, (Y - 128) * 16384 + (g - 128) * 2097152 + (o - 128) + F % 128 * 128 + (F - F % 128) * 2097152, c + 4
            end
          elseif B <= 20 then
            if B <= 19 then
              B, Y, U = 21, (Y - 128) * 128 + (g - 128) + o * 16384, U + 3
            else
              local F, N, _ = D[1], D[2], D[5]
              local M, h = F + N, N <= 0
              F, N = M >= _, M <= _
              _ = h and F or not h and N
              D[1] = M
              if _ then
                B, Y = 27, M
              else
                B = 8
              end
            end
          elseif B <= 21 then
            local F = b[67](V, U)
            B, g = F < 128 and 1 or 28, F
          else
            local F, N = Y - 1, 1 + 0
            local _ = { j - N, N, nil, D, F + 0 }
            B, D = 20, _
          end
        elseif B <= 26 then
          if B <= 24 then
            if B <= 23 then
              local F = b[67](V, U + 2)
              B, q = F < 128 and 24 or 29, F
            else
              B, g, U = 26, (g - 128) * 128 + (o - 128) + q * 16384, U + 3
            end
          elseif B <= 25 then
            B, Y, c = 13, Y - 128 + g * 128, c + 2
          else
            local F, N = b[67](V, U), U + 1
            b[74](s, c + Y, F, g)
            B = 10
          end
        elseif B <= 28 then
          if B <= 27 then
            S = (g * W + o) % 256
            b[44](V, Y, (b[28](b[67](s, c + Y), U, S)))
            B, W = 20, S
          else
            local F = b[67](V, U + 1)
            B, o = F < 128 and 15 or 23, F
          end
        elseif B <= 29 then
          local F = b[67](V, U + 3)
          B, g, U = 26, (g - 128) * 16384 + (o - 128) * 2097152 + (q - 128) + F % 128 * 128 + (F - F % 128) * 2097152, U + 4
        else
          local F = b[67](s, c + 1)
          B, g = F < 128 and 25 or 5, F
        end
      end
    end
  end
end

--[[
  Phantom Hub - Rc4StringDecryptor

  Role: RC4 key-scheduling/PRGA routine used to decrypt embedded strings. Byte offsets are resolved through the
  VM object's buffer helpers.
  Category: vm
  Recovered factory key: 201   source position: 44   bytes: 1623

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 3
    deps[1..3] = VM helpers used for buffer reads, byte extraction and the state table.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local Rc4StringDecryptor = function(b, F, F, F)
  return function(F)
    local N = F[1]
    local _ = F[2]
    local M = F[3]
    return function()
      local F, S, B, D, h, W, U, s, c, Y, g, o, V, q, j = 9
      while true do
        local m, i
        if F <= 5 then
          if F <= 2 then
            if F <= 0 then
              m = b[123](h + 1, 255)
              i = b[123](W + Y[m], 255)
              Y[m], Y[i] = Y[i], Y[m]
              local k = Y[b[123](Y[m] + Y[i], 255)]
              b[44](g, B, (b[28](b[67](U, s + B), k)))
              F, h, W = 6, m, i
            elseif F <= 1 then
              local k = b[123](D + Y[q], 255)
              Y[q], Y[k] = Y[k], Y[q]
              local G
              D, F, G = b[122](Y[b[123](Y[q] + Y[k], 255)], 16), 5, b[123](q + 1, 255)
              q, j = G, k + Y[G]
            else
              local k, G = c - 1, 1 + 0
              local A = o - G
              local l = { nil, G, k + 0, S, A }
              F, S = 6, l
            end
          elseif F <= 3 then
            local k = S[5]
            F, S = 2, k
          elseif F <= 4 then
            local k, G, A = S[2], S[1], S[4]
            local l, r = k + G, G <= 0
            G, k = l >= A, l <= A
            A = r and G or not r and k
            S[2] = l
            if A then
              F, V = 11, l
            else
              F = 3
            end
          else
            local k = b[123](j, 255)
            Y[q], Y[k] = Y[k], Y[q]
            local j = b[90](B, h, W, D, (b[122](Y[b[123](Y[q] + Y[k], 255)], 24)))
            b[0](g, V, (b[28](b[120](U, s + V), j)))
            F, B, D, h, W = 4, q, k, q, k
          end
        elseif F <= 8 then
          if F <= 6 then
            local V, j, k = S[5], S[2], S[3]
            local G, A = V + j, j <= 0
            V, j = G >= k, G <= k
            k = A and V or not A and j
            S[5] = G
            if k then
              F, B = 0, G
            else
              F = 8
            end
          elseif F <= 7 then
            return g
          else
            local V = S[4]
            F, S = 7, V
          end
        elseif F <= 9 then
          local V, j = N[6][N[5]], _[6][_[5]]
          local N, _, k, G = b[41](V) - j
          _, m, i, k, G = M[6][M[5]], 0, 0, b[99](N), N - N % 4
          local M, m = G - 1, 4 + 0
          local i, A = 0 - m
          A, F = { m, i, nil, M + 0, S }, 4
          S, h, W, U, s, c, Y, g, o = A, 0, 0, V, j, N, _, k, G
        elseif F <= 10 then
          local N = b[123](W, 255)
          local _ = b[123](D + Y[N], 255)
          Y[N], Y[_] = Y[_], Y[N]
          local M
          W, F, D, M = b[122](Y[b[123](Y[N] + Y[_], 255)], 8), 1, _, b[123](N + 1, 255)
          q = M
        else
          local N, _ = 0, b[123](h + 1, 255)
          local M = b[123](W + Y[_], 255)
          Y[_], Y[M] = Y[M], Y[_]
          F, B, D, h, W = 10, N, M, b[122](Y[b[123](Y[_] + Y[M], 255)], 0), _ + 1
        end
      end
    end
  end
end

--[[
  Phantom Hub - ChaCha20Core

  Role: ChaCha20-style 32-bit quarter-round/block core used by the VM's string and bytecode decryption.
  Category: vm
  Recovered factory key: 5061   source position: 164   bytes: 618

  This is one of the 59 feature factories stored in the Luraph v15.1 outer
  table of script_1793920296_0006.luau. The body below is the recovered
  code with whitespace normalised. Short names (F, N, _, M, S, ...) are
  obfuscator-generated locals; the first `local X = b[n]` lines load the
  dependency slots supplied by the missing Phantom Hub main module.

  Dependency slots: 1
    deps[1] = VM object providing the byte-read helper `Bs`.

  The `b[n]` dependency slots cannot be resolved to concrete values from
  this capture: the main module that built each dependency array lives in
  a nested encrypted payload that never executed. Treat the slots as an
  interface contract, not as a shared global table.
]]
local ChaCha20Core = function(b, F, F, F, F, F)
  return function(F, N, N)
    local N = F[1]
    return function(F, _)
      local M = F[13]
      for M = 1, _, 2 do
        for _ = 1, 32, 4 do
          M = _ - 1
          local S, B = b:Bs(N, M), _ + 1 - 1
          local M, D = b:Bs(N, B), _ + 2 - 1
          local B, h = b:Bs(N, D), _ + 3 - 1
          local W, U, s, c = b:Bs(N, h), F[S], F[M], F[B]
          _ = F[W]
          U = (U + s) % 4294967296
          D = b[28](_, U)
          _ = b[90](b[122](D, 16), (b[17](D, 16))) % 4294967296
          c = (c + _) % 4294967296
          D = b[28](s, c)
          s = b[90](b[122](D, 12), (b[17](D, 20))) % 4294967296
          U = b[123](U + s, 4294967295)
          D = b[28](_, U)
          _ = b[90](b[122](D, 8), (b[17](D, 24))) % 4294967296
          c = (c + _) % 4294967296
          D = b[28](s, c)
          s = b[90](b[122](D, 7), (b[17](D, 25))) % 4294967296
          F[S] = U
          F[M] = s
          F[B] = c
          F[W] = _
        end
      end
    end
  end
end

-- ============================================================================
-- FEATURE REGISTRY
-- ============================================================================
--
-- Name -> factory. Keys are the original outer-table keys from the Luraph
-- chunk; `slots` is the number of dependency values the factory expects.

local FeatureRegistry = {
  WeaponGcPatcher = { factory = WeaponGcPatcher, key = "5136", category = "combat", slots = 3 },
  WeaponStatsPatcher = { factory = WeaponStatsPatcher, key = "6212", category = "combat", slots = 5 },
  AimTargetController = { factory = AimTargetController, key = "211", category = "combat", slots = 14 },
  TargetSelector = { factory = TargetSelector, key = "72", category = "combat", slots = 13 },
  BackstabAim = { factory = BackstabAim, key = "93", category = "combat", slots = 16 },
  ShieldDetector = { factory = ShieldDetector, key = "38", category = "combat", slots = 5 },
  HitFeedback = { factory = HitFeedback, key = "94", category = "combat", slots = 12 },
  VoidSpamAutoShoot = { factory = VoidSpamAutoShoot, key = "13437", category = "combat", slots = 8 },
  Triggerbot = { factory = Triggerbot, key = "14", category = "combat", slots = 14 },
  AimTargetState = { factory = AimTargetState, key = "2582", category = "combat", slots = 8 },
  RageRevertRecorder = { factory = RageRevertRecorder, key = "14905", category = "combat", slots = 6 },
  NearestTargetSearch = { factory = NearestTargetSearch, key = "15", category = "combat", slots = 6 },
  BackstabValidator = { factory = BackstabValidator, key = "118", category = "combat", slots = 5 },
  NearestPlayerSearch = { factory = NearestPlayerSearch, key = "97", category = "combat", slots = 5 },
  RageResolver = { factory = RageResolver, key = "7", category = "combat", slots = 4 },
  VisibilityRay = { factory = VisibilityRay, key = "9", category = "combat", slots = 5 },
  ShieldCache = { factory = ShieldCache, key = "35", category = "combat", slots = 3 },
  AutoReload = { factory = AutoReload, key = "5058", category = "combat", slots = 4 },
  DuelCheck = { factory = DuelCheck, key = "112", category = "combat", slots = 2 },
  EquipItem = { factory = EquipItem, key = "25", category = "combat", slots = 1 },
  EspRenderer = { factory = EspRenderer, key = "81", category = "visuals", slots = 22 },
  CrosshairRenderer = { factory = CrosshairRenderer, key = "43", category = "visuals", slots = 12 },
  ChamsController = { factory = ChamsController, key = "58", category = "visuals", slots = 11 },
  EspOrchestrator = { factory = EspOrchestrator, key = "124", category = "visuals", slots = 12 },
  HitMarkerRenderer = { factory = HitMarkerRenderer, key = "37", category = "visuals", slots = 7 },
  DamageNumberHook = { factory = DamageNumberHook, key = "59", category = "visuals", slots = 4 },
  MovementAntiAimController = { factory = MovementAntiAimController, key = "10167", category = "movement", slots = 16 },
  FlyController = { factory = FlyController, key = "9656", category = "movement", slots = 5 },
  NoclipController = { factory = NoclipController, key = "4655", category = "movement", slots = 5 },
  MovementMetatablePatches = { factory = MovementMetatablePatches, key = "7733", category = "movement", slots = 2 },
  NamecallGuard = { factory = NamecallGuard, key = "9390", category = "exploit", slots = 11 },
  DesyncWallbangController = { factory = DesyncWallbangController, key = "4353", category = "exploit", slots = 16 },
  PlayerIdentitySpoof = { factory = PlayerIdentitySpoof, key = "127", category = "exploit", slots = 8 },
  GameTitleSpoofer = { factory = GameTitleSpoofer, key = "82", category = "exploit", slots = 9 },
  GcDuelScanner = { factory = GcDuelScanner, key = "21", category = "exploit", slots = 2 },
  GcFighterScanner = { factory = GcFighterScanner, key = "34", category = "exploit", slots = 2 },
  LoadoutViewerGui = { factory = LoadoutViewerGui, key = "24", category = "ui", slots = 9 },
  LoadoutTextFormatter = { factory = LoadoutTextFormatter, key = "76", category = "ui", slots = 18 },
  LoadoutModelPreview = { factory = LoadoutModelPreview, key = "10", category = "ui", slots = 3 },
  LoadoutScanner = { factory = LoadoutScanner, key = "84", category = "ui", slots = 3 },
  CameraViewmodelSync = { factory = CameraViewmodelSync, key = "77", category = "camera", slots = 3 },
  CameraCframeBroadcast = { factory = CameraCframeBroadcast, key = "64", category = "camera", slots = 4 },
  Mouse2Clicker = { factory = Mouse2Clicker, key = "36", category = "input", slots = 2 },
  FrameTickLoop = { factory = FrameTickLoop, key = "7082", category = "core", slots = 20 },
  RngStateMixer = { factory = RngStateMixer, key = "3476", category = "core", slots = 2 },
  FeatureStateReset = { factory = FeatureStateReset, key = "23", category = "core", slots = 6 },
  RngStateStepA = { factory = RngStateStepA, key = "7181", category = "core", slots = 2 },
  RngStateReset = { factory = RngStateReset, key = "8338", category = "core", slots = 5 },
  RngStateStepB = { factory = RngStateStepB, key = "5603", category = "core", slots = 3 },
  RngStateStepC = { factory = RngStateStepC, key = "11360", category = "core", slots = 3 },
  InvokeCallbackWithState = { factory = InvokeCallbackWithState, key = "11839", category = "core", slots = 2 },
  InvokeCallbackWithStateAlt = { factory = InvokeCallbackWithStateAlt, key = "15334", category = "core", slots = 2 },
  InvokeCallbackWithDepAndArg = { factory = InvokeCallbackWithDepAndArg, key = "12396", category = "core", slots = 2 },
  InvokeCallbackWithDepAndArgAlt = { factory = InvokeCallbackWithDepAndArgAlt, key = "10971", category = "core", slots = 2 },
  InvokeCallback = { factory = InvokeCallback, key = "51", category = "core", slots = 1 },
  LuraphVM = { factory = LuraphVM, key = "2056", category = "vm", slots = 0 },
  VmOpcodeDispatcher = { factory = VmOpcodeDispatcher, key = "7294", category = "vm", slots = 2 },
  Rc4StringDecryptor = { factory = Rc4StringDecryptor, key = "201", category = "vm", slots = 3 },
  ChaCha20Core = { factory = ChaCha20Core, key = "5061", category = "vm", slots = 1 },
}

return {
  Features = FeatureRegistry,
  Note = "Factories require the Phantom Hub dependency arrays; see REPORT.md",
}
wwwwwwwwwwwwwwwwwwww
