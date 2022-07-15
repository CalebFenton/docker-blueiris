## docker-blueiris

This is a Container for BlueIris based on [jshridha/docker-blueiris](https://github.com/jshridha/docker-blueiris)

This container runs:

* Xvfb - X11 in a virtual framebuffer
* x11vnc - A VNC server that scrapes the above X11 server
* [noNVC](https://kanaka.github.io/noVNC/) - A HTML5 canvas vnc viewer
* Fluxbox - a small window manager
* WINE - to run Windows executables on linux
* blueiris.exe - official Windows BlueIris

# Known Issues:

* Saving and restoring settings backup via the BlueIris interface does not work!

      - 1007:8080    # vnc
      - 1006:1006    # blueiris www
