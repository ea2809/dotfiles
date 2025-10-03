from inspect import isfunction
from collections import OrderedDict
from functools import partial, wraps
from typing import Any, Dict, List, Optional, Callable, Tuple, Union
import json
import copy
import os
import socket


def basic_rule(description: str = "Rule", type: str = "basic", functions: Optional[List[Any]] = None) -> Dict[str, Any]:
    if functions is None:
        functions = []
    basic_manipulators: Dict[str, str] = {"type": type}

    basic: Dict[str, Any] = {
        "description": description,
        "manipulators": []
    }

    def add_functions(inner_functions: List[Any], basic_json: Dict[str, Any]) -> None:
        basic_json["manipulators"].append(copy.deepcopy(basic_manipulators))
        for function in inner_functions:
            if callable(function):
                function(basic_json["manipulators"][-1])

    def analize_functions(functions: List[Any]) -> Tuple[List[Any], List[Any]]:
        globals: List[Any] = []
        funcs: List[Any] = []
        for function in functions:
            if isfunction(function) or isinstance(function, Karabiner):
                globals.append(function)
            else:
                funcs.append(function)
        return globals, funcs

    globals, ana_funcs = analize_functions(functions)
    # One manipulator
    if not ana_funcs:
        add_functions(globals, basic)
    # Multiple manipulators
    else:
        for function in ana_funcs:
            add_functions(function+globals, basic)

    return basic


class Karabiner(object):
    def __init__(self, options: Dict[str, Any]) -> None:
        self.options: Dict[str, Any] = copy.deepcopy(options)

    def run(self, base_json: Dict[str, Any]) -> Dict[str, Any]:
        return base_json

    def __call__(self, base_json: Dict[str, Any]) -> Dict[str, Any]:
        return self.run(base_json)

    def __repr__(self) -> str:
        return self.__unicode__()

    def __str__(self) -> str:
        return self.__unicode__()

    def __unicode__(self) -> str:
        return "Karabiner {}".format(self.options)


def basic_from(keycode: str = "", mandatory: Optional[List[str]] = None, optional: Optional[List[str]] = None) -> Karabiner:
    if optional is None:
        optional = ["any"]

    class KarabinerFrom(Karabiner):
        def run(self, base_json: Dict[str, Any]) -> Dict[str, Any]:
            fron: Dict[str, Any] = {
                "key_code": self.options.get("keycode"),
            }

            if mandatory:
                modifiers: Dict[str, Any] = fron.setdefault("modifiers", {})
                modifiers.update({"mandatory": mandatory})

            if optional:
                modifiers = fron.setdefault("modifiers", {})
                modifiers.update({"optional": optional})

            base_json["from"] = fron
            return fron
    return KarabinerFrom({"keycode": keycode})


def basic_to(keycode: str = "", modifiers: Optional[List[str]] = None, event: str = "to", lazy: Optional[bool] = None, other_params: Optional[Dict[str, Any]] = None) -> Karabiner:
    if other_params is None:
        other_params = {}

    class KarabinerTo(Karabiner):
        def run(self, base_json: Dict[str, Any]) -> None:
            to: Dict[str, Any] = {
                "key_code": self.options.get("keycode"),
                **self.options.get("other_params", {})
            }

            if lazy is not None:
                to["lazy"] = self.options.get("lazy")

            if self.options.get("modifiers"):
                to["modifiers"] = self.options.get("modifiers")

            base_json[self.options.get("event")] = to
    return KarabinerTo(
        {"keycode": keycode, "modifiers": modifiers, "event": event, "lazy": lazy, "other_params": other_params})


basic_if_alone = wraps(basic_to)(partial(basic_to, event="to_if_alone"))
basic_if_held_down = wraps(basic_to)(partial(basic_to, event="to_if_held_down"))


def set_variable(name: str, value: int, event: str = "to") -> Karabiner:
    class KarabinerVar(Karabiner):
        def run(self, base_json: Dict[str, Any]) -> None:
            to: Dict[str, Any] = {
                "set_variable": {
                    "name":  self.options.get("name"),
                    "value": self.options.get("value")
                }
            }

            base_json[self.options.get("event")] = to
    return KarabinerVar({"name": name, "value": value, "event": event})


def conditions(name: str, value: int) -> Karabiner:
    class KarabinerCon(Karabiner):
        def run(self, base_json: Dict[str, Any]) -> None:
            conditions: List[Dict[str, Any]] = [
                {
                    "type": "variable_if",
                    "name":  self.options.get("name"),
                    "value": self.options.get("value")
                }
            ]

            conditions_arr: List[Dict[str, Any]] = base_json.setdefault("conditions", [])
            conditions_arr += conditions
    return KarabinerCon({"name": name, "value": value})


def parameters(**kwargs: Any) -> Karabiner:
    class KarabinerParam(Karabiner):
        def run(self, base_json: Dict[str, Any]) -> None:
            conditions_arr: Dict[str, Any] = base_json.setdefault("parameters", {})
            conditions_arr.update(self.options.get("parameters", {}))
    return KarabinerParam({"parameters": kwargs})


def device_unless(identifiers: List[Dict[str, Any]]) -> Karabiner:
    class KarabinerDU(Karabiner):
        def run(self, base_json: Dict[str, Any]) -> None:
            conditions: List[Dict[str, Any]] = [
                {
                    "type": "device_unless",
                    "identifiers": self.options.get("identifiers")
                }
            ]

            conditions_arr: List[Dict[str, Any]] = base_json.setdefault("conditions", [])
            conditions_arr += conditions
    return KarabinerDU({"identifiers": identifiers})


def shell_to(script: str = "", event: str = "to") -> Karabiner:
    class KarabinerShell(Karabiner):
        def run(self, base_json: Dict[str, Any]) -> None:
            to: Dict[str, Any] = {
                "shell_command": self.options.get("script"),
            }

            base_json[self.options.get("event")] = to
    return KarabinerShell({"script": script, "event": event})


def program_to(program: str) -> Karabiner:
    script = "open -a '{}'".format(program)
    return shell_to(script=script)


SFN_VAR = "spacefn_mode"
SFN_ON = 1
SFN_OFF = 0


def base_spaceFN() -> Dict[str, Any]:
    methods: List[Karabiner] = [
        basic_from("spacebar"),
        # set_variable(name=SFN_VAR, value=SFN_ON, event="to"),
        set_variable(name=SFN_VAR, value=SFN_ON, event="to_if_held_down"),
        basic_to("spacebar", event="to_if_alone"),
        set_variable(name=SFN_VAR, value=SFN_OFF, event="to_after_key_up"),
    ]
    return basic_rule(description="SpaceFn basic config", functions=methods)


def basic_spaceFN(description: str, functions: Optional[List[Any]] = None) -> Dict[str, Any]:
    if functions is None:
        functions = []
    methods: List[Any] = [conditions(name=SFN_VAR, value=SFN_ON)] + functions
    description = "SpaceFN: " + description
    return basic_rule(description=description, functions=methods)


def hyper_keycode(keycode: str = "", event: str = "to") -> Karabiner:
    modifiers: List[str] = [
        "right_command", "right_control", "right_option", "right_shift"
    ]
    return basic_to(keycode=keycode, modifiers=modifiers, event=event)


def fhyper_keycode(keycode: str = "", event: str = "from") -> Karabiner:
    modifiers: List[str] = [
        "left_command", "left_control", "left_option", "left_shift"
    ]
    return basic_from(keycode=keycode, mandatory=modifiers)


def meh_keycode(keycode: str = "", event: str = "to") -> Karabiner:
    modifiers: List[str] = [
        "right_command", "right_control", "right_option"
    ]
    return basic_to(keycode=keycode, modifiers=modifiers, event=event)


functions: Dict[str, Callable[..., Any]] = {
    "from": basic_from,
    "to": basic_to,
    "if_alone": basic_if_alone,
    "if_held_down": basic_if_held_down,
    "shell": program_to,
    "hyper": hyper_keycode,
    "fhyper": fhyper_keycode,
    "meh": meh_keycode,
    "device_unless": device_unless,
    "parameters": parameters,
}

def add_functions(in_definitions: List[Dict[str, Any]], rule_type: Callable[..., Dict[str, Any]] = basic_rule) -> List[Dict[str, Any]]:
    rules: List[Dict[str, Any]] = []
    for definition in in_definitions:
        global_name: str = ""
        funcs: List[Any] = []

        def add_funcs_to(name: str, options: Dict[str, Any], funcs: List[Any]) -> None:
            function = functions.get(name)
            if callable(function):
                funcs.append(function(**options))

        for name, options in definition.items():
            if name == "name":
                global_name = options
            elif name == "complex":
                for option in options:
                    sub_funcs: List[Any] = []
                    for sub_name, sub_options in option.items():
                        add_funcs_to(sub_name, sub_options, sub_funcs)
                    funcs.append(sub_funcs)
            else:
                add_funcs_to(name, options, funcs)
        rules.append(rule_type(description=global_name, functions=funcs))
    return rules


def add_functions_hyper(in_definitions: List[Dict[str, Any]], rule_type: Callable[..., Dict[str, Any]] = basic_rule) -> List[Dict[str, Any]]:
    rules: List[Dict[str, Any]] = []
    for definition in in_definitions:
        global_name: str = ""
        funcs: List[Any] = []
        ignore: bool = False

        def add_funcs_to(name: str, options: Dict[str, Any], funcs: List[Any]) -> None:
            function = functions.get(name)
            if callable(function):
                funcs.append(function(**options))

        for name, options in definition.items():
            if name == "name":
                global_name = options
            elif name == "complex" or name == "hyper":
                ignore = True
            elif name == "from":
                add_funcs_to("fhyper", options, funcs)
            else:
                add_funcs_to(name, options, funcs)
        if not ignore:
            rules.append(rule_type(description="Hyper "+global_name, functions=funcs))
    return rules


def main(spacefn_definitions: List[Dict[str, Any]], normal_definitions: List[Dict[str, Any]]) -> OrderedDict[str, Any]:
    rules: List[Dict[str, Any]] = [
        base_spaceFN(),
    ]
    rules += add_functions(spacefn_definitions, rule_type=basic_spaceFN)
    rules += add_functions_hyper(spacefn_definitions, rule_type=basic_rule)
    rules += add_functions(normal_definitions, rule_type=basic_rule)

    base: OrderedDict[str, Any] = OrderedDict({"title": "Enrique's rules", "rules": rules})
    return base


# ============================================================================
# CONFIGURATION LOADING
# ============================================================================

def get_hostname() -> str:
    """Get the current machine's hostname."""
    return socket.gethostname().split('.')[0]  # Strip domain if present


def get_script_dir() -> str:
    """Get the directory where this script is located."""
    return os.path.dirname(os.path.abspath(__file__))


def load_json_file(filepath: str) -> Optional[Dict[str, Any]]:
    """Load a JSON configuration file."""
    if not os.path.exists(filepath):
        return None

    with open(filepath, 'r') as f:
        return json.load(f)


def resolve_variables(config: Union[Dict[str, Any], List[Any], Any], variables: Dict[str, Any]) -> Union[Dict[str, Any], List[Any], Any]:
    """
    Recursively resolve variable references in config.
    Variables are referenced as "$variable_name" in the JSON.
    """
    if isinstance(config, dict):
        result: Dict[str, Any] = {}
        for key, value in config.items():
            if isinstance(value, str) and value.startswith('$'):
                var_name = value[1:]  # Remove the $
                result[key] = variables.get(var_name, value)
            else:
                result[key] = resolve_variables(value, variables)
        return result
    elif isinstance(config, list):
        return [resolve_variables(item, variables) for item in config]
    else:
        return config


def merge_configs(default: Optional[Dict[str, Any]], override: Optional[Dict[str, Any]]) -> Optional[Dict[str, Any]]:
    """
    Deep merge two configuration dictionaries.
    Lists in override replace lists in default (not merged).
    """
    if default is None:
        return copy.deepcopy(override) if override else None
    if override is None:
        return copy.deepcopy(default)

    result: Dict[str, Any] = copy.deepcopy(default)
    for key, value in override.items():
        if key.startswith('_'):  # Skip comment fields
            continue
        if key in result and isinstance(result[key], dict) and isinstance(value, dict):
            merged = merge_configs(result[key], value)
            if merged is not None:
                result[key] = merged
        else:
            result[key] = copy.deepcopy(value)
    return result


def load_config(config_dir: Optional[str] = None) -> Dict[str, Any]:
    """
    Load configuration from JSON files based on hostname.

    Looks for:
    - config.default.json (required)
    - config.<hostname>.json (optional, hostname-specific overrides)

    Args:
        config_dir: Directory containing config files. Defaults to script directory.

    Returns:
        dict: Merged configuration
    """
    if config_dir is None:
        config_dir = get_script_dir()

    hostname = get_hostname()

    # Load default config
    default_path = os.path.join(config_dir, 'config.default.json')
    default_config = load_json_file(default_path)

    if default_config is None:
        raise FileNotFoundError(f"Default configuration not found: {default_path}")

    # Extract and resolve variables (things like non_ansii_keyboards)
    variables = {}
    for key, value in default_config.items():
        if not key.endswith('_definitions') and key != 'profile_name':
            variables[key] = value

    # Try to find host-specific config
    # Try exact match first, then look for any file containing the hostname
    host_config = None
    host_config_path = os.path.join(config_dir, f'config.{hostname}.json')

    if os.path.exists(host_config_path):
        print(f"Loading host-specific config: config.{hostname}.json")
        host_config = load_json_file(host_config_path)
    else:
        # Look for partial hostname matches
        for filename in os.listdir(config_dir):
            if filename.startswith('config.') and filename.endswith('.json'):
                # Extract hostname from filename
                file_hostname = filename[7:-5]  # Remove 'config.' and '.json'
                if file_hostname == 'default' or file_hostname.startswith('example'):
                    continue

                # Check for partial match
                if (hostname.lower().startswith(file_hostname.lower()) or
                    file_hostname.lower() in hostname.lower()):
                    print(f"Loading host-specific config: {filename} (hostname: {hostname})")
                    host_config_path = os.path.join(config_dir, filename)
                    host_config = load_json_file(host_config_path)
                    break

    # Merge configs
    if host_config:
        config = merge_configs(default_config, host_config)
    else:
        print(f"Using default configuration (hostname: {hostname})")
        config = default_config

    # Resolve variable references
    config = resolve_variables(config, variables)

    return config


# ============================================================================
# KARABINER APPLICATION
# ============================================================================

# ============================================================================
# HTML EXPORT
# ============================================================================

# Key layout mapping (keycode -> CSS class)
KEY_LAYOUT: Dict[str, str] = {
    # Row 1 (function keys)
    'escape': 'esc', 'f1': 'f1', 'f2': 'f2', 'f3': 'f3', 'f4': 'f4',
    'f5': 'f5', 'f6': 'f6', 'f7': 'f7', 'f8': 'f8', 'f9': 'f9',
    'f10': 'f10', 'f11': 'f11', 'f12': 'f12',

    # Row 2 (numbers)
    'grave_accent_and_tilde': 'a_1',
    '1': 'a_2', '2': 'a_3', '3': 'a_4', '4': 'a_5', '5': 'a_6',
    '6': 'a_7', '7': 'a_8', '8': 'a_9', '9': 'a_10', '0': 'a_11',
    'hyphen': 'a_12', 'equal_sign': 'a_13', 'delete_or_backspace': 'a_14',

    # Row 3 (QWERTY)
    'tab': 'tap',
    'q': 'q', 'w': 'w', 'e': 'e', 'r': 'r', 't': 't',
    'y': 'y', 'u': 'u', 'i': 'i', 'o': 'o', 'p': 'p',
    'open_bracket': 'p1', 'close_bracket': 'p2', 'backslash': 'p3',

    # Row 4 (ASDF)
    'caps_lock': 'caps',
    'a': 'a', 's': 's', 'd': 'd', 'f': 'f', 'g': 'g',
    'h': 'h', 'j': 'j', 'k': 'k', 'l': 'l',
    'semicolon': 'b_1', 'quote': 'b_2', 'return_or_enter': 'b_3',

    # Row 5 (ZXCV)
    'left_shift': 'shift',
    'z': 'z', 'x': 'x', 'c': 'c', 'v': 'v', 'b': 'b',
    'n': 'n', 'm': 'm', 'comma': 'm_1', 'period': 'm_2', 'slash': 'm_3',
    'right_shift': 'm_4',

    # Row 6 (modifiers)
    'left_control': 'ctrl', 'left_option': 'windows', 'left_command': 'alt',
    'spacebar': 'space',
    'right_command': 'alt_1', 'right_option': 'windows_1', 'fn': 'right_on',
    'right_control': 'ctrl_1',
}

# Friendly names for keycodes
KEYCODE_NAMES: Dict[str, str] = {
    'delete_or_backspace': 'Backspace',
    'return_or_enter': 'Enter',
    'caps_lock': 'Caps Lock',
    'left_shift': 'Shift', 'right_shift': 'Shift',
    'left_control': 'Ctrl', 'right_control': 'Ctrl',
    'left_option': 'Opt', 'right_option': 'Opt',
    'left_command': 'Cmd', 'right_command': 'Cmd',
    'spacebar': 'Space',
    'grave_accent_and_tilde': '`',
    'hyphen': '-', 'equal_sign': '=',
    'open_bracket': '[', 'close_bracket': ']',
    'backslash': '\\', 'semicolon': ';', 'quote': "'",
    'comma': ',', 'period': '.', 'slash': '/',
    'left_arrow': '←', 'right_arrow': '→',
    'up_arrow': '↑', 'down_arrow': '↓',
    'page_up': 'PgUp', 'page_down': 'PgDn',
    'home': 'Home', 'end': 'End',
}


def parse_rule_actions(definition: Dict[str, Any]) -> Tuple[str, str, str]:
    """
    Parse a rule definition and extract the action description.
    Returns a tuple of (from_key, action_description, layer)
    """
    from_key: str = definition.get('from', {}).get('keycode', '')
    name: str = definition.get('name', '')

    # Determine action from various fields
    action: str = ""
    layer: str = 'normal'

    if 'shell' in definition:
        action = definition['shell'].get('program', '')
        layer = 'spacefn'
    elif 'to' in definition:
        to_key = definition['to'].get('keycode', '')
        modifiers = definition['to'].get('modifiers', [])
        if modifiers:
            mod_str = '+'.join(modifiers[:2]) if len(modifiers) > 1 else modifiers[0]
            action = f"{mod_str}+{KEYCODE_NAMES.get(to_key, to_key.upper())}"
        else:
            action = KEYCODE_NAMES.get(to_key, to_key.upper())
        layer = 'spacefn'
    elif 'hyper' in definition:
        action = 'Hyper+' + definition['hyper'].get('keycode', '').upper()
        layer = 'hyper'
    elif 'meh' in definition:
        action = 'Meh+' + definition['meh'].get('keycode', '').upper()
        layer = 'meh'
    elif 'if_alone' in definition:
        alone = definition['if_alone'].get('keycode', '')
        held = definition.get('to', {}).get('keycode', definition.get('if_held_down', {}).get('keycode', ''))
        action = f"{KEYCODE_NAMES.get(alone, alone)} / {KEYCODE_NAMES.get(held, held)}"
        layer = 'normal'
    else:
        action = name

    return from_key, action, layer


def build_keymap(config: Dict[str, Any]) -> Dict[str, Dict[str, str]]:
    """
    Build a dictionary mapping keys to their actions across different layers.
    Returns: {keycode: {'normal': action, 'spacefn': action, 'hyper': action}}
    """
    keymap: Dict[str, Dict[str, str]] = {}

    # Process SpaceFN definitions
    for definition in config.get('spacefn_definitions', []):
        if 'complex' in definition:
            # Handle complex definitions (multiple mappings)
            for sub_def in definition['complex']:
                from_key, action, layer = parse_rule_actions(sub_def)
                if from_key:
                    if from_key not in keymap:
                        keymap[from_key] = {}
                    keymap[from_key]['spacefn'] = action
        else:
            from_key, action, layer = parse_rule_actions(definition)
            if from_key:
                if from_key not in keymap:
                    keymap[from_key] = {}
                keymap[from_key][layer] = action

    # Process Normal definitions
    for definition in config.get('normal_definitions', []):
        if 'complex' in definition:
            for sub_def in definition['complex']:
                from_key, action, layer = parse_rule_actions(sub_def)
                if from_key:
                    if from_key not in keymap:
                        keymap[from_key] = {}
                    keymap[from_key]['normal'] = action
        else:
            from_key, action, layer = parse_rule_actions(definition)
            if from_key:
                if from_key not in keymap:
                    keymap[from_key] = {}
                keymap[from_key]['normal'] = action

    return keymap


def generate_html_keyboard(config: Dict[str, Any], output_path: str = 'index.html') -> None:
    """
    Generate an HTML keyboard visualization from configuration.

    Args:
        config: Configuration dictionary from load_config()
        output_path: Path to write HTML file
    """
    keymap = build_keymap(config)

    # HTML template
    html_template = '''<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <title>Karabiner SpaceFN Configuration</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #f5f6f7;
            font-size: 12px;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
        }

        .info {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }

        .legend {
            max-width: 900px;
            margin: 0 auto 20px;
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .legend-box {
            width: 20px;
            height: 20px;
            border-radius: 3px;
        }

        #keyboard {
            width: 900px;
            height: 340px;
            border: 1px solid #999;
            margin: 0 auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: rgba(0, 0, 0, 0.2) 0 2px 10px;
            position: relative;
            padding: 40px 0 20px;
        }

        .key {
            width: 40px;
            height: 40px;
            border: none;
            box-shadow: rgba(0, 0, 0, 0.2) 0 1px 3px;
            position: absolute;
            border-radius: 4px;
            background: #f8f8f8;
            padding: 3px;
            overflow: hidden;
        }

        .key.modified { background-color: rgba(100, 156, 255, 0.3); }
        .key.spacefn { background-color: rgba(255, 200, 100, 0.3); }
        .key.special { background-color: rgba(200, 100, 200, 0.3); }

        .key-label {
            position: absolute;
            font-size: 8px;
            line-height: 9px;
            left: 3px;
            width: 34px;
            word-wrap: break-word;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .key-main { top: 2px; font-weight: bold; font-size: 9px; }
        .key-spacefn { top: 12px; color: #d97706; }
        .key-normal { top: 21px; color: #0066cc; }
        .key-hyper { top: 30px; color: #7c3aed; }
        .key-meh { top: 30px; color: #059669; }

        /* Key positioning - Row 1 (function keys) */
        .esc { left: 20px; top: 10px; height: 28px; }
        .f1 { left: 116px; top: 10px; height: 28px; }
        .f2 { left: 164px; top: 10px; height: 28px; }
        .f3 { left: 212px; top: 10px; height: 28px; }
        .f4 { left: 260px; top: 10px; height: 28px; }
        .f5 { left: 328px; top: 10px; height: 28px; }
        .f6 { left: 384px; top: 10px; height: 28px; }
        .f7 { left: 432px; top: 10px; height: 28px; }
        .f8 { left: 480px; top: 10px; height: 28px; }
        .f9 { left: 548px; top: 10px; height: 28px; }
        .f10 { left: 596px; top: 10px; height: 28px; }
        .f11 { left: 644px; top: 10px; height: 28px; }
        .f12 { left: 692px; top: 10px; height: 28px; }

        /* Key positioning - Row 2 (numbers) */
        .a_1 { left: 20px; top: 45px; }
        .a_2 { left: 68px; top: 45px; }
        .a_3 { left: 116px; top: 45px; }
        .a_4 { left: 164px; top: 45px; }
        .a_5 { left: 212px; top: 45px; }
        .a_6 { left: 260px; top: 45px; }
        .a_7 { left: 308px; top: 45px; }
        .a_8 { left: 356px; top: 45px; }
        .a_9 { left: 404px; top: 45px; }
        .a_10 { left: 452px; top: 45px; }
        .a_11 { left: 500px; top: 45px; }
        .a_12 { left: 548px; top: 45px; }
        .a_13 { left: 596px; top: 45px; }
        .a_14 { left: 644px; top: 45px; width: 88px; }

        /* Row 3 (QWERTY) */
        .tap { left: 20px; top: 90px; width: 70px; }
        .q { left: 98px; top: 90px; }
        .w { left: 146px; top: 90px; }
        .e { left: 194px; top: 90px; }
        .r { left: 242px; top: 90px; }
        .t { left: 290px; top: 90px; }
        .y { left: 338px; top: 90px; }
        .u { left: 386px; top: 90px; }
        .i { left: 434px; top: 90px; }
        .o { left: 482px; top: 90px; }
        .p { left: 530px; top: 90px; }
        .p1 { left: 578px; top: 90px; }
        .p2 { left: 626px; top: 90px; }
        .p3 { left: 674px; top: 90px; width: 58px; }

        /* Row 4 (ASDF) */
        .caps { left: 20px; top: 135px; width: 80px; }
        .a { left: 108px; top: 135px; }
        .s { left: 156px; top: 135px; }
        .d { left: 204px; top: 135px; }
        .f { left: 252px; top: 135px; }
        .g { left: 300px; top: 135px; }
        .h { left: 348px; top: 135px; }
        .j { left: 396px; top: 135px; }
        .k { left: 444px; top: 135px; }
        .l { left: 492px; top: 135px; }
        .b_1 { left: 540px; top: 135px; }
        .b_2 { left: 588px; top: 135px; }
        .b_3 { left: 636px; top: 135px; width: 96px; }

        /* Row 5 (ZXCV) */
        .shift { left: 20px; top: 180px; width: 107px; }
        .z { left: 135px; top: 180px; }
        .x { left: 183px; top: 180px; }
        .c { left: 231px; top: 180px; }
        .v { left: 279px; top: 180px; }
        .b { left: 327px; top: 180px; }
        .n { left: 375px; top: 180px; }
        .m { left: 423px; top: 180px; }
        .m_1 { left: 471px; top: 180px; }
        .m_2 { left: 519px; top: 180px; }
        .m_3 { left: 569px; top: 180px; }
        .m_4 { left: 615px; top: 180px; width: 117px; }

        /* Row 6 (modifiers) */
        .ctrl { left: 20px; top: 225px; width: 65px; }
        .windows { left: 93px; top: 225px; width: 55px; }
        .alt { left: 156px; top: 225px; width: 50px; }
        .space { left: 214px; top: 225px; width: 270px; }
        .alt_1 { left: 492px; top: 225px; width: 50px; }
        .windows_1 { left: 550px; top: 225px; width: 55px; }
        .right_on { left: 613px; top: 225px; width: 50px; }
        .ctrl_1 { left: 671px; top: 225px; width: 61px; }
    </style>
</head>
<body>
    <h1>Karabiner SpaceFN Configuration</h1>
    <p class="info">Generated from: <strong>{{hostname}}</strong> | Profile: <strong>{{profile}}</strong></p>

    <div class="legend">
        <div class="legend-item">
            <div class="legend-box" style="background: rgba(100, 156, 255, 0.3);"></div>
            <span>Normal Layer</span>
        </div>
        <div class="legend-item">
            <div class="legend-box" style="background: rgba(255, 200, 100, 0.3);"></div>
            <span>SpaceFN Layer</span>
        </div>
        <div class="legend-item">
            <div class="legend-box" style="background: rgba(200, 100, 200, 0.3);"></div>
            <span>Special Modifier</span>
        </div>
        <div class="legend-item">
            <span style="color: #d97706;">●</span> <span>SpaceFN</span>
        </div>
        <div class="legend-item">
            <span style="color: #0066cc;">●</span> <span>Normal</span>
        </div>
        <div class="legend-item">
            <span style="color: #7c3aed;">●</span> <span>Hyper</span>
        </div>
        <div class="legend-item">
            <span style="color: #059669;">●</span> <span>Meh</span>
        </div>
    </div>

    <div id="keyboard">
{{keys}}
    </div>
</body>
</html>
'''

    # Generate key HTML
    keys_html = []
    for keycode, css_class in KEY_LAYOUT.items():
        actions = keymap.get(keycode, {})

        # Determine key class
        key_class = 'key'
        if actions.get('normal') or actions.get('spacefn') or actions.get('hyper') or actions.get('meh'):
            if keycode in ['caps_lock', 'return_or_enter', 'spacebar']:
                key_class += ' special'
            elif 'spacefn' in actions:
                key_class += ' spacefn'
            elif 'normal' in actions:
                key_class += ' modified'

        # Key labels
        main_label = KEYCODE_NAMES.get(keycode, keycode.replace('_', ' ').title() if len(keycode) > 1 else keycode.upper())
        spacefn_label = actions.get('spacefn', '')
        normal_label = actions.get('normal', '')
        hyper_label = actions.get('hyper', '')
        meh_label = actions.get('meh', '')

        # Truncate long labels
        max_len = 12
        if len(spacefn_label) > max_len:
            spacefn_label = spacefn_label[:max_len-1] + '…'
        if len(normal_label) > max_len:
            normal_label = normal_label[:max_len-1] + '…'
        if len(hyper_label) > max_len:
            hyper_label = hyper_label[:max_len-1] + '…'
        if len(meh_label) > max_len:
            meh_label = meh_label[:max_len-1] + '…'

        # Generate key HTML
        key_html = f'        <div class="{css_class} {key_class}">\n'
        key_html += f'            <div class="key-label key-main">{main_label}</div>\n'

        # Add labels in order of priority
        if spacefn_label:
            key_html += f'            <div class="key-label key-spacefn">{spacefn_label}</div>\n'
        if normal_label and normal_label != main_label:
            key_html += f'            <div class="key-label key-normal">{normal_label}</div>\n'
        if hyper_label:
            key_html += f'            <div class="key-label key-hyper">{hyper_label}</div>\n'
        if meh_label:
            key_html += f'            <div class="key-label key-meh">{meh_label}</div>\n'

        key_html += '        </div>\n'

        keys_html.append(key_html)

    # Fill in template
    html = html_template.replace('{{keys}}', ''.join(keys_html))
    html = html.replace('{{hostname}}', get_hostname())
    html = html.replace('{{profile}}', config.get('profile_name', 'VIM'))

    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f"✓ Generated HTML keyboard visualization: {output_path}")


# ============================================================================
# KARABINER APPLICATION
# ============================================================================

def apply_rules_to_karabiner(rules: OrderedDict[str, Any], profile_name: str = "VIM", karabiner_config_path: Optional[str] = None) -> None:
    """
    Apply generated rules to Karabiner-Elements configuration.
    Creates a backup before modifying.

    Args:
        rules: Rules dictionary from main()
        profile_name: Name of the Karabiner profile to modify
        karabiner_config_path: Path to karabiner.json (default: ~/.config/karabiner/karabiner.json)
    """
    if karabiner_config_path is None:
        home_dir = os.getenv("HOME")
        if home_dir is None:
            raise ValueError("HOME environment variable not set")
        karabiner_config_path = os.path.join(home_dir, '.config/karabiner/karabiner.json')

    if not os.path.exists(karabiner_config_path):
        raise FileNotFoundError(f"Karabiner config not found: {karabiner_config_path}")

    # Load existing config
    with open(karabiner_config_path) as json_file:
        data = json.load(json_file)

    # Create backup
    i = 0
    backup_pattern = "{}_{}.back.json"
    while os.path.exists(backup_pattern.format(karabiner_config_path, i)):
        i += 1

    backup_path = backup_pattern.format(karabiner_config_path, i)
    print(f"Creating backup: {backup_path}")
    with open(backup_path, "w+") as back_file:
        json.dump(data, back_file, indent=4)

    # Find target profile
    profile = None
    for value in data["profiles"]:
        if value["name"] == profile_name:
            profile = value
            break

    if profile is None:
        available_profiles = [p["name"] for p in data.get("profiles", [])]
        raise ValueError(
            f"Profile '{profile_name}' not found in Karabiner config.\n"
            f"Available profiles: {', '.join(available_profiles)}"
        )

    # Apply rules
    if "complex_modifications" not in profile:
        profile["complex_modifications"] = {}

    profile["complex_modifications"]["rules"] = rules["rules"]

    # Save updated config
    with open(karabiner_config_path, "w") as json_file:
        json.dump(data, json_file, indent=4)

    print(f"✓ Successfully applied {len(rules['rules'])} rules to profile '{profile_name}'")


# ============================================================================
# LIBRARY USAGE EXAMPLE
# ============================================================================
#
# To use this as a library in another script:
#
#   from spacefn import (
#       basic_rule, basic_from, basic_to, basic_if_alone,
#       basic_spaceFN, main, load_config, apply_rules_to_karabiner
#   )
#
#   # Option 1: Load from JSON config files
#   config = load_config('/path/to/config/dir')
#   rules = main(config["spacefn_definitions"], config["normal_definitions"])
#   apply_rules_to_karabiner(rules, config["profile_name"])
#
#   # Option 2: Define rules programmatically
#   my_spacefn_rules = [
#       {"name": "A to B", "from": {"keycode": "a"}, "to": {"keycode": "b"}}
#   ]
#   my_normal_rules = []
#   rules = main(my_spacefn_rules, my_normal_rules)
#   apply_rules_to_karabiner(rules, "MyProfile")
#
# ============================================================================


if __name__ == "__main__":
    import sys

    # Parse command line arguments
    config_dir = None
    html_only = False
    skip_html = False

    args = sys.argv[1:]
    for arg in args:
        if arg == '--html-only':
            html_only = True
        elif arg == '--no-html':
            skip_html = True
        elif arg.startswith('--'):
            print(f"Unknown option: {arg}")
            print("Usage: python spacefn.py [config_dir] [--html-only] [--no-html]")
            sys.exit(1)
        else:
            config_dir = arg
            if not os.path.isdir(config_dir):
                print(f"Error: '{config_dir}' is not a valid directory")
                sys.exit(1)

    # Load configuration from JSON files
    try:
        config = load_config(config_dir)
    except FileNotFoundError as e:
        print(f"Error: {e}")
        sys.exit(1)

    # Determine output path for HTML
    if config_dir:
        html_output = os.path.join(config_dir, 'index.html')
    else:
        html_output = os.path.join(get_script_dir(), 'index.html')

    # Generate HTML keyboard visualization
    if html_only:
        generate_html_keyboard(config, html_output)
        sys.exit(0)

    # Generate Karabiner rules
    rules = main(config["spacefn_definitions"], config["normal_definitions"])

    # Apply to Karabiner-Elements
    try:
        apply_rules_to_karabiner(rules, config.get("profile_name", "VIM"))
    except (FileNotFoundError, ValueError) as e:
        print(f"Error: {e}")
        sys.exit(1)

    # Also generate HTML by default (unless --no-html specified)
    if not skip_html:
        generate_html_keyboard(config, html_output)
