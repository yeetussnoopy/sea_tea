local Lib = {}

function Lib:init()
	Utils.hook(Soul, "init", function(orig, self, x, y, color)
		orig(self, x, y, color)
		self.speed = self.speed + Game.battle.soul_speed_bonus

		if Game.battle.soul_speed_bonus > 0 then
			self.af_effect = Game.battle.timer:every(0.15, function()
				Game.battle:addChild(AfterImage(self.sprite, 0.5))
			end)
		end
	end)

	Utils.hook(Battle, "onStateChange", function(orig, self, old, new)
		local result = self.encounter:beforeStateChange(old, new)

		if new == "DEFENDINGEND" and self.soul_speed_bonus > 0 then

			Game.battle.timer:cancel(Game.battle.soul.af_effect)

			self.soul_speed_bonus = 0
		end

		orig(self, old, new)
	end)

	Utils.hook(Battle, "init", function(orig, self)
		orig(self)
		self.soul_speed_bonus = 0
	end)
end

return Lib
