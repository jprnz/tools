# Tools
A series of makefiles inteneded to install local versions of various tools.  
When available, tools are built from latest commit of their source repository.  
Assumes a fully stocked build environment.

# Running
```
make <tool>-install # To install a specific tool
make                # To install all tools
```

## Building in parellel
`make` can process tasks in parellel with `-j<int>` where `<int>` indicated
the desired number of simultanious jobs. If `<int>` is omitted, `make` will
use all available cpu resources.

## Installing from git-repository
When tools are build a git repository, the following will be agvailable:
```
make <tool>-update  # Checks out HEAD and re-complies
make <tool>-reset   # Checks out HEAD~ and re-compiles
```

# Organization
Makefiles for all tools are located in `src/<tool>.mk`. 

# Notes
## Pip executable
In order to provide the python client library for neovim the variables
`PIP2` and `PIP3` must be defined. By default these are:
``` Makefile
PIP2 = pip2.7
PIP3 = pip3.6
```

To change these at runtime use
``` Makefile
make PIP2=<executable> PIP3=<executable>
```



