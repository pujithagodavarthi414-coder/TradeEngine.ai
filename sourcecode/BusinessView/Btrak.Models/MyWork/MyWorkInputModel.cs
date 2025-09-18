using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MyWork
{
    public class MyWorkInputModel : SearchCriteriaInputModelBase
    {
        public MyWorkInputModel() : base(InputTypeGuidConstants.MyWorkInputCommandTypeGuid)
        {
        }

        public string TeamMemberId { get; set; }
        public string TeamMemberIdsXml { get; set; }
        public string UserStoryStatusIds { get; set; }
        public string UserStoryStatusIdsXml { get; set; }
        public bool? IsStatusMultiselect { get; set; }
        public Guid? ProjectId { get; set; }
        public bool? IsUserStoryParked { get; set; }
        public bool? IsUserStoryArchived { get; set; }
        public bool? IsMyWorkOnly { get; set; }

        public string TeamMembersList { get; set; }
        public Guid? UserStoryId { get; set; }
        public string TeamMembersXml { get; set; }
        public bool? IsIncludeCompletedUserStories { get; set; }
        public bool? IsParked { get; set; }

        public Guid Id { get; set; }
        public Guid StatusReportingConfigurationOptionId { get; set; }
        public string Description { get; set; }
        public string FilePath { get; set; }
        public string FileName { get; set; }
        public DateTime? CreatedOn { get; set; }
        public string AssignedTo { get; set; }
        public bool? IsUnread { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("  TeamMemberId = " + TeamMemberId);
            stringBuilder.Append(", TeamMemberIdsXml  = " + TeamMemberIdsXml);
            stringBuilder.Append(", UserStoryStatusIds  = " + UserStoryStatusIds);
            stringBuilder.Append(", UserStoryStatusIdsXml  = " + UserStoryStatusIdsXml);
            stringBuilder.Append(", IsStatusMultiselect = " + IsStatusMultiselect);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", IsUserStoryParked = " + IsUserStoryParked);
            stringBuilder.Append(", IsUserStoryArchived = " + IsUserStoryArchived);
            stringBuilder.Append(", IsMyWorkOnly = " + IsMyWorkOnly);

            stringBuilder.Append(", TeamMembersList = " + TeamMembersList);
            stringBuilder.Append(", UserStoryId  = " + UserStoryId);
            stringBuilder.Append(", TeamMembersXml  = " + TeamMembersXml);
            stringBuilder.Append(", IsIncludeCompletedUserStories  = " + IsIncludeCompletedUserStories);
            stringBuilder.Append(", IsParked = " + IsParked);

            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", StatusReportingConfigurationOptionId  = " + StatusReportingConfigurationOptionId);
            stringBuilder.Append(", Description  = " + Description);
            stringBuilder.Append(", FilePath  = " + FilePath);
            stringBuilder.Append(", FileName = " + FileName);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", AssignedTo = " + AssignedTo);
            stringBuilder.Append(", IsUnread = " + IsUnread);

            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", SearchText = " + SearchText);
            stringBuilder.Append(", PageNumber = " + PageNumber);
            stringBuilder.Append(", PageSize = " + PageSize);
            return stringBuilder.ToString();
        }
    }
}