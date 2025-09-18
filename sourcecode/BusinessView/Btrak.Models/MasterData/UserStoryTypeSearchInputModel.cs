using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class UserStoryTypeSearchInputModel : SearchCriteriaInputModelBase
    {
        public UserStoryTypeSearchInputModel() : base(InputTypeGuidConstants.UserStoryReplanTypeSearchCommandTypeGuid)
        {
        }
        public Guid? UserStoryTypeId { get; set; }
        public string UserStoryTypeName { get; set; }
        public string ShortName { get; set; }
        public bool? IsBug { get; set; }
        public bool? IsUserStory { get; set; }
        public bool? IsLogTimeRequired { get; set; }
        public bool? IsQaRequired { get; set; }
        public bool? IsFillForm { get; set; }
        public bool IsAction { get; set; }
        public bool? IsApproveOrDecline { get; set; }        
        public bool? GenericStatusType { get; set; }
        public string UserStoryTypeColor { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryTypeName = " + UserStoryTypeName);
            stringBuilder.Append("ShortName = " + ShortName);
            stringBuilder.Append("IsBug = " + IsBug);
            stringBuilder.Append("IsFillForm = " + IsFillForm);
            stringBuilder.Append("IsAction = " + IsAction);
            stringBuilder.Append("IsUserStory = " + IsUserStory);
            return stringBuilder.ToString();
        }
    }
}
