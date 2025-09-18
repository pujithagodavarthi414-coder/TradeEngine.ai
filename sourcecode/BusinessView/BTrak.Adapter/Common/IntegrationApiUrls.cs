using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BTrak.Adapter.Common
{
    public class IntegrationApiUrls
    {
        //Jira
        public static string JiraAddWorkLog = "{0}rest/api/3/issue/{1}/worklog";
        public static string JiraJqlSearch = "{0}rest/api/3/search?jql={1}";
        public static string validateUser = "{0}rest/api/3/search?jql=assignee=currentUser()";
    }
}
