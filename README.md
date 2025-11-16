# simple-backup-script

A small, single-file Bash backup helper that creates a tarball of a given source directory.

**What the script does**
- Creates a tar archive named `backup.tar` in `SOURCE_DIR` that contains the files from `SOURCE_DIR`.
- Calculates the MD5 checksum of the newly created tarball.
- If a tarball already exists at `DEST_DIR/backup.tar`, it calculates the MD5 checksum of that file and compares it to the local checksum.
	- If checksums differ, it copies the new tarball to `DEST_DIR` (overwriting the existing backup).
	- If checksums are the same, it does nothing (avoids unnecessary copy).
- If no tarball exists at `DEST_DIR/backup.tar`, it copies the new tarball there.
- Removes the local `SOURCE_DIR/backup.tar` after handling the copy.
- Appends informational and error messages to the file defined by `PATH_TO_LOG`.

**Usage**
1. Edit `backup-git-repos.sh` and set the three variables at the top to valid paths:

```bash
PATH_TO_LOG="/path/to/log"
SOURCE_DIR="/path/to/source/dir"
DEST_DIR="/path/to/backup"
```

2. Make the script executable (optional) and run it:
```bash
chmod +x backup-script.sh
./backup-script.sh
# or
bash backup-script.sh
```