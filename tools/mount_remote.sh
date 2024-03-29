#!/bin/bash

usage() {
  NF='\e[0m'  # no formatting
  BOLD='\e[1m'
  SELF="${0##*/}"

  echo -e "${BOLD}USAGE${NF}
  $SELF <remote> [-f|--force] [-m|--mount-dir <dir>] [-p|--port <port>]
               [-r|--remote-dir <dir>] [-u|--unmount]
  "

  echo -e "${BOLD}DESCRIPTION${NF}
  Mount (or unmount) a remote machine to a local directory using sshfs.
  "

  echo -e "${BOLD}ARGUMENTS${NF}
  remote
    The hostname/address of the remote machine.
  "
  
  echo -e "${BOLD}OPTIONS${NF}
  "

  exit 0
}

is_available() {
  REMOTE="$1"
  ping -c 1 -t 100 -q $REMOTE > /dev/null 2>&1
  return
}

is_mounted() {
  MOUNT_POINT="$1"
  mountpoint "$MOUNT_POINT" -q
  return
}

mount_remote() {
  REMOTE=$1

  if [ -z "$MOUNT_DIR" ]; then
    MOUNT_DIR="$HOME/remote"
  fi

  MOUNT_POINT="$MOUNT_DIR/$REMOTE"
  mkdir -p "$MOUNT_POINT"

  if [ -z "$(which sshfs)" ]; then
    echo "ERROR: sshfs not found. Install sshfs and try again."
    exit 1
  elif is_mounted "$MOUNT_POINT"; then
    echo "$MOUNT_POINT is already mounted"
  else
    if [ $FORCE ] || is_available $REMOTE; then
      msg="Mounting $MOUNT_POINT to $REMOTE"
      if [ -n "$REMOTE_DIR" ]; then
        msg="$msg:$REMOTE_DIR"
      fi
      echo "$msg"

      opts="follow_symlinks,idmap=user" 
      if [ -n "$PORT" ]; then
        opts="$opts,port=$PORT"
      fi

      sshfs -o "$opts" $REMOTE:"$REMOTE_DIR" "$MOUNT_POINT"
    else
      echo "$REMOTE cannot be reached"
    fi
  fi
}

unmount_remote() {
  REMOTE=$1

  if [ -z "$MOUNT_DIR" ]; then
    MOUNT_DIR="$HOME/remote"
  fi

  MOUNT_POINT="$MOUNT_DIR/$REMOTE"

  if [ $FORCE ] || is_mounted "$MOUNT_POINT"; then
    echo "Unmounting $MOUNT_POINT"
    fusermount -u "$MOUNT_POINT"
  else
    echo "$MOUNT_POINT is not mounted"
  fi
}

REMOTE="$1"
shift 1

while (( "$#" )); do
  case "$1" in
    -f|--force)
      FORCE=true
      shift 1
      ;;
    -m|--mount-dir)
      MOUNT_DIR="$2"
      shift 2
      ;;
    -p|--port)
      PORT="$2"
      shift 2
      ;;
    -r|--remote-dir)
      REMOTE_DIR="$2"
      shift 2
      ;;
    -u|--unmount)
      UNMOUNT=true
      shift 1
      ;;
  esac
done

if [ -z "$REMOTE" ]; then
  usage
elif [ $UNMOUNT ]; then
  unmount_remote "$REMOTE"
else
  mount_remote "$REMOTE"
fi
