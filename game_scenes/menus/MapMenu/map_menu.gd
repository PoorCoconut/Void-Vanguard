extends Control

@onready var follow_path: PathFollow2D = $path/follow_path

@onready var lbl_hw: RichTextLabel = $lbl_hw
@onready var lbl_af: RichTextLabel = $lbl_af
@onready var lbl_nb: RichTextLabel = $lbl_nb
@onready var lbl_es: RichTextLabel = $lbl_es
@onready var lbl_ds: RichTextLabel = $lbl_ds
@onready var lbl_cd: RichTextLabel = $lbl_cd
@onready var lbl_ap: RichTextLabel = $lbl_ap
@onready var lbl_ms: RichTextLabel = $lbl_ms

var hw_tween : Tween
var af_tween : Tween
var nb_tween : Tween
var es_tween : Tween
var ds_tween : Tween
var cd_tween : Tween
var ap_tween : Tween
var ms_tween : Tween
var label_dur : float = 0.25

@export var SPEED : float = 0.05

var hw_prog : float = 0.0
var af_prog : float = 0.18
var nb_prog : float = 0.29
var es_prog : float = 0.407
var ds_prog : float = 0.6409
var cd_prog : float = 0.869
var ms_prog : float = 1.0

var prog_arr : Array = [hw_prog, af_prog, nb_prog, es_prog, ds_prog, cd_prog, ms_prog]
var lvl_labels : Array = []

var can_prog : bool = false
var prog_to : float = 0.0

var locked_label : RichTextLabel = null 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lvl_labels = [lbl_hw, lbl_af, lbl_nb, lbl_es, lbl_ds, lbl_cd, lbl_ms]
	reset_label_ratio()
	update_prog(0)
	load_saved_progress(0)
	sync_locked_label_from_progress()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_prog:
		if follow_path.progress_ratio == prog_to:
			can_prog = false
		follow_path.progress_ratio = clampf(follow_path.progress_ratio + delta * SPEED, 0, prog_to)

func reset_label_ratio():
	lbl_hw.visible_ratio = 0.0
	lbl_af.visible_ratio = 0.0
	lbl_nb.visible_ratio = 0.0
	lbl_es.visible_ratio = 0.0
	lbl_ds.visible_ratio = 0.0
	lbl_cd.visible_ratio = 0.0
	lbl_ap.visible_ratio = 0.0
	lbl_ms.visible_ratio = 0.0

func update_prog(index : int):
	follow_path.progress_ratio = prog_arr[index - 1]
	prog_to = prog_arr[index]
	can_prog = true

func load_saved_progress(index: int) -> void:
	follow_path.progress_ratio = prog_arr[index]
	prog_to = prog_arr[index]
	can_prog = false
	sync_locked_label_from_progress()

# Scans prog_arr for a match against the path's current progress_ratio and
# locks that label instantly (no tween) if found. Used at boot/load time,
# where the label should already be visible with no animation.
func sync_locked_label_from_progress() -> void:
	for i in range(prog_arr.size()):
		if is_equal_approx(follow_path.progress_ratio, prog_arr[i]):
			lock_label(lvl_labels[i], true)
			return

func lock_label(lbl: RichTextLabel, instant: bool = false) -> void:
	if lbl == locked_label:
		return
	var prev := locked_label
	locked_label = lbl
	if prev != null:
		if instant:
			prev.visible_ratio = 0.0
		else:
			_tween_label(prev, 0.0)
	if instant:
		locked_label.visible_ratio = 1.0
	else:
		_tween_label(locked_label, 1.0)

func _tween_label(lbl: RichTextLabel, target: float) -> void:
	var t := get_tree().create_tween()
	t.tween_property(lbl, "visible_ratio", target, label_dur)


func _on_lvl_hw_mouse_entered() -> void:
	if lbl_hw == locked_label:
		return
	hw_tween = get_tree().create_tween()
	hw_tween.tween_property(lbl_hw, "visible_ratio", 1.0, label_dur)

func _on_lvl_hw_mouse_exited() -> void:
	if lbl_hw == locked_label:
		return
	hw_tween = get_tree().create_tween()
	hw_tween.tween_property(lbl_hw, "visible_ratio", 0.0, label_dur)


func _on_lvl_af_mouse_entered() -> void:
	if lbl_af == locked_label:
		return
	af_tween = get_tree().create_tween()
	af_tween.tween_property(lbl_af, "visible_ratio", 1.0, label_dur)

func _on_lvl_af_mouse_exited() -> void:
	if lbl_af == locked_label:
		return
	af_tween = get_tree().create_tween()
	af_tween.tween_property(lbl_af, "visible_ratio", 0.0, label_dur)


func _on_lvl_nb_mouse_entered() -> void:
	if lbl_nb == locked_label:
		return
	nb_tween = get_tree().create_tween()
	nb_tween.tween_property(lbl_nb, "visible_ratio", 1.0, label_dur)

func _on_lvl_nb_mouse_exited() -> void:
	if lbl_nb == locked_label:
		return
	nb_tween = get_tree().create_tween()
	nb_tween.tween_property(lbl_nb, "visible_ratio", 0.0, label_dur)


func _on_lvl_es_mouse_entered() -> void:
	if lbl_es == locked_label:
		return
	es_tween = get_tree().create_tween()
	es_tween.tween_property(lbl_es, "visible_ratio", 1.0, label_dur)

func _on_lvl_es_mouse_exited() -> void:
	if lbl_es == locked_label:
		return
	es_tween = get_tree().create_tween()
	es_tween.tween_property(lbl_es, "visible_ratio", 0.0, label_dur)


func _on_lvl_ds_mouse_entered() -> void:
	if lbl_ds == locked_label:
		return
	ds_tween = get_tree().create_tween()
	ds_tween.tween_property(lbl_ds, "visible_ratio", 1.0, label_dur)

func _on_lvl_ds_mouse_exited() -> void:
	if lbl_ds == locked_label:
		return
	ds_tween = get_tree().create_tween()
	ds_tween.tween_property(lbl_ds, "visible_ratio", 0.0, label_dur)


func _on_lvl_cd_mouse_entered() -> void:
	if lbl_cd == locked_label:
		return
	cd_tween = get_tree().create_tween()
	cd_tween.tween_property(lbl_cd, "visible_ratio", 1.0, label_dur)

func _on_lvl_cd_mouse_exited() -> void:
	if lbl_cd == locked_label:
		return
	cd_tween = get_tree().create_tween()
	cd_tween.tween_property(lbl_cd, "visible_ratio", 0.0, label_dur)


func _on_lvl_ap_mouse_entered() -> void:
	if lbl_ap == locked_label:
		return
	ap_tween = get_tree().create_tween()
	ap_tween.tween_property(lbl_ap, "visible_ratio", 1.0, label_dur)

func _on_lvl_ap_mouse_exited() -> void:
	if lbl_ap == locked_label:
		return
	ap_tween = get_tree().create_tween()
	ap_tween.tween_property(lbl_ap, "visible_ratio", 0.0, label_dur)


func _on_lvl_ms_mouse_entered() -> void:
	if lbl_ms == locked_label:
		return
	ms_tween = get_tree().create_tween()
	ms_tween.tween_property(lbl_ms, "visible_ratio", 1.0, label_dur)

func _on_lvl_ms_mouse_exited() -> void:
	if lbl_ms == locked_label:
		return
	ms_tween = get_tree().create_tween()
	ms_tween.tween_property(lbl_ms, "visible_ratio", 0.0, label_dur)


func _on_lvl_hw_pressed() -> void:
	update_prog(0)
	lock_label(lbl_hw)

func _on_lvl_af_pressed() -> void:
	update_prog(1)
	lock_label(lbl_af)

func _on_lvl_nb_pressed() -> void:
	update_prog(2)
	lock_label(lbl_nb)

func _on_lvl_es_pressed() -> void:
	update_prog(3)
	lock_label(lbl_es)

func _on_lvl_ds_pressed() -> void:
	update_prog(4)
	lock_label(lbl_ds)

func _on_lvl_cd_pressed() -> void:
	update_prog(5)
	lock_label(lbl_cd)

func _on_lvl_ap_pressed() -> void:
	lock_label(lbl_ap)

func _on_lvl_ms_pressed() -> void:
	update_prog(6)
	lock_label(lbl_ms)
