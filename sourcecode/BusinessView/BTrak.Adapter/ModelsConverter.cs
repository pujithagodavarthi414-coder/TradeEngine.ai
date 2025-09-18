using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Models.Integration;
using BTrak.Adapter.Models;

namespace BTrak.Adapter
{
    public class ModelsConverter
    {
        public List<MyWorkDetailsModel> ConvertJiraIssuesToMyWorkDetails(List<Issue> issues)
        {
            return issues.Select(ConvertJiraIssueToMyWorkDetailsModel).ToList();
        }

        private MyWorkDetailsModel ConvertJiraIssueToMyWorkDetailsModel(Issue issue)
        {
            try
            {
                return new MyWorkDetailsModel
                {
                    WorkItemId = issue.id,
                    WorkItemKey = issue.key,
                    WorkItemStatus = issue.fields.status.name,
                    WorkItemStatusId = issue.fields.status.id,
                    WorkItemSummary = issue.fields.summary,
                    WorkItemType = issue.fields.issuetype.name,
                    AssigneeId = issue.fields.assignee.accountId,
                    AssigneeName = issue.fields.assignee.displayName
                };
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex);
                return null;
            }
        }
    }
}
