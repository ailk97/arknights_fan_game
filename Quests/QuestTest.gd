extends Panel

var Panelname = "QuestTest"
var QuestName = "Тестовое задание"
var QuestDesc = "- Убить 5 противников"
var questType = 1
var questEnemyType = "Enemy"
var questCountStart = 0
var questCount = 5

func _ready():
	$QuestName.text = QuestName
	$QuestDesc.text = QuestDesc
	QuestReady()

func QuestProgress():
	questCountStart += 1
	QuestReady()

func QuestReady():
	$Quest.text = str(questCountStart) + "/" + str(questCount)
	if questCountStart == questCount:
		get_tree().get_first_node_in_group("player").experience += 80
		get_tree().get_first_node_in_group("player").money += 100
		Events.quest_test_accepted = false
		queue_free()
