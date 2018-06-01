This Project has been created to bring all the deployment related hassles to a single Platform . We intend to Automate the entire deployment process at Go-Jek in the shortest and safest way .

Main Objectives are -

1) Get a List of all User Specific Projects currently hosted on Gitlab
2) Get a list of all deployed and undeployed commits for a specific Project user chooses to deploy from .
3) User can choose which commit to deploy and get a "git diff" from last deployed commit .
4) Redirect user to fill a Mandatory deployment checklist .
5) Once the deployment checklist form is filled and submitted, it moves to next screen where the developer needs to choose a reviewer. Once a reviewer is selected, and this is submitted, backend will create a Jira ticket in our DEPL board, and send a mail to the reviewer regarding a pending review. This mail should have fixed message along with the JIRA ticket number and a link to OUR service for approving the deployment.
6) The link shared in the mail should open OUR service with the creating deployment checklist and other details, which the reviewer can review.
7) On approval, the backend should do 2 things:
    *  Move the Jira ticket in DEPL board to approved.
    * The developer should receive the mail along with the link to OUR service  where he can go for triggering the deployment.
8) The developer can open the link shared in the mail, and can go the OUR service to see the deployment CI pipeline of the related project.

MAJOR COMPONENTS -
The user is authenticated using the CAS which uses GATE-SSO .
The project currently uses Gitlab v4 API for automating all gitlab tasks on our platform.

Steps to Follow -

1) Clone the git repository using "git clone" or directly download and unzip the project
2) Run "bundle install" and then "rails db:migrate"
3) Install CAS server and replace the "cas_base_url" in config/initializers/devise.rb to your own CAS server url .
4) Run "rails server" and open the browser at "http://localhost:3000" .


ENJOY !!!
