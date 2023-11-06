import argparse
import subprocess
import sys
import os

def terraform_command(commands):
    print(" ".join(commands))
    result = subprocess.run(commands, text=True, capture_output=True)
    print(result.stdout)
    print(result.stderr, file=sys.stderr)
    return result.returncode

def terraform_apply(args):
    if terraform_command(["terraform",f"-chdir={args.instance_type}",'init'])== 0:
        if terraform_command(["terraform",f"-chdir={args.instance_type}",'validate']) == 0:
            lst=["terraform",f"-chdir={args.instance_type}","apply"]
            if args.instance is not None:
                lst.append(f"-target=module.{args.instance}")
            lst.append("-auto-approve")
            terraform_command(lst)

def terraform_destroy(args):
    lst=["terraform",f"-chdir={args.instance_type}","destroy"]
    if args.instance is not None:
        lst.append(f"-target=module.{args.instance}")
    lst.append("-auto-approve")
    terraform_command(lst)

def list_instances(args):
    list_command = ['gcloud', 'compute', 'instances', 'list']
    if args.label:
        list_command += ['--filter', f'labels.{args.label}']
    
    result = subprocess.run(list_command, text=True, capture_output=True)
    print(result.stdout)
    if result.stderr:
        print(result.stderr, file=sys.stderr)

def main():
    parser = argparse.ArgumentParser(description='Manage Vertex AI Notebook instances with Terraform.')
    subparsers = parser.add_subparsers(dest='command')

    # Create subparser for the 'build' command
    parser_build = subparsers.add_parser('build', help='Build instances using Terraform.')
    parser_build.add_argument('instance_type', choices=['gpu', 'cpu'], help='Path to Terraform config directory.')
    parser_build.add_argument('--instance',  help='Specific vertex-ai instance to build')
    parser_build.set_defaults(func=terraform_apply)

    # Create subparser for the 'destroy' command
    parser_destroy = subparsers.add_parser('destroy', help='Destroy instances using Terraform.')
    parser_destroy.add_argument('instance_type', choices=['gpu', 'cpu'], help='Path to Terraform config directory.')
    parser_destroy.add_argument('--instance',  help='Specific vertex-ai instance to destroy')
    parser_destroy.set_defaults(func=terraform_destroy)

    # Create subparser for the 'list' command
    parser_list = subparsers.add_parser('list', help='List instances using gcloud.')
    parser_list.add_argument('label', help='Label filter for listing instances. Format key:value')

    parser_list.set_defaults(func=list_instances)

    args = parser.parse_args()

    if hasattr(args, 'func'):
        args.func(args)
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
