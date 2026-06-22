# Room.gd
# Presentation layer - Gestiona la UI i interacció d'una estança (Clean Architecture)
extends Node2D
class_name Room

# Auto-detect room_id from the scene filename
var room_id: String = ""

var _hotspot_nodes: Dictionary = {}  # hotspot_id -> Area2D
var _current_hovered: String = ""
var _room_data: Dictionary = {}
var _show_hints: bool = true

@onready var background: TextureRect = $Background
@onready var room_title: Label = $RoomTitle
@onready var hotspot_layer: Node2D = $HotspotLayer
@onready var description_label: Label = $Description


func _ready() -> void:
    # Auto-detect room_id from scene path: scenes/rooms/{id}.tscn
    if room_id.is_empty():
        var scene_path: String = ""
        if get_tree() != null and get_tree().current_scene != null:
            scene_path = get_tree().current_scene.scene_file_path
        else:
            scene_path = scene_file_path
        
        if not scene_path.is_empty():
            var filename: String = scene_path.get_file()
            var dot_idx: int = filename.rfind(".")
            if dot_idx > 0:
                room_id = filename.substr(0, dot_idx).to_lower()
    
    if room_id.is_empty():
        push_error("Room.gd: room_id no definit!")
        return
    
    NavigationManager.room_changed.connect(_on_navigation_changed)
    
    _load_room_data()
    _setup_background()
    _create_hotspots()
    _show_description()


func _load_room_data() -> void:
    _room_data = NavigationManager.get_room_data(room_id)


func _setup_background() -> void:
    if _room_data.is_empty():
        return
    
    var bg_path: String = _room_data.get("background", "")
    if not bg_path.is_empty():
        var texture: Texture2D = ResourceLoader.load(bg_path) as Texture2D
        if texture != null:
            background.texture = texture
            _expand_to_screen()
    
    room_title.text = _room_data.get("name", "Desconegut")


func _expand_to_screen() -> void:
    background.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
    background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.position = Vector2.ZERO


func _create_hotspots() -> void:
    var hotspots: Array = _room_data.get("hotspots", [])
    
    for hs_data in hotspots:
        var hs_dict: Dictionary = hs_data
        var hs_id: String = hs_dict.get("id", "")
        if not hs_id.is_empty():
            var hotspot: Area2D = _create_single_hotspot(hs_dict)
            _hotspot_nodes[hs_id] = hotspot


func _create_single_hotspot(hs_data: Dictionary) -> Area2D:
    var viewport: Viewport = get_viewport()
    var viewport_size: Vector2 = Vector2(1280, 720)
    if viewport != null:
        viewport_size = viewport.get_visible_rect().size
    
    var area: Area2D = Area2D.new()
    area.name = "Hotspot_" + hs_data.get("id", "")
    
    var shape_node: CollisionShape2D = CollisionShape2D.new()
    var rect_shape: RectangleShape2D = RectangleShape2D.new()
    
    var hs_pos: Vector2 = Vector2(
        hs_data.get("x", 0.0) * viewport_size.x,
        hs_data.get("y", 0.0) * viewport_size.y
    )
    var hs_size: Vector2 = Vector2(
        hs_data.get("width", 0.1) * viewport_size.x,
        hs_data.get("height", 0.1) * viewport_size.y
    )
    
    rect_shape.size = hs_size
    shape_node.shape = rect_shape
    area.add_child(shape_node)
    
    area.position = hs_pos + hs_size * 0.5
    
    var highlight: ColorRect = ColorRect.new()
    highlight.name = "Highlight"
    highlight.size = hs_size
    highlight.position = -hs_size * 0.5
    highlight.color = Color(1, 1, 1, 0.0)
    highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
    area.add_child(highlight)
    
    var tooltip: Label = Label.new()
    tooltip.name = "Tooltip"
    tooltip.text = hs_data.get("label", "")
    tooltip.theme_override_colors = {
        &"font_color": Color(1, 1, 0.8),
        &"font_outline_color": Color(0, 0, 0, 0.7)
    }
    tooltip.theme_override_constants = {
        &"outline_size": 3
    }
    tooltip.theme_override_font_sizes = {
        &"font_size": 16
    }
    tooltip.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    tooltip.position = Vector2(-hs_size.x * 0.5, -hs_size.y * 0.5 - 28)
    tooltip.size = Vector2(hs_size.x, 24)
    tooltip.mouse_filter = Control.MOUSE_FILTER_IGNORE
    tooltip.visible = false
    tooltip.modulate = Color(1, 1, 1, 0)
    area.add_child(tooltip)
    
    area.mouse_entered.connect(_on_hotspot_hover_started.bind(hs_data))
    area.mouse_exited.connect(_on_hotspot_hover_ended.bind(hs_data))
    area.input_event.connect(_on_hotspot_input.bind(hs_data))
    
    hotspot_layer.add_child(area)
    return area


func _on_hotspot_hover_started(hs_data: Dictionary) -> void:
    _current_hovered = hs_data.get("id", "")
    var node: Node = _hotspot_nodes.get(hs_data.get("id", ""))
    if node == null:
        return
    
    var highlight: ColorRect = node.get_node_or_null("Highlight") as ColorRect
    if highlight != null:
        var tween: Tween = create_tween()
        tween.tween_property(highlight, "color:a", 0.15, 0.2)
    
    var tooltip: Label = node.get_node_or_null("Tooltip") as Label
    if tooltip != null and _show_hints:
        tooltip.visible = true
        var tween: Tween = create_tween()
        tween.tween_property(tooltip, "modulate:a", 1.0, 0.15)
    
    Input.set_custom_mouse_cursor(null, Input.CURSOR_POINTING_HAND)
    
    var hint: String = hs_data.get("hint", "")
    description_label.text = hint


func _on_hotspot_hover_ended(hs_data: Dictionary) -> void:
    _current_hovered = ""
    var node: Node = _hotspot_nodes.get(hs_data.get("id", ""))
    if node == null:
        return
    
    var highlight: ColorRect = node.get_node_or_null("Highlight") as ColorRect
    if highlight != null:
        var tween: Tween = create_tween()
        tween.tween_property(highlight, "color:a", 0.0, 0.2)
    
    var tooltip: Label = node.get_node_or_null("Tooltip") as Label
    if tooltip != null:
        var tween: Tween = create_tween()
        tween.tween_property(tooltip, "modulate:a", 0.0, 0.15)
        tween.tween_callback(func(): tooltip.visible = false)
    
    Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)
    description_label.text = ""


func _on_hotspot_input(event: InputEvent, hs_data: Dictionary) -> void:
    var is_click: bool = false
    
    if event is InputEventMouseButton:
        var mouse_event: InputEventMouseButton = event as InputEventMouseButton
        is_click = mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed
    elif event is InputEventScreenTouch:
        var touch_event: InputEventScreenTouch = event as InputEventScreenTouch
        is_click = touch_event.pressed
    
    if not is_click:
        return
    
    var target: String = hs_data.get("target_room", "")
    if target.is_empty():
        return
    
    var node: Node = _hotspot_nodes.get(hs_data.get("id", ""))
    if node != null:
        var highlight: ColorRect = node.get_node_or_null("Highlight") as ColorRect
        if highlight != null:
            var flash: Tween = create_tween()
            flash.tween_property(highlight, "color:a", 0.4, 0.1)
            flash.tween_property(highlight, "color:a", 0.0, 0.2)
            await flash.finished
    
    NavigationManager.navigate_to(target)


func _show_description() -> void:
    if _room_data.is_empty():
        return
    var desc: String = _room_data.get("description", "")
    if desc.is_empty():
        return
    description_label.text = desc


func _on_navigation_changed(_new_room_id: String) -> void:
    pass


func _exit_tree() -> void:
    Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW)