![](images_mrhub/MRHub_banner.png)

This is the GitHub repository associated with the [MR-Hub website](https://ismrm.github.io/mrhub/) - a platform to share information about open source software relevant to the [ISMRM](http://www.ismrm.org) community.

This version of the page was created during the [MRI-themed Hackathon](http://mrathon.github.io) and during the ISMRM meeting in Montreal, 2019. 

Currently we are using the number of citations that [Semantic Scholar](http://www.semanticscholar.org) (this is used because of its API which is free to use) finds on the main paper associated with the software to allow sorting by a proxy metric related to 'impact' of the software. We realise that this is not a perfect solution, not least because not everyone who cites a paper uses the software - and not everyone who uses software has cited the paper. For now this seems like a reasonable solution - but feel free to use the 'issues' section to discuss any issues that arise due to this choice, along with any suggestions you might have for how to improve it.

A script which is run separately on an admin computer (`_data/update.rb`) every few months will allow automatic updating of the number of citations and the date the software was last updated (using GitHub / Bitbucket APIs to retrieve last commit date).

### Submission instructions:
The database of packages is stored in the `_data` folder of this repository and is called `projects.json`. To add your own package:

1. Download the template file for the JSON file (`_data/template.json`) to your own computer 
2. Fill in all the fields - if you're unsure about any of the formatting take a look through the `projects.json` file to see how it was done for other packages. Watch out for the following fields which may not be obvious:
   * `"imageFile"` - this is the name of the logo image for your package. **Upload this file separately to the `images_packages` folder of this repo.** We don't currently have specific restrictions on the logo shape/size - but it seems to work well if it's at least 100 px high and no more than 250px wide, and a .png with a transparent background. Once we have more logos from different packages we can look at improving the visual layout of the site.
   * `"repoURL"` - Fairly self-explanatory - but please let me know ( [Dan Gallichan](mailto:gallichand@cardiff.ac.uk) ) if you are **not using** Github or Bitbucket for your repo as so far I've only included automatic querying of the date the software was last updated for these two!
   * `"extraResources"` - Currently we have examples of packages with video tutorials which can be directly linked from the software description. If you have a Jupyter Notebook, for example (or anything similar!), which acts as a quick way to visualise how the software works, this would also be a great thing to add here. 
   * `"citationSearchString"` - As we are currently using [Semantic Scholar](http://www.semanticscholar.org) to provide the citation count for the main paper associated with the software, this field is used to uniquely identify the paper. This is straightforward for full papers, as they typically have a DOI, and this can be used directly. Semantic Scholar also finds ISMRM abstracts - but as these don't historically have a DOI, you'll need to put the paperID from Semantic Scholar here. As an example, I've found one of my ISMRM abstracts from 2012 on Semantic Scholar - and when I look at the full URL I get this:
   ```
   https://www.semanticscholar.org/paper/Simultaneous-Linear-and-Nonlinear-Encoding-in-a-Gallichan-Testud/4b760bd2bd9bcb2b2bb87438c029d206374bb2a2
   ```
   The paperID for SemanticScholar is the very last part after the '/' - starting with `4b760...`.
   
   **Please let me know if your paper isn't in Semantic Scholar at all!** - this is still in the trial phase to see if such an approach is feasible - please contact [Dan Gallichan](mailto:gallichand@cardiff.ac.uk) if you can't find your paper and we'll see what else we might be able to do (it seems it should be possible to 'submit' your own paper to their database...). You can test to see if your `citationSearchString` works by pointing your browser at 
   ```
   https://api.semanticscholar.org/v1/paper/<YourCitationSearchStringGoesHere>
   ```
   If you see a page full of text in JSON format, then your `citationSearchString` works!
   
   * `"citationCount"` - This is the number of citations for the linked paper found by Semantic Scholar. This will get updated automatically by a site admin every so often to try to keep this info up-to-date.
  
3. Once you've got all your text entered into the template, go to `mrhub/_data/projects.json` and click the 'Edit' button (this will fork the repository into your own Github account - but all this should be possible inside your browser). Paste the full contents of your edited version of `template.json` into the top of the `projects.json` file, **after the square bracket on the very first line**. 
4. Before you submit a pull-request - please then copy/paste the entire new version of `projects.json` into a JSON validator such as this one: https://jsonlint.com/ and check that after your changes the full file is still 'valid JSON'.
5. Submit a pull-request to merge your forked version with the main MR-Hub site.
6. Wait some amount of time for an admin to approve your pull-request. We realise this will still take some time - but hopefully it will be considerably faster than the 'review' process that we had in place for the previous version of MR-Hub.


If you think any of these instructions are not clear enough - please feel free to make minor changes yourself and submit a pull-request on that. You can also start discussion in the 'Issues' section. 

The idea of this page is to crowd-source a website that is actually useful for the ISMRM community - allowing software creators to let potential users know about their code - and making it easier for those new to the field (or new to a sub-topic) to find relevant open-source solutions that are already there. If you have any suggestions for how to improve it - let us know (or, even better, implement them and submit a pull-request...!)
   
   
   


