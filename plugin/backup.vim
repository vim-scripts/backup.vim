" Filename: backups.vim
" Description: Puts backups where they belong: out of the way
" Author: Nathan Lawrence
"

set backup
set writebackup
set backupcopy=auto

au BufNewFile,BufRead * python SetupBackupDir()
au BufWritePre * silent exe "set backupdir=" . b:backupdir

python << EOF

import vim
import os
import hashlib
import re, sys

def SetupBackupDir():
	(dir_part, foobar, file_part) = \
		os.path.realpath(vim.current.buffer.name).rpartition('/')

	backup_dir = os.path.join(os.environ['HOME'],'.vim_plugins','vim_backup',
		hashlib.md5(dir_part).hexdigest())

	if os.path.exists(backup_dir):
		if not os.path.isdir(backup_dir):
			sys.stderr.write("Vim Backup Error: " + backup_dir + " should be a directory")
	else:
		os.mkdir(backup_dir)

	vim.command('let b:backupdir="' + backup_dir + '"')

SetupBackupDir()

