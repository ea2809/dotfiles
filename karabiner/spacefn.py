from inspect import isfunction
from collections import OrderedDict
from functools import partial, wraps
import json
import copy
import os


def basic_rule(description="Rule", type="basic", functions=[]):
    basic_manipulators = {"type": type}

    basic = {
        "description": description,
        "manipulators": [
        ]
    }

    def add_functions(inner_functions, basic_json):
        basic_json["manipulators"].append(copy.deepcopy(basic_manipulators))
        for function in inner_functions:
            if callable(function):
                function(basic_json["manipulators"][-1])

    def analize_functions(functions):
        globals = []
        funcs = []
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
    def __init__(self, options):
        self.options = copy.deepcopy(options)

    def run(self, base_json):
        return base_json

    def __call__(self, base_json):
        return self.run(base_json)

    def __repr__(self):
        return self.__unicode__()

    def __str__(self):
        return self.__unicode__()

    def __unicode__(self):
        return "Karabiner {}".format(self.options)


def basic_from(keycode="", mandatory=None, optional=["any"]):
    class KarabinerFrom(Karabiner):
        def run(self, base_json):
            fron = {
                "key_code": self.options.get("keycode"),
            }

            if mandatory:
                modifiers = fron.setdefault("modifiers", {})
                modifiers.update({"mandatory": mandatory})

            if optional:
                modifiers = fron.setdefault("modifiers", {})
                modifiers.update({"optional": optional})

            base_json["from"] = fron
            return fron
    return KarabinerFrom({"keycode": keycode})


def basic_to(keycode="", modifiers=None, event="to", lazy=None, other_params={}):
    class KarabinerTo(Karabiner):
        def run(self, base_json):
            to = {
                "key_code": self.options.get("keycode"),
                **self.options.get("other_params")
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


def set_variable(name, value, event="to"):
    class KarabinerVar(Karabiner):
        def run(self, base_json):
            to = {
                "set_variable": {
                    "name":  self.options.get("name"),
                    "value": self.options.get("value")
                }
            }

            base_json[self.options.get("event")] = to
    return KarabinerVar({"name": name, "value": value, "event": event})


def conditions(name, value):
    class KarabinerCon(Karabiner):
        def run(self, base_json):
            conditions = [
                {
                    "type": "variable_if",
                    "name":  self.options.get("name"),
                    "value": self.options.get("value")
                }
            ]

            conditions_arr = base_json.setdefault("conditions", [])
            conditions_arr += conditions
    return KarabinerCon({"name": name, "value": value})


def parameters(**kwargs):
    class KarabinerParam(Karabiner):
        def run(self, base_json):
            conditions_arr = base_json.setdefault("parameters", {})
            conditions_arr.update(self.options.get("parameters"))
    return KarabinerParam({"parameters": kwargs})


def device_unless(identifiers):
    class KarabinerDU(Karabiner):
        def run(self, base_json):
            conditions = [
                {
                    "type": "device_unless",
                    "identifiers": self.options.get("identifiers")
                }
            ]

            conditions_arr = base_json.setdefault("conditions", [])
            conditions_arr += conditions
    return KarabinerDU({"identifiers": identifiers})


def shell_to(script="", event="to"):
    class KarabinerShell(Karabiner):
        def run(self, base_json):
            to = {
                "shell_command": self.options.get("script"),
            }

            base_json[self.options.get("event")] = to
    return KarabinerShell({"script": script, "event": event})


def program_to(program):
    script = "open -a '{}'".format(program)
    return shell_to(script=script)


SFN_VAR = "spacefn_mode"
SFN_ON = 1
SFN_OFF = 0


def base_spaceFN():
    methods = [
        basic_from("spacebar"),
        # set_variable(name=SFN_VAR, value=SFN_ON, event="to"),
        set_variable(name=SFN_VAR, value=SFN_ON, event="to_if_held_down"),
        basic_to("spacebar", event="to_if_alone"),
        set_variable(name=SFN_VAR, value=SFN_OFF, event="to_after_key_up"),
    ]
    return basic_rule(description="SpaceFn basic config", functions=methods)


def basic_spaceFN(description, functions=[]):
    methods = [conditions(name=SFN_VAR, value=SFN_ON)] + functions
    description = "SpaceFN: " + description
    return basic_rule(description=description, functions=methods)


def hyper_keycode(keycode="", event="to"):
    modifiers = [
        "right_command", "right_control", "right_option", "right_shift"
    ]
    return basic_to(keycode=keycode, modifiers=modifiers, event=event)


def meh_keycode(keycode="", event="to"):
    modifiers = [
        "right_command", "right_control", "right_option"
    ]
    return basic_to(keycode=keycode, modifiers=modifiers, event=event)


def add_functions(in_definitions, rule_type=basic_rule):
    functions = {
        "from": basic_from,
        "to": basic_to,
        "if_alone": basic_if_alone,
        "if_held_down": basic_if_held_down,
        "shell": program_to,
        "hyper": hyper_keycode,
        "meh": meh_keycode,
        "device_unless": device_unless,
        "parameters": parameters,
    }

    rules = []
    for definition in in_definitions:
        global_name = ""
        funcs = []

        def add_funcs_to(name, options, funcs):
            function = functions.get(name)
            if callable(function):
                funcs.append(function(**options))

        for name, options in definition.items():
            if name == "name":
                global_name = options
            elif name == "complex":
                for option in options:
                    sub_funcs = []
                    for sub_name, sub_options in option.items():
                        add_funcs_to(sub_name, sub_options, sub_funcs)
                    funcs.append(sub_funcs)
            else:
                add_funcs_to(name, options, funcs)
        rules.append(rule_type(description=global_name, functions=funcs))
    return rules


def main(spacefn_definitions, normal_definitions):
    rules = [
        base_spaceFN(),
    ]
    rules += add_functions(spacefn_definitions, rule_type=basic_spaceFN)
    rules += add_functions(normal_definitions, rule_type=basic_rule)

    base = OrderedDict({"title": "Enrique's rules", "rules": rules})
    return base


spacefn_definitions = [
    {"name": "a to Alfred", "from": {"keycode": "a"}, "shell": {"program": "Alfred 4"}},
    {"name": "b to spacebar", "from": {"keycode": "b"}, "to": {"keycode": "spacebar"}},
    {"name": "i to Kitty", "from": {"keycode": "i"}, "shell": {"program": "kitty"}},
    {"name": "s to Safari", "from": {"keycode": "s"}, "shell": {"program": "Safari"}},
    {"name": "c to Chrome", "from": {"keycode": "c"}, "shell": {"program": "Google Chrome"}},
    {"name": "t to Teams", "from": {"keycode": "t", "optional": False}, "shell": {"program": "Microsoft Teams"}},
    {"name": "o to Outlook", "from": {"keycode": "o", "optional": False}, "shell": {"program": "Microsoft Outlook"}},
    # {"name": "p to PyCharm", "from": {"keycode":"p"}, "shell": { "program": "PyCharm"}},
    {"name": "hyper g to Alfred github", "from": {"keycode": "g"}, "hyper": {"keycode": "g"}},
    {"name": "hyper T to Trello", "from": {"keycode": "t", "mandatory": ["shift"]}, "shell": {"program": "Trello"}},
    {"name": "hyper w to Trello", "from": {"keycode": "w"}, "hyper": {"keycode": "spacebar"}},
    {"name": "hyper r to Todoist", "from": {"keycode": "r"}, "meh": {"keycode": "r"}},
    {"name": "hyper R to Todoist", "from": {"keycode": "r", "mandatory": ["shift"]}, "hyper": {"keycode": "r"}},
    {"name": "v to Viber", "from": {"keycode": "v"}, "shell": {"program": "Viber"}},
    {"name": "hyper hjkl to arrows", "complex": [
        {"from": {"keycode": "h"}, "to": {"keycode": "left_arrow"}},
        {"from": {"keycode": "j"}, "to": {"keycode": "down_arrow"}},
        {"from": {"keycode": "k"}, "to": {"keycode": "up_arrow"}},
        {"from": {"keycode": "l"}, "to": {"keycode": "right_arrow"}},
        {"from": {"keycode": "semicolon", "optional": False}, "to": {"keycode": "delete_or_backspace"}},
        {"from": {"keycode": "semicolon", "mandatory": ["shift"]}, "to": {"keycode": "delete_or_backspace", "modifiers": ["fn"]}},
    ]},
    {"name": "Navigation", "complex": [
        {"from": {"keycode": "n"}, "to": {"keycode": "left_arrow", "modifiers": ["control"]}},
        {"from": {"keycode": "m"}, "to": {"keycode": "right_arrow", "modifiers": ["control"]}},
        {"from": {"keycode": "d"}, "to": {"keycode": "tab", "modifiers": ["control", "shift"]}},
        {"from": {"keycode": "f"}, "to": {"keycode": "tab", "modifiers": ["control"]}},
        {"from": {"keycode": "comma"}, "to": {"keycode": "left_arrow", "modifiers": ["option"]}},
        {"from": {"keycode": "period"}, "to": {"keycode": "right_arrow", "modifiers": ["option"]}},
    ]},
]

non_ansii_keyboards = {"identifiers": [{"description": "Atreus", "vendor_id": 4617}]}

normal_definitions = [
    {"name": "Escape to caps lock", "from": {"keycode": "escape"}, "if_alone": {"keycode": "escape"}, "if_held_down": {"keycode": "caps_lock"}, "parameters": {
        "basic.to_if_alone_timeout_milliseconds": 250,
        "basic.to_if_held_down_threshold_milliseconds": 250
    }, "device_unless": non_ansii_keyboards},
    {"name": "Enter right control", "from": {"keycode": "return_or_enter"}, "to": {"keycode": "right_control", "lazy": True}, "if_alone": {"keycode": "return_or_enter"}},
    {"name": "Capslock to escape or control", "from": {"keycode": "caps_lock"}, "to": {"keycode": "left_control", "lazy": True}, "if_alone": {"keycode": "escape"}},
    {"name": "Double shift caps lock", "complex": [
        {"from": {"keycode":"left_shift", "mandatory": ["right_shift"], "optional": ["caps_lock"]}, "to": {"keycode": "caps_lock"}, "if_alone": {"keycode": "left_shift"}},
        {"from": {"keycode":"right_shift", "mandatory": ["left_shift"], "optional": ["caps_lock"]}, "to": {"keycode": "caps_lock"}, "if_alone": {"keycode": "right_shift"}},
    ]},
    {"name": "Special Shifts arrows", "complex": [
        {"from": {"keycode": "up_arrow", "mandatory": ["shift"]}, "to": {"keycode": "page_up"}},
        {"from": {"keycode": "down_arrow", "mandatory": ["shift"]}, "to": {"keycode": "page_down"}},
        {"from": {"keycode": "left_arrow", "mandatory": ["shift"]}, "to": {"keycode": "home"}},
        {"from": {"keycode": "right_arrow", "mandatory": ["shift"]}, "to": {"keycode": "end"}},
    ]},
]

if __name__ == "__main__":
    rules = main(spacefn_definitions, normal_definitions)

    full_path = os.path.join(os.getenv("HOME"), '.config/karabiner/karabiner.json')
    data = {}
    with open(full_path) as json_file:
        data = json.load(json_file)

    i = 0
    new_path = "{}_{}.back.json"
    while os.path.exists(new_path.format(full_path, i)):
        i += 1

    print(f"Backupfile: {new_path.format(full_path, i)}")
    with open(new_path.format(full_path, i), "w+") as back_file:
        back_file.write(json.dumps(data, indent=4))

    profile = {}
    for value in data["profiles"]:
        if value["name"] == "VIM":
            profile = value
            break
    profile["complex_modifications"]["rules"] = rules["rules"]

    with open(full_path, "w") as json_file:
        json.dump(data, json_file, indent=4)
