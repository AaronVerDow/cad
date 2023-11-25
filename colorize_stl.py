#!/usr/bin/python
import argparse
import sys
import subprocess
from colour import Color
try:
    import bpy
except ImportError:
    bpy = None


# https://blender.stackexchange.com/questions/6817/how-to-pass-command-line-arguments-to-a-blender-python-script
class ArgumentParserForBlender(argparse.ArgumentParser):
    """
    This class is identical to its superclass, except for the parse_args
    method (see docstring). It resolves the ambiguity generated when calling
    Blender from the CLI with a python script, and both Blender and the script
    have arguments. E.g., the following call will make Blender crash because
    it will try to process the script's -a and -b flags:
    >>> blender --python my_script.py -a 1 -b 2

    To bypass this issue this class uses the fact that Blender will ignore all
    arguments given after a double-dash ('--'). The approach is that all
    arguments before '--' go to Blender, arguments after go to the script.
    The following calls work fine:
    >>> blender --python my_script.py -- -a 1 -b 2
    >>> blender --python my_script.py --
    """

    def _get_argv_after_doubledash(self):
        """
        Given the sys.argv as a list of strings, this method returns the
        sublist right after the '--' element (if present, otherwise returns
        an empty list).
        """
        try:
            idx = sys.argv.index("--")
            return sys.argv[idx+1:]  # the list after '--'
        except ValueError:  # '--' not in the list:
            return []

    # overrides superclass
    def parse_args(self):
        """
        This method is expected to behave identically as in the superclass,
        except that the sys.argv list will be pre-processed using
        _get_argv_after_doubledash before. See the docstring of the class for
        usage examples and details.
        """
        return super().parse_args(args=self._get_argv_after_doubledash())


def parse_args():
    parser = ArgumentParserForBlender()
    parser.add_argument('-o', '--outfile', help='file to write to')
    parser.add_argument('-f', '--file', action='append', help='files to import', required=True)
    parser.add_argument('-c', '--color', action='append', help='color to make files', required=True)
    return parser.parse_args()


def delete_cube():
    if 'Cube' not in bpy.data.objects:
        return
    bpy.ops.object.select_all(action='DESELECT')
    bpy.data.objects['Cube'].select_set(True)
    bpy.ops.object.delete()


def override(area_type='VIEW_3D', region_type='WINDOW'):
    for area in bpy.context.screen.areas:
        if area.type != area_type:
            continue
        for region in area.regions:
            if region.type != region_type:
                continue
            return {'area': area, 'region': region, 'edit_object': bpy.context.selected_objects}


def view_all():
    bpy.ops.object.select_all(action='DESELECT')
    bpy.ops.object.select_by_type(type='MESH')
    bpy.ops.view3d.view_selected(override())


def pair_args():
    args = parse_args()
    files = args.file
    colors = args.color
    for file in files:
        color = colors.pop(0)
        yield file, color


def create_material(color):
    name = str(color)
    if name in bpy.data.materials:
        return
    bpy.data.materials.new(name=name)
    rgba = list(Color(color).get_rgb())
    rgba.append(1.0)
    bpy.data.materials[color].diffuse_color = rgba
    return name


def load_material(obj, color):
    if obj.material_slots:
        obj.material_slots[0].material = bpy.data.materials[color]
    else:
        obj.data.materials.append(bpy.data.materials[color])


def color_import(file, color):
    bpy.ops.object.select_all(action='DESELECT')
    bpy.ops.import_mesh.stl(filepath=file)
    bpy.ops.transform.resize(value=(1/1000, 1/1000, 1/1000))
    material = create_material(color)
    for obj in bpy.context.selected_objects:
        load_material(obj, material)


def main():
    bpy.context.preferences.view.show_splash = False
    delete_cube()
    args = parse_args()

    for file, color in pair_args():
        color_import(file, color)

    view_all()

    if args.outfile:
        bpy.ops.export_scene.obj(filepath=args.outfile)


if __name__ == "__main__":
    main()
