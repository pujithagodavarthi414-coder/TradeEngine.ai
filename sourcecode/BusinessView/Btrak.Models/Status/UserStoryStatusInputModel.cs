using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Status
{
    public class UserStoryStatusInputModel : InputModelBase
    {
        public UserStoryStatusInputModel() : base(InputTypeGuidConstants.UserStoryStatusInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public Guid? TaskStatusId { get; set; }
        public string TaskStatusName { get; set; }

        public bool? IsArchived { get; set; }
        public DateTime? ArchivedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", TaskStatusId = " + TaskStatusId);
            stringBuilder.Append(", TaskStatusName = " + TaskStatusName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            return stringBuilder.ToString();
        }
    }
}
