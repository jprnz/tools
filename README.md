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


