# OCR-D Famework
Installation of OCR-D framework containing all available processors, taverna workflow and local research data repository.

## Installation with Docker
### Hardware Requirements
More than 8GB RAM and 20 GB of hard disc.

### Requirements
- Docker
  - docker
  - docker-compose
- git
- sed
- unzip
- wget

### Installation
Choose a directory on a disc with at least 10 GB free space left.
(In our example we use ocrd_framework inside the home directory)
Start [installation script](install_OCR-D_framework.sh).
```bash=bash
user@localhost:/home/user/$install_OCR-D_framework.sh /home/user/ocrd_framework
[...]
SUCCESS
Now you can start an OCR-D workflow with the following commands:
cd "/home/user/ocrd_framework/taverna"
docker run --network=\"host\" -v `pwd`:/data ocrd/taverna process"
```
Now there exists several folders
- repository - Contains all files of repository and the databases
- taverna - Contains all files workspaces and configuration of workflows

### Prepare hosts for accessing files in repo via browser
```bash=bash
user@localhost:/home/user/$ echo '127.0.0.1   kitdm20' | sudo tee -a /etc/hosts 
127.0.0.1   kitdm20
```

### First Test
To check if the installation works fine you can start a first test.
```bash=bash
user@localhost:~/ocrd_framework/taverna$docker run --network="host" -v 'pwd':/data ocrd/taverna testWorkflow
[...]
Outputs will be saved to the directory: /taverna/git/Execute_OCR_D_workfl_output
# The processed workspace should look like this:
user@localhost:~/ocrd_framework/taverna$ls -1 workspace/example/data/
metadata
mets.xml
OCR-D-GT-SEG-BLOCK
OCR-D-GT-SEG-PAGE
OCR-D-IMG
OCR-D-IMG-BIN
OCR-D-IMG-BIN-OCROPY
OCR-D-OCR-CALAMARI_GT4HIST
OCR-D-OCR-TESSEROCR-BOTH
OCR-D-OCR-TESSEROCR-FRAKTUR
OCR-D-OCR-TESSEROCR-GT4HISTOCR
OCR-D-SEG-LINE
OCR-D-SEG-REGION
```
Each sub folder starting with 'OCR-D-OCR' should now
contain 4 files with the detected full text.


#### The metadata sub directory
The subdirectory 'metadata' contains the provenance of the workflow all
intermediate mets files and the stdout and stderr output of all executed processors.

#### Check results in browser
After the workflow all results are ingested to the research data repository.
The repository is available at http://localhost:8080/api/v1/metastore/bagit

### Create your own workflow
For configuration of the workflow see instructions in [README.md](https://github.com/OCR-D/taverna_workflow/blob/master/README.MD).

:information_source: All provided paths inside the parameter and workflow configuration files have to be 'dockerized'. For executing scripts relative paths are also possible. 

The commands should look like this:
### Test Processors
For a fast test if a processor is available try the following command:
```bash=bash
# Test if processor is installed e.g. ocrd-cis-ocropy-binarize
user@localhost:~/ocrd_framework/taverna$docker run -v 'pwd':/data ocrd/taverna dump ocrd-cis-ocropy-binarize
{
 "executable": "ocrd-cis-ocropy-binarize",
 "categories": [
  "Image preprocessing"
 ],
 "steps": [
  "preprocessing/optimization/binarization",
  "preprocessing/optimization/grayscale_normalization",
  "preprocessing/optimization/deskewing"
 ],
 "input_file_grp": [
  "OCR-D-IMG",
  "OCR-D-SEG-BLOCK",
  "OCR-D-SEG-LINE"
 ],
 "output_file_grp": [
  "OCR-D-IMG-BIN",
  "OCR-D-SEG-BLOCK",
  "OCR-D-SEG-LINE"
 ],
 "description": "Binarize (and optionally deskew/despeckle) pages / regions / lines with ocropy",
 "parameters": {
  "method": {
   "type": "string",
   "enum": [
    "none",
    "global",
    "otsu",
    "gauss-otsu",
    "ocropy"
   ],
   "description": "binarization method to use (only ocropy will include deskewing)",
   "default": "ocropy"
  },
  "grayscale": {
   "type": "boolean",
   "description": "for the ocropy method, produce grayscale-normalized instead of thresholded image",
   "default": false
  },
  "maxskew": {
   "type": "number",
   "description": "modulus of maximum skewing angle to detect (larger will be slower, 0 will deactivate deskewing)",
   "default": 0.0
  },
  "noise_maxsize": {
   "type": "number",
   "description": "maximum pixel number for connected components to regard as noise (0 will deactivate denoising)",
   "default": 0
  },
  "level-of-operation": {
   "type": "string",
   "enum": [
    "page",
    "region",
    "line"
   ],
   "description": "PAGE XML hierarchy level granularity to annotate images for",
   "default": "page"
  }
 }
}
user@localhost:~/ocrd_framework/taverna$
```

### Execute your own Workflow
If workflow is configured it can be started.
```bash=bash
user@localhost:~/ocrd_framework/taverna$docker run --network="host" -v 'pwd':/data ocrd/taverna process my_parameters.txt relative/path/to/workspace/containing/mets
```



## More Information

* [Docker](https://www.docker.com/)

