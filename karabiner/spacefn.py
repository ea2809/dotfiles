from inspect import isfunction
import json
import copy


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
        def run(self,base_json):
            fron = {
                "key_code": self.options.get("keycode"),
            }

            if mandatory:
                modifiers = fron.setdefault("modifiers", {}) 
                modifiers.update({"mandatory" : mandatory})

            if optional:
                modifiers = fron.setdefault("modifiers", {}) 
                modifiers.update({"optional" : optional})

            base_json["from"] = fron
            return fron
    return KarabinerFrom({"keycode": keycode})


def basic_to(keycode="", modifiers=None, event="to"):
    class KarabinerTo(Karabiner):
        def run(self,base_json):
            to = {
                "key_code": self.options.get("keycode"),
            }

            if self.options.get("modifiers"):
                to["modifiers"] = self.options.get("modifiers")

            base_json[self.options.get("event")] = to
    return KarabinerTo({"keycode": keycode, "modifiers":modifiers, "event":event})


def set_variable(name, value, event="to"):
    class KarabinerVar(Karabiner):
        def run(self,base_json):
            to = {
                "set_variable": {
                    "name":  self.options.get("name"),
                    "value": self.options.get("value")
                }
            }

            base_json[self.options.get("event")] = to
    return KarabinerVar({"name": name, "value":value, "event":event})


def conditions(name, value):
    class KarabinerCon(Karabiner):
        def run(self,base_json):
            conditions = [
                {
                    "type": "variable_if",
                    "name":  self.options.get("name"),
                    "value": self.options.get("value")
                }
            ]

            base_json["conditions"] = conditions
    return KarabinerCon({"name": name, "value": value})


def shell_to(script="", event="to"):
    class KarabinerShell(Karabiner):
        def run(self,base_json):
            to = {
                "shell_command": self.options.get("script"),
            }

            base_json[self.options.get("event")] = to
    return KarabinerShell({"script": script, "event": event})


def program_to(program, event="to"):
    script = "open -a '{}'".format(program)
    return shell_to(script=script)
pass


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


def basic_spaceFN(name, functions=[]):
    methods = [
        conditions(name=SFN_VAR, value=SFN_ON),
    ]
    methods += functions
    name = "SpaceFN: "+ name
    return basic_rule(description=name, functions=methods)


def hyper_keycode(keycode="", event="to"):
    modifiers = ["right_command", "right_control", "right_option", "right_shift"]
    return basic_to(keycode=keycode, modifiers=modifiers, event=event)


def spacefn_functions():
    functions = {
        "from": basic_from,
        "to": basic_to,
        "shell": program_to,
        "hyper": hyper_keycode,
    }

    rules = []
    for definition in definitions:
        global_name = ""
        funcs = []

        def add_funcs_to(name, options, funcs):
            function = functions.get(name)
            if callable(function):
                funcs.append(function(**options))

        for name, options in definition.iteritems():
            if name == "name":
                global_name = options
            elif name == "complex":
                for option in options:
                    sub_funcs = []
                    for sub_name, sub_options in option.iteritems():
                        add_funcs_to(sub_name, sub_options, sub_funcs)
                    funcs.append(sub_funcs)
            else:
                add_funcs_to(name, options, funcs)
        rules.append(basic_spaceFN(global_name, functions=funcs))
    return rules


def main():
    out = []
    rules = [
        base_spaceFN(),
    ]
    rules += spacefn_functions()

    base = {"title": "Enrique's rules", "rules": rules}
    print(json.dumps(base, indent=2))


definitions = [
    {"name": "a to Alfred", "from": {"keycode":"a"}, "shell": { "program": "Alfred 4"}},
    {"name": "b to spacebar", "from": {"keycode":"b"}, "to": { "keycode": "spacebar"}},
    {"name": "i to Iterm", "from": {"keycode":"i"}, "shell": { "program": "iTerm"}},
    {"name": "s to Safari", "from": {"keycode":"s"}, "shell": { "program": "Safari"}},
    {"name": "c to Chrome", "from": {"keycode":"c"}, "shell": { "program": "Google Chrome"}},
    {"name": "t to Slack", "from": {"keycode":"t", "optional": False}, "shell": { "program": "Slack"}},
    {"name": "T to Station", "from": {"keycode":"t", "mandatory": ["shift"]}, "shell": { "program": "Station"}},
    {"name": "p to PyCharm", "from": {"keycode":"p"}, "shell": { "program": "PyCharm"}},
    {"name": "hyper g to Alfred github", "from": {"keycode":"g"}, "hyper": { "keycode": "g"}},
    {"name": "hyper w to Alfred github", "from": {"keycode":"w"}, "hyper": { "keycode": "w"}},
    {"name": "hyper hjkl to arrows", "complex":[
        {"from": {"keycode":"h"}, "to": { "keycode": "left_arrow"}},
        {"from": {"keycode":"j"}, "to": { "keycode": "down_arrow"}},
        {"from": {"keycode":"k"}, "to": { "keycode": "up_arrow"}},
        {"from": {"keycode":"l"}, "to": { "keycode": "right_arrow"}},
        {"from": {"keycode":"semicolon", "optional": False}, "to": { "keycode": "delete_or_backspace"}},
        {"from": {"keycode":"semicolon", "mandatory": ["shift"]}, "to": { "keycode": "delete_or_backspace", "modifiers": ["fn"]}},
    ]},
    {"name": "Navigation", "complex":[
        {"from": {"keycode":"n"}, "to": { "keycode": "left_arrow", "modifiers": ["control"]}},
        {"from": {"keycode":"m"}, "to": { "keycode": "right_arrow", "modifiers": ["control"]}},
        {"from": {"keycode":"d"}, "to": { "keycode": "tab", "modifiers": ["control", "shift"]}},
        {"from": {"keycode":"f"}, "to": { "keycode": "tab", "modifiers": ["control"]}},
    ]},
]


if __name__ == "__main__":
    main()
