@tool
extends EditorPlugin

func _enter_tree():
    # DOCK_SLOT_LEFT_UR = 左侧dock槽位
    var inspector_dock = get_editor_interface().get_inspector_dock()
    add_control_to_dock(DOCK_SLOT_LEFT_UR, inspector_dock)

func _exit_tree():
    remove_control_from_docks(get_editor_interface().get_inspector_dock())
