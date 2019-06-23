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
        basic_json["manipulators"].append(basic_manipulators)
        for function in inner_functions:
            if callable(function):
                function(basic_json["manipulators"][-1])

    def analize_functions(functions):
        globals = []
        funcs = []
        for function in functions:
            if isfunction(function):
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
            print(globals)
            print(function)
            add_functions(function+globals, basic)

    return basic


def basic_from(keycode=""):
    def basic_from_inner(base_json):
        fron = {
            "key_code": keycode,
            "modifiers": {
                "optional": [
                    "any"
                ]
            }
        }

        base_json["from"] = fron
    return basic_from_inner


def basic_to(keycode="", modifiers=None, event="to"):
    def basic_to_inner(base_json):
        to = {
            "key_code": keycode,
        }

        if modifiers:
            to["modifiers"] = modifiers

        base_json[event] = to
    return basic_to_inner


def set_variable(name, value, event="to"):
    def set_variable_inner(base_json):
        to = {
            "set_variable": {
                "name": name,
                "value": value
            }
        }

        base_json[event] = to
    return set_variable_inner


def conditions(name, value):
    def basic_condition(base_json):
        conditions = [
            {
                "type": "variable_if",
                "name": name,
                "value": value
            }
        ]

        base_json["conditions"] = conditions
    return basic_condition


def shell_to(script="", event="to"):
    def basic_shell(base_json):
        to = {
            "shell_command": script,
        }

        base_json[event] = to
    return basic_shell


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
                print(name,options)
                funcs.append(function(**options))
                print(funcs)

        for name, options in definition.iteritems():
            if name == "name":
                global_name = options
            elif name == "complex":
                for option in options:
                    sub_funcs = []
                    for sub_name, sub_options in option.iteritems():
                        print(sub_name, sub_options)
                        add_funcs_to(sub_name, sub_options, sub_funcs)
                    print(sub_funcs)
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
    {"name": "hyper g to Alfred github", "from": {"keycode":"g"}, "hyper": { "keycode": "g"}},
    {"name": "hyper w to Alfred github", "from": {"keycode":"w"}, "hyper": { "keycode": "w"}},
    {"name": "hyper jkil to arrows", "complex":[
        {"from": {"keycode":"h"}, "to": { "keycode": "left_arrow"}},
        {"from": {"keycode":"j"}, "to": { "keycode": "down_arrow"}},
        {"from": {"keycode":"k"}, "to": { "keycode": "up_arrow"}},
        {"from": {"keycode":"l"}, "to": { "keycode": "right_arrow"}},
    ]},
]


if __name__ == "__main__":
    main()
