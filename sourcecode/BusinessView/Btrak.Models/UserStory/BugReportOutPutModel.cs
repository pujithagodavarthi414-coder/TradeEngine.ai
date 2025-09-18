using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class BugReportOutPutModel
    {
        public string UserStoryName { get; set; }
        public string UserStoryUniqueName { get; set; }
        public int? BugsCount { get; set; }
        public decimal? EstimatedTime { get; set; }
        public string Assignee { get; set; }
        public string ProfileImage { get; set; }
        public Guid? OwnerUserId { get; set; }
        public string RAGStatus { get; set; }
    }
}
