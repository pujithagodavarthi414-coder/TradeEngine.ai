using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Status
{
    public class UserStoryStatusUpsertInputModel : InputModelBase
    {
        public UserStoryStatusUpsertInputModel() : base(InputTypeGuidConstants.UserStoryStatusUpsertInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryStatusId { get; set; }
        public Guid? TaskStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }

        public bool IsArchived { get; set; }

        public string TimeZone { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", TaskStatusId = " + TaskStatusId);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}