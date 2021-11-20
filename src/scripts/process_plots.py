# -*- coding: utf-8 -*-

import fileinput
import os
import re
import subprocess


def create_plots(file_name, working_dir, rel_dir):
	print('Plotting {}...'.format(os.path.join(rel_dir, file_name)))

	command = 'gnuplot -e "load \'{}\'"'.format(file_name)
	subprocess.call(command, shell=True, cwd=working_dir)


def convert_ps2pdf(file_name, working_dir, rel_dir):
	print('Converting {} to pdf...'.format(os.path.join(rel_dir, file_name)))

	fn_base = os.path.splitext(file_name)[0]
	command = 'ps2pdf -dEPSCrop {} {}.pdf'.format(file_name, fn_base)
	subprocess.call(command, shell=True, cwd=working_dir)
	print('Removing {}...'.format(os.path.join(rel_dir, file_name)))
	os.remove(os.path.join(working_dir, file_name))


def fix_include_path(file_name, working_dir, rel_dir):
	print('Fixing {} include path...'.format(os.path.join(rel_dir, file_name)))

	with open(os.path.join(working_dir, file_name), 'r') as f:
		tex_file = f.readlines()

	fn_base = os.path.splitext(file_name)[0]
	unix_path = os.path.join(rel_dir, fn_base).replace('\\', '/')
	include_re = re.compile(f'(?P<prefix>\\\\includegraphics.*{{)(?P<filename>{fn_base})(?P<suffix>}})')
	for i, line in enumerate(tex_file):
		tex_file[i] = include_re.sub(f'\\g<prefix>{unix_path}\\g<suffix>', line)

	with open(os.path.join(working_dir, file_name), 'w') as f:
		f.writelines(tex_file)


def process_plots():
	plot_settings = [
		# relative directory                filename      ps2pdf  outputs
		['results_and_discussion/assets/artefact/',
			'artefact_amphidinium.gp', True, ['artefact_amphidinium.eps']],
		['results_and_discussion/assets/interpretation/at',
			'interpretation_at.gp', True, ['interpretation_at.eps']],
		['results_and_discussion/assets/interpretation/gc',
			'interpretation_gc.gp', True, ['interpretation_gc.eps']],
		['results_and_discussion/assets/power_optimization_triplexes/',
			'power_optimization_triplexes_pU.gp', False, ['power_optimization_triplexes_pU.pdf']],
		['results_and_discussion/assets/power_optimization_triplexes/',
			'power_optimization_triplexes.gp', True, ['power_optimization_triplexes.eps']],
		['results_and_discussion/assets/power_optimization_triplexes2/',
			'power_optimization_triplexes2_pU.gp', False, ['power_optimization_triplexes2_pU.pdf']],
		['results_and_discussion/assets/power_optimization_triplexes2/',
			'power_optimization_triplexes2.gp', True, ['power_optimization_triplexes2.eps']],
	]

	root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

	for plot_list in plot_settings:
		plot_dir = plot_list[0]
		plot_file_name = plot_list[1]
		use_ps2pdf = plot_list[2]
		plot_outputs = plot_list[3]
		working_dir = os.path.normpath(os.path.join(root_dir, plot_dir))
		rel_dir = os.path.relpath(working_dir, root_dir)
		create_plots(plot_file_name, working_dir, rel_dir)

		for f in plot_outputs:
			if use_ps2pdf:
				convert_ps2pdf(f, working_dir, rel_dir)
			fn_base = os.path.splitext(f)[0]
			tex_file_name = '{}.tex'.format(fn_base)
			fix_include_path(tex_file_name, working_dir, rel_dir)


if __name__ == '__main__':
	process_plots()
