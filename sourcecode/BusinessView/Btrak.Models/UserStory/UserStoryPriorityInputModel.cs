using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStoryPriorityInputModel : InputModelBase
    {
        public UserStoryPriorityInputModel() : base(InputTypeGuidConstants.UserStoryPriorityInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryPriorityId { get; set; }
        public string PriorityName { get; set; }
		public bool? IsArchived { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryPriorityId = " + UserStoryPriorityId);
            stringBuilder.Append(", PriorityName = " + PriorityName);
            return stringBuilder.ToString();
        }
    }
}
