#!/usr/bin/env python3

import argparse
import os
import shlex
import subprocess

current_script_path = os.getcwd()
k6_scripts_path = "loadtest/k6"

default_base_url = os.environ.get("BASE_URL", f"https://{os.environ['PHX_HOST']}")
path_to_k6_scripts = "loadtest/k6"

# SETUP
os.chdir(  # navigate to current script directory
    os.path.abspath(os.path.dirname(__file__))
)

# ARGS
parser = argparse.ArgumentParser(
    prog="loadtest-k6",
    description="Run a load test using a `k6` Docker container.",
    epilog="To run a basic load test, run this script with no arguments.",
)
parser.add_argument(
    "args",
    nargs="*",
    help='Arguments to pass to k6 (must be in quotes, e.g. "-u 300 -d 30s", otherwise this wrapper script will attempt (and fail) to parse the flags)',  # noqa: E501
)
parser.add_argument(
    "-p",
    "--podman",
    dest="container_runtime",
    help="Use Podman instead of Docker",
    action="store_const",
    default="docker",
    const="podman",
)
parser.add_argument(
    "-u",
    "--base-url",
    help="The base URL of the server (default: 'https://$PHX_HOST')",
    type=str,
    nargs="?",
    default=default_base_url,
)
parser.add_argument(
    "-s",
    "--scripts",
    help="One or more load testing scripts to run with K6 (located in './loadtest/k6')",
    nargs="*",
    default="index.js",
)
args = parser.parse_args()


def normalize_script_names() -> list[str]:
    f"""The k6 container mounts a volume called '/{path_to_k6_scripts}/'
    which contains the k6 load test scripts. This path was chosen
    because it mirrors the path to the scripts relative to the module
    you are currently viewing ('loadtest_k6').

    In order to normalize the names, we will strip all path info to
    the scripts, leaving only the base name of the script to be run,
    then return each script name as the absolute path of the script
    as if it were run from the container.

    Examples:
      - 'example.js' -> '/{path_to_k6_scripts}/example.js'
      - '/path/to/example.js' -> '/{path_to_k6_scripts}/example.js'
    """
    result: list[str] = []

    # cast args.scripts to list so single value isn't a string
    scripts = [args.scripts] if type(args.scripts) == str else args.scripts

    for script in scripts:
        # get the base name of the script (e.g. '/path/to/example.js' -> 'example.js')
        script_base_name = script.split("/")[-1]

        script_path_in_container = f"/{path_to_k6_scripts}/{script_base_name}"
        result.append(script_path_in_container)

    return result


def build_command() -> str:
    normalized_script_names = normalize_script_names()

    return " ".join(
        [
            args.container_runtime,
            # container preamble boilerplate
            "run --rm --network=host -it",
            # enable colored prompt text
            '-e "TERM=xterm-256color"',
            # k6 boilerplate
            f'-e "BASE_URL={args.base_url}"',
            f'-v "./{path_to_k6_scripts}:/{path_to_k6_scripts}:ro" grafana/k6 run',
            # custom k6 args
            " ".join(args.args) or "",
            "--include-system-env-vars",
        ]
        + normalized_script_names
    )


def main() -> None:
    command_to_run = build_command()

    if os.environ.get("DEBUG") == "1":
        # print debug info
        print(args)
        print(command_to_run)

    # run the command
    subprocess.run(shlex.split(command_to_run))


if __name__ == "__main__":
    main()
