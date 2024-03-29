![image](https://user-images.githubusercontent.com/24285860/171511142-7e91f143-def8-4374-8655-a94d178520b9.png)

## General
Basic KHANDLE information: https://rachelwhitmer.ucdavis.edu/khandle <br>
Basic STAR information: https://rachelwhitmer.ucdavis.edu/lifeafter90 <br>
Basic LA90 information: https://rachelwhitmer.ucdavis.edu/star <br>

## First Things First
* This repository serves as a place for all of us to share our code, so we don't have to reinvent the wheel when sharing measures and analyses.
* All code in the analyses and measures (KHANDLE/STAR/LA90) folders should be compatible with the corresponding datasets.
* In some cases, code may require restricted data only available at Kaiser DOR. These scripts should be uploaded to the the appropriate measures or analyses subfolders within the Restricted Data directory. 
* **Don't upload data!** Be careful to never upload datasets or a workspace that may contain KHANDLE data, this is for code sharing _only_
* To facilitate collaboration among KHANDLE/STAR researchers, we have created a [KHANDLE coding style guide](KHANDLE_style_guide.md) with best practices for variable and file naming as well as some considerations for output.

## Adding Brand New Code
1. Find the appropriate directory/subdirectory for your code
   * Example:  Code for deriving an education measure in the KHANDLE study should be added to the folder Measures - KHANDLE/EDU
   * Example:  Code for deriving a STAR-specific lifetime discrimination measure should be added to the folder Measures - STAR/DISC_LIFE <br> 
   **Notes:**  
     * Scripts within the Measures directory are used to create derived variables
     * Scripts within the Analyses directory are used to reproduced analyses using KHANDLE/STAR/LA90 data
   * If an appropriate directory/subdirectory does not yet exist for your script, create one based on the list of [KHANDLE/STAR study category prefixes](prefix_list.md) while making the README file for your code (see next step)
   <br>
2. Create a README.md file based on this [template](example_README_template.md) for the folder that contains your script so others know what your code does.  The README file should contain the following information: 
   * Decision History<br>
     e.g. if you decided to drop or recode any responses for a summary measure, include justification why
   * Source Variables
   * Output (Derived) Variables<br>
  	  Include the type of variable (is it categorical? 0/1 binary? continuous?)
   * What language code is written in:
     
      | Derived Variable Name | SAS  | STATA  | R  |
      | :---:   | :-: | :-: | :-: |
      | Derived Variable #1 | X |  | X |
      | Derived Variable #2 | X |  |  |
      | Version (Date)  | V3 (02/05/20) |  | V1 (01/01/20) |
    
      Code to make a table:
      ```
      | Derived Variable Name | SAS  | STATA  | R  |
      | :---:   | :-: | :-: | :-: |
      | Derived Variable #1 | X |  | X |
      | Derived Variable #2 | X |  |  |
      | Version (Date)  | V# (MM/DD/YY) |  | V# (MM/DD/YY) |
  
    For more help with markdown formatting, refer to this handy cheatsheet:  
    https://github.com/tchapi/markdown-cheatsheet/blob/master/README.md
    
    **Note:** If you need to create a directory/subdirectory for your scripts first, in the box where you would normally name your file (after clicking "create new file"), type the name for your new directory, then "/", then the file name.  For example, when creating a new directory named "New Folder" for my script named "New Script" within the KHANDLE measures directory, I would navigate to the KHANDLE measures directory, click "create new file" and in the box for naming my file, I would type: "New Folder/New Script". The Measures folder is organized by KHANDLE/STAR study category prefixes found in this [list](prefix_list.md).
  
  3. Once your README is created, create a new file in that same directory to copy and paste your code into.
  
  4. Give your file the name that matches the variable derived by your code and add the appropriate file extension for the language your code is in: .R for R, .do for STATA, .sas for SAS

  5. Make sure your code is well-commented and compatible with KHANDLE datasets available to all (if not in the restricted data)<br>
      Regarding compatibility: For example, if you have previously created your own education variable to create an intergenerational education measure, either include that previous coding or code directly from the source variables

## Just here to upload existing code in a new language?
  1. Upload your script into the relevant folder 
  
  2. Update the coding language table in the README!

## Found an issue/have a question on some uploaded code or documentation?
File an "issue" and the author of the code will be notified directly!  Have a back-and-forth on GitHub until the author marks the issue officially resolved.  

To file an issue for code...

  1. Click on the script you have a question about
  
  2. Within the script, click on the line number (or drag to highlight many lines) to specify which portion of the code you have questions on
  
  3. Click the ... icon and choose "Reference in new issue"
  
  4. Write up your question or comments
  
  5. Optional:  Assign the issue.  The original contributer will get a notification about the issue filed, but you can add other assignees to the issue if you'd like so that they get notified as well.
  
  6. Have a back and forth conversation until the issue is resolved and "closed"

To comment on a markdown file...<br> 

Comments on markdown files are not line-specific unless you're willing to sift through the version history of the file to find the specific commit that generated the line you'd like to comment on.  For now, it seems like the best solution would be to click on the file you'd like to comment on, click the history button, click on the latest commit title, and write a comment in the box you see at the end of the commit.  The author of the file will be notified, but you can also @mention other team members so they will be notified of your comment as well.

## New to Github?
We have prepared a series of GitHub tutorials specific to the KHANDLE organization. You can find slides and resources [here](https://drive.google.com/drive/folders/1WPClgefMWRWZ7bnCJgEsAAJ70gPYmfyx?usp=sharing).  
If you're just here to use code, you can copy-and-paste directly from the Github website; but if you're interested in all the cool features of Github's version control abilities, check out these links:
* Git-based tutorials: https://try.github.io/
* Don't know what words mean? https://www.atlassian.com/git
* Want to get real in-depth? https://www.udacity.com/course/version-control-with-git--ud123
* Language specific integration:
  * SAS: https://documentation.sas.com/?docsetId=lefunctionsref&docsetTarget=n1mlc3f9w9zh9fn13qswiq6hrta0.htm&docsetVersion=9.4&locale=en
  * R: https://www.udacity.com/course/version-control-with-git--ud123

## Integration
This is an optional step that will allow you to push and pull code from GitHub straight into your preferred coding interface.  You can still use GitHub by copying and pasting if you do not choose to integrate your software with it.
* SAS:  Integrated into SAS 9.4
* STATA:  Need desktop git client like GitKraken (https://support.gitkraken.com/how-to-install/)
* R:  Built into RStudio

## For access requests
Contact:<br>
Yingyan Wu<br>
PhD Student, *UCLA Epidemiology*<br>
Graduate Student Researcher, *Mayeda Research Group (UCLA Epidemiology)*<br>
UCLA Fielding School of Public Health<br>
yingyanwu@ucla.edu

## Need troubleshooting help?
Contact:<br>
Juliet Zhou<br>
PhD Student, *UCLA Biostatistics*<br>
Graduate Student Researcher, *Mayeda Research Group (UCLA Epidemiology)*<br>
UCLA Fielding School of Public Health<br>
jyixzhou@g.ucla.edu

