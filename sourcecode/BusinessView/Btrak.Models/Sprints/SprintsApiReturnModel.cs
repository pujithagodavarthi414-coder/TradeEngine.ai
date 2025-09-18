using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Sprints
{
    public class SprintsApiReturnModel
    {
        public Guid? SprintId { get; set; }
        public string SprintName { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CreatedUserName { get; set; }
        public DateTime? SprintStartDate { get; set; }
        public DateTime? SprintEndDate { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? CompletedSprintDate { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public int? UserStoriesCount { get; set; }
        public int? CompletedUserStoriesCount { get; set; }
        public bool? IsWarning { get; set; }
        public string Description { get; set; }
        public bool? IsReplan { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public string Version { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        public bool? IsDefault { get; set; }
        public Guid? WorkFlowId { get; set; }
        public string sprintUniqueName { get; set; }
        public string SprintResponsiblePersonName { get; set; }
        public Guid? SprintResponsiblePersonId { get; set; }
        public string ProfileImage { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public string ProjectResponsiblePersonname { get; set; }
        public string UserName { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool? IsEnableSprints { get; set; }
        public bool IsEnableTestRepo { get; set; }
        public bool? IsComplete { get; set; }
        public int WorkItemsCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", SprintId = " + SprintId);
            stringBuilder.Append(", SprintName = " + SprintName);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CreatedUserName = " + CreatedUserName);
            stringBuilder.Append(", SprintStartDate = " + SprintStartDate);
            stringBuilder.Append(", SprintEndDate = " + SprintEndDate);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", Description = " + Description);
            return stringBuilder.ToString();
        }
    }
}
