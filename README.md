Developer Satisfaction Investigation
====================================================================================================
Investigation using statistical and visualization techniques to understand job satisfaction across the tech landscape.

<br>

Purpose
----------------------------------------------------------------------------------------------------
Simple statistical tests for [Stack Overflow Developer Survey 2019]() data and a [Processing]()-based visualization of that data to understand how satisfied different disciplines are with their work and what factors matter to them at a job.

<br>

Local Development Environment
----------------------------------------------------------------------------------------------------
Visualization requires this project requires use of the [Sam Pottinger Processing](https://github.com/sampottinger/processing) branch and installation instructions are provided at that branch's README. In order to run the python data analysis steps, one will need [Jupyter](https://jupyter.org/), [Pandas](https://pandas.pydata.org/), [Matplotlib](https://matplotlib.org/), and [Scipy stats](https://scipy.org/install.html). Users looking for a shortcut may consider installing [Anaconda](https://www.anaconda.com/distribution/). Finally, users may optionally apply data transformation scripts after installing [OpenRefine](http://openrefine.org/).

After installing the required packages, unzip the dev_satisfaction_data.zip archive in the `data` directory such that its contents sit within the data folder. One will also need to generate the following fonts within Processing:

 -

<br>

Execution
----------------------------------------------------------------------------------------------------
One can execute the Jupyter notebooks by running `jupyter notebook` within the `data` directory. To execute the visualization, simply open this repository within Processing and run.

<br>

Deployment
----------------------------------------------------------------------------------------------------
Though the visualization will display live when the sketch is run locally, the result can be "deployed" through the `dev_satisfaction.png` file.

<br>

Structure
----------------------------------------------------------------------------------------------------
Note that the Processing sketch contents live at the root of this directory. Data preparation, artifacts, and logic for statistical tests lives under the `data` directory.

<br>

Coding Standards
----------------------------------------------------------------------------------------------------
Please try to include JavaDoc where possible and commenting within the Jupyter notebooks as appropriate.

<br>

Open Source Libraries Used
----------------------------------------------------------------------------------------------------
This project uses the following:

 - [Matplotlib](https://matplotlib.org/) under the [PSF license](https://docs.python.org/3/license.html).
 - [Pandas](https://pandas.pydata.org/) under the [BSD 3 Clause license](https://pandas.pydata.org/pandas-docs/stable/getting_started/overview.html#license).
 - [Processing core](https://processing.org) under the [LGPL license](https://github.com/processing/processing/blob/master/license.txt).
 - [Scipy](https://github.com/scipy/scipy) under the [BSD 3 Clause license](https://github.com/scipy/scipy/blob/master/LICENSE.txt).

This project also uses colors selected via [ColorBrewer 2](https://colorbrewer2.org) and uses the [Lato free fonts](http://www.latofonts.com/lato-free-fonts/) under the [SIL license](https://scripts.sil.org/cms/scripts/page.php?item_id=OFL_web).
