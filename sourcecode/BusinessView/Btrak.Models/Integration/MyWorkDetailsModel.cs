using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Integration
{
    public class MyWorkDetailsModel
    {
        public string WorkItemId { get; set; }
        public string WorkItemKey { get; set; }
        public string WorkItemType { get; set; }
        public string WorkItemTypeColor { get; set; }
        public string WorkItemSummary { get; set; }
        public string WorkItemStatus { get; set; }
        public string WorkItemStatusColor { get; set; }
        public string WorkItemStatusId { get; set; }
        public string AssigneeId { get; set; }
        public string AssigneeName { get; set; }
        public string AssigneeProfileImage { get; set; }
        public bool IsAdhoc { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
    }
}
