extends Node

var Difficulty: float = 0.07
var Gaps: int = 2

func GetRandomSeed() -> int:
	randomize()
	return int(rand_range(0, 99999))

func TimeSinceLast(last: int) -> int:
	return OS.get_unix_time() - last
	
func LevelForXp(xp) -> int:
	return int(floor(Difficulty * sqrt(xp)))

func XpForLevel(lvl) -> int:
	return int(floor(pow((lvl / Difficulty), Gaps)))
	
func ToNextLevel() -> int:
	return XpForLevel(LevelForXp(Persist.CurrentEXP) + 1) - XpForLevel(LevelForXp(Persist.CurrentEXP))
