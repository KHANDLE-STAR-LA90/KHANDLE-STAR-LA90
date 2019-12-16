![Picture](https://lh3.googleusercontent.com/A6qdMRZqcRQg9ooQl_pAmbKn_dM660Kyljj3gZxa8mSiUGQTwyKO2GEye1u1O1sUWwQhpT-j8pSC1ThT0y7sHLIBrkiSgg8RtmMP4qW_mbBxT9whk1aZzMw_bu1GGNxl5Lg_RINiFXOxGYQanYcgwNIAaO5rAjLWEOVY2CjgRzx90mTqd2dve_btYv648i6DxtSWt7nqakk7f8vGd59UhEb0BleGnKAnFTiXaLkVHbOB64_CZsbnqqh6ttX2-ivV82zTqlQTJ_UxXDk_nALt32ROy-sZU9HBzaspdYNpB7Y66MuG-5elciqRkWFlBAmtxloObkIkHav4ccMMvfP_3BfwlSaR3Wxc6V2eqZ_oFWj3UbvOfaG52FQTD9eGmlIBdjtoRvDoxaFCRlKUS_-7l2MbVsZ3wjkST5Oj46Hm_L3piZEMLUmuZ2xkuvMvaprBwmIgKmhkJ0G6Ii4etvnDPmbdNXw1Qysx2H2lURVRkcAHm9WPZSC9wI_CcnIKIGncNdt-Dd5wRPKMACCW7F0veycjtRHTM8FYPuxnyA7qOaspTT8NjSEZecSPpXNxHk-NIauqbQJ3jJYmBorzI8ha1JNWHC9Y8sRCsxrzWCe3HkBILSxH8d7fixY9PIxDFMNyki_iTebDP2vzTFH7xDMmK8sIof7bI7Lgd1_o4saQ3cMOlZLexBw3PAlFDPG1XXrO29uE3Cea1yHqznd64IOW7m9g1OUra6Ie2wrZs4CzeS0CbXInuQ=w705-h166-no)

## General
Basic KHANDLE information: https://rachelwhitmer.ucdavis.edu/khandle

## First Things First
* This repository serves as a place for all of us to share our code, so we don't have to reinvent the wheel when sharing measures and analyses.
* All code in the KHANDLE and STAR analyses and measures folders should be compatible with available KHANDLE datasets.
* In some cases, code may require restricted data only available at Kaiser DOR. These scripts should be uploaded to the the appropriate measures or analyses subfolders within the Restricted Data directory. 
* **Don't upload data!** Be careful to never upload datasets or a workspace that may contain KHANDLE data, this is for code sharing _only_

## Adding Brand New Code
* Find the appropriate directory/subdirectory for your code
  * Example:  Code for deriving an education measure in the KHANDLE study should be added to the folder Measures/Education
  * Example:  Code for deriving a STAR-specific lifetime discrimination measure should be added to the folder STAR/Measures/Discrimination/Lifetime Discrimination <br> 
  **Note:**  The STAR folder contains STAR-specific code, i.e. code that only works with access to the variables in the STAR study
  * If an appropriate directory/subdirectory does not yet exist for your script, create one while making the README file for your code (see next step)
* Create a README for the folder that contains your script so others know what your code does
* In the README, the following should be noted:
  * Decision History
    * e.g. if you decided to drop or recode any responses for a summary measure, include justification why
  * Source Variables
  * Output (Derived) Variables 
  	* Include the type of variable (is it categorical? 0/1 binary? continuous?)
  * What language code is written in:

    | Derived Variable Name | SAS  | STATA  | R  |
    | :---:   | :-: | :-: | :-: |
    | Derived Variable #1 | X |  | X |
    | Derived Variable #2 | X |  |  |
    
    Code to make a table:
    ```
    | Derived Variable Name | SAS  | STATA  | R  |
    | :---:   | :-: | :-: | :-: |
    | Derived Variable #1 | X |  | X |
    | Derived Variable #2 | X |  |  |

* Code should be well commented and compatable with KHANDLE datasets available to all
  * e.g. if you have previously created your own education variable to create an intergenerational education measure, either include that previous coding or code directly from the source variables

## Just here to upload existing code in a new language?
* Just upload into the relevant folder and **update the readme!**

## Found an issue/have a question on some uploaded code?
* File an "issue" and the author of the code will be notified directly!  Have a back-and-forth on GitHub until the author marks the issue officially resolved.

## New to Github?
These links might help, but remember that if you're just here to use code, you can copy-and-paste directly from here:
* Git-based tutorials: https://try.github.io/
* Don't know what words mean? https://www.atlassian.com/git
* Want to get real in-depth? https://www.udacity.com/course/version-control-with-git--ud123
* Language specific integration:
  * SAS: https://documentation.sas.com/?docsetId=lefunctionsref&docsetTarget=n1mlc3f9w9zh9fn13qswiq6hrta0.htm&docsetVersion=9.4&locale=en
  * R: https://www.udacity.com/course/version-control-with-git--ud123

## Integration
* SAS:  Integrated into SAS 9.4
* STATA:  Need desktop git client
* R:  Built into RStudio

## Need more help?
Contact:<br>
Crystal Shaw<br>
PhD Student, *UCLA Biostatistics*<br>
Graduate Student Researcher, *Mayeda Research Group (UCLA Epi)*<br>
UCLA Fielding School of Public Health<br>
c.shaw@ucla.edu

