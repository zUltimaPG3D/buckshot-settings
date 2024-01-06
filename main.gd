extends MenuManager.Global.ModNode

var mods_have_settings:Array[String]
var mod_settings_page:Dictionary

func register_for_settings(id:String):
    mods_have_settings.append(id)

func register_settings_screen(id:String, screen:Control):
    mod_settings_page[id] = screen

func BasicSettingsScreen() -> Control:
    var ctrl:Panel = Panel.new()
    ctrl.set_anchors_preset(Control.PRESET_FULL_RECT)
    ctrl.visible = false
    get_tree().root.add_child(ctrl)

    var exit_btn:Button = Button.new()
    ctrl.add_child(exit_btn)
    exit_btn.name = "CloseButton"
    exit_btn.text = "Close"
    exit_btn.pressed.connect(CloseSettings)
    exit_btn.size.x = ctrl.size.x - 40
    exit_btn.position.x = 20
    exit_btn.position.y = ctrl.size.y - 20 - exit_btn.size.y

    return ctrl

func OpenSettings(mod_id:String):
    CloseSettings()
    mod_settings_page[mod_id].visible = true

func CloseSettings():
    for m_id in mod_settings_page: mod_settings_page[m_id].visible = false

func _process(_delta):
    if is_instance_valid(MenuManager.Global.instance.menu_ui):
        for m in mods_have_settings:
            var holder:VBoxContainer = MenuManager.Global.instance.mods_vbox.get_node(get_mod(m).name)
            if holder.has_node("Settings"):
                continue
            var settings_button:Button = Button.new()
            settings_button.name = "Settings"
            settings_button.text = "Mod Settings"
            settings_button.pressed.connect(OpenSettings.bind(m))
            holder.add_child(settings_button)
            holder.get_node("Separator").move_to_front()
