# How to run a WDL
WDL (Workflow Description Language) is a standardized language designed for bioinformatics workflows. It is designed to be portable and reproducible.

You can use the Terra webservice to easily run WDL workflows on GCP. You can also run them locally, in the cloud, or on an HPC using Cromwell or miniwdl.

## Running on Terra
These instructions assume you already have an account on [Terra](https://terra.bio/) and [a billing project set up](https://support.terra.bio/hc/en-us/articles/360026182251-How-to-set-up-billing-in-Terra).

### If the workflow is on Dockstore
1. Go to the Dockstore entry of the workflow (as an example, [here's myco_raw's Dockstore entry](https://dockstore.org/workflows/github.com/aofarrel/myco/myco_raw))
2. On the right hand side of the Dockstore entry, select Terra under the heading "Launch with"
3. Select which Terra workspace you wish to import into, or create a new one -- you'll then be taken to Terra
4. In Terra, go to the workflow tab (it's on the top below the bright green header bar), select your workflow to run it

If you use Dockstore, and the author of the workflow has set up the repo to automatically sync with Dockstore, the workflow will be automatically updated on Terra when the author pushes a change to their workflow on GitHub/Dockstore. Additionally, you can select any branches or tagged versions of the workflow within Terra's workflow setup UI without needing to re-import the workflow.

### If the workflow is not on Dockstore
1. On Terra, go to the workflows tab (it's on the top below the bright green header bar), and select "Find a workflow"
2. In the popup, under "Find additional workflows," select "Broad Methods Repository"
3. Press the blue button in the top right corner that says "Create new method..." 
4. Fill out the namespace and workflow name (they do not need to match anything in your workspace), then copy-paste the WDL into the large text box
5. Click the blue upload button
6. Select which Terra workspace you wish to import into, or create a new one -- you'll then be taken to Terra
7. In Terra, go to the workflow tab, select your workflow to run it

**Unlike Dockstore workflows, using the Broad Methods Repository will not transfer over git versioning, nor will your copy of the workflow keep up-to-date automatically.** If you want a new version of your workflow, you will need to copy-paste it into the BMR again.

## On a local machine
You will need:
* [miniwdl](https://github.com/chanzuckerberg/miniwdl) or [the Dockstore CLI](https://dockstore.org/quick-start) or [Cromwell](https://github.com/broadinstitute/cromwell)
* Python 3 if you're using miniwdl, or Java 11 (OpenJDK recommended) if using Dockstore CLI/Cromwell
* Docker Engine or Docker Desktop
  * if you are on a Linux machine, it is advised *not* to use Docker Desktop -- use Docker Engine instead
* The WDL file (optional if using the Dockstore CLI and the WDL is on Dockstore)
* A JSON file that describes your inputs -- if any of them are files, use relative (to the workdir you will be running from) paths

In rare scenarios, Mac users may need to manually override `TMPDIR` (e.g. `export TMPDIR=/whatever`) to prevent Docker shenanigans.

### miniwdl
`miniwdl run your_workflow.wdl -i your_inputs.json`

miniwdl, unlike Cromwell, links input files instead of copying them. If your WDL modifies input files such as trying to `mv` them, you must use the `--copy-input-files` option, or else you will get "device or resource busy" errors.

### Cromwell
`java -jar /Applications/cromwell-xx.jar run your_workflow.wdl -i your_inputs.json`

On non-cloud backends, Cromwell can be less stable than miniwdl. Both attempt to run tasks concurrently if they think the backend can handle it, but Cromwell doesn't have a good sense of what the backend can handle compared to miniwdl. For some workflows this isn't usually a problem, but for heavier workflows, this can cause tasks getting sigkilled. Sometimes it can even cause the Docker daemon to stop responding. If you are running a WDL that may launch multiple tasks concurrently, it is recommend to [follow these instructions to make Cromwell/the Dockstore CLI only run one thing at a time](https://docs.dockstore.org/en/stable/advanced-topics/dockstore-cli/local-cromwell-config.html?highlight=cromwell), or switch to miniwdl.

### Dockstore CLI
The Dockstore CLI wraps Cromwell, so most Cromwell caveats and instructions apply to it too. However, the Dockstore CLI does add the ability to localize input files from a Google bucket using gs:// URIs, and can run WDLs directly from Dockstore.

Running a local WDL:
`dockstore workflow launch --local-entry your_workflow.wdl --json your_inputs.json`

Running a WDL from Dockstore:
`dockstore workflow launch --entry full_dockstore_entry_name/your_workflow.wdl --json your_inputs.json`

Dockstore entry names are sometimes GitHub URLs, for example:
`dockstore workflow launch --entry github.com/aofarrel/myco/myco_sra:2.0.1 --json your_inputs.json`

You can use `--wdl-output-target` to put your workflow outputs into a remote path, such as an S3 bucket.

## On an HPC
Many (not all) institutes do not allow Docker to run on their HPC systems for security reasons. Strictly speaking, [there are ways](https://docs.dockstore.org/en/stable/advanced-topics/docker-alternatives.html) to get around this limitation, but this is on a case-by-case basis. Some workflows will work perfectly with Singularity, others... not so much.
