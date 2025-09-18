using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStorySubTypeUpsertInputModel : InputModelBase
    {
        public UserStorySubTypeUpsertInputModel() : base(InputTypeGuidConstants.UserStorySubTypeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? UserStorySubTypeId { get; set; }
        public string UserStorySubTypeName { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStorySubTypeId = " + UserStorySubTypeId);
            stringBuilder.Append(", UserStorySubTypeName = " + UserStorySubTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
