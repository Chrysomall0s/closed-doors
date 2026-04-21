extends Area3D

@export var linked_door: NodePath

@onready var portal_surface: MeshInstance3D = $MeshInstance3D
@onready var viewport: SubViewport = $SubViewport
@onready var portal_camera: Camera3D = $SubViewport/Camera3D

var linked_door_node: Node3D
var player_cam: Camera3D

func _ready():
	linked_door_node = get_node(linked_door)
	player_cam = get_viewport().get_camera_3d()

	_bind_viewport_texture()


func _bind_viewport_texture():
	var mat := portal_surface.get_active_material(0)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("portal_texture", viewport.get_texture())


func _process(_delta):
	if not linked_door_node or not player_cam:
		return

	_update_viewport_size()
	_update_portal_camera()


func _update_viewport_size():
	viewport.size = get_viewport().size


func _update_portal_camera():
	# Transform player camera into portal space
	var entry_transform = global_transform
	var exit_transform = linked_door_node.global_transform

	var relative_transform = entry_transform.affine_inverse() * player_cam.global_transform
	portal_camera.global_transform = exit_transform * relative_transform

	portal_camera.fov = player_cam.fov
